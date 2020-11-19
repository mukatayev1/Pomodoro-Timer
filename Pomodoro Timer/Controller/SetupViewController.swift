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
    
    //MARK: - Properties
    
    var delegate: SetupViewControllerDelegate?
    
    private let setTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Timer Time"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.backgroundColor = ModeTheme.light.backgroundColor
        return picker
    }()
    
    let doneButton: UIButton = {
        let button = OnOffButton()
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let timerVC = TimerViewController()
    
    var darkMode = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ModeTheme.light.backgroundColor
        
        setupDarkMode()
        //Subviews
        timerPickerSubviewed()
        doneButtonSubviewed()
        setTimerLabelSubviewed()
    }
    
    //MARK: - Helpers
    
    func setupDarkMode() {
        darkMode = true
        //notification for Dark Mode settings
        NotificationCenter.default.addObserver(self, selector: #selector(enableDarkMode), name: Notification.Name("darkMode"), object: nil)
    }
    
    //MARK: - Subvewing
    
    func setTimerLabelSubviewed() {
        view.addSubview(setTimerLabel)
        setTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        setTimerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        setTimerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        setTimerLabel.topAnchor.constraint(equalTo: timePicker.topAnchor, constant: -40).isActive = true
    }
    
    func timerPickerSubviewed() {
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func doneButtonSubviewed() {
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
    }
    
    //MARK: - Selectors
    
    @objc func enableDarkMode() {
        //user defaults for going back to light mode.
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        let theme = isDarkMode ? ModeTheme.dark : ModeTheme.light
        view.backgroundColor = theme.backgroundColor
    }
    
    @objc func doneButtonTapped() {
//        dismiss(animated: true, completion: nil)
        let pickedTime = timePicker.countDownDuration
        delegate?.didSetTimer(pickedTime)
    }

}
