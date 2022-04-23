//
//  ViewBuilder.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//
//

import UIKit

// Abstract interface for building view controllers.
protocol ViewBuilder {
  func build(navigationController: UINavigationController?) -> UIViewController
}

extension ViewBuilder {
  func build() -> UIViewController {
    return build(navigationController: nil)
  }
}
