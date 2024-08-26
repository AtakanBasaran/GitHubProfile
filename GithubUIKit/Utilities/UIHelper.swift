//
//  UIHelper.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 17.07.2024.
//

import UIKit

//We use enums instead of structs since we can initialize empty UIHelper object but there is no need to do that, so we use enums, with enums we cannot initialize an empty object
enum UIHelper {
    
    static func createFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - 2*padding - 2*minimumItemSpacing
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
