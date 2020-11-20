//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 07/11/2020.
//

import UIKit

class FollowerListVC: UIViewController {
    
    enum Section {
        case main // main section of our collection view. we create it in enum, because it's hashable (needs to be hashable for the diffableDataSource)
    }

    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>! // Diffable Data Source has to know about the section where it should work (Section) and about our collection view items (Follower)
    
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
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self // now our VC "listens" to the collectionView and will execute code once it meets its requirements set in its extension.
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self // search controller has to have a delegate, which of course will be our VC.
        searchController.searchBar.delegate = self // setting our VC to 'listen' to any changes in our searchBar
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false // now the collection view is not greyed-out when we activate the search bar.
        navigationItem.searchController = searchController // setting search controller in the navigation controller.
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView() // this function is taken from the extension of UIViewController in 'UIViewController+Ext' file.
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in // our network manager has a strong reference to the FollowerListVC - this can cause a memory leak. So the solution is to make self WEAK.
            guard let self = self else { return } // unwrapping the 'self' so we don't have to make it optional below.
            
            self.dismissLoadingView() // once the loading finishes, dismiss the loading view (the one with spinning activity indicator).
            
            switch result {
            case .success(let followers): // with 'let followers' we describe what we get if the case is a success.
                if followers.count < 100 {
                    self.hasMoreFollowers = false // when we get the followers, set 'hasMoreFollowers' to false if there are less than 100 of them.
                }
                self.followers.append(contentsOf: followers) // add downloaded followers to the array of the followers.
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😄."
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                        return
                    }
                }
                
                self.updateData(on: self.followers)

            case .failure(let error): // with 'let error' we describe what we get if the case is a failure.
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK") // 'rawValue' is an associated type of an enum. in this case it's a String, so in order to have errorMessage comply to the 'message' type in GFAlert, we have to make it a rawValue of the errorMessage - which is a String.
            }
        }
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
    

}

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y // the y offset that gets incremented the more we scroll down.
        let contentHeight = scrollView.contentSize.height // height of our content view (for example, if we had 3000 followers, the content view height would be thousands of points!)
        let height = scrollView.frame.height // height of our screen
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return } // execute the code below only if the user has more followers than 100.
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}


extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate { // anytime we change the search results, it's letting us know that something has changed.
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return } // our filter is the text in the search bar. once we have that filter, we want to check if it's not empty.
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) } // we are going through our 'followers' array and we are filtering out based on our 'filter' text. because we iterate through all the followers, '$0' is each follower. as we're going through the followers, we want to check their login, make it lowercased so casing is irrelevant when matching, and see if it contains our 'filter' text (also lowercased, for matching purposes).
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers) // when the "Cancel" button is tapped, we want our original followers to appear.
    }
}
