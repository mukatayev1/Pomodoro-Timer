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
        setShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
        setShadow()
    }
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = #colorLiteral(red: 0.4156862745, green: 0.09803921569, blue: 0.4901960784, alpha: 1).cgColor
        titleLabel?.font = UIFont(name: "AvenirNext - DemiBold", size: 20)
        layer.cornerRadius = 25
        layer.borderWidth = 1.0
        setTitle("Start", for: .normal)
        backgroundColor = .clear
        setTitleColor(.black , for: .normal)
    }
    
    private func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 0.6)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
        
    }
    
}

//MARK: - Extending UIButton class for the animation purposes

extension UIButton {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.7
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}
