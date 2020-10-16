//
//  SettingsViewController.swift
//  Pomodoro Focus Timer
//
//  Created by AZM on 2020/10/03.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let cellID = "cellID-123"
    
    let sectionNames = [
//        ["Working Inverval"],
        ["Dark Mode"]
    ]
    
    let sectionTitles = [
        "  General",
        "  Set Timer"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    
    }
    
    //MARK: - Setup for TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        label.text = sectionTitles[section]
        label.backgroundColor = #colorLiteral(red: 0.4156862745, green: 0.09803921569, blue: 0.4901960784, alpha: 1)
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext - Bold", size: 20)
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionNames[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let name = sectionNames[indexPath.section][indexPath.row]
        cell.textLabel?.text = name
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
        let mySwitch = UISwitch()
        mySwitch.onTintColor = #colorLiteral(red: 0.4156862745, green: 0.09803921569, blue: 0.4901960784, alpha: 1)
        mySwitch.addTarget(self, action: #selector(switchSwitched), for: .valueChanged)
//
        switch indexPath.section {
        case 0: switch indexPath.row {
        case 0: cell.accessoryView = mySwitch
        default: break
        }
//        case 1: cell.accessoryView = button
        default: break
        }
        
        return cell
    }
    
    
    //MARK: - Selectors
    var isActive = false
    
    @objc func switchSwitched(sender: UISwitch) {
        
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkMode")
        
        let currentMode = sender.isOn ? ModeTheme.dark : ModeTheme.light
        
        //            print("turned on")
        NotificationCenter.default.post(name: Notification.Name("darkMode"), object: nil)
        
        view.backgroundColor = currentMode.backgroundColor
        tableView.backgroundColor = currentMode.backgroundColor
        navigationController?.navigationBar.barTintColor = currentMode.backgroundColor
        navigationController?.tabBarController?.tabBar.barTintColor = currentMode.backgroundColor
        navigationController?.tabBarController?.tabBar.tintColor = sender.isOn ? #colorLiteral(red: 1, green: 0.6470588235, blue: 0.6901960784, alpha: 1) : #colorLiteral(red: 0.4156862745, green: 0.09803921569, blue: 0.4901960784, alpha: 1)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: currentMode.textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
}
