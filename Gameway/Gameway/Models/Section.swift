//
//  Section.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import Foundation

struct Section: Decodable, Hashable {
    let id: Int
    let type: String
    let title: String
    let subtitle: String
    let items: [Item]
}
