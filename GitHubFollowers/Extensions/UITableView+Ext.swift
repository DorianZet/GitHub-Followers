//
//  UITableView+Ext.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 10/12/2020.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() { // shown for educational purposes. This function is not used in this project.
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
}
