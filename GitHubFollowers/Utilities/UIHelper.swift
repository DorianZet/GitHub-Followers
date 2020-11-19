//
//  UIHelper.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 18/11/2020.
//

import UIKit

struct UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout { // we are making the function static so that it can be used outside of UIHelper.
        let width = view.bounds.width // total width of the screen
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2) // the width that will be divided by 3 is the width of the screen minus the left and right padding and the spacing between the columns.
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40) // + 40 in item height gives us extra space for the label at the bottom.
        
        return flowLayout
    }
    
}
