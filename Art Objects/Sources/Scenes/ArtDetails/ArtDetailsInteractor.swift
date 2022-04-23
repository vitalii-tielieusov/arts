//
//  ArtDetailsInteractor.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 21.04.2021.
//
//

import UIKit
import RxSwift

enum ArtDetailsAction {
    case showUserInfo
}

protocol ArtDetailsInteractor {
    var isActivityIndicatorAnimating: Observable<Bool> { get }
    var objectNumber: Observable<String?> { get }
    var image: Observable<String?> { get }
    var title: Observable<String?> { get }
    var makerLine: Observable<String?> { get }
    var description: Observable<String?> { get }
    
    func onAction(_ action: ArtDetailsAction)
}

final class ArtDetailsInteractorImpl: ArtDetailsInteractor {
    
    let isActivityIndicatorAnimatingStream = MutableStream<Bool>(value: false)
    var isActivityIndicatorAnimating: Observable<Bool> {
        return isActivityIndicatorAnimatingStream.asObservable()
    }
    
    private let objectNumberStream = MutableStream<String?>(value: nil)
    var objectNumber: Observable<String?> {
        return objectNumberStream.asObservable()
    }
    
    private let avatarStream = MutableStream<String?>(value: nil)
    var image: Observable<String?> {
        return avatarStream.asObservable()
    }
    
    private let titleStream = MutableStream<String?>(value: nil)
    var title: Observable<String?> {
        return titleStream.asObservable()
    }
    
    private let makerLineStream = MutableStream<String?>(value: nil)
    var makerLine: Observable<String?> {
        return makerLineStream.asObservable()
    }
    
    private let descriptionStream = MutableStream<String?>(value: nil)
    var description: Observable<String?> {
        return descriptionStream.asObservable()
    }
    
    weak var router: ArtDetailsRouter?
    weak var presenter: ArtDetailsPresenter?
    
    private let disposeBag = DisposeBag()
    
    private let artObjectDetails: ArtObjectDetails
    
    init(artObjectDetails: ArtObjectDetails) {
        self.artObjectDetails = artObjectDetails
    }
    
    deinit {
    }
    
    func onAction(_ action: ArtDetailsAction) {
        switch action {
        case .showUserInfo:
            showArtDetailsInfo(artObjectDetails)
        }
    }
}

extension ArtDetailsInteractorImpl {
    func showArtDetailsInfo(_ artObjectDetails: ArtObjectDetails) {
        
        objectNumberStream.onNext(artObjectDetails.objectNumber)
        avatarStream.onNext(artObjectDetails.webImage?.url)
        titleStream.onNext(artObjectDetails.label?.title)
        makerLineStream.onNext(artObjectDetails.label?.makerLine)
        descriptionStream.onNext(artObjectDetails.label?.description)
    }
}
