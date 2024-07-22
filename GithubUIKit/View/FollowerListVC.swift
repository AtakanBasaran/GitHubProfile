//
//  FollowerListVC.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 13.07.2024.
//

import UIKit

class FollowerListVC: UIViewController {
    
    enum Section { //Enums Hashable by default
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    var page = 1
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>! //we force unwrap since we configure in viewDidLoad
    var hasMoreFollowers = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getFollowers(username: String, page: Int) {
        
        showLoadingView()
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in //we use weak self since network function has a strong reference to the self which means FollowerListVC
                    
            guard let self = self else {return}
            
            self.dismissLoadingView()
            
            switch result {
                
            case .success(let followers):
                
                hasMoreFollowers = !(followers.count < 100)
                
                self.followers.append(contentsOf: followers)
                
                
                if self.followers.isEmpty { //isEmpty is more efficient than .count = 0. We check after appending since followers that comes from can be 0 after last request but we need to look at the total followers after network call
                    let message = "This user doesn't have any followers. Go follow them 😀"
                    
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                        return //if we have no follower stop the func
                    }
                }
                
                self.updateData()
                
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message:  error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
}


//MARK: - Collection View Arranging

extension FollowerListVC {
    
    
    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
    }
    
    
    func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
            
        })
    }
    
    func updateData() { // we used NSDiffableDataSourceSnapshot for search functionality among followers, if not, we could use DataSource protocol for collection view
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>() //for UI updates after getting fetched data
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
        
        
    }
    
}

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY = scrollView.contentOffset.y // how far we scroll down
        let contentHeight = scrollView.contentSize.height //Entire scroll view not screen size, if we have a 1k of followers, it would be huge
        let height = scrollView.frame.size.height //Scroll view size in the screen, has nothing to do with how long of the scroll
        
        
        if offsetY > contentHeight - height {
            
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }

    }
    
}


