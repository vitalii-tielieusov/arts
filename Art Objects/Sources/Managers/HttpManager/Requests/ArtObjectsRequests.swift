//
//  ArtObjectsRequests.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import Foundation

protocol ArtObjectsRequests: AnyObject {
    func artObjects(apiKey: String,
                    page: Int,
                    pageSize: Int,
                    culture: String,
                    _ completion: @escaping ((Result<ArtObjectsResponse, Error>) -> Void))
}

extension HTTPManager: ArtObjectsRequests {
    func artObjects(apiKey: String = Constants.apiKey,
                    page: Int,
                    pageSize: Int,
                    culture: String = Culture.nl.rawValue,
                    _ completion: @escaping ((Result<ArtObjectsResponse, Error>) -> Void)) {
        
        let params: Dictionary = [
            "key": "\(apiKey)",
            "p": "\(page)",
            "ps": "\(pageSize)"]
        
        guard let request = clientURLRequest(path: "/\(culture)/collection",
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
                self.object(ArtObjectsResponse.self, from: data) { (result) in
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
