//
//  SettingsForColors.swift
//  Pomodoro Timer
//
//  Created by AZM on 2020/10/16.
//

import UIKit

struct ModeTheme {
    let textColor: UIColor
    let backgroundColor: UIColor
    
    static let dark = ModeTheme(textColor: .white, backgroundColor: #colorLiteral(red: 0.1767528553, green: 0.1767528553, blue: 0.1767528553, alpha: 1))
    static let light = ModeTheme(textColor: .black, backgroundColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1))
}
