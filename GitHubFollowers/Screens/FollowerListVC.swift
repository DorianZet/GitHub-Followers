//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 07/11/2020.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {
    
    enum Section {
        case main // main section of our collection view. we create it in enum, because it's hashable (needs to be hashable for the diffableDataSource)
    }

    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false // a boolean which checks if we are in a search mode or just browse all the followers.
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>! // Diffable Data Source has to know about the section where it should work (Section) and about our collection view items (Follower)
    
    var isDogModeOn = false
    
    init(username: String) { // now when we push the FollowerListVC, we can initialize it with the username. the initializer automatically sets the VC's username property and VC's title.
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true) // this gets rid of a bug with navbar when transitioning between this VC and searchVC by dragging your finger from the left edge of the screen.
        
        collectionView.setBackgroundColor(forDogMode: GlobalVariables.isDogModeOn)
        view.setBackgroundColor(forDogMode: GlobalVariables.isDogModeOn)
    }
    
    func configureViewController() {
        view.setBackgroundColor(forDogMode: isDogModeOn)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self // now our VC "listens" to the collectionView and will execute code once it meets its requirements set in its extension.
        collectionView.setBackgroundColor(forDogMode: isDogModeOn)
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self // search controller has to have a delegate, which of course will be our VC.
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false // now the collection view is not greyed-out when we activate the search bar.
        navigationItem.searchController = searchController // setting search controller in the navigation controller.
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView() // this function is taken from the extension of UIViewController in 'UIViewController+Ext' file.
        isLoadingMoreFollowers = true // mark the start of loading more followers.
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in // our network manager has a strong reference to the FollowerListVC - this can cause a memory leak. So the solution is to make self WEAK.
            guard let self = self else { return } // unwrapping the 'self' so we don't have to make it optional below.
            
            if self.isDogModeOn == false {
                self.dismissLoadingView() // once the loading finishes, dismiss the loading view (the one with spinning activity indicator).
            }
            
            switch result {
            case .success(let followers): // with 'let followers' we describe what we get if the case is a success.

                if self.isDogModeOn == true {
                    self.getDogs(for: followers, numberOfDogs: followers.count)
                } else {
                    self.updateUI(with: followers)
                }

            case .failure(let error): // with 'let error' we describe what we get if the case is a failure.
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK") // 'rawValue' is an associated type of an enum. in this case it's a String, so in order to have errorMessage comply to the 'message' type in GFAlert, we have to make it a rawValue of the errorMessage - which is a String.
                if self.isDogModeOn == true {
                    self.dismissLoadingView()
                }
            }
            if self.isDogModeOn == false {
                self.isLoadingMoreFollowers = false // loading more followers is finished, so we can set it to false.
            }
        }
    }
    
    func getDogs(for followers: [Follower], numberOfDogs: Int) {
        NetworkManager.shared.getRandomDogs(numberOfDogs: followers.count) { [weak self] (result) in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let dogs):
                var newFollowers = followers

                if !followers.isEmpty {
                    var followerIndex = 0
                    for eachDogMessage in dogs.message {
                        newFollowers[followerIndex].avatarUrl = eachDogMessage // we are switching the original avatar URLs with dog image URLS.
                        followerIndex += 1
                    }
                }
    
                self.updateUI(with: newFollowers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Woof! :(", message: error.rawValue, buttonTitle: "OK")
            }
            self.isLoadingMoreFollowers = false
        }
    }
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 50 {
            hasMoreFollowers = false // when we get the followers, set 'hasMoreFollowers' to false if there are less than 100 of them.
        }
        self.followers.append(contentsOf: followers)
        
        if followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😄."
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
                return
            }
        }
        updateData(on: self.followers)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
        // dataSource takes a snapshot of the current data, takes the snapshot of the new data and then it converges them (with a nice animation)
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>() //
        snapshot.appendSections([.main]) // adding the sections that we want to snapshot
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true) // applying the snapshot on the main thread for safety.
        }
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorites(user: user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] (error) in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user 😃!", buttonTitle: "Woohoo!")
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK") // if saving is unsuccessful, present the alert controller with the error.
        }
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y // the y offset that gets incremented the more we scroll down.
        let contentHeight = scrollView.contentSize.height // height of our content view (for example, if we had 3000 followers, the content view height would be thousands of points!)
        let height = scrollView.frame.height // height of our screen
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, isLoadingMoreFollowers == false else { return } // execute the code below only if the user has more followers than 50 AND when loading more followers is NOT in a process.
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers // if 'isSearching' is true, activeArray = filteredFollowers. if its false, activeArray = followers. it's easier to remember just as W?T:F.
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login // passing the tapped follower's login to the 'username' property in destVC.
        destVC.delegate = self // FollowerListVC is now "listening" to the UserInfoVC
        destVC.isDogModeOn = isDogModeOn
        let navController = UINavigationController(rootViewController: destVC) // create the navigation controller for our destVC.
        present(navController, animated: true) // instead of just presenting destVC, show the navigation controller that our destVC is embedded in.
    }
}

extension FollowerListVC: UISearchResultsUpdating { // anytime we change the search results, it's letting us know that something has changed.
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { // our filter is the text in the search bar. once we have that filter, we want to check if it's not empty. if it is (whether by deleting the text or tapping the 'cancel' button), go back to the original state of collection view.
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) } // we are going through our 'followers' array and we are filtering out based on our 'filter' text. because we iterate through all the followers, '$0' is each follower. as we're going through the followers, we want to check their login, make it lowercased so casing is irrelevant when matching, and see if it contains our 'filter' text (also lowercased, for matching purposes).
        updateData(on: filteredFollowers)
    }

}

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username // update our VC with new username from didRequestFollowers() method.
        title = username
        page = 1
        followers.removeAll() // reset the followers array
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true) // scroll up to the first row of items.
        getFollowers(username: username, page: page)
    }
}

// Basically, delegates work here like that:
// GFItemInfoVC will say "Hey, my button was tapped". -> "UserInfoVC" will say "OK, I will let the FollowerListVC know about that and dismiss myself" -> FollowerListVC will say "OK, I'm making a network call for new username" or "OK, I will show a new Safari VC with the user's profile".
