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
    
    private let imageView: GiveawayImageView = GiveawayImageView()
    
    private let title: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .mainYellow
        return label
    }()
    
    private let worth: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        return label
    }()
    
    private let free: UILabel = {
        let label: UILabel = UILabel()
        label.text = "FREE"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .mainYellow
        return label
    }()
    
    private let expire: UILabel = {
        let label: UILabel = UILabel()
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
        
        let priceHorizontalStackView: UIStackView = UIStackView(arrangedSubviews: [free, worth])
        priceHorizontalStackView.axis = .horizontal
        priceHorizontalStackView.distribution = .fill
        priceHorizontalStackView.spacing = 10
        
        let horizontalStackView: UIStackView = UIStackView(arrangedSubviews: [priceHorizontalStackView, expire])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        
        let verticalStackView: UIStackView = UIStackView(arrangedSubviews: [imageView, title, horizontalStackView])
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
        
        getImage(item.giveaway.thumbnail)
        
        title.text = item.giveaway.title
        
        if item.giveaway.worth != "N/A" {
            worth.textColor = .darkGray
            worth.text = item.giveaway.worth
        }
        else {
            //To fix cell conditional bug
            worth.textColor = .mainDarkBlue
            worth.text = "N/A"
        }
        
        configureExpireText(endDate: item.giveaway.endDate)
        
        let imageSize: CGFloat = contentView.frame.height - (20 + worth.intrinsicContentSize.height + title.intrinsicContentSize.height)
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    }
    
    private func configureExpireText(endDate giveawayEndDate: String) {
        guard let endDate: Date = DateHelper.convertStringToDate(giveawayEndDate) else {
            expire.text = ""
            return
        }
        
        guard let dayDiff: Int = DateHelper.getDayDifference(from: Date(), to: endDate) else {
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
        imageView.image = UIImage(named: "placeholder-image")
        if let url: URL = URL(string: urlString) {
            cancellable = ImageLoader.shared.loadImage(from: url)
                .sink(receiveValue: { [unowned self] image in
                    self.imageView.stopActivityIndicator()
                    guard let image: UIImage = image else { return }
                    
                    self.imageView.image = image
                })
        } else {
            self.imageView.stopActivityIndicator()
        }
    }
}
