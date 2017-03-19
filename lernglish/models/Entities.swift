//
//  Entities.swift
//  lernglish
//
//  Created by Maxim Belsky on 19/03/2017.
//  Copyright © 2017 Maxim Belsky. All rights reserved.
//

import CoreData

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
