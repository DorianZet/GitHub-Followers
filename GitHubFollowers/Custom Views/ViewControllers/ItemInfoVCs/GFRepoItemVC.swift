//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 01/12/2020.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC { // we inherit all the logic from GFItemInfoVC
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user) // by tapping the button, we send the action to our delegate (which is UserInfoVC).
    }
    
    
}
