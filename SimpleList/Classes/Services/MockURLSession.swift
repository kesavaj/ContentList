//
//  MockURLSession.swift
//  SimpleList
//
//  Created by Kesava Jawaharlal on 17/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

import Foundation

protocol URLSessionProtocol { typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(_ request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol { func resume() }

extension URLSession: URLSessionProtocol {
    func dataTask(_ request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?

    func dataTask(_ request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask {
            completionHandler(self.data, nil, self.error)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    func resume() {
        closure()
    }
}
