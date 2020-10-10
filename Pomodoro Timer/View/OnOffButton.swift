//
//  TimerControlToggleButton.swift
//  Pomodoro Focus Timer
//
//  Created by AZM on 2020/10/03.
//

import UIKit

class OnOffButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor
        titleLabel?.font = UIFont(name: "AvenirNext - DemiBold", size: 20)
        layer.cornerRadius = 25
        layer.borderWidth = 1.0
        setTitle("Start", for: .normal)
        backgroundColor = .clear
        setTitleColor(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), for: .normal)
    }
    
}
