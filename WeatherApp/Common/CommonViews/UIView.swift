//
//  UIView.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 18.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit

extension UIView {
    func load() -> UIView? {
        guard let nibName = type(of: self).description().components(separatedBy: ".").last else { return nil }
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func addAndFit(subview: UIView) {
        subview.frame = bounds
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subview)
        
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        subview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
