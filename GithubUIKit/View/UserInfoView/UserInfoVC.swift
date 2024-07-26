//
//  UserInfoVC.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 22.07.2024.
//

import UIKit

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemView1 = UIView()
    let itemView2 = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []

    var userName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo(username: userName)
        
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissUserInfoVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    @objc func dismissUserInfoVC() {
        dismiss(animated: true)
    }
    
    func getUserInfo(username: String) {
        
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            
            guard let self = self else { return }
            
            dismissLoadingView()
            
            switch result {
                
            case .success(let user):
                
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                    self.add(childVC: GFRepoItemVC(user: user), to: self.itemView1)
                    self.add(childVC: GFFollowerItemVC(user: user), to: self.itemView2)
                    self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
                }
                  
            case .failure(let error):
                presentGFAlertOnMainThread(title: "Error!", message: error.rawValue, buttonTitle: "OK")
            }
        }
        
    }
    
    func layoutUI() {
        
        itemViews = [headerView, itemView1, itemView2, dateLabel]
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
   
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemView1.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemView2.topAnchor.constraint(equalTo: itemView1.bottomAnchor, constant: padding),
            itemView2.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemView2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view) //we add childVC view to container view we created, header view
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self) //we use UserInfoHeaderVC as our child VC for UserInfoVC
    }
    
    
    
    
    
}
