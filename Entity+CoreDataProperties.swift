//
//  Entity+CoreDataProperties.swift
//  TO - DO LIST
//
//  Created by Anastasia on 02.04.2026.
//
//

public import Foundation
public import CoreData


public typealias EntityCoreDataPropertiesSet = NSSet

extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var text: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var prioriry: String?
    @NSManaged public var deadline: Date?
    @NSManaged public var id: String?

}

extension Entity : Identifiable {

}
