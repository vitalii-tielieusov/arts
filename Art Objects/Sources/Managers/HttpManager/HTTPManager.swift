//
//  HTTPManager.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import Foundation

enum HTTPManagerLocalError: Error {
    case jsonSerializationError
    case noDataInResponse
    case unknownError
    case createClientURLRequest
    case accessTokenHasExpired
    case noResponseError
}

enum HTTPManagerServerError: Error {
    case unauthorizedError
    case badRequest
    case validationError
    case notFound
}

enum HTTPServerErrorCodes: Int {
    case unauthorized = 401
    case badRequest = 400
    case validationError = 422
    case notFound = 404
}

enum Culture: String {
    case nl
    case en
}

internal struct Constants {
    static let urlString = "https://www.rijksmuseum.nl/api"
    static let apiKey = "0fiuZFh4"
}

protocol SerializationBase: AnyObject {
    func json(from data: Data,
              completion: @escaping ((Result<Any, Error>) -> Void))
    func decode<T>(_ type: T.Type,
                   from data: Data,
                   completion: @escaping ((Result<T, Error>) -> Void)) where T: Decodable
    func object<T>(_ type: T.Type,
                   from data: Data,
                   completion: @escaping ((Result<T, Error>) -> Void)) where T: Decodable
}

protocol HTTPManagerBase: AnyObject {
    func dataTask(request: NSMutableURLRequest,
                  method: String,
                  completion: @escaping ((Result<Data, Error>) -> Void))
    
    func post(request: NSMutableURLRequest,
              completion: @escaping ((Result<Data, Error>) -> Void))
    
    func put(request: NSMutableURLRequest,
             completion: @escaping ((Result<Data, Error>) -> Void))
    
    func get(request: NSMutableURLRequest,
             completion: @escaping ((Result<Data, Error>) -> Void))
    
    func patch(request: NSMutableURLRequest,
               completion: @escaping ((Result<Data, Error>) -> Void))
    
    func delete(request: NSMutableURLRequest,
                completion: @escaping ((Result<Data, Error>) -> Void))
    
    func clientURLRequest(path: String,
                          params: Dictionary<String, String>?) -> NSMutableURLRequest?
}

class HTTPManager: NSObject {
    
    static let `shared` = HTTPManager()
    
    override init() {
        super.init()
    }
}

extension HTTPManager: HTTPManagerBase {
    
    internal func dataTask(request: NSMutableURLRequest,
                           method: String,
                           completion: @escaping ((Result<Data, Error>) -> Void)) {
        
        LogsManager.shared.appendLogs(with: method)
        if FeatureFlags.shared.shouldPrintHTTPLogs {
            print("\(method)")
        }
        
        request.httpMethod = method
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if let error = error {
                LogsManager.shared.appendLogs(with: "error: \(error)")
                if FeatureFlags.shared.shouldPrintHTTPLogs {
                    print("error: \(error)")
                }
                completion(.failure(error))
                return
            }
            
            if let serverResponse = response as? HTTPURLResponse {
                LogsManager.shared.appendLogs(with: "\(serverResponse)")
                LogsManager.shared.appendLogs(with: "\(HTTPURLResponse.localizedString(forStatusCode: serverResponse.statusCode))")
                if FeatureFlags.shared.shouldPrintHTTPLogs {
                    print("\(serverResponse)")
                    print("\(HTTPURLResponse.localizedString(forStatusCode: serverResponse.statusCode))")
                }
            }
            
            ///Should work with error codes here
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(HTTPManagerLocalError.noResponseError))
                return
            }
            
            guard 200...299 ~= response.statusCode else {
                if let serverErrorCode = HTTPServerErrorCodes(rawValue: response.statusCode) {
                    switch serverErrorCode {
                    case .badRequest:
                        completion(.failure(HTTPManagerServerError.badRequest))
                    case .unauthorized:
                        completion(.failure(HTTPManagerServerError.unauthorizedError))
                    case .notFound:
                        completion(.failure(HTTPManagerServerError.notFound))
                    case .validationError:
                        completion(.failure(HTTPManagerServerError.validationError))
                    }
                    return
                } else {
                    completion(.failure(HTTPManagerLocalError.unknownError))
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(HTTPManagerLocalError.noDataInResponse))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    internal func post(request: NSMutableURLRequest,
                       completion: @escaping ((Result<Data, Error>) -> Void)) {
        dataTask(request: request,
                 method: "POST",
                 completion: completion)
    }
    
    internal func put(request: NSMutableURLRequest,
                      completion: @escaping ((Result<Data, Error>) -> Void)) {
        dataTask(request: request,
                 method: "PUT",
                 completion: completion)
    }
    
    internal func get(request: NSMutableURLRequest,
                      completion: @escaping ((Result<Data, Error>) -> Void)) {
        dataTask(request: request,
                 method: "GET",
                 completion: completion)
    }
    
    internal func patch(request: NSMutableURLRequest,
                        completion: @escaping ((Result<Data, Error>) -> Void)) {
        dataTask(request: request,
                 method: "PATCH",
                 completion: completion)
    }
    
    internal func delete(request: NSMutableURLRequest,
                         completion: @escaping ((Result<Data, Error>) -> Void)) {
        dataTask(request: request,
                 method: "DELETE",
                 completion: completion)
    }
    
    internal func clientURLRequest(path: String,
                                   params: Dictionary<String, String>? = nil) -> NSMutableURLRequest? {
        
        if let parameters = params, FeatureFlags.shared.shouldPrintHTTPLogs {
            
            print("params: \(parameters)")
        }
        
        if let parameters = params {
            LogsManager.shared.appendLogs(with: "params: \(parameters)")
        }
        
        guard let url = URL(string: Constants.urlString + path) else { return nil }
        
        var items = [URLQueryItem]()
        var myURL = URLComponents(string: url.absoluteString)
        if let params = params {
            for (key, value) in params {
                items.append(URLQueryItem(name: key, value: value))
            }
        }
        
        myURL?.queryItems = items
        let percentEncodedQuery = myURL?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        myURL?.percentEncodedQuery = percentEncodedQuery
        
        if let requestUrl = myURL, let urll = requestUrl.url {
            return NSMutableURLRequest(url: urll)
        } else {
            return nil
        }
    }
}

extension HTTPManager: SerializationBase {
    
    func json(from data: Data,
              completion: @escaping ((Result<Any, Error>) -> Void)) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            completion(.success(json))
        } catch {
            completion(.failure(HTTPManagerLocalError.jsonSerializationError))
        }
    }
    
    func decode<T>(_ type: T.Type,
                   from data: Data,
                   completion: @escaping ((Result<T, Error>) -> Void)) where T: Decodable {
        let decoder = JSONDecoder()
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            completion(.success(decodedObject))
        } catch {
            completion(.failure(HTTPManagerLocalError.jsonSerializationError))
        }
    }
    
    func object<T>(_ type: T.Type,
                   from data: Data,
                   completion: @escaping ((Result<T, Error>) -> Void)) where T: Decodable {
        self.decode(T.self, from: data) { (result) in
            
            switch result {
            case .failure(let error):
                LogsManager.shared.appendLogs(with: "error: \(error)")
                if FeatureFlags.shared.shouldPrintHTTPLogs {
                    print("error: \(error)")
                }
                completion(.failure(error))
            case .success(let result):
                LogsManager.shared.appendLogs(with: "result: \(result)")
                if FeatureFlags.shared.shouldPrintHTTPLogs {
                    print("result: \(result)")
                }
                completion(.success(result))
            }
        }
    }
}

