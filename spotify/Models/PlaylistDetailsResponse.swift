//
//  PlaylistDetailsResponse.swift
//  spotify
//
//  Created by thunder on 11/03/21.
//

import Foundation

struct PlaylistDetailResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
//    let primary_color: String
    let tracks: PlaylistTracksResponse
    
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}


struct PlaylistItem: Codable {
    let track: AudioTrack
}
