//
//  ArtsRouter.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//
//

import UIKit

protocol ArtsRouter: AnyObject {
    func showArtObjectDetails(_ artObjectDetails: ArtObjectDetails)
}

extension ArtsViewController: ArtsRouter {
    func showArtObjectDetails(_ artObjectDetails: ArtObjectDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let viewBuilder = ArtDetailsViewBuilder(artObjectDetails: artObjectDetails)
            let vc = viewBuilder.build()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
