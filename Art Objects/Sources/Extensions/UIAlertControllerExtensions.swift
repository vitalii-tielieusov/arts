//
//  UIAlertControllerExtensions.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import UIKit

extension UIAlertAction {
    
    static func action(title: String, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
  
    static func ok(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: handler)
    }
  
    static func logout(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: R.string.localizable.logOut(), style: .default, handler: handler)
    }
  
    static func delete(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: R.string.localizable.delete(), style: .default, handler: handler)
    }
    
    static func done(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: R.string.localizable.done(), style: .default, handler: handler)
    }
    
    static func cancel(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: handler)
    }
    
    static func yes(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: R.string.localizable.yes(), style: .destructive, handler: handler)
    }
    
    static func no(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: R.string.localizable.no(), style: .default, handler: handler)
    }
}
