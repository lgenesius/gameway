//
//  HomeCardCollectionViewCell.swift
//  Gameway
//
//  Created by Luis Genesius on 11/01/22.
//

import Combine
import UIKit

final class HomeCardCollectionViewCell: UICollectionViewCell, ConfigCell {
    typealias Request = Item
    static var identifier: String = "HomeCardCollectionViewCell"
    
    private lazy var imageView: GiveawayImageView = GiveawayImageView()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .mainYellow
        return label
    }()
    
    private lazy var worthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var freeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "FREE"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .mainYellow
        return label
    }()
    
    private lazy var expireLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .red
        return label
    }()
    
    private var cancellable: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: attributeString.length)
        )
        worthLabel.attributedText = attributeString
        
        let priceHorizontalStackView: UIStackView = UIStackView(
            arrangedSubviews: [freeLabel, worthLabel]
        )
        priceHorizontalStackView.axis = .horizontal
        priceHorizontalStackView.distribution = .fill
        priceHorizontalStackView.spacing = 10
        
        let horizontalStackView: UIStackView = UIStackView(
            arrangedSubviews: [priceHorizontalStackView, expireLabel]
        )
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        
        let verticalStackView: UIStackView = UIStackView(
            arrangedSubviews: [imageView, titleLabel, horizontalStackView]
        )
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
        guard let item: Item = item else { return }
        
        imageView.image = nil
        imageView.setImage(with: item.giveaway.thumbnail)
        
        titleLabel.text = item.giveaway.title
        
        if item.giveaway.worth != "N/A" {
            worthLabel.textColor = .darkGray
            worthLabel.text = item.giveaway.worth
        }
        else {
            //To fix cell conditional bug
            worthLabel.textColor = .mainDarkBlue
            worthLabel.text = "N/A"
        }
        
        configureExpireText(endDate: item.giveaway.endDate)
        
        let imageSize: CGFloat = contentView.frame.height - (20 + worthLabel.intrinsicContentSize.height + titleLabel.intrinsicContentSize.height)
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    }
    
    private func configureExpireText(endDate giveawayEndDate: String) {
        expireLabel.textColor = .red
        expireLabel.text = ""
        
        guard let endDate: Date = DateHelper.convertStringToDate(giveawayEndDate),
              let dayDiff: Int = DateHelper.getDayDifference(from: Date(), to: endDate)
        else {
            return
        }
        
        if dayDiff < 0 {
            expireLabel.text = "Has Expired"
            expireLabel.textColor = .systemGray
        } else if dayDiff == 0 {
            expireLabel.text = "Expire Today"
            expireLabel.textColor = .systemRed
        } else {
            expireLabel.text = "\(dayDiff) Days Left"
            
            if dayDiff <= 3 {
                expireLabel.textColor = .systemRed
            } else if dayDiff <= 7 {
                expireLabel.textColor = .systemOrange
            } else {
                expireLabel.textColor = .systemGreen
            }
        }
    }
    
    private func getImage(_ urlString: String) {
        imageView.showLoadingImage()
        if let url: URL = URL(string: urlString) {
            cancellable = ImageLoader.shared.loadImage(from: url)
                .sink(receiveValue: { [unowned self] image in
                    self.imageView.stopLoadingImage()
                    guard let image: UIImage = image else { return }
                    
                    self.imageView.image = image
                })
        } else {
            self.imageView.stopLoadingImage()
        }
    }
}
