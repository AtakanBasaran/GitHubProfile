//
//  GFAlertContainerView.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 20.08.2024.
//

import UIKit

class GFAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor //We use cgColor due to layer that it one level down
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
