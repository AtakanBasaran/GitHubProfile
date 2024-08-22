//
//  GFButton.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 12.07.2024.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame) // everything default made by apple called first then our custom code
        configure()
    }
    
    required init?(coder: NSCoder) { //this is for the storyboard case which we cannot implement
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(backgroundColor: UIColor, title: String) { //we created this alongside with initializer to configure our button when we initialize without custom one
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
    
    
}
