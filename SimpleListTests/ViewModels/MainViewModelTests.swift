//
//  MainViewModelTests.swift
//  SimpleListTests
//
//  Created by Kesava Jawaharlal on 19/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

import XCTest
@testable import SimpleList

class MainViewModelTests: XCTestCase {

    var viewModel: MainViewModel!
    var networkService: NetworkServiceProtocol!
    var mockSession: MockURLSession!
    var vmDelegate: MockViewModelDelegate!

    override func setUp() {
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
        vmDelegate = MockViewModelDelegate()
        
        viewModel = MainViewModel(networkService: networkService, delegate: vmDelegate)
    }
    
    func test_noOfRowsAvailable_should_return_exact_contents_being_set() {
        //Given
        let contents: [Content] = [Content.create(), Content.create(), Content.create(), Content.create()]
        viewModel.contents = contents
        
        //When
        let noOfRows = viewModel.noOfRowsAvailable()
        
        //Then
        XCTAssertEqual(noOfRows, 4)
    }
    
    func test_noOfRowsAvailable_should_return_1_when_page_number_is_two_and_count_is_11() {
        //Given
        let contents: [Content] = [Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create()]
        viewModel.contents = contents
        viewModel.pageNumber = 1
        
        //When
        let noOfRows = viewModel.noOfRowsAvailable()
        
        //Then
        XCTAssertEqual(noOfRows, 1)
    }
    
    func test_noOfRowsAvailable_should_return_10_when_page_number_is_one_and_count_is_11() {
        //Given
        let contents: [Content] = [Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create()]
        viewModel.contents = contents
        viewModel.pageNumber = 0
        
        //When
        let noOfRows = viewModel.noOfRowsAvailable()
        
        //Then
        XCTAssertEqual(noOfRows, 10)
    }
    
    func test_contentFor_should_return_correct_content_when_page_number_is_1() {
        //Given
        let contents: [Content] = [Content.create(), Content.create(title: "title2"), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create()]
        viewModel.contents = contents
        viewModel.pageNumber = 0
        
        //When
        let content = viewModel.contentFor(row: 1)
        
        //Then
        XCTAssertEqual(content?.title, "title2")
    }
    
    func test_contentFor_should_return_correct_content_when_page_number_is_2() {
        //Given
        let contents: [Content] = [Content.create(), Content.create(title: "title2"), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(title: "title11")]
        viewModel.contents = contents
        viewModel.pageNumber = 1
        
        //When
        let content = viewModel.contentFor(row: 0)
        
        //Then
        XCTAssertEqual(content?.title, "title11")
    }
    
    func test_noOfPages_should_return_1_when_content_is_less_than_or_equal_to_10() {
        //Given
        var contents: [Content] = [Content.create(), Content.create(title: "title2"), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create()]
        viewModel.contents = contents
        viewModel.pageNumber = 1
        
        //When
        var pages = viewModel.noOfPages()
        
        //Then
        XCTAssertEqual(pages, 1)
        
        //Given
        contents = [Content.create()]
        viewModel.contents = contents
        viewModel.pageNumber = 1
        
        //When
        pages = viewModel.noOfPages()
        
        //Then
        XCTAssertEqual(pages, 1)
    }
    
    func test_noOfPages_should_return_2_when_content_is_less_than_or_equal_to_20() {
        //Given
        let contents: [Content] = [Content.create(), Content.create(title: "title2"), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create(), Content.create()]
        viewModel.contents = contents
        viewModel.pageNumber = 1
        
        //When
        let pages = viewModel.noOfPages()
        
        //Then
        XCTAssertEqual(pages, 2)
    }
    
    func test_loadContents_should_call_vmdelegates_refresh_if_service_returns_a_success() {
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
        viewModel.loadContents()
        
        //Then
        XCTAssertTrue(vmDelegate.refreshCalled)
    }
    
    func test_loadContents_should_not_call_vmdelegates_refresh_if_service_returns_a_failure() {
        //Given
        mockSession.data = "[".data(using: .utf8)
        
        //When
        viewModel.loadContents()
        
        //Then
        XCTAssertFalse(vmDelegate.refreshCalled)
        XCTAssertTrue(vmDelegate.showErrorCalled)
    }
}
