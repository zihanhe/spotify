//
//  SearchResultResponse.swift
//  spotify
//
//  Created by thunder on 13/03/21.
//

import Foundation

struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]

}

struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]

}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]

}
