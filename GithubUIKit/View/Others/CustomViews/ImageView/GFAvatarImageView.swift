//
//  GFAvatarImageView.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 17.07.2024.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeHolderImage = UIImage(named: "icons")
    let cache = NetworkManager.shared.cache

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
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // We make our network code here instead of Network Manager file because we do not show any error, we do not pass result type because we need to pass error type either but we do not have anything to do with errors since we use placeholder in case of error
    
    func downloadImage(from urlString: String) { //we do not show any error to the user because we use placeholder image
        
        let cacheKey = NSString(string: urlString) //we use urlString as identifier for each cache value since they are unique
        
        if let image = cache.object(forKey: cacheKey) { //
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self else {return}
            
            if error != nil { return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else {return}
            
            guard let image = UIImage(data: data) else { return }
            
             cache.setObject(image, forKey: cacheKey) //we save our image to cache
         
            DispatchQueue.main.async {
                self.image = image //since we using self in the dispatch main thread, we need to use weak self in network call to prevent memory leaks and strong references
            }
        }
        
        task.resume()
        
    }

}
