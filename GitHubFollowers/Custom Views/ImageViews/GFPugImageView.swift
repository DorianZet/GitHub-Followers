//
//  GFPugImageView.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 16/12/2020.
//

import UIKit

class GFPugImageView: UIImageView {
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        image = UIImage(named: "pug.png")
        translatesAutoresizingMaskIntoConstraints = false
    }
}
