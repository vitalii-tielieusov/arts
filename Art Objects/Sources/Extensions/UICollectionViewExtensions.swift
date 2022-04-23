//
//  UICollectionViewExtensions.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import UIKit

extension UICollectionView {
    
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: ReusableCell {
        if let nib = T.nib {
            self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: ReusableCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("wrong cell type at index path \(indexPath)")
        }
        return cell
    }
}
