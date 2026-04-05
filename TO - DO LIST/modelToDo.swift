import Foundation

enum TaskPriority: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

class Task {
    private(set) var id: String 
    var text: String
    var isDone: Bool
    var priority: TaskPriority
    var deadline: Date

    
    init(id: String, text: String, isDone: Bool = false, priority: TaskPriority, deadline: Date) {
        self.text = text
        self.isDone = isDone
        self.priority = priority
        self.deadline = deadline
        self.id = id
    }
    convenience init(text: String, isDone: Bool = false, priority: TaskPriority, deadline: Date) {
        self.init(
            id: String(UUID().uuidString.prefix(8)),
            text: text,
            isDone: isDone,
            priority: priority,
            deadline: deadline
        )
    }
}

class ToDoList {
    var tasks: [Task] = []
}
