//
//  HomeGiveawayCell.swift
//  Gameway
//
//  Created by Luis Genesius on 11/01/22.
//

import UIKit

class HomeGiveawayCell: UICollectionViewCell, ConfigCell {
    static var identifier: String = "HomeGiveawayCell"
    
    let imageView = UIImageView()
    let title = UILabel()
    let worth = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        title.font = UIFont.preferredFont(forTextStyle: .title3)
        title.textColor = .vividYellow
        
        let freeLabel = UILabel()
        freeLabel.text = "FREE"
        freeLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        freeLabel.textColor = .vividYellow
        
        worth.font = UIFont.preferredFont(forTextStyle: .subheadline)
        worth.textColor = .darkGray
        
        let horizontalStackView = UIStackView(arrangedSubviews: [freeLabel, worth])
        horizontalStackView.axis = .horizontal
        
        let verticalStackView = UIStackView(arrangedSubviews: [imageView, title, horizontalStackView])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with giveaway: Giveaway) {
        imageView.image = UIImage(named: giveaway.thumbnail)
        title.text = giveaway.title
        worth.text = giveaway.worth
    }
}
