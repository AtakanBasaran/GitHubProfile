//
//  GFEmptyView.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 20.07.2024.
//

import UIKit

class GFEmptyView: UIView {
    
    let imageView = UIImageView()
    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }
    
    private func configure() {
        addSubview(messageLabel)
        addSubview(imageView)
        
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        imageView.image = UIImage(named: "icons")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200), //not dynamic, it is a constant message so we give constant value
            
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1), //make image width 130% of the width of the screen
            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1), //square image
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            imageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 30)
        ])
         
        
    }

}
