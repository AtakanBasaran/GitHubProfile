//
//  FavoritesVC.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 11.07.2024.
//

import UIKit

class FavoritesVC: UIViewController {
    
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveFavorites()
    }
    
    private func retrieveFavorites() {
        
        self.showLoadingView()
        
        PersistenceManager.retrieveFavorites { [weak self] result in
            
            guard let self = self else {return}
            
            self.dismissLoadingView()
            
            switch result {
                
            case .success(let favorites):
                self.favorites = favorites
                print(favorites)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error :(", message: error.rawValue, buttonTitle: "Ok")
                
            }
        }
    }
    

    

}
