//
//  StorageHelper.swift
//  lernglish
//
//  Created by Maxim Belsky on 17/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import CoreData
import SwiftyJSON

class StorageHelper {
    static let instance = StorageHelper()
    
    fileprivate let
    moc: NSManagedObjectContext,
    privateMoc: NSManagedObjectContext
    
    func getSections() -> [SectionMO] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: StorageEntity.section.rawValue)
        return try! moc.fetch(request) as! [SectionMO]
    }
    
    func getLessonsFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: StorageEntity.theme.rawValue)
        let sortSections = NSSortDescriptor(key: "section.id", ascending: true)
        let sortThemes = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortSections, sortThemes]
        return NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "section.transientName", cacheName: nil)
    }

    func getTests(_ testsHandler: @escaping ([TestMO]?) -> Void) {
        privateMoc.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: StorageEntity.test.rawValue)
            request.predicate = NSPredicate(format: "theme.isStudied == true")

            var tests: [TestMO]? = nil
            do {
                tests = try self.privateMoc.fetch(request) as? [TestMO]
            } catch {
            }
            DispatchQueue.main.async {
                testsHandler(tests!)
            }
        }

    }

    func save() throws {
        if moc.hasChanges {
            try moc.save()
        }
    }
    
    private init() {
        moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        if let modelUrl = Bundle.main.url(forResource: "DataModel", withExtension: "momd"),
                let model = NSManagedObjectModel(contentsOf: modelUrl) {
            moc.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        }
        
        privateMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMoc.parent = moc
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                return
            }
            
            let persistentStoreUrl = documents.appendingPathComponent("lernglish.sqlite")
            do {
                try self.moc.persistentStoreCoordinator?
                        .addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreUrl)
            } catch {
            }
        }
    }

    deinit {
        print("It's time to DIE")
    }
}

// MARK: - Import Sections
extension StorageHelper {
    func importBaseSections() {
        privateMoc.perform {
            let defaults = UserDefaults()
            let key = "baseSections.hasImported"
            if defaults.bool(forKey: key) {
                return
            }

            guard let url = Bundle.main.url(forResource: "base-sections", withExtension: "json") else {
                return
            }

            //TODO: Catch instead of crashing
            try! self.importSections(url)

            defaults.set(true, forKey: key)
            defaults.synchronize()
        }
    }

    func importSections(from url: URL) {
        privateMoc.perform {
            try! self.importSections(url)
        }
    }

    private func importSections(_ url: URL) throws {
        guard let data = try? Data(contentsOf: url) else {
            throw StorageError.corruptedData
        }
        let json = JSON(data: data)
        for section in json.arrayValue {
            let id = section["id"].int32Value
            let name = section["name"].stringValue
            var themes = [Theme]()

            for theme in section["themes"].arrayValue {
                let id = theme["id"].int32Value
                let name = theme["name"].stringValue
                let content = theme["content"].stringValue

                if let theme = Theme(id: id, content: content, name: name) {
                    themes.append(theme)
                } else {
                    // Log wrong formatted theme
                }
            }

            do {
                try putSection(in: privateMoc, name: name, id: id, themes: themes)
            } catch {
                // Handle error
            }
        }

        guard privateMoc.hasChanges else {
            return
        }

        // Save changes
        do {
            try privateMoc.save()
        } catch {
            throw StorageError.preservingFailed
        }

        moc.performAndWait {
            try! self.save()
        }
    }

    private func putSection(in moc: NSManagedObjectContext, name: String, id: Int32, themes: [Theme]) throws {
        let sectionObject = NSEntityDescription.insertNewObject(forEntityName: StorageEntity.section.rawValue,
                                                                into: moc) as! SectionMO
        sectionObject.id = id
        sectionObject.name = name

        for theme in themes {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: StorageEntity.theme.rawValue)
            request.predicate = NSPredicate(format: "id == \(theme.id)")

            var themeObject: ThemeMO
            if let _ = try! moc.fetch(request).last {
                //TODO: Improve parser to rewrite themes data
                fatalError("Theme's id\(theme) isn't unique")
            } else {
                themeObject = NSEntityDescription.insertNewObject(forEntityName: StorageEntity.theme.rawValue,
                                                                  into: moc) as! ThemeMO
            }
            themeObject.content = theme.content
            themeObject.id = theme.id
            themeObject.name = theme.name

            sectionObject.addToThemes(themeObject)
        }
    }
}

// MARK: - Import Tests
extension StorageHelper {
    func importBaseTests() {
        privateMoc.perform {
            let defaults = UserDefaults()
            let key = "baseTests.hasImported"
            if defaults.bool(forKey: key) {
                return
            }

            guard let url = Bundle.main.url(forResource: "base-tests", withExtension: "json") else {
                return
            }

            try! self.importTests(url)

            defaults.set(true, forKey: key)
            defaults.synchronize()
        }
    }

    private func importTests(_ url: URL) throws {
        guard let data = try? Data(contentsOf: url) else {
            throw StorageError.corruptedData
        }
        let json = JSON(data: data)
        for testJson in json.arrayValue {
            let id = testJson["theme_id"].int32Value
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: StorageEntity.theme.rawValue)
            request.predicate = NSPredicate(format: "id == \(id)")
            guard let any = try? privateMoc.fetch(request).last, let themeObject = any as? ThemeMO else {
                continue
            }

            for contentJson in testJson["content"].arrayValue {
                let testObject = NSEntityDescription.insertNewObject(forEntityName: StorageEntity.test.rawValue,
                                                                     into: privateMoc) as! TestMO
                testObject.content = contentJson.stringValue
                testObject.theme = themeObject

                themeObject.addToTests(testObject)
            }
        }

        guard privateMoc.hasChanges else {
            return
        }

        do {
            try privateMoc.save()
        } catch {
            throw StorageError.preservingFailed
        }

        moc.performAndWait {
            try! self.save()
        }
    }
}

enum StorageError: Error {
    case corruptedData, preservingFailed
}

private enum StorageEntity: String {
    case section = "Section", theme = "Theme", test = "Test"
}

private struct Theme: CustomDebugStringConvertible {
    let
    id: Int32,
    content: String,
    name: String

    init?(id: Int32, content: String, name: String) {
        self.id = id
        self.content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if self.content.isEmpty || self.name.isEmpty {
            return nil
        }
    }

    var debugDescription: String {
        return "<Theme: id=\(id) name=\(name)>"
    }
}
