//
//  UIViewExtensions.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set(value) {
            self.layer.cornerRadius = value
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = self.layer.borderColor else { return nil }
            
            return UIColor(cgColor: color)
        } set(value) {
            guard let color = value else { return }
            
            self.layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        } set(value) {
            self.layer.borderWidth = value
        }
    }
    
    @discardableResult
    func forAutolayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension UIView {
    @discardableResult
    public func addSubviews(_ views: UIView...) -> Self {
        views.forEach(addSubview)
        return self
    }
    
    @discardableResult
    public func addSubviews(_ views: [UIView]) -> Self {
        views.forEach(addSubview)
        return self
    }
}

public func create<T>(_ setup: ((T) -> Void)) -> T where T: UIView {
    let view = T(frame: .zero)
    setup(view)
    return view
}
