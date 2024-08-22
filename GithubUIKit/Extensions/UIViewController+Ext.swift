//
//  UIViewController+Ext.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 14.07.2024.
//

import UIKit
import SafariServices

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
    
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
}
