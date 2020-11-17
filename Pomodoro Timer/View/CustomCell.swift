//
//  CustomCell.swift
//  Pomodoro Timer
//
//  Created by AZM on 2020/10/16.
//

import UIKit

class CustomCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        ModeThemeManager.addDarkModeObserver(to: self, selector: #selector(enableDarkMode))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func enableDarkMode() {
        let currentTheme = ModeThemeManager.currentTheme
        backgroundColor = currentTheme.backgroundColor
        textLabel?.textColor = currentTheme.textColor
    }
}
