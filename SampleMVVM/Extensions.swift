//
//  Extensions.swift
//  SampleMVVM
//
//  Created by Abderrahman Ajid on 24/5/2022.
//

import UIKit

extension UIView {
    
    func addSubviews( _ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addShadow(color: CGColor = UIColor.black.cgColor,
                   opacity: Float = 1,
                   offset: CGSize = .zero,
                   radius: CGFloat = 1) {
        
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}
