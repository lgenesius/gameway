//
//  HomeGiveawayCell.swift
//  Gameway
//
//  Created by Luis Genesius on 11/01/22.
//

import UIKit
import Combine

class HomeCollectionViewCell: UICollectionViewCell, ConfigCell {
    typealias Request = Item
    static var identifier: String = "HomeCollectionViewCell"
    
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
    
    private let expire: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .red
        return label
    }()
    
    private var cancellable: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        worth.attributedText = attributeString
        
        let priceHorizontalStackView = UIStackView(arrangedSubviews: [free, worth])
        priceHorizontalStackView.axis = .horizontal
        priceHorizontalStackView.distribution = .fill
        priceHorizontalStackView.spacing = 10
        
        let horizontalStackView = UIStackView(arrangedSubviews: [priceHorizontalStackView, expire])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        
        let verticalStackView = UIStackView(arrangedSubviews: [imageView, title, horizontalStackView])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.spacing = 10
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            
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
        
        getImage(item.giveaway.thumbnail)
        
        title.text = item.giveaway.title
        
        if item.giveaway.worth != "N/A" {
            worth.text = item.giveaway.worth
        }
        
        configureExpireText(endDate: item.giveaway.endDate)
        
        let imageSize = contentView.frame.height - (20 + worth.intrinsicContentSize.height + title.intrinsicContentSize.height)
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    }
    
    private func configureExpireText(endDate giveawayEndDate: String) {
        let endDate = convertStringToDate(giveawayEndDate)
        guard let endDate = endDate else {
            expire.text = ""
            return
        }
        
        let dayDiff = getDayDifference(from: Date(), to: endDate)
        guard let dayDiff = dayDiff else {
            expire.text = ""
            return
        }
        
        if dayDiff < 0 {
            expire.text = "Has Expired"
            expire.textColor = .gray
        } else {
            expire.text = dayDiff == 0 ? "Expire Today": "\(dayDiff) Days Left"
        }
    }
    
    private func getImage(_ urlString: String) {
        imageView.startActivityIndicator()
        
        if let url = URL(string: urlString) {
            cancellable = ImageLoader.shared.loadImage(from: url)
                .sink(receiveValue: { [unowned self] image in
                    self.imageView.stopActivityIndicator()
                    guard let image = image else { return }
                    
                    self.imageView.image = image
                })
        } else {
            self.imageView.stopActivityIndicator()
        }
    }
}

extension HomeCollectionViewCell: DateService {}
