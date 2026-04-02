//
//  Entity+CoreDataProperties.swift
//  TO - DO LIST
//
//  Created by Anastasia on 01.04.2026.
//
//

public import Foundation
public import CoreData


public typealias EntityCoreDataPropertiesSet = NSSet

extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var priority: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var deadline: Date?

}

extension Entity : Identifiable {

}
