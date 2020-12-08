//
//  GFFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 01/12/2020.
//

import UIKit

protocol GFFollowerItemVCDelegate: class { // it's easier to define protocol in a class that will SEND out the message.
    func didTapGitHubFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC { // we inherit all the logic from GFItemInfoVC
    
    weak var delegate: GFFollowerItemVCDelegate! // every time we deal with the delegates, THEY NEED TO BE WEAK so that we avoid the retain cycle!
   
    init(user: User, delegate: GFFollowerItemVCDelegate) { // we create a custom initializer where we provide user and the delegate (see 'configureUIElements()' function in UserInfoVC).
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
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubFollowers(for: user) // When we tap the action button in this VC, it says to its delegate (which is UserInfoVC) that the follower button was tapped.
    }
    
    
}
