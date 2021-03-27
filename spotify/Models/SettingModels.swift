//
//  SettingModels.swift
//  spotify
//
//  Created by thunder on 8/03/21.
//

import Foundation

struct Section {
    let title: String
    let option: [Option]
    
    
}


struct Option {
    let title: String
    let handler: () -> Void
}
