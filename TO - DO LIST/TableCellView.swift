//
//  tableCellView.swift
//  TO - DO LIST
//
//  Created by Владислав Рылов on 08.03.2026.
//

import UIKit

class TableCellView: UITableViewCell {
    
    static let reuseID = "todoCell"
    
    private lazy var todoCellView: UIView = {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    private  lazy var todoCellLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.numberOfLines = 0 // перенос текста
        $0.textColor = .black
        
        return $0
    }(UILabel())
    
    lazy var todoStatus: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(red: 235/255, green: 228/255, blue: 221/255, alpha: 0.4)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 235/255, green: 228/255, blue: 221/255, alpha: 0.6).cgColor
        
        return $0
    }(UIView())
    
    lazy var imageStatus: UIImageView = {
        $0.frame = CGRect(x: 3, y: 3, width: 14, height: 14)
        $0.tintColor = UIColor(red: 139/255, green: 150/255, blue: 64/255, alpha: 1)
        return $0
    }(UIImageView())
    
    var deleteTap: (() -> Void)?
    
    lazy var removeButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        
        let image = UIImageView(image: UIImage(systemName: "trash.fill"))
        image.frame = CGRect(x: 4.5, y: 6, width: 24, height: 26)
        image.tintColor = UIColor(red: 225/255, green: 215/255, blue: 210/255, alpha: 1)
        $0.addSubview(image)
        
        return $0
    }(UIButton(primaryAction: UIAction { [weak self] _ in
        self?.deleteTap?()
    }))
    
    lazy var editImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "pencil.line")
        $0.tintColor = UIColor(red: 225/255, green: 215/255, blue: 210/255, alpha: 1)
        
        return $0
    }(UIImageView())
    
    private lazy var priorityLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = .black
        
        return $0
    }(UILabel())
    
    private lazy var priorityImage: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 6
        
        return $0
    }(UIImageView())
    
    private lazy var deadlineLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .black
        
        return $0
    }(UILabel())
    
    private lazy var deadlineImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "watch.analog")
        $0.tintColor = UIColor(red: 225/255, green: 215/255, blue: 210/255, alpha: 1)
        
        return $0
    }(UIImageView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(todoCellView)
        todoCellView.addSubview(removeButton)
        todoCellView.addSubview(todoCellLabel)
        todoCellView.addSubview(todoStatus)
        todoStatus.addSubview(imageStatus)
        todoCellView.addSubview(priorityLabel)
        todoCellView.addSubview(priorityImage)
        todoCellView.addSubview(deadlineLabel)
        todoCellView.addSubview(deadlineImage)
        todoCellView.addSubview(editImage)
        
        setupConstraints()
    }
    
    func setupCell(task: Task) {
        imageStatus.image = task.isDone ? UIImage(systemName: "checkmark") : nil
        todoCellLabel.text = task.text
        priorityLabel.text = task.priority.rawValue
        deadlineLabel.text = task.deadline.toStringDate
        
        priorityImage.backgroundColor =  {
            switch task.priority {
            case .low:
                return .blue
            case .medium:
                return .orange
            case .high:
                return .red
            }
        }()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            todoCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            todoCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            todoCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            todoCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            removeButton.topAnchor.constraint(equalTo: todoCellView.topAnchor, constant: 4),
            removeButton.trailingAnchor.constraint(equalTo: todoCellView.trailingAnchor, constant: -8),
            removeButton.widthAnchor.constraint(equalToConstant: 26),
            removeButton.heightAnchor.constraint(equalToConstant: 26),
            
           
            todoStatus.topAnchor.constraint(equalTo: todoCellView.topAnchor, constant: 8),
            todoStatus.leadingAnchor.constraint(equalTo: todoCellView.leadingAnchor, constant: 8),
            todoStatus.widthAnchor.constraint(equalToConstant: 20),
            todoStatus.heightAnchor.constraint(equalToConstant: 20),
            todoStatus.bottomAnchor.constraint(lessThanOrEqualTo: todoCellView.bottomAnchor, constant: -8),

        
            todoCellLabel.topAnchor.constraint(equalTo: todoCellView.topAnchor, constant: 8),
            todoCellLabel.leadingAnchor.constraint(equalTo: todoStatus.trailingAnchor, constant: 8),
            todoCellLabel.trailingAnchor.constraint(equalTo: todoCellView.trailingAnchor, constant: -32),
            
            editImage.topAnchor.constraint(equalTo: todoStatus.bottomAnchor, constant: 4),
            editImage.leadingAnchor.constraint(equalTo: todoCellView.leadingAnchor, constant: 8),
            editImage.widthAnchor.constraint(equalToConstant: 20),
            editImage.heightAnchor.constraint(equalToConstant: 20),
            
            priorityLabel.topAnchor.constraint(equalTo: todoCellLabel.bottomAnchor, constant: 8),
            priorityLabel.leadingAnchor.constraint(equalTo: todoStatus.trailingAnchor, constant: 26),
            priorityLabel.trailingAnchor.constraint(equalTo: todoCellView.trailingAnchor, constant: -8),
            priorityLabel.bottomAnchor.constraint(equalTo: todoCellView.bottomAnchor, constant: -8),
        
            priorityImage.centerYAnchor.constraint(equalTo: priorityLabel.centerYAnchor),
            priorityImage.leadingAnchor.constraint(equalTo: todoStatus.trailingAnchor, constant: 8),
            priorityImage.heightAnchor.constraint(equalToConstant: 12),
            priorityImage.widthAnchor.constraint(equalToConstant: 12),
            
            deadlineLabel.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 2),
            deadlineLabel.leadingAnchor.constraint(equalTo: todoStatus.trailingAnchor, constant: 26),
            deadlineLabel.trailingAnchor.constraint(equalTo: todoCellView.trailingAnchor, constant: -8),
            
            deadlineImage.centerYAnchor.constraint(equalTo: deadlineLabel.centerYAnchor),
            deadlineImage.leadingAnchor.constraint(equalTo: todoStatus.trailingAnchor, constant: 8),
            deadlineImage.heightAnchor.constraint(equalToConstant: 12),
            deadlineImage.widthAnchor.constraint(equalToConstant: 12)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
