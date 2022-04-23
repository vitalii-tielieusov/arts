//
//  ArtsPresenter.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//
//

import UIKit

protocol ArtsPresenter: AnyObject {
    func showError(_ message: String)
    func showMessage(_ message: String, completion: ((UIAlertAction) -> Void)?)
}

extension ArtsViewController: ArtsPresenter {
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "",
                message: message,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction.ok())
            self.present(alert, animated: true)
        }
    }
    
    func showMessage(_ message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "",
                message: message,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction.ok(handler: completion))
            self.present(alert, animated: true)
        }
    }
}
