//
//  GFTextField.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 07/11/2020.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        
        textColor = .label // black on light mode, white on dark mode.
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no // don't use the autocorrection when putting in a user name.
        keyboardType = .default // we can use many kinds of keyboard types for text fields etc., but here a default one is all we need.
        returnKeyType = .go // what return (or ENTER) button says.
        clearButtonMode = .whileEditing // adds a little button to the text field that clears the text when tapped.
        placeholder = "Enter a username"
    }
}
