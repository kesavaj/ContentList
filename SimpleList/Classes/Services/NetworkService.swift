//
//  NetworkService.swift
//  SimpleList
//
//  Created by Kesava Jawaharlal on 17/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func get<T: Decodable>(request: NetworkRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
}

struct NetworkService: NetworkServiceProtocol {
    let urlSession: URLSessionProtocol!
    
    init(session: URLSessionProtocol) {
        self.urlSession = session
    }
    
    func get<T: Decodable>(request: NetworkRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: request.url)
        request.httpMethod = "GET"
        
        return makeNetworkRequest(urlRequest: request, completion: completion)
    }

    private func makeNetworkRequest<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        urlSession.dataTask(urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkRequestFailed(urlString: urlRequest.url?.absoluteString ?? "", errorDescription: error.localizedDescription)))
                return
            }
            guard let data = data,
                let responseEntity: T = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.corruptResponse(responseString: "Corrupt data received")))
                return
            }
            
            completion(.success(responseEntity))
        }.resume()
    }
}

enum NetworkRequest: Equatable {
    case contentList
    case somethingElse
    
    var url: URL {
        switch self {
        case .contentList:
            return URL(string: "https://google.com/wiki/rest/api/content")!
        case .somethingElse:
            return URL(string: "https://google.com/wiki/rest/api/somethingelse")!
        }
    }
}

enum NetworkError: LocalizedError, Equatable {
    case networkRequestFailed(urlString: String, errorDescription: String)
    case corruptResponse(responseString: String)
    case dummyError
    
    var errorDescription: String? {
        switch self {
        case .networkRequestFailed(let urlString, let errorDescription):
            return "Content '\(urlString)' couldn't be fetched: \(errorDescription)"
        case .corruptResponse(let responseString):
            return "Received corrupt response: \n'\(responseString)'"
        case .dummyError:
            return ""
        }
    }
}
