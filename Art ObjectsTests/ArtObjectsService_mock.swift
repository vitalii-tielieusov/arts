//
//  ArtsService_mock.swift
//  Art ObjectsTests
//
//  Created by Vitaliy Teleusov on 26.04.2021.
//

import Foundation
@testable import Art_Objects

class ArtObjectsService_mock: ArtObjectsServiceImpl {
    
    var maxArtsObjectsCount: Int!
    
    override func artObjects(page: Int,
                             pageSize: Int,
                             _ completion: @escaping ((Result<ArtObjectsResponse, Error>) -> Void)) {
        let response = testArtObjectsResponse(page: page, pageSize: pageSize)
        completion(.success(response))
    }
    
    private func testArtObjectsResponse(page: Int, pageSize: Int) -> ArtObjectsResponse {
        var testArtObjects = [ArtObject]()

        guard (page - 1) * pageSize < maxArtsObjectsCount else {
            return ArtObjectsResponse(elapsedMilliseconds: 200, count: 10_000, artObjects: [])
        }
        
        let minArtObjectIndexInCurrentPage = (page - 1) * pageSize
        let delta = (maxArtsObjectsCount > (minArtObjectIndexInCurrentPage + pageSize)) ?
            pageSize :
            (maxArtsObjectsCount! - minArtObjectIndexInCurrentPage)
        let maxArtObjectIndexInCurrentPage = minArtObjectIndexInCurrentPage + delta
        
        for i in minArtObjectIndexInCurrentPage..<maxArtObjectIndexInCurrentPage {
            let mocArtObject = testArtObject(index: i)
            testArtObjects.append(mocArtObject)
        }
        return ArtObjectsResponse(elapsedMilliseconds: 200, count: 10_000, artObjects: testArtObjects)
    }
    
    private func testArtObject(index: Int) -> ArtObject {
        let links = Links(original: nil,
                          web: nil,
                          search: nil)
        
        return ArtObject(links: links,
                         id: "\(index)",
                         objectNumber: nil,
                         title: nil,
                         hasImage: false,
                         principalOrFirstMaker: nil,
                         longTitle: nil,
                         showImage: false,
                         permitDownload: false,
                         webImage: nil,
                         headerImage: nil,
                         productionPlaces: nil)
    }
}
