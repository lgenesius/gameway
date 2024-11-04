//
//  CarouselCardCollectionViewCell.swift
//  Gameway
//
//  Created by Luis Genesius on 11/01/22.
//

import Combine
import UIKit

final class CarouselCardCollectionViewCell: UICollectionViewCell {
    typealias Request = CarouselLayoutItemModel
    static var identifier: String = "CarouselCardCollectionViewCell"
    
    private lazy var mainVerticalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var imageViewHeightConstraint: NSLayoutConstraint?
    private lazy var imageView: GiveawayImageView = {
        let imageView: GiveawayImageView = GiveawayImageView()
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .mainYellow
        return label
    }()
    
    private lazy var priceHorizontalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var worthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        
        // Implement strikethrough
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: attributeString.length)
        )
        label.attributedText = attributeString
        
        return label
    }()
    
    private lazy var freeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "FREE"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .mainYellow
        return label
    }()
    
    private lazy var bottomHorizontalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
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
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.resetImage()
    }
    
    func configure(with item: CarouselLayoutItemModel) {
        configureTitleLabel(text: item.giveaway.title)
        configureWorthLabel(worth: item.giveaway.worth)
        configureExpireText(endDate: item.giveaway.endDate)
        configureImageView(imageURLString: item.giveaway.thumbnail)
    }
    
    private func configureTitleLabel(text: String) {
        titleLabel.text = text
    }
    
    private func configureWorthLabel(worth: String) {
        if worth != "N/A" {
            worthLabel.textColor = .darkGray
            worthLabel.text = worth
        }
        else {
            //To fix cell conditional bug
            worthLabel.textColor = .mainDarkBlue
            worthLabel.text = "N/A"
        }
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
    
    private func configureImageView(imageURLString: String) {
        imageView.setImage(with: imageURLString)
    }
    
    private func setupViews() {
        priceHorizontalStackView.addArrangedSubview(freeLabel)
        priceHorizontalStackView.addArrangedSubview(worthLabel)
        
        bottomHorizontalStackView.addArrangedSubview(priceHorizontalStackView)
        bottomHorizontalStackView.addArrangedSubview(expireLabel)
        
        mainVerticalStackView.addArrangedSubview(imageView)
        
        mainVerticalStackView.addArrangedSubview(titleLabel)
        mainVerticalStackView.addArrangedSubview(bottomHorizontalStackView)
        
        contentView.addSubview(mainVerticalStackView)
        
        NSLayoutConstraint.activate([
            mainVerticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
