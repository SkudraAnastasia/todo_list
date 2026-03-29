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
}

extension Date {
    var toStringDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
