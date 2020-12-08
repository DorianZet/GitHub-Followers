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
}
