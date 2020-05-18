//
//  Content.swift
//  SimpleList
//
//  Created by Kesava Jawaharlal on 17/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

import Foundation

struct Content: Codable {
    var title: String
    var description: String
    var contentType: ContentType
    var contentFileName: String
}

enum ContentType: String, Codable {
    case image
    case video
}
