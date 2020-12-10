//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 01/12/2020.
//

import UIKit

protocol GFRepoItemVCDelegate: class { // it's easier to define protocol in a class that will SEND out the message.
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC { // we inherit all the logic from GFItemInfoVC
    
    weak var delegate: GFRepoItemVCDelegate! // every time we deal with the delegates, THEY NEED TO BE WEAK so that we avoid the retain cycle!
    
    init(user: User, delegate: GFRepoItemVCDelegate) { // we create a custom initializer where we provide user and the delegate (see 'configureUIElements()' function in UserInfoVC).
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
