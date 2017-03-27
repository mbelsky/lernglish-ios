//
//  Entities.swift
//  lernglish
//
//  Created by Maxim Belsky on 19/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import CoreData

@objc(ScoreMO)
public class ScoreMO: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScoreMO> {
        return NSFetchRequest<ScoreMO>(entityName: "Score");
    }

    @NSManaged public var correct: Int32
    @NSManaged public var total: Int32
    public var ratio: Float {
        return ceilf(Float(correct) / Float(total) * 100)
    }
    @NSManaged public var theme: ThemeMO?
}

@objc(SectionMO)
public class SectionMO: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionMO> {
        return NSFetchRequest<SectionMO>(entityName: "Section");
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var themes: NSSet?
    public var transientName: String? {
        return name
    }

    // Accessors for themes
    @objc(addThemesObject:)
    @NSManaged public func addToThemes(_ value: ThemeMO)

    @objc(removeThemesObject:)
    @NSManaged public func removeFromThemes(_ value: ThemeMO)

    @objc(addThemes:)
    @NSManaged public func addToThemes(_ values: NSSet)

    @objc(removeThemes:)
    @NSManaged public func removeFromThemes(_ values: NSSet)
}
