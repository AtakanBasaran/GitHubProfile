//
//  UIViewController+Ext.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 14.07.2024.
//

import UIKit

fileprivate var containerView: UIView! //it is a global variable but has a protection fileprivate because we want to use in this file, UIViewController extension but we cannot create variables inside of extensions. If we write private instead of fileprivate, we could not use this variable inside of UIViewController extension. We use ! since we initialize

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
        
    }
    
    
    func showLoadingView() { // we write loading view as UIViewController extension since we will use in multiple views
        
        containerView = UIView(frame: view.bounds) //Fill up the whole screen, we do not need to set constraints
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func dismissLoadingView() { //Since we call this func inside of network code, it is happening in background thread but since it is a UI related code, it must happen in main thread.
        
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
}
