//
//  GFDogEmitterLayerView.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 15/12/2020.
//

import UIKit

private let animationLayerKey = "com.MZacharski.animationLayer"

final class GFDogEmitterLayerView: UIView {
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func emit(with contents: [GFEmitterLayerContent], for duration: TimeInterval = 3.0) {
        let layer = GFEmitterLayer()
        
        layer.configure(with: contents)
        layer.frame = self.bounds
        layer.needsDisplayOnBoundsChange = true
        self.layer.addSublayer(layer)
        
        guard duration.isFinite else { return }
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterCell.birthRate))
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.values = [1, 0, 0]
        animation.keyTimes = [0, 0.5, 1]
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        layer.beginTime = CACurrentMediaTime()
        layer.birthRate = 1.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let transition = CATransition()
            transition.delegate = self
            transition.type = .fade
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.setValue(layer, forKey: animationLayerKey)
            transition.isRemovedOnCompletion = false
            
            layer.add(transition, forKey: nil)
            
            layer.opacity = 0
        }
        layer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard let superview = newSuperview else { return }
        frame = superview.alignmentRect(forFrame: CGRect(x: 0, y: 0 , width: superview.bounds.width, height: 1))
    }
}


extension GFDogEmitterLayerView: CAAnimationDelegate {
    func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        if let layer = animation.value(forKey: animationLayerKey) as? CALayer {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
    }
}
