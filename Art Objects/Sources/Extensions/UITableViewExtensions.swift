//
//  UITableViewExtensions.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import UIKit

extension UITableView {
    
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: ReusableCell {
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: ReusableCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("wrong type cell at index path \(indexPath)")
        }
        return cell
    }
    
    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableHeaderFooter {
        if let nib = T.nib {
            register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: ReusableHeaderFooter {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
    }
    
    func updateCellHeights() {
        performBatchUpdates(nil, completion: nil)
    }
}

public protocol Identifiable {
    var identifier: String { get }
}

extension UITableView {
    var allIndexPaths: [IndexPath] {
        var result = [IndexPath]()
        (0..<numberOfSections).forEach { section in
            (0..<numberOfRows(inSection: section)).forEach { row in
                result.append(IndexPath(row: row, section: section))
            }
        }
        return result
    }
}
