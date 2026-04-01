import Foundation

enum TaskPriority: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

class Task {
    private(set) var id: String = String(UUID().uuidString.prefix(8))
    var text: String
    var isDone: Bool
    var priority: TaskPriority
    var deadline: Date
    
    func toggleIsDone() {
        isDone.toggle()
    }
    
    init(text: String, isDone: Bool = false, priority: TaskPriority, deadline: Date) {
        self.text = text
        self.isDone = isDone
        self.priority = priority
        self.deadline = deadline
    }
}

class ToDoList {
    var tasks: [Task] = []
    
    
    func addTask(task: Task) {
        tasks.append(task)
    }
    
    func removeTask(id: String) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks.remove(at: index)
    }
    
    func editTask(id: String, newText: String, newPriority: TaskPriority, newDeadline: Date) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        
        let task = tasks[index]
        task.text = newText
        task.priority = newPriority
        task.deadline = newDeadline
    }
}
