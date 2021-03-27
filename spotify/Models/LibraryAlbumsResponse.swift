//
//  LibraryAlbumsResponse.swift
//  spotify
//
//  Created by thunder on 24/03/21.
//

import Foundation
struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
