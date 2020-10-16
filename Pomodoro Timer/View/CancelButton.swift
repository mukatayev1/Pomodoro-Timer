//
//  CustomButton.swift
//  Pomodoro Focus Timer
//
//  Created by AZM on 2020/10/03.
//

import UIKit

class CancelButton: UIButton {
    
    let timerButton = OnOffButton()
    
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
        setTitle("Cancel", for: .normal)
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
