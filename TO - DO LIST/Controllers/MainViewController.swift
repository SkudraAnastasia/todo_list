//
//  ViewController.swift
//  TO - DO LIST
//
//  Created by Анастасия Скудра on 04.03.2026.
//

import UIKit


class MainViewController: UIViewController {
    
    var isHiddenDeleteButton = true
    var statusDoClear: (() -> Void)?
    
    private func toggleEdit() {
        self.isHiddenDeleteButton.toggle()
        self.editButtonLabel.text = isHiddenDeleteButton ? "Edit" : "Done"
        tableViewTasks.reloadData()
    }
    
    private lazy var titleToDo: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "TO DO LIST"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 42, weight: .light)
        
        return $0
    }(UILabel())
    
    private lazy var blurButtonTheme: UIVisualEffectView = {
        
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        $0.effect = blurEffect
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        
        
        let image = UIImageView(image: UIImage(systemName: "sun.max"))
        
        image.frame = CGRect(x: 8, y: 8, width: 32, height: 32)
        image.tintColor = .black
        $0.contentView.addSubview(image)
        
        $0.isUserInteractionEnabled = false
        return $0
    }(UIVisualEffectView())
    
    private lazy var buttonTheme: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = .init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        $0.layer.shadowRadius = 10
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return $0
    }(UIButton())
    
    private lazy var viewTasks: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.shadowColor = .init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        $0.layer.shadowRadius = 2
        $0.layer.shadowOpacity = 0.3
        $0.layer.cornerRadius = 12
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        return $0
    }(UIView())
    
    private lazy var emptyLabel: UILabel = {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "No tasks"
        $0.font = .systemFont(ofSize: 42, weight: .light)
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.isHidden = false
        
        return $0
    }(UILabel())
    
    private lazy var tableViewTasks: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self //объект, который предоставляет данные для таблицы
        $0.delegate = self //обработка нажатий по строкам
        $0.register(TableCellView.self, forCellReuseIdentifier: TableCellView.reuseID)//регистр стандарт ячейку для переиспользования
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
        $0.separatorStyle = .singleLine
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
        $0.separatorStyle = .none
        $0.isHidden = true
        
        return $0
    }(UITableView())
    
    private lazy var blurEditButton: UIVisualEffectView = {
        
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        $0.effect = blurEffect
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
        
        return $0
    }(UIVisualEffectView())
    
    private lazy var editButtonLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Edit"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .black
        
        
        return $0
    }(UILabel())
    
    private lazy var editButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 12
        
        $0.layer.shadowColor = .init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        $0.layer.shadowRadius = 10
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        return $0
    }(UIButton(primaryAction: UIAction { [ weak self ] _ in
        self?.toggleEdit()
    }))
    
    
    private lazy var buttonAddTask: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 32
        $0.layer.shadowColor = .init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        $0.layer.shadowRadius = 10
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let image = UIImageView(image: UIImage(systemName: "plus"))
        image.frame = CGRect(x: 18, y: 18, width: 28, height: 28)
        image.tintColor = .white
        $0.addSubview(image)
        
        return $0
    }(UIButton(primaryAction: UIAction { [weak self]  _ in
        self?.presentAddTask()
    }))
    
    private let tasksViewModel = ViewModelToDo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 235/255, green: 228/255, blue: 221/255, alpha: 1)
        view.addSubview(titleToDo)
        view.addSubview(buttonTheme)
        buttonTheme.addSubview(blurButtonTheme)
        view.addSubview(viewTasks)
        view.addSubview(buttonAddTask)
        view.addSubview(editButton)
        editButton.addSubview(blurEditButton)
        blurEditButton.contentView.addSubview(editButtonLabel)
        viewTasks.addSubview(tableViewTasks)
        viewTasks.addSubview(emptyLabel)
        
        buttonTheme.enableHapticAnimation()
        buttonAddTask.enableHapticAnimation()
        editButton.enableHapticAnimation()
        
        setupConstraints()
        updateEmptyStatus()
    }
    
    private func presentAddTask() {
        let controller = AddNewTaskController()
        controller.modalPresentationStyle = .pageSheet
        controller.delegate = self
        
        if let sheet = controller.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium()]
        }
        
        present(controller, animated: true)
    }
    
    private func updateEmptyStatus() {
        emptyLabel.isHidden = !tasksViewModel.isEmpty
        tableViewTasks.isHidden = tasksViewModel.isEmpty
        editButton.isHidden = tasksViewModel.isEmpty
        blurEditButton.isHidden = tasksViewModel.isEmpty
    }
    
}
// MARK: TableFunctions, Delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksViewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableCellView.reuseID, for: indexPath) as? TableCellView {
        
            let task = tasksViewModel.tasks[indexPath.row]
            cell.setupCell(task: task)
            cell.selectionStyle = .none
            
            cell.removeButton.isHidden = isHiddenDeleteButton
            cell.editImage.isHidden = isHiddenDeleteButton
            
            cell.imageStatus.tintColor = isHiddenDeleteButton ? UIColor(red: 139/255, green: 150/255, blue: 64/255, alpha: 1) : UIColor(red: 139/255, green: 150/255, blue: 64/255, alpha: 0.2)
            cell.todoStatus.backgroundColor = isHiddenDeleteButton ? UIColor(red: 235/255, green: 228/255, blue: 221/255, alpha: 0.4) : UIColor(red: 235/255, green: 228/255, blue: 221/255, alpha: 0.1)
            cell.todoStatus.layer.borderColor = isHiddenDeleteButton ? UIColor(red: 235/255, green: 228/255, blue: 221/255, alpha: 0.6).cgColor : UIColor(red: 235/255, green: 228/255, blue: 221/255, alpha: 0.2).cgColor

            cell.deleteTap = {
                [ weak self, weak tableView ] in
                guard
                    let self = self,
                    let tableView = tableView,
                    let indexPath = tableView.indexPath(for: cell)
                else { return }
                
                let task = self.tasksViewModel.tasks[indexPath.row]
                self.tasksViewModel.removeTask(id: task.id)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateEmptyStatus()
            }
        
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {   //  <-- ф-ия обрабатывает тап
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard isHiddenDeleteButton else { return }
        
        let task = tasksViewModel.tasks[indexPath.row]
        task.toggleIsDone()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: Delegate
extension MainViewController: AddNewTaskProtocolDelegate {
    func didAddTask(text: String, priority: TaskPriority, deadline: Date) {
        tasksViewModel.addTask(text: text, priority: priority, deadline: deadline)
        tableViewTasks.reloadData()
        updateEmptyStatus()
    }
}

extension UIButton {
    func enableHapticAnimation() {
        self.addAction(UIAction  { [ weak self ] _ in
            guard let self = self else { return }
            
            let generator  = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            UIView.animate(withDuration: 0.1, animations: { //встроенный метод для анимации
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                }
            })
        }, for: .touchUpInside) //cобытие кнопки, которое срабатывает когда палец отпускает кнопку.
    }
}

extension MainViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleToDo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleToDo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleToDo.trailingAnchor.constraint(equalTo: buttonTheme.leadingAnchor, constant: -16),
            
            buttonTheme.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            buttonTheme.leadingAnchor.constraint(equalTo: titleToDo.trailingAnchor, constant: 0),
            buttonTheme.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonTheme.widthAnchor.constraint(equalToConstant: 48),
            buttonTheme.heightAnchor.constraint(equalToConstant: 48),
            
            blurButtonTheme.topAnchor.constraint(equalTo: buttonTheme.topAnchor),
            blurButtonTheme.leadingAnchor.constraint(equalTo: buttonTheme.leadingAnchor),
            blurButtonTheme.trailingAnchor.constraint(equalTo: buttonTheme.trailingAnchor),
            blurButtonTheme.bottomAnchor.constraint(equalTo: buttonTheme.bottomAnchor),
            
            viewTasks.topAnchor.constraint(equalTo: titleToDo.bottomAnchor, constant: 32),
            viewTasks.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewTasks.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewTasks.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            
            emptyLabel.centerXAnchor.constraint(equalTo: viewTasks.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: viewTasks.centerYAnchor),
            
            buttonAddTask.widthAnchor.constraint(equalToConstant: 64),
            buttonAddTask.heightAnchor.constraint(equalToConstant: 64),
            buttonAddTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonAddTask.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            tableViewTasks.topAnchor.constraint(equalTo: viewTasks.topAnchor, constant: 48),
            tableViewTasks.leadingAnchor.constraint(equalTo: viewTasks.leadingAnchor, constant: 16),
            tableViewTasks.trailingAnchor.constraint(equalTo: viewTasks.trailingAnchor, constant: -16),
            tableViewTasks.bottomAnchor.constraint(equalTo: viewTasks.bottomAnchor, constant: -16),
            
            editButton.topAnchor.constraint(equalTo: viewTasks.bottomAnchor, constant: 16),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editButton.heightAnchor.constraint(equalToConstant: 28),
            editButton.widthAnchor.constraint(equalToConstant: 120),
            
            blurEditButton.topAnchor.constraint(equalTo: editButton.topAnchor),
            blurEditButton.leadingAnchor.constraint(equalTo: editButton.leadingAnchor),
            blurEditButton.trailingAnchor.constraint(equalTo: editButton.trailingAnchor),
            blurEditButton.bottomAnchor.constraint(equalTo: editButton.bottomAnchor),
            
            editButtonLabel.centerXAnchor.constraint(equalTo: blurEditButton.centerXAnchor),
            editButtonLabel.centerYAnchor.constraint(equalTo: blurEditButton.centerYAnchor)
        ])
    }
}

