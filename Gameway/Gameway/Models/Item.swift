//
//  Item.swift
//  Gameway
//
//  Created by Luis Genesius on 04/02/22.
//

import Foundation

struct Item: Decodable, Hashable {
    let id: String
    let giveaway: Giveaway
}
