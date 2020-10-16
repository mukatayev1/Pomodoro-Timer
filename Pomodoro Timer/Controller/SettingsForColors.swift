//
//  SettingsForColors.swift
//  Pomodoro Timer
//
//  Created by AZM on 2020/10/16.
//

import UIKit

class Settings {
    static let sharedInstance = Settings()
    
    var backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    
    var lightBackgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    var darkBackgroundColor = #colorLiteral(red: 0.2036459889, green: 0.2036459889, blue: 0.2036459889, alpha: 1)
    
    var lightTimeTextColor = UIColor.black
    var darkTimeTextColor = UIColor.white
    
    var lightButtonTextColor = #colorLiteral(red: 0.4156862745, green: 0.09803921569, blue: 0.4901960784, alpha: 1)
    var darkButtonTextColor = UIColor.white
}
