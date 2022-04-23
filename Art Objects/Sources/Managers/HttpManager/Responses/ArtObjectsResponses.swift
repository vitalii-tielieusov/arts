//
//  ArtObjectsResponses.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import Foundation

struct ArtObjectsResponse: Codable {
    let elapsedMilliseconds: Int
    let count: Int
    let artObjects: [ArtObject]?
    
    enum CodingKeys: String, CodingKey {
        case elapsedMilliseconds
        case count
        case artObjects
    }
}

struct ArtObject: Codable, Equatable {
    
    let links: Links
    let id: String
    let objectNumber: String?
    let title: String?
    let hasImage: Bool
    let principalOrFirstMaker: String?
    let longTitle: String?
    let showImage: Bool
    let permitDownload: Bool
    let webImage: ArtImage?
    let headerImage: ArtImage?
    let productionPlaces: [String]?
    
    enum CodingKeys: String, CodingKey {
        case links
        case id
        case objectNumber
        case title
        case hasImage
        case principalOrFirstMaker
        case longTitle
        case showImage
        case permitDownload
        case webImage
        case headerImage
        case productionPlaces
    }
    
    static func == (lhs: ArtObject, rhs: ArtObject) -> Bool {
        return lhs.id == rhs.id
    }
    
    func viewModel() -> ArtObjectViewModel {
        return ArtObjectViewModel(
            link: links.web ?? links.original ?? links.search,
            objectNumber: objectNumber,
            title: title,
            principalOrFirstMaker: principalOrFirstMaker,
            longTitle: longTitle,
            imageInfo: webImage,
            productionPlaces: productionPlaces)
    }
}

struct Links: Codable {
    let original: String?
    let web: String?
    let search: String?
    
    enum CodingKeys: String, CodingKey {
        case original = "self"
        case web
        case search
    }
}

struct ArtImage: Codable {
    let guid: String?
    let offsetPercentageX: Int
    let offsetPercentageY: Int
    let width: Int
    let height: Int
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case guid
        case offsetPercentageX
        case offsetPercentageY
        case width
        case height
        case url
    }
}
