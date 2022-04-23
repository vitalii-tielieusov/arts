//
//  ArtObjectsService.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 22.04.2021.
//

import Foundation

protocol ArtObjectsService: AnyObject {
    func artObjects(page: Int,
                    pageSize: Int,
                    _ completion: @escaping ((Result<ArtObjectsResponse, Error>) -> Void))
    
    func artObjectDetails(objectNumber: String,
                          _ completion: @escaping ((Result<ArtObjectDetailsResponse, Error>) -> Void))
}

class ArtObjectsServiceImpl: ArtObjectsService {
    
    private let apiKey: String
    private let culture: Culture
    
    init(apiKey: String,
         culture: Culture) {
        self.apiKey = apiKey
        self.culture = culture
    }
    
    func artObjects(page: Int,
                    pageSize: Int,
                    _ completion: @escaping ((Result<ArtObjectsResponse, Error>) -> Void)) {
        HTTPManager.shared.artObjects(apiKey: apiKey,
                                      page: page,
                                      pageSize: pageSize,
                                      culture: culture.rawValue,
                                      completion)
    }
    
    func artObjectDetails(objectNumber: String,
                          _ completion: @escaping ((Result<ArtObjectDetailsResponse, Error>) -> Void)) {
        HTTPManager.shared.artObjectDetails(apiKey: apiKey,
                                            culture: culture.rawValue,
                                            objectNumber: objectNumber,
                                            completion)
    }
}

