//
//  Artist.swift
//  spotify
//
//  Created by thunder on 9/03/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
    
    let images: [APIImage]?
}


