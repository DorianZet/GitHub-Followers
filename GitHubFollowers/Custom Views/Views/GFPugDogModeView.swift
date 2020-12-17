//
//  GFPugDogModeView.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 16/12/2020.
//

import UIKit

class GFPugDogModeView: UIView {

    let pugImage = GFPugImageView(frame: .zero)
    var pugImageTopAnchorDown: NSLayoutConstraint!
    var pugImageTopAnchorUp: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        addSubviews(pugImage)
        
        pugImageTopAnchorDown = pugImage.topAnchor.constraint(equalTo: self.bottomAnchor)
        pugImageTopAnchorUp = pugImage.topAnchor.constraint(equalTo: self.topAnchor)

        NSLayoutConstraint.activate([
            pugImageTopAnchorDown,
            pugImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pugImage.widthAnchor.constraint(equalTo: self.widthAnchor),
            pugImage.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    func animatePugDown() {
        if !DeviceTypes.isiPhoneSE && !DeviceTypes.isiPhone8Zoomed && !DeviceTypes.isiPhone8Standard {
            pugImageTopAnchorUp.isActive = false
            pugImageTopAnchorDown.isActive = true

            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func animatePugUp() {
        if !DeviceTypes.isiPhoneSE && !DeviceTypes.isiPhone8Zoomed && !DeviceTypes.isiPhone8Standard {
            pugImageTopAnchorDown.isActive = false
            pugImageTopAnchorUp.isActive = true
            
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        }
    }
}
