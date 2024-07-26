//
//  GFFollowerItemVC.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 25.07.2024.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .followers, with: user.followers)
        itemInfoView2.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
}
