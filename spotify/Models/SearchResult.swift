//
//  SearchResult.swift
//  spotify
//
//  Created by thunder on 13/03/21.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
