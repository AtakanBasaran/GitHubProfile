//
//  UserInfoVC.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 22.07.2024.
//

import UIKit


protocol UserInfoVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemView1 = UIView()
    let itemView2 = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []

    var userName: String!
    weak var delegate: FollowerListVCDelegate!
    
    
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
                    self.configureUIElements(with: user)
                }
                  
            case .failure(let error):
                presentGFAlertOnMainThread(title: "Error!", message: error.rawValue, buttonTitle: "OK")
                dismissUserInfoVC()
            }
        }
        
    }
    
    func configureUIElements(with user: User) {
        
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self //we listen a command from GFRepoItemVC
        
        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemView1) //we initialize it by creating an instance of the itemVCs with user from network call and then we make their delegate to equal self to listen any command
        self.add(childVC: followerItemVC, to: self.itemView2)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
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


extension UserInfoVC: UserInfoVCDelegate {
    
    
    func didTapGitHubProfile(for user: User) {
        
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(with: url)
        
        
    }
    
    func didTapGetFollowers(for user: User) {
        
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers.", buttonTitle: "Ok")
            return
        }
        
        delegate.didRequestFollowers(for: user)
        dismissUserInfoVC()
    }
 
}
