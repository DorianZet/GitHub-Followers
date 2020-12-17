//
//  GFEmitterLayerContent.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 15/12/2020.
//

import UIKit

enum GFEmitterLayerContent {
    case image(UIImage, UIColor?)
    case emoji(Character, UIColor?)
}

fileprivate extension GFEmitterLayerContent {
    var color: UIColor? {
        switch self {
        case let .image(_, color?):
            return color
        case let .emoji(_, color?):
            return color
        default:
            return nil
        }
    }
    
    var image: UIImage {
        switch self {
        case let .image(image, _):
            return image
        case let .emoji(character, _):
            return "\(character)".image()
        }
    }
}

fileprivate extension String {
    func image(with font: UIFont = UIFont.systemFont(ofSize: 23.0)) -> UIImage {
        let string = NSString(string: "\(self)")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        let size = string.size(withAttributes: attributes)
        
        return UIGraphicsImageRenderer(size: size).image { _ in
            string.draw(at: .zero, withAttributes: attributes)
        }
    }
}

 final class GFEmitterLayer: CAEmitterLayer {
    func configure(with contents: [GFEmitterLayerContent]) {
        emitterCells = contents.map { (content) in
            let cell = CAEmitterCell()
            
            cell.birthRate = 25
            cell.lifetime = 10.0
            cell.velocity = CGFloat(cell.birthRate * 2 * cell.lifetime)
            cell.velocityRange = cell.velocity / 2
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spinRange = .pi * 6
            cell.scaleRange = 0.25
            cell.scale = 2.0 - cell.scaleRange
            cell.contents = content.image.cgImage
            if let color = content.color {
                cell.color = color.cgColor
            }
            
            return cell
        }
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        emitterShape = .line
        emitterSize = CGSize(width: frame.size.width, height: 1.0)
        emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
    }
}

