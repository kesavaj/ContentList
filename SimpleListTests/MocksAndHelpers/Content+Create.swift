//
//  Content+Create.swift
//  SimpleListTests
//
//  Created by Kesava Jawaharlal on 19/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

@testable import SimpleList

extension Content {
    static func create(title: String = "title1",
                       description: String = "description1",
                       contentType: ContentType = .image,
                       fileName: String = "fileName1") -> Content {
        return Content(title: title,
                       description: description,
                       contentType: contentType,
                       contentFileName: fileName)
    }
}
