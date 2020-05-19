//
//  MainViewModel.swift
//  SimpleList
//
//  Created by Kesava Jawaharlal on 18/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

import Foundation

protocol ViewModelDelegate {
    func refreshView()
    func showError(_ error: NetworkError)
}

class MainViewModel {
    
    // MARK:  - Vars
    private var networkService: NetworkServiceProtocol?
    var contents: [Content]?
    var pageNumber = 0
    let noOfRowsPerPage = 10
    private var delegate: ViewModelDelegate

    init(networkService: NetworkServiceProtocol, delegate: ViewModelDelegate) {
        self.networkService = networkService
        self.delegate = delegate
    }
    
    func loadContents() {
        networkService?.get(request: .contentList, completion: { (result: Result<[Content], NetworkError>) in
            switch result {
            case .success(let contents):
                self.contents = contents
                self.delegate.refreshView()
            case .failure(let error):
                print("Error received: \(error.localizedDescription)")
                self.delegate.showError(error)
            }
        })
    }
    
    func noOfRowsAvailable() -> Int {
        let count = contents?.count ?? 0
        let rowCount = count > ((pageNumber + 1) * noOfRowsPerPage) ? noOfRowsPerPage : count - (pageNumber * noOfRowsPerPage)
        return rowCount
    }
    
    func contentFor(row: Int) -> Content? {
        guard let contentList = contents, contentList.count > row else { return nil }
        
        return contentList[row + (pageNumber * noOfRowsPerPage)]
    }
    
    func noOfPages() -> Int {
        let count = contents?.count ?? noOfRowsPerPage
        return Int(ceil(Float(integerLiteral: Int64(count)) / Float(noOfRowsPerPage)))
    }
}
