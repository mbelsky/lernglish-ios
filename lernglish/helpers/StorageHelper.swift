//
//  StorageHelper.swift
//  lernglish
//
//  Created by Maxim Belsky on 17/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import CoreData

enum StorageEntity: String {
    case section = "Section", theme = "Theme"
}

class StorageHelper {
    static let instance = StorageHelper()
    
    private let
    coordinator: NSPersistentStoreCoordinator,
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
        return NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "section.name", cacheName: nil)
    }

    func putSection(_ name: String, id: Int32, themes: [(String, String, Int32)]) throws {
        let sectionObject = NSEntityDescription.insertNewObject(forEntityName: StorageEntity.section.rawValue,
                                                                into: moc) as! SectionMO
        sectionObject.id = id
        sectionObject.name = name
        
        for pair in themes {
            let themeObject = NSEntityDescription.insertNewObject(forEntityName: StorageEntity.theme.rawValue,
                                                                  into: moc) as! ThemeMO
            themeObject.content = pair.1
            themeObject.id = pair.2
            themeObject.name = pair.0
            
            sectionObject.addToThemes(themeObject)
        }
        
        try save()
    }
    
    private func save() throws {
        if moc.hasChanges {
            try moc.save()
        }
    }
    
    private init?() {
        guard let modelUrl = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
            return nil
        }
        guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            return nil
        }

        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return nil
        }
        
        // move in background thread
        let persistentStoreUrl = documents.appendingPathComponent("lernglish.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil,
                                               at: persistentStoreUrl)
        } catch {
            return nil
        }
        
        moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = coordinator
        privateMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMoc.persistentStoreCoordinator = coordinator
    }
}
