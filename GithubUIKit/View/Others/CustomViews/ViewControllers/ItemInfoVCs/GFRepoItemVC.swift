//
//  GFRepoItemVC.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 25.07.2024.
//

import UIKit


protocol RepoItem {
    
    func openGitHubProfile()
    func getFollowers()
}


class GFRepoItemVC: GFItemInfoVC { //We inherit from our custom GFItemInfoVC
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoView2.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
    
    
    
    
    
    
    
    
}
