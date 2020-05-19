//
//  MockViewModelDelegate.swift
//  SimpleListTests
//
//  Created by Kesava Jawaharlal on 19/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

@testable import SimpleList

class MockViewModelDelegate: ViewModelDelegate {
    var refreshCalled = false
    var showErrorCalled = false
    var errorReceived: NetworkError?
    
    func refreshView() {
        refreshCalled = true
    }
    
    func showError(_ error: NetworkError) {
        showErrorCalled = true
        errorReceived = error
    }
}
