//
//  Section.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import Foundation

enum SectionType: Decodable {
    case popular
    case recent
    case valuable
    case soonExpired
}

struct Section: Decodable, Hashable {
    let id: Int
    let type: SectionType
    let title: String
    let subtitle: String
    let items: [Item]
}
