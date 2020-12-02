//
//  GFFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 01/12/2020.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC { // we inherit all the logic from GFItemInfoVC
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubFollowers(for: user) // When we tap the action button in this VC, it says to its delegate (which is UserInfoVC) that the follower button was tapped.
    }
    
    
}
