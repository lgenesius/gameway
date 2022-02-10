//
//  RecentGiveawayCell.swift
//  Gameway
//
//  Created by Luis Genesius on 05/02/22.
//

import UIKit

class RecentGiveawayCell: UICollectionViewCell, ConfigCell {
    static var identifier: String = "RecentGiveawayCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with item: Item) {
        
    }
}
