//
//  HomeGiveawayCell.swift
//  Gameway
//
//  Created by Luis Genesius on 11/01/22.
//

import UIKit

class PopularGiveawayCell: UICollectionViewCell, ConfigCell {
    static var identifier: String = "PopularGiveawayCell"
    
    private let imageView = UIImageView()
    private let title = UILabel()
    private let worth = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        
        title.font = UIFont.preferredFont(forTextStyle: .title3)
        title.textColor = .vividYellow
        
        let freeLabel = UILabel()
        freeLabel.text = "FREE"
        freeLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        freeLabel.textColor = .vividYellow
        
        worth.font = UIFont.preferredFont(forTextStyle: .subheadline)
        worth.textColor = .darkGray
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        worth.attributedText = attributeString
        
        let horizontalStackView = UIStackView(arrangedSubviews: [freeLabel, worth])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 10
        
        let verticalStackView = UIStackView(arrangedSubviews: [imageView, title, horizontalStackView])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.spacing = 10
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with item: Item) {
        imageView.image = UIImage(systemName: "house")
        title.text = item.giveaway.title
        
        if item.giveaway.worth != "N/A" {
            worth.text = item.giveaway.worth
        }
        
        let imageSize = contentView.frame.height - (20 + worth.intrinsicContentSize.height + title.intrinsicContentSize.height)
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    }
}
