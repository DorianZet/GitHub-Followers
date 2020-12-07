//
//  GFTitleLabel.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 07/11/2020.
//

import UIKit

class GFTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) { // convenience initializers first call the designated initializer. In this case, it's init(frame: CGRect) which we override above with our 'configure' function. This is why we no longer have to call 'configure()' both in our init and the designated init, but only in the designated one - as it will always get called with our convenience init.
        self.init(frame: .zero) // convenience initializers use self.init(), not super.init().
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail // if the username is too long, it will add '...' and truncate the name.
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
