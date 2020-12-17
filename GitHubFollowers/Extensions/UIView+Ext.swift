//
//  UIView+Ext.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 08/12/2020.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) { // the variadic parameter ('UIView...') means that the function accepts any number of the parameters we want.
        for view in views {
            addSubview(view)
        }
    }
    
    func pinToEdges(of superview: UIView) { // useful extension when we want to pin the view to the edges of the superview.
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func setBackgroundColor(forDogMode: Bool) {
        if forDogMode == true {
            if traitCollection.userInterfaceStyle == .dark {
                backgroundColor = .secondarySystemBackground
            } else {
                backgroundColor = .systemYellow
            }
        } else {
            backgroundColor = .systemBackground
        }
    }
}
