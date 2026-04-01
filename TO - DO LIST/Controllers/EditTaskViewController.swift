//
//  EditTaskViewController.swift
//  TO - DO LIST
//
//  Created by Anastasia on 30.03.2026.
//
import UIKit

protocol EditTaskProtocolDelegate: AnyObject {
    func didEditTask(text: String, priority: TaskPriority, deadline: Date)
}
class EditTaskViewController: UIViewController {
    
    weak var delegate: EditTaskProtocolDelegate? //сделать ф-ию редактирования, если нажат эдит, при тапе всплывает окно
    
    private lazy var scrollView: UIScrollView = {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.keyboardDismissMode = .interactive
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        
        return $0
    }(UIScrollView())
    
    private lazy var contentView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIView())
    
    private lazy var labelEditTask: UILabel = {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Edit task"
        $0.font = .systemFont(ofSize: 32, weight: .light)
        $0.textColor = .black
        
        return $0
    }(UILabel())
    
    private lazy var taskEditTextView: UITextView = { //сделать так, чтоб при нажатии был написан текст таски
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16, weight: .light)
        $0.textColor = .black
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.tintColor = UIColor(red: 200/255, green: 190/255, blue: 190/255, alpha: 1)
        $0.delegate = self
        
        return $0
    }(UITextView())
    
    private lazy var placeholderLabel: UILabel  = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Enter task..."
        $0.font = .systemFont(ofSize: 16, weight: .light)
        $0.textColor = .lightGray
        
        
        return $0
    }(UILabel())
    
     lazy var prioritySegmentControl: UISegmentedControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.selectedSegmentIndex = 1
        
        return $0
    }(UISegmentedControl(items: ["Low", "Medium", "High"]))
    
    private lazy var deadlinePicker: UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.minimumDate = Date()
        
        let calendar = Calendar.current
        if let maxDate = calendar.date(byAdding: .year, value: 2, to: Date()) {
            $0.maximumDate = maxDate
        }
        return $0
    }(UIDatePicker())
    
    private lazy var blurSaveButton: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        $0.effect = blurEffect
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 22
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        $0.clipsToBounds = true
        
        
        return $0
    }(UIVisualEffectView())
    
    private lazy var saveButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Save", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.backgroundColor = .clear
        $0.layer.shadowRadius = 10
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return $0
    }(UIButton(primaryAction: UIAction { [weak self] _ in
        self?.editTask()
    }))
    
     func config(task: Task) {
         
        taskEditTextView.text = task.text
        placeholderLabel.isHidden = !task.text.isEmpty
        deadlinePicker.date = task.deadline
        
     switch task.priority {
            case .low:
                prioritySegmentControl.selectedSegmentIndex = 0
            case .medium:
                prioritySegmentControl.selectedSegmentIndex = 1
            case .high:
                prioritySegmentControl.selectedSegmentIndex = 2
        }
    }
    
    func editTask() {
        let text = taskEditTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    
        guard !text.isEmpty else { return }
        
        let priority = selectedPriority()
        let deadline = deadlinePicker.date
        
        delegate?.didEditTask(text: text, priority: priority, deadline: deadline)
        
        dismiss(animated: true)
    }


     func selectedPriority() -> TaskPriority {
        
        switch prioritySegmentControl.selectedSegmentIndex {
        case 0:
            return .low
        case 1:
            return .medium
        case 2:
            return .high
        default:
            return .medium
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(labelEditTask)
        contentView.addSubview(taskEditTextView)
        contentView.addSubview(prioritySegmentControl)
        contentView.addSubview(deadlinePicker)
        contentView.addSubview(blurSaveButton)
        blurSaveButton.contentView.addSubview(saveButton)
        taskEditTextView.addSubview(placeholderLabel)
        
        saveButton.enableHapticAnimation()
        setupConstrains()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        taskEditTextView.becomeFirstResponder()
        }
    }

// MARK: Delegate
extension EditTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: constraints
extension EditTaskViewController {
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            labelEditTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelEditTask.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            labelEditTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: labelEditTask.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            taskEditTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            taskEditTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            taskEditTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskEditTextView.heightAnchor.constraint(equalToConstant: 90),
            
            placeholderLabel.topAnchor.constraint(equalTo: taskEditTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: taskEditTextView.leadingAnchor, constant: 6),
            
            blurSaveButton.topAnchor.constraint(equalTo: deadlinePicker.bottomAnchor, constant: 26),
            blurSaveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 68),
            blurSaveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -68),
            blurSaveButton.heightAnchor.constraint(equalToConstant: 56),
            
            saveButton.leadingAnchor.constraint(equalTo: blurSaveButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: blurSaveButton.trailingAnchor),
            saveButton.topAnchor.constraint(equalTo: blurSaveButton.topAnchor),
            saveButton.bottomAnchor.constraint(equalTo: blurSaveButton.bottomAnchor),
            
            deadlinePicker.topAnchor.constraint(equalTo: taskEditTextView.bottomAnchor, constant: 42),
            deadlinePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deadlinePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deadlinePicker.heightAnchor.constraint(equalToConstant: 150),
            
            prioritySegmentControl.topAnchor.constraint(equalTo: taskEditTextView.bottomAnchor, constant: 0),
            prioritySegmentControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            prioritySegmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            prioritySegmentControl.heightAnchor.constraint(equalToConstant: 28),
            
            blurSaveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
