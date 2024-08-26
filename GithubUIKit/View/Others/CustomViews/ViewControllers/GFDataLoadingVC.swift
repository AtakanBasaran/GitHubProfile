//
//  GFDataLoadingVC.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 22.08.2024.
//

import UIKit

class GFDataLoadingVC: UIViewController {
    
    var containerView: UIView!

    func showLoadingView() { // we write loading view as UIViewController extension since we will use in multiple views
        
        containerView = UIView(frame: view.bounds) //Fill up the whole screen, we do not need to set constraints
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func dismissLoadingView() { //Since we call this func inside of network code, it is happening in background thread but since it is a UI related code, it must happen in main thread.
        
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    

}
