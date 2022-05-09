//
//  Shimmer+UIView.swift
//  VIDA
//
//  Created by Ronit Tushir on 28/01/22.
//

import UIKit

extension UIView {
    var gradientColorOne : CGColor { UIColor(white: 0.85, alpha: 0.5).cgColor }
    var gradientColorTwo : CGColor { UIColor(white: 0.95, alpha: 0.5).cgColor }

    private func addGradientLayer(padding:(left:CGFloat,right:CGFloat,bottom:CGFloat,top:CGFloat)? = nil,cornerRadius:CGFloat? = nil) -> CAGradientLayer {
            
            let gradientLayer = CAGradientLayer()
            var boundsRect = self.bounds
            gradientLayer.cornerRadius = self.cornerRadius
            gradientLayer.frame = boundsRect
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
            gradientLayer.name = "ShimmerLayer"
            gradientLayer.locations = [0.0, 0.5, 1.0]
            
            if padding.isNotNil
            {
            guard let padding = padding else {
                self.layer.addSublayer(gradientLayer)
                return gradientLayer
            }

                boundsRect = CGRect(x: padding.left, y: padding.top, width: boundsRect.width - (padding.left + padding.right), height: boundsRect.height - (padding.top + padding.bottom))
            }
            gradientLayer.frame = boundsRect
            if cornerRadius.isNotNil
            {
            gradientLayer.cornerRadius = cornerRadius ?? 0
            }
            self.layer.addSublayer(gradientLayer)
            return gradientLayer
        }
        
    private func addAnimation() -> CABasicAnimation {
           
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = [-1.0, -0.5, 0.0]
            animation.toValue = [1.0, 1.5, 2.0]
            animation.repeatCount = .infinity
            animation.duration = 0.9
            return animation
        }
        
    func startShimmering(padding:(left:CGFloat,right:CGFloat,bottom:CGFloat,top:CGFloat)? = nil,cornerRadius:CGFloat? = nil) {
        
        let alreadyAdded = layer.sublayers?.contains(where: {$0.name == "ShimmerLayer"}) ?? false
        if alreadyAdded { return }
        let gradientLayer = addGradientLayer(padding: padding,cornerRadius: cornerRadius)
        let animation = addAnimation()
        gradientLayer.add(animation, forKey: animation.keyPath)
        
    }
    
    var isShimmering:Bool {
        let alreadyAdded = layer.sublayers?.contains(where: {$0.name == "ShimmerLayer"}) ?? false
        return alreadyAdded
    }
    
    func stopShimmering(){
        layer.sublayers?.forEach({
            if $0.name == "ShimmerLayer" { $0.removeFromSuperlayer()}
        })
    }
}
