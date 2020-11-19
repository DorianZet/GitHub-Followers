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
    var page = 1
    var hasMoreFollowers = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>! // Diffable Data Source has to know about the section where it should work (Section) and about our collection view items (Follower)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
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
    
    func getFollowers(username: String, page: Int) {
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in // our network manager has a strong reference to the FollowerListVC - this can cause a memory leak. So the solution is to make self WEAK.
            guard let self = self else { return } // unwrapping the 'self' so we don't have to make it optional below.
            
            switch result {
            case .success(let followers): // with 'let followers' we describe what we get if the case is a success.
                if followers.count < 100 {
                    self.hasMoreFollowers = false // when we get the followers, set 'hasMoreFollowers' to false if there are less than 100 of them.
                }
                self.followers.append(contentsOf: followers) // add downloaded followers to the array of the followers.
                self.updateData() //

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
    
    func updateData() {
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
