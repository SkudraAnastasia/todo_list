//
//  SettingsController.swift
//  TO - DO LIST
//
//  Created by Anastasia on 08.04.2026.
//

import UIKit

struct SettingsItem {
    let title: String
    let image: UIImage?
}

class SettingsViewController: UIViewController {
    
    private let items: [SettingsItem] = [
        SettingsItem(title: "Theme", image: UIImage(systemName: "sun.max.fill")),
        SettingsItem(title: "Language", image: UIImage(systemName: "globe"))
    ]
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    
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
        $0.layer.cornerRadius = 34
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
        $0.showsVerticalScrollIndicator = false
        $0.clipsToBounds = true
        $0.isScrollEnabled = false
        $0.tableFooterView = UIView()
        
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        view.addSubview(settingsLabel)
        view.addSubview(tableViewSettings)
        
        setupConstraints()
        tableViewSettings.reloadData()
        tableViewSettings.layoutIfNeeded()
        tableViewHeightConstraint?.constant = tableViewSettings.contentSize.height
        
    }
}

// MARK: Constraints
extension SettingsViewController {
    func setupConstraints() {
        tableViewHeightConstraint = tableViewSettings.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            settingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            tableViewSettings.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 12),
            tableViewSettings.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableViewSettings.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        tableViewHeightConstraint?.isActive = true
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = items[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = item.title
        content.image = item.image
        content.imageProperties.tintColor = .black
        cell.contentConfiguration = content
        
        let switchControl = UISwitch()
        if indexPath.row == 0 {
            cell.accessoryView = switchControl
        } else {
            cell.accessoryView = nil
        }
        
        
      //  cell.backgroundColor = .clear
        cell.selectionStyle = .none
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
