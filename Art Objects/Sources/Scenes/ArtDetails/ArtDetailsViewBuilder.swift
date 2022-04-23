//
//  ArtDetailsViewBuilder.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 21.04.2021.
//
//

import UIKit

struct ArtDetailsViewBuilder: ViewBuilder {
    
    private let artObjectDetails: ArtObjectDetails
    
    init(artObjectDetails: ArtObjectDetails) {
        self.artObjectDetails = artObjectDetails
    }
    
    func build(navigationController: UINavigationController?) -> UIViewController {
        let interactor = ArtDetailsInteractorImpl(artObjectDetails: artObjectDetails)
        let vc = ArtDetailsViewController(interactor: interactor)
        interactor.router = vc
        interactor.presenter = vc
        return vc
    }
}
