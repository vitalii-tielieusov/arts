//
//  ArtsViewController.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private struct Styles {
    static let cellHeight = CGFloat(100)
}

class ArtsViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .large)
    }()
    
    private let refreshControl = UIRefreshControl()
    
    public lazy var tableView: UITableView = {
        let tableView = createTableView(dataSource: self,
                                        delegate: self,
                                        registerCell: ArtObjectViewCellImpl.self,
                                        isScrollEnabled: true)
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private var artObjects = [ArtObjectViewModel]()
    
    let interactor: ArtsInteractor
    
    init(interactor: ArtsInteractor) {
        self.interactor = interactor
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#function): \(String(describing: type(of: self)))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayouts()
        setupActions()
        setupStreams()
        
        interactor.fetchNextArts(completion: nil)
    }
    
    func setupViews() {
        setupNavigationBar()
        self.view.backgroundColor = .white
        view.addSubviews([tableView, activityIndicatorView])
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = R.string.localizable.arts()
    }
    
    func setupLayouts() {
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(10)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupActions() {
        refreshControl.addTarget(self, action: #selector(refreshContent(_:)), for: .valueChanged)
    }
    
    @objc private func refreshContent(_ sender: Any) {
        if artObjects.isEmpty {
            interactor.fetchNextArts(completion: nil)
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    func setupStreams() {
        interactor.isActivityIndicatorAnimating
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe(onNext: { newValue in
                if newValue {
                    self.activityIndicatorView.startAnimating()
                } else {
                    self.activityIndicatorView.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        interactor.artObjects
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe(onNext: { newValue in
                
                self.artObjects = newValue
                self.tableView.reloadData()
                
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ArtsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ArtObjectViewCellImpl = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.selectionStyle = .default
        
        let artObject = artObjects[indexPath.row]
        
        cell.update(withIcon: artObject.imageInfo?.url,
                    title: artObject.title ?? artObject.longTitle,
                    objectNumber: artObject.objectNumber,
                    productionPlaces: artObject.productionPlaces?.joined(separator: ", "))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Styles.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.interactor.didClickArtObject(atIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let ( _, lastPostIndex) = artObjects.lastWithIndex,
            indexPath.row == lastPostIndex
        else { return }
        
        DispatchQueue.main.async {
            self.interactor.fetchNextArts(completion: nil)
        }
    }
}
