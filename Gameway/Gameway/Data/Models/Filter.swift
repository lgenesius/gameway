//
//  Filter.swift
//  Gameway
//
//  Created by Luis Genesius on 15/05/22.
//

import Foundation

fileprivate let userDefaults: UserDefaults = UserDefaults.standard

struct Filter {
    let name: String
    let code: String
    let type: Choice
    var isSelected: Bool
    
    init(name: String, code: String, type: Choice) {
        self.name = name
        self.code = code
        self.type = type
        self.isSelected = userDefaults.bool(forKey: "user-defaults-\(code)")
    }
}
