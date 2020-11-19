//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 16/11/2020.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: "avatar-placeholder")!
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        
        let cacheKey = NSString(string: urlString) // setting the image's cache key, which will be its url string.
        
        if let image = cache.object(forKey: cacheKey) { // if the image is already in the cache, set the avatar image as this image in the cache and return.
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil { return } // return if there is an error. we don't need to handle the errors here, as our natural error handler is the octocat avatar placeholder - it will be there is something goes wrong and the user's avatar doesn't load.
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey) // set the image into the cache (the cache key of the image is the url string from where we get the image)
            
            DispatchQueue.main.async { // because we are on a background thread, we have to update our UI on the main one.
                self.image = image
            }
        }
        
        task.resume()
    }
}
