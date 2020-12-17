//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 21/11/2020.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    
    let scrollView = UIScrollView()
    let contentView = UIView() // scroll view content view, where we put all the UI elements.
    
    let headerView = UIView() // this is a container view for a child view controller (which in this case will be GFUserInfoHeaderVC).
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []

    var username: String!
    weak var delegate: UserInfoVCDelegate!
    
    var isDogModeOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        view.setBackgroundColor(forDogMode: isDogModeOn)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view) // using the extension to pin the edges of our scroll view to the general view.
        contentView.pinToEdges(of: scrollView) // pinning the edges of our content view to the scroll view.
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600) // manually dialed-in height for the scroll view, which look good on iPhone SE. As the content will be all layed out at once on all other iPhones, scroll view will be automatically disabled there.
        ])
        
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func configureUIElements(with user: User) {
        let repoItemVC = GFRepoItemVC(user: user, delegate: self)
        let followerItemVC = GFFollowerItemVC(user: user, delegate: self)
        
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView) // if we manage to download the user info, present the GFUserInfoHeaderVC in the headerView, showing all the info about the user
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView) // adding the subviews by going through them in a loop. NOTE THAT we add the itemViews to the contentView, NOT the general view.
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([ // putting the leading and trailing anchor in the loop, as they are the same for all the item views.
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

}

extension UserInfoVC: GFRepoItemVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid.", buttonTitle: "OK")
            return
        }
        
        presentSafariVC(with: url)
    }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
    func didTapGitHubFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers 😔", buttonTitle: ":(")
            return
        }
        
        delegate.didRequestFollowers(for: user.login) // once the button is tapped, UserInfoVC passess the info to FollowerListVC
        dismissVC() // dismiss the UserInfoVC to return to FollowerListVC.
    }
}


