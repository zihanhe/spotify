//
//  AllCategoriseResponse.swift
//  spotify
//
//  Created by thunder on 13/03/21.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}


struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}
