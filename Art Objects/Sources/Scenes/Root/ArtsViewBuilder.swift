//
//  ArtsViewBuilder.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//
//

import UIKit

struct ArtsViewBuilder: ViewBuilder {
    
    private let artObjectsService: ArtObjectsService
    
    init(artObjectsService: ArtObjectsService) {
        self.artObjectsService = artObjectsService
    }
    
    func build(navigationController: UINavigationController?) -> UIViewController {
        let interactor = ArtsInteractorImpl(artObjectsService: artObjectsService)
        let vc = ArtsViewController(interactor: interactor)
        interactor.router = vc
        interactor.presenter = vc
        return vc
    }
}
