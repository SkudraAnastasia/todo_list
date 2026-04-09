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
    
    var editingTaskID: String?
    
    private func toggleEdit() {
        self.isHiddenDeleteButton.toggle()
        
        UIView.performWithoutAnimation {
            if isHiddenDeleteButton {
                editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                editButton.tintColor = .black
            } else {
                editButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                editButton.tintColor = UIColor(red: 139/255, green: 180/255, blue: 64/255, alpha: 1)
            }
            editButton.layoutIfNeeded()
        }
        
        tableViewTasks.reloadData()
    }
    
    private lazy var titleToDo: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "TO DO LIST"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 42, weight: .light)
        
        return $0
    }(UILabel())
    
    private lazy var buttonTheme: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.configuration = .glass()
        $0.configuration?.image = UIImage(systemName: "sun.max")
        
        $0.layer.shadowColor = .init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        $0.layer.shadowRadius = 6
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return $0
    }(UIButton())
    
    private lazy var editButton: UIButton = {
       // $0.translatesAutoresizingMaskIntoConstraints = false
        
        //$0.configuration = .prominentClearGlass()
        //$0.configuration?.baseBackgroundColor = UIColor(red: 245/255, green: 238/255, blue: 231/255, alpha: 1)
       // $0.configuration?.image = UIImage(systemName: "pencil")
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.tintColor = .black
        $0.backgroundColor = .clear
        
       
        return $0
    }(UIButton(primaryAction: UIAction { [ weak self ] _ in
        self?.toggleEdit()
    }))
    
    
    private lazy var viewTasks: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear

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
        
        $0.contentInset.bottom = 90
        
        return $0
    }(UITableView())
    
    private lazy var buttonAddTask: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.configuration = .glass()
        $0.layer.shadowColor = .init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        $0.layer.shadowRadius = 10
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.configuration?.image = UIImage(systemName: "plus")

        
        return $0
    }(UIButton(primaryAction: UIAction { [weak self]  _ in
        self?.presentAddTask()
    }))
    
    private let tasksViewModel = ViewModelToDo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TO-DO LIST"
        navBar()
        
        view.backgroundColor = UIColor(red: 245/255, green: 238/255, blue: 231/255, alpha: 1)
        setupViews()
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
    
    private func presentEditTask(id: String) {
        let controller = EditTaskViewController()
        controller.modalPresentationStyle = .pageSheet
        controller.delegate = self
        if let task = tasksViewModel.tasks.first(where: { $0.id == id }) {
            controller.config(task: task)
        }
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
                tableView.reloadData()
                self.updateEmptyStatus()
            }
        
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {   //  <-- ф-ия обрабатывает тап
        tableView.deselectRow(at: indexPath, animated: false)
    
        if isHiddenDeleteButton {
            let task = tasksViewModel.tasks[indexPath.row]
            tasksViewModel.toggleIsDone(id: task.id)
        } else {
            let task = tasksViewModel.tasks[indexPath.row]
            editingTaskID = task.id
            self.presentEditTask(id: task.id)
        }
        
        tableView.reloadData()
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
extension MainViewController: EditTaskProtocolDelegate {
    func didEditTask(text: String, priority: TaskPriority, deadline: Date) {
        guard let id = editingTaskID else { return }
        tasksViewModel.editTask(id: id, newText: text, newPriority: priority, newDeadline: deadline)
        tableViewTasks.reloadData()
        updateEmptyStatus()
    }
}
// MARK: Animation
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
// MARK: SetupViews
extension MainViewController {
    func setupViews() {
        view.addSubview(viewTasks)
        //view.addSubview(titleToDo)
       // view.addSubview(buttonTheme)
        view.addSubview(buttonAddTask)
      //   view.addSubview(editButton)
        viewTasks.addSubview(tableViewTasks)
        viewTasks.addSubview(emptyLabel)
        
        buttonTheme.enableHapticAnimation()
        buttonAddTask.enableHapticAnimation()
        editButton.enableHapticAnimation()
    }
}

// MARK: NagigationBar
extension MainViewController {
    
    func navBar() {
        let bar = UINavigationBarAppearance()
        
        bar.configureWithTransparentBackground()
        bar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = bar
        navigationController?.navigationBar.scrollEdgeAppearance = bar
        navigationController?.navigationBar.compactAppearance = bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
}

// MARK: Constraits
extension MainViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
//            titleToDo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            titleToDo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            titleToDo.trailingAnchor.constraint(equalTo: buttonTheme.leadingAnchor, constant: -16),
            
//            buttonTheme.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            buttonTheme.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            buttonTheme.widthAnchor.constraint(equalToConstant: 48),
//            buttonTheme.heightAnchor.constraint(equalToConstant: 48),
            
//            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            editButton.trailingAnchor.constraint(equalTo: buttonTheme.leadingAnchor, constant: -12),
//            editButton.heightAnchor.constraint(equalToConstant: 48),
//            editButton.widthAnchor.constraint(equalToConstant: 48),
            
            viewTasks.topAnchor.constraint(equalTo: view.topAnchor),
            viewTasks.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewTasks.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewTasks.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: viewTasks.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: viewTasks.centerYAnchor),
            
            buttonAddTask.widthAnchor.constraint(equalToConstant: 64),
            buttonAddTask.heightAnchor.constraint(equalToConstant: 64),
            buttonAddTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonAddTask.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            tableViewTasks.topAnchor.constraint(equalTo: viewTasks.topAnchor),
            tableViewTasks.leadingAnchor.constraint(equalTo: viewTasks.leadingAnchor),
            tableViewTasks.trailingAnchor.constraint(equalTo: viewTasks.trailingAnchor),
            tableViewTasks.bottomAnchor.constraint(equalTo: viewTasks.bottomAnchor),
            
        ])
    }
}

