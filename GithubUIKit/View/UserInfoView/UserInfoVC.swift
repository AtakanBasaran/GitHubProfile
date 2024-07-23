//
//  UserInfoVC.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 22.07.2024.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var userName: String!
    var user: User? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        getUsername(username: userName)
    
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissUserInfoVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    @objc func dismissUserInfoVC() {
        dismiss(animated: true)
    }
    
    func getUsername(username: String) {
        
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            
            guard let self = self else { return }
            
            dismissLoadingView()
            
            switch result {
                
            case .success(let user):
                self.user = user
                print(user)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error!", message: error.rawValue, buttonTitle: "OK")
            }
        }
        
        
    }
    
    
    


}
