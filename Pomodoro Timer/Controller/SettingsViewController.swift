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
        ["Working Inverval"],
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
        tableView.tableFooterView = UIView()
    
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
        cell.selectionStyle = .none
        
        let mySwitch = UISwitch()
        mySwitch.onTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        mySwitch.addTarget(self, action: #selector(switchSwitched), for: .valueChanged)
        
        let button = UIButton(type: .custom)
        button.setTitle("set working timer", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.sizeToFit()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.workButtonTapped)))
        button.titleLabel?.font = UIFont(name: "AvenirNext", size: 10)

//        let button1 = UIButton(type: .custom)
//        button1.setTitle("set resting timer", for: .normal)
//        button1.backgroundColor = .clear
//        button1.setTitleColor(UIColor.darkGray, for: .normal)
//        button1.sizeToFit()
//        button1.addTarget(self, action: #selector(restButtonTapped), for: .touchUpInside)
//        button1.titleLabel?.font = UIFont(name: "AvenirNext", size: 10)
        
        switch indexPath.section {
        case 0: switch indexPath.row {
        case 0: cell.accessoryView = button
//        case 1: cell.accessoryView = button1
        default: break
        }
        case 1: cell.accessoryView = mySwitch
        default: break
        }
        
        return cell
    }

    //MARK: - Selectors
    var isActive = false
    
    @objc func workButtonTapped(sender: UIButton) {
        print("Im being tapped")
        let vc =  SetupViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func switchSwitched(sender: UISwitch) {
        if sender.isOn {
            print("turned on")
        } else {
            print("turned off")
        }
    }
    
}
