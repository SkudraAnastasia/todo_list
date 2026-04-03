//
//  CoreDataManager.swift
//  TO - DO LIST
//
//  Created by Anastasia on 02.04.2026.
//
import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init (){}
    
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is not found")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func createEnity<T: NSManagedObject>(type: T.Type) -> T {
        return T(context: context)
    }
    
    func fetchEnities<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let request = T.fetchRequest()
        request.predicate = predicate
        do {
            return try context.fetch(request) as? [T] ?? []
        } catch {
            print("error")
            return []
        }
    }
    
    func deleteEntity(entity: NSManagedObject) {
        context.delete(entity)
    }
    
    func save() {
        if let AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            AppDelegate.saveContext()
        }
    }
}
