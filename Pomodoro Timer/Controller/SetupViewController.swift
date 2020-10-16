//
//  SetupViewController.swift
//  Pomodoro Timer
//
//  Created by AZM on 2020/10/12.
//

import UIKit

protocol SetupViewControllerDelegate {
    func didSetTimer(_ time: TimeInterval)
}

class SetupViewController: UIViewController {
    
    var delegate: SetupViewControllerDelegate?
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.backgroundColor = ModeTheme.light.backgroundColor
        return picker
    }()
    
    func timerPickerSubviewed() {
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    let doneButton: UIButton = {
        let button = OnOffButton()
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func doneButtonSubviewed() {
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerPickerSubviewed()
        doneButtonSubviewed()
        view.backgroundColor = ModeTheme.light.backgroundColor
        
        setupDarkMode()
    }
    
    //MARK: - Enabling Dark Mode
    
    var darkMode = false
    func setupDarkMode() {
        darkMode = true
        //notification for Dark Mode settings
        NotificationCenter.default.addObserver(self, selector: #selector(enableDarkMode), name: Notification.Name("darkMode"), object: nil)
    }
    
    
    //MARK: - selectors
    
    let timerVC = TimerViewController()
    @objc func doneButtonTapped() {
//        dismiss(animated: true, completion: nil)
        let pickedTime = timePicker.countDownDuration
        delegate?.didSetTimer(pickedTime)
        
    }
    
    @objc func enableDarkMode() {
        //user defaults for going back to light mode.
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        
        let theme = isDarkMode ? ModeTheme.dark : ModeTheme.light
        
        view.backgroundColor = theme.backgroundColor
//        navigationController?.navigationBar.barTintColor = theme.backgroundColor
 
    }
}
