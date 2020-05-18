//
//  NSViewController+JSONHelper.swift
//  SimpleList
//
//  Created by Kesava Jawaharlal on 18/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

import Cocoa

extension NSViewController {
    func getContents(from fileName: String) -> String? {
        guard let filePath = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json"),
            let resultString = try? String(contentsOf: filePath) else {
                return nil
        }
        
        return resultString
    }
}
