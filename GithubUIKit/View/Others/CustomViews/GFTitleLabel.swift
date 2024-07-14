//
//  GFTitleLabel.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 14.07.2024.
//

import UIKit

class GFTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true // try to fit in long space if it has a long name
        minimumScaleFactor = 0.9 //max decrease to 90% of size if it has a long name
        lineBreakMode = .byTruncatingTail // if the username is too long, break the line line like this ata...
        translatesAutoresizingMaskIntoConstraints = false
    }

}
