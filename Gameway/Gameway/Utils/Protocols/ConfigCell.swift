//
//  ConfigCell.swift
//  Gameway
//
//  Created by Luis Genesius on 11/01/22.
//

import Foundation

protocol ConfigCell {
    static var identifier: String { get }
    func configure(with item: Item)
}
