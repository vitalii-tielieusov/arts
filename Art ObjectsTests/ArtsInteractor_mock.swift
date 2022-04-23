//
//  ArtsInteractor_mock.swift
//  Art ObjectsTests
//
//  Created by Vitaliy Teleusov on 26.04.2021.
//

import Foundation
@testable import Art_Objects

class ArtsInteractor_mock: ArtsInteractorImpl {
    lazy var artsCount: Int = {
        return arts.count
    }()
    
    lazy var  currentArtsPageValue: Int = {
        return currentArtsPage
    }()
}
