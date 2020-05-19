//
//  NetworkServiceTests.swift
//  SimpleListTests
//
//  Created by Kesava Jawaharlal on 19/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

import XCTest
@testable import SimpleList

class NetworkServiceTest: XCTestCase {
    
    var networkService: NetworkServiceProtocol!
    var mockSession: MockURLSession!
    
    override func setUp() {
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
    }
    
    func test_get_should_send_success_if_url_session_responds_with_success() {
        //Given
        let mockData = """
        [
            {
                "title": "Sample title 1",
                "description": "Sample description 1",
                "contentType": "image",
                "contentFileName": "flower1"
            },
            {
                "title": "Sample title 2",
                "description": "Sample description 2",
                "contentType": "video",
                "contentFileName": "rays"
            }
        ]
        """
        mockSession.data = mockData.data(using: .utf8)
        
        //When
        let expectation = XCTestExpectation(description: "Get Request")
        networkService.get(request: .contentList) { (result: Result<[Content], NetworkError>) in
            //Then
            switch result {
            case .success(let contents):
                XCTAssertEqual(contents.count, 2)
            case .failure:
                XCTFail("Shouldn't have received a failure")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_should_send_failure_if_url_session_responds_with_invalid_json() {
        //Given
        mockSession.data = "[".data(using: .utf8)
        
        //When
        let expectation = XCTestExpectation(description: "Get Request")
        networkService.get(request: .contentList) { (result: Result<[Content], NetworkError>) in
            //Then
            switch result {
            case .success:
                XCTFail("Shouldn't have received a success")
            case .failure(let error):
                XCTAssertTrue(error == NetworkError.corruptResponse(responseString: "Corrupt data received"))
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_should_send_failure_if_url_session_doesnt_respond_with_data() {
        //Given
        mockSession.error = NetworkError.dummyError
        
        //When
        let expectation = XCTestExpectation(description: "Get Request")
        networkService.get(request: .contentList) { (result: Result<[Content], NetworkError>) in
            //Then
            switch result {
            case .success:
                XCTFail("Shouldn't have received a success")
            case .failure(let error):
                XCTAssertTrue(error == .networkRequestFailed(urlString: NetworkRequest.contentList.url.absoluteString, errorDescription: ""))
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

