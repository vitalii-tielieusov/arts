//
//  ArtsModels.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//
//

import UIKit

struct ArtObjectViewModel: Codable, Equatable {
    
    let link: String?
    let objectNumber: String?
    let title: String?
    let principalOrFirstMaker: String?
    let longTitle: String?
    let imageInfo: ArtImage?
    let productionPlaces: [String]?
    
    enum CodingKeys: String, CodingKey {
        case link
        case objectNumber
        case title
        case principalOrFirstMaker
        case longTitle
        case imageInfo
        case productionPlaces
    }
    
    static func == (lhs: ArtObjectViewModel, rhs: ArtObjectViewModel) -> Bool {
        return lhs.objectNumber == rhs.objectNumber
    }
}
