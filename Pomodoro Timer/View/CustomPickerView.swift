//
//  TimerControlToggleButton.swift
//  Pomodoro Focus Timer
//
//  Created by AZM on 2020/10/03.
//

import UIKit

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: - Properties

    var minutes = [1...60]
    var seconds = [1...60]


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 59
        case 1: return 59
        default: return 0
        }
    }


    //MARK: - initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        initPickerView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
    }

}
