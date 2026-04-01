//
//  ToDoViewModel.swift
//  TO - DO LIST
//
//  Created by Владислав Рылов on 10.03.2026.
//
import Foundation

class ViewModelToDo {
    var todoList = ToDoList()
    
    var tasks: [Task] {
        return todoList.tasks
    }
    
    var isEmpty: Bool {
        tasks.isEmpty
    }
    
    func addTask(text: String, priority: TaskPriority, deadline: Date) {
        
        let newTask = Task(text: text, priority: priority, deadline: deadline)
        todoList.addTask(task: newTask)
    }
    
    func removeTask(id: String) {
        todoList.removeTask(id: id)
    }
    
    func editTask(id: String, newText: String, newPriority: TaskPriority, newDeadline: Date) {
        todoList.editTask(id: id, newText: newText, newPriority: newPriority, newDeadline: newDeadline)
    }
}

extension Date {
    var toStringDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
