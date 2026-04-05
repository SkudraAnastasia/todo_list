//
//  ToDoViewModel.swift
//  TO - DO LIST
//
//  Created by Владислав Рылов on 10.03.2026.
//
import Foundation
import CoreData

final class ViewModelToDo {
    private let todoList = ToDoList()

    var tasks: [Task] {
        todoList.tasks
    }
    
    var isEmpty: Bool {
        tasks.isEmpty
    }
    
    init() {
        fetchTasks()
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            let entities = try CoreDataManager.shared.context.fetch(request)

            todoList.tasks = entities.compactMap { entity in
                guard
                    let id = entity.id,
                    let text = entity.text,
                    let priorityRaw = entity.priority,
                    let priority = TaskPriority(rawValue: priorityRaw),
                    let deadline = entity.deadline
                else {
                    return nil
                }
                return Task(
                    id: id,
                    text: text,
                    isDone: entity.isDone,
                    priority: priority,
                    deadline: deadline,
                )
            }
        } catch {
            todoList.tasks = []
        }
    }
     
    func addTask(text: String, priority: TaskPriority, deadline: Date) {
        let newTask = Task(
            text: text,
            priority: priority,
            deadline: deadline
        )
        
        let entity = CoreDataManager.shared.createEnity(type: Entity.self)
        entity.id = newTask.id
        entity.text = newTask.text
        entity.priority = newTask.priority.rawValue
        entity.deadline = newTask.deadline
        entity.isDone = newTask.isDone
        
        CoreDataManager.shared.save()
        fetchTasks()
    }
    
    func removeTask(id: String) {
        let predicate = NSPredicate(format: "id == %@", id)
        
        if let entity = CoreDataManager.shared.fetchEnities(type: Entity.self, predicate: predicate).first {
            CoreDataManager.shared.deleteEntity(entity: entity)
            CoreDataManager.shared.save()
            fetchTasks()
        }
    }
    
    func editTask(id: String, newText: String, newPriority: TaskPriority, newDeadline: Date) {
        let predicate = NSPredicate(format: "id == %@", id)
        
        if let entity = CoreDataManager.shared.fetchEnities(type: Entity.self, predicate: predicate).first {
            entity.text = newText
            entity.priority = newPriority.rawValue
            entity.deadline = newDeadline
            
            CoreDataManager.shared.save()
            fetchTasks()
        }
    }
    
    func toggleIsDone(id: String) {
        let predicate = NSPredicate(format: "id == %@", id)
        
        if let entity = CoreDataManager.shared.fetchEnities(type: Entity.self, predicate: predicate).first {
            entity.isDone.toggle()
            
            CoreDataManager.shared.save()
            fetchTasks()
        }
    }
}


extension Date {
    var toStringDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
