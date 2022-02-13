//
//  HomeGiveawayCell.swift
//  Gameway
//
//  Created by Luis Genesius on 11/01/22.
//

import UIKit

class HomeGiveawayCell: UICollectionViewCell, ConfigCell {
    typealias Request = Item
    static var identifier: String = "HomeGiveawayCell"
    
    private let imageView = GiveawayImageView()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .vividYellow
        return label
    }()
    
    private let worth: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        return label
    }()
    
    private let free: UILabel = {
        let label = UILabel()
        label.text = "FREE"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .vividYellow
        return label
    }()
    
    private let imageLoader = ImageLoader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        worth.attributedText = attributeString
        
        let horizontalStackView = UIStackView(arrangedSubviews: [free, worth])
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
    
    func configure(with item: Item?) {
        guard let item = item else { return }
        
        imageView.startActivityIndicator()
        
        if let url = URL(string: item.giveaway.thumbnail) {
            imageLoader.loadImage(with: url) { [weak self] image in
                guard let self = self else { return }
                guard let image = image else { return }
                
                self.imageView.image = image
                self.imageView.stopActivityIndicator()
            }
        }
        
        title.text = item.giveaway.title
        
        if item.giveaway.worth != "N/A" {
            worth.text = item.giveaway.worth
        }
        
        let imageSize = contentView.frame.height - (20 + worth.intrinsicContentSize.height + title.intrinsicContentSize.height)
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    }
}
