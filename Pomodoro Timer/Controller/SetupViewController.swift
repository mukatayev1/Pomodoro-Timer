//
//  SetupViewController.swift
//  Pomodoro Timer
//
//  Created by AZM on 2020/10/12.
//

import UIKit

class SetupViewController: UIViewController {
    
    public var completionHandler: ((TimeInterval) -> Void)?
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        return picker
    }()
    
    func timerPickerSubviewed() {
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePicker.widthAnchor.constraint(equalToConstant: view.frame.width - 65).isActive = true
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
        view.backgroundColor = .white
    }
    
    
    //MARK: - selectors
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
        
        let pickedTime = timePicker.countDownDuration
        navigationController?.popToRootViewController(animated: true)
        
    }
}
