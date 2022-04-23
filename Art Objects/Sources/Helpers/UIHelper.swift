//
//  UIHelper.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 20.04.2021.
//

import UIKit
import Rswift

/*
 TableView
 */

func createTableView<T: UITableViewCell>(dataSource: UITableViewDataSource?,
                                         delegate: UITableViewDelegate? = nil,
                                         estimatedRowHeight: CGFloat? = 85,
                                         rowHeight: CGFloat? = UITableView.automaticDimension,
                                         separatorStyle: UITableViewCell.SeparatorStyle = .none,
                                         registerCell: T.Type,
                                         isScrollEnabled: Bool = false) -> UITableView where T: ReusableCell {
  let tableView = UITableView()
    tableView.dataSource = dataSource
    tableView.delegate = delegate
    tableView.separatorStyle = separatorStyle
    tableView.backgroundColor = .white
    if let estimatedRowHeight = estimatedRowHeight {
        tableView.estimatedRowHeight = estimatedRowHeight
    }
    if let rowHeight = rowHeight {
        tableView.rowHeight = rowHeight
    }
    tableView.isScrollEnabled = isScrollEnabled
    tableView.showsHorizontalScrollIndicator = false
    tableView.showsVerticalScrollIndicator = false
    tableView.tableFooterView = UIView()
    tableView.registerReusableCell(T.self)
    
    return tableView
}

/*
 Labels
 */

func createLabel(text: String? = nil,
                 font: UIFont? = UIFont.systemFont(ofSize: 15),
                 textColor: UIColor? = .black,
                 textAlignment: NSTextAlignment = .natural,
                 lineBreakMode: NSLineBreakMode = .byTruncatingTail,
                 numberOfLines: Int = 0,
                 cornerRadius: CGFloat = 0) -> UILabel {
    let label = UILabel()
    label.textColor = textColor
    label.textAlignment = textAlignment
    label.font = font
    label.numberOfLines = numberOfLines
    label.text = text
    label.layer.masksToBounds = true
    label.cornerRadius = cornerRadius
    label.lineBreakMode = lineBreakMode
    return label
}

/*
 imageViews
 */

func prepareImageView(image: UIImage? = nil,
                      backgroundColor: UIColor? = UIColor.lightGray,
                      cornerRadius: CGFloat = 6.0,
                      contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = image
    imageView.contentMode = contentMode
    imageView.clipsToBounds = true
    imageView.backgroundColor = backgroundColor
    imageView.cornerRadius = cornerRadius
    return imageView
}

final class LayoutsHelper {
  
  private struct ScreenSizeByDesign {
    static let width = CGFloat(375)
    static let height = CGFloat(667)
  }

  class func scaleByScreenWidth(constraintValue: CGFloat) -> CGFloat {
    return (constraintValue * UIScreen.main.bounds.size.width) / ScreenSizeByDesign.width
  }

  class func scaleByScreenHeight(constraintValue: CGFloat) -> CGFloat {
    return (constraintValue * UIScreen.main.bounds.size.height) / ScreenSizeByDesign.height
  }
}
