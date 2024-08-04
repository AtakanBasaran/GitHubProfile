//
//  FavoritesVC.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 11.07.2024.
//

import UIKit

class FavoritesVC: UIViewController {
    
    let tableView = UITableView()
    var favorites: [Follower] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveFavorites()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true //since we have 2 different navigation controller for each tab view, we need to make the large titles large here too
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
   
    }
    
    private func retrieveFavorites() {
        
        self.showLoadingView()
        
        PersistenceManager.retrieveFavorites { [weak self] result in
            
            guard let self = self else {return}
            
            self.dismissLoadingView()
            
            switch result {
                
            case .success(let favorites):
                
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen", in: self.view)
                    
                } else {
                    self.favorites = favorites
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView) //just in case, empty state populated and stay in front of table view
                    }
                }
                
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error :(", message: error.rawValue, buttonTitle: "Ok")
                
            }
        }
    }
    
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let favorite = favorites[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as? FavoriteCell {
            
            cell.set(favorite: favorite)
            
            return cell
            
        } else {
            
            let cell = UITableViewCell()
            
            var configuration = UIListContentConfiguration.cell()
            configuration.text = favorite.login
            cell.contentConfiguration = configuration
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        
        let destVC = FollowerListVC()
        destVC.username = favorite.login
        destVC.title = favorite.login
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    
    
    
}
