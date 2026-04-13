//
//  SettingsController.swift
//  TO - DO LIST
//
//  Created by Anastasia on 08.04.2026.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var settingsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Settings"
        $0.font = .systemFont(ofSize: 42, weight: .light)
        $0.textColor = .black
        $0.textAlignment = .right
        
        return $0
    }(UILabel())
    
    private lazy var tableViewSettings: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .snowWhite
        $0.layer.cornerRadius = 28
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
        $0.showsVerticalScrollIndicator = false
        $0.clipsToBounds = true
        
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        view.addSubview(settingsLabel)
        view.addSubview(tableViewSettings)
        
        setupConstraints()
    }
}

// MARK: Constraints
extension SettingsViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            settingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            tableViewSettings.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 12),
            tableViewSettings.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableViewSettings.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableViewSettings.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
        ])
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "1"
        cell.backgroundColor = .clear
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
