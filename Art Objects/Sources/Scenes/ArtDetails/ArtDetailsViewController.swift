//
//  ArtDetailsViewController.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 21.04.2021.
//
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private struct Styles {
    static let imageSide = CGFloat(80)
    static let labelsHeight = CGFloat(20)
    static let verticalOffset = CGFloat(14)
    static let verticalLabelsOffset = CGFloat(6)
    static let horizontalOffset = CGFloat(15)
    static let boldFont = UIFont.boldSystemFont(ofSize: 15)
    static let regularFont = UIFont.systemFont(ofSize: 13)
}

class ArtDetailsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: R.image.back(),
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        button.tintColor = .black
        button.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        return button
    }()
    
    
    private let imageView: UIImageView = {
        return prepareImageView(backgroundColor: .clear,
                                contentMode: .scaleAspectFit)
    }()
    
    private let titleLabel: UILabel = {
        return createLabel(font: Styles.boldFont)
    }()
    
    private let makerLineLabel: UILabel = {
        return createLabel(font: Styles.regularFont)
    }()
    
    private let descriptionLabel: UILabel = {
        return createLabel(font: Styles.regularFont,
                           textColor: UIColor.gray)
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .large)
    }()
    
    internal let interactor: ArtDetailsInteractor
    
    init(interactor: ArtDetailsInteractor) {
        self.interactor = interactor
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#function): \(String(describing: type(of: self)))")
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayouts()
        setupStreams()
        
        interactor.onAction(.showUserInfo)
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        view.addSubviews([imageView, titleLabel, makerLineLabel, descriptionLabel, activityIndicatorView])
        
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil);
    }
    
    @objc func orientationChanged(_ notification: NSNotification) {
        setupLayouts()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = self.backButton
    }

    private func setupLayouts(for orientation: UIDeviceOrientation = UIDevice.current.orientation) {
        
        activityIndicatorView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(Styles.verticalOffset)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).offset(Styles.horizontalOffset)
            make.width.equalTo(imageView.snp.height)
            
            if orientation.isLandscape {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-Styles.verticalOffset)
            } else {
                make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(Styles.horizontalOffset)
            }
        }
        
        titleLabel.snp.remakeConstraints { (make) in

            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(Styles.horizontalOffset)
            
            if orientation.isLandscape {
                make.top.equalTo(imageView.snp.top)
                make.left.equalTo(imageView.snp.right).offset(Styles.horizontalOffset)
            } else {
                make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).offset(Styles.horizontalOffset)
                make.top.equalTo(imageView.snp.bottom)
            }
        }
        
        makerLineLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(Styles.horizontalOffset)
            make.left.equalTo(titleLabel.snp.left)
        }
        
        descriptionLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(makerLineLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(Styles.horizontalOffset)
            make.left.equalTo(titleLabel.snp.left)
        }
    }
    
    private func setupStreams() {
        interactor.image
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe(onNext: { newValue in
                if let iconURLString = newValue, let iconUrl = URL(string: iconURLString) {
                    self.activityIndicatorView.startAnimating()
                    
                    self.imageView.sd_setImage(with: iconUrl) { (image, error, cacheType, url) in
                        DispatchQueue.main.async {
                            self.activityIndicatorView.stopAnimating()
                        }
                    }
                } else {
                    self.imageView.image = nil
                }
            })
            .disposed(by: disposeBag)
        
        interactor.title
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        interactor.objectNumber
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        interactor.makerLine
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(to: makerLineLabel.rx.text)
            .disposed(by: disposeBag)
        
        interactor.description
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

