//
//  ArtObjectViewCell.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 20.04.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SDWebImage

protocol ArtObjectViewCell {
    func update(withIcon icon: String?,
                title: String?,
                objectNumber: String?,
                productionPlaces: String?)
}

class ArtObjectViewCellImpl: UITableViewCell, ReusableCell {
    
    private struct Styles {
        static let cellHeight = CGFloat(100)
        static let imageSide = CGFloat(80)
        static let labelsHeight = CGFloat(20)
        static let verticalOffset = CGFloat(14)
        static let verticalLabelsOffset = CGFloat(6)
        static let horizontalOffset = CGFloat(15)
        static let boldFont = UIFont.boldSystemFont(ofSize: 15)
        static let regularFont = UIFont.systemFont(ofSize: 13)
    }
    
    let disposeBag = DisposeBag()
    
    private let avatarImageView: UIImageView = {
        return prepareImageView(backgroundColor: .lightGray,
                                contentMode: .scaleAspectFit)
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .large)
    }()
    
    private let titleLabel: UILabel = {
        return createLabel(font: Styles.boldFont)
    }()
    
    private let objectNumberLabel: UILabel = {
        return createLabel(font: Styles.regularFont)
    }()
    
    private let infoLabel: UILabel = {
        return createLabel(font: Styles.regularFont,
                           textColor: UIColor.gray)
    }()
    
    private let bottomSeparatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        selectionStyle = .gray
        
        setupViews()
        setupLayouts()
    }
    
    override var intrinsicContentSize: CGSize {
        let result = CGSize(width: UIView.noIntrinsicMetric,
                            height: Styles.cellHeight)
        return result
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#function): \(String(describing: type(of: self)))")
    }
    
    func setupViews() {
        addSubviews([avatarImageView, titleLabel, objectNumberLabel, infoLabel, bottomSeparatorView, activityIndicatorView])
        
        backgroundColor = UIColor.white
    }
    
    func setupLayouts() {
        
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Styles.horizontalOffset)
            make.width.height.equalTo(Styles.imageSide)
        }
        
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(avatarImageView.snp.center)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Styles.verticalOffset)
            make.height.equalTo(Styles.labelsHeight)
            make.left.equalToSuperview().offset(Styles.horizontalOffset)
            make.right.equalTo(avatarImageView.snp.left).offset(-Styles.horizontalOffset)
        }
        
        objectNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
            make.height.equalTo(Styles.labelsHeight)
            make.left.equalToSuperview().offset(Styles.horizontalOffset)
            make.right.equalTo(avatarImageView.snp.left).offset(-Styles.horizontalOffset)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(objectNumberLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
            make.height.equalTo(Styles.labelsHeight)
            make.left.equalToSuperview().offset(Styles.horizontalOffset)
            make.right.equalTo(avatarImageView.snp.left).offset(-Styles.horizontalOffset)
        }
        
        bottomSeparatorView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.sd_cancelCurrentImageLoad()
        avatarImageView.image = nil
        avatarImageView.backgroundColor = .lightGray
        activityIndicatorView.stopAnimating()
    }
}

extension ArtObjectViewCellImpl: ArtObjectViewCell {
    func update(withIcon icon: String?,
                title: String?,
                objectNumber: String?,
                productionPlaces: String?) {
        if let iconURLString = icon, let iconUrl = URL(string: iconURLString) {
            
            avatarImageView.backgroundColor = .white
            activityIndicatorView.startAnimating()
            
            avatarImageView.sd_setImage(with: iconUrl,
                                        placeholderImage: nil,
                                        options: .scaleDownLargeImages) { (image, error, _, _) in
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.activityIndicatorView.stopAnimating()
                    if image == nil && error != nil {
                        self.avatarImageView.backgroundColor = .lightGray
                    } else {
                        self.avatarImageView.backgroundColor = .white
                    }
                }
            }
        } else {
            avatarImageView.image = nil
            avatarImageView.backgroundColor = .lightGray
        }
        
        titleLabel.text = title
        objectNumberLabel.text = objectNumber
        infoLabel.text = productionPlaces
    }
}


