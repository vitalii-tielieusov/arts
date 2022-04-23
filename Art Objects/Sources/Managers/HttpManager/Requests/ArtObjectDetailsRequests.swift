//
//  ArtObjectDetailsRequests.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 20.04.2021.
//

import Foundation

protocol ArtObjectDetailsRequests: AnyObject {
    func artObjectDetails(apiKey: String,
                          culture: String,
                          objectNumber: String,
                          _ completion: @escaping ((Result<ArtObjectDetailsResponse, Error>) -> Void))
}

extension HTTPManager: ArtObjectDetailsRequests {
    func artObjectDetails(apiKey: String = Constants.apiKey,
                          culture: String = Culture.nl.rawValue,
                          objectNumber: String,
                          _ completion: @escaping ((Result<ArtObjectDetailsResponse, Error>) -> Void)) {
        
        let params: Dictionary = ["key": "\(apiKey)"]
        
        guard let request = clientURLRequest(path: "/\(culture)/collection/\(objectNumber)",
                                             params: params) else {
            completion(.failure(HTTPManagerLocalError.createClientURLRequest))
            return
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        get(request: request) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                self.object(ArtObjectDetailsResponse.self, from: data) { (result) in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let result):
                        completion(.success(result))
                    }
                }
            }
        }
    }
}
