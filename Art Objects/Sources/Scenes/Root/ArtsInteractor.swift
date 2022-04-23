//
//  ArtsInteractor.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//
//

import UIKit
import RxSwift

protocol ArtsInteractor {
    var artObjects: Observable<[ArtObjectViewModel]> { get }
    var isActivityIndicatorAnimating: Observable<Bool> { get }
    
    func fetchNextArts(completion: ((Bool) -> Void)?)
    func didClickArtObject(atIndex index: Int) -> String
}

class ArtsInteractorImpl: ArtsInteractor {

    struct Constants {
        static let minPageNumber: Int = 1
        static let pageSize: Int = 20
    }
    
    let artObjectsStream = MutableStream<[ArtObjectViewModel]>(value: [])
    var artObjects: Observable<[ArtObjectViewModel]> {
        return artObjectsStream.asObservable()
    }
    
    let isActivityIndicatorAnimatingStream = MutableStream<Bool>(value: false)
    var isActivityIndicatorAnimating: Observable<Bool> {
        return isActivityIndicatorAnimatingStream.asObservable()
    }
    
    weak var router: ArtsRouter?
    weak var presenter: ArtsPresenter?
    
    private let artObjectsService: ArtObjectsService
    
    internal var arts = [ArtObject]()
    internal var currentArtsPage: Int = Constants.minPageNumber - 1
    
    private let disposeBag = DisposeBag()
    
    init(artObjectsService: ArtObjectsService) {
        self.artObjectsService = artObjectsService
    }
    
    deinit {
    }

    func didClickArtObject(atIndex index: Int) -> String {
        if let artObjectNumber = arts[index].objectNumber {
            displayArtObjectDetails(objectNumber: artObjectNumber)
            return artObjectNumber
        } else {
            preconditionFailure("Art object number not found")
        }
    }

    func fetchNextArts(completion: ((Bool) -> Void)?) {
        
        guard !isActivityIndicatorAnimatingStream.value() else { return }
        
        isActivityIndicatorAnimatingStream.onNext(true)
        
        artObjectsService.artObjects(page: currentArtsPage + 1, pageSize: Constants.pageSize) { [weak self] (result) in
            guard let self = self else { return }
            
            self.isActivityIndicatorAnimatingStream.onNext(false)
            
            switch result {
            case .failure(let error):                
                self.presenter?.showMessage(error.localizedDescription, completion: { (_) in
                    completion?(false)
                })
            case .success(let response):
                
                print("\(self.arts.count)")
                
                let currentPageArts = response.artObjects ?? []
                let nextArtObjects = response.artObjects?.compactMap({ $0.viewModel() })
                
                if !(nextArtObjects ?? []).isEmpty {
                    self.currentArtsPage = self.currentArtsPage + 1
                }
                
                var previousArtObjectsList = self.artObjectsStream.value()
                previousArtObjectsList.append(contentsOf: nextArtObjects ?? [])
                self.artObjectsStream.onNext(previousArtObjectsList)
                
                self.arts.append(contentsOf: currentPageArts)
                
                completion?(true)
            }
        }
    }
    
    internal func displayArtObjectDetails(objectNumber: String) {
        
        isActivityIndicatorAnimatingStream.onNext(true)
        
        artObjectsService.artObjectDetails(objectNumber: objectNumber) { [weak self] (result) in
            guard let self = self else { return }
            
            self.isActivityIndicatorAnimatingStream.onNext(false)
            
            switch result {
            case .failure(let error):
                self.presenter?.showError(error.localizedDescription)
            case .success(let response):
                if let artObjectDetails = response.artObject {
                    self.router?.showArtObjectDetails(artObjectDetails)
                } else {
                    self.presenter?.showError(R.string.localizable.artObjectDetailsNotFound())
                }
            }
        }
    }
}
