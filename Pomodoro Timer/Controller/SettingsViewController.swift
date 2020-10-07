////
////  SettingsViewController.swift
////  Pomodoro Focus Timer
////
////  Created by AZM on 2020/10/03.
////
//
//import UIKit
//
//private let reuseIdentifier = "SettingsCell"
//
//class SettingsViewController: UIViewController {
//
//    var tableView: UITableView!
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        overrideUserInterfaceStyle = .light
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
//
//        configureUI()
//    }
//
//    func configureTableView() {
//        tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = 60
//
//        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
//        view.addSubview(tableView)
//        tableView.frame = view.frame
//    }
//
//    func configureUI() {
//        configureTableView()
//
//        //        navigationController?.navigationBar.isTranslucent = false
//        //        navigationController?.navigationBar.barStyle = .black
//    }
//}
//
//extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
//        return cell
//    }
//
//
//}

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
        ["Working Inverval", "Resting Interval"],
        ["Dark Mode"]
    ]
    
    let sectionTitles = [
        "  Set Timer",
        "  General"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        label.text = sectionTitles[section]
        label.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
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
        
        
        let mySwitch = UISwitch()
        mySwitch.onTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        mySwitch.addTarget(self, action: #selector(switchSwitched), for: .valueChanged)
        
//        cell.accessoryView = mySwitch
        
        switch indexPath.section {
        case 0: cell.backgroundColor = .white
        case 1: cell.accessoryView = mySwitch
        default: break
        }
        
        return cell
    }
    
    @objc func switchSwitched(sender: UISwitch) {
        if sender.isOn {
            print("turned on")
        } else {
            print("turned off")
        }
    }
    
}

