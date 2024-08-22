//
//  GFAvatarImageView.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 17.07.2024.
//

import UIKit

class GFAvatarImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true //image is now cannot exceed image view borders
        image = Images.placeholder
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
