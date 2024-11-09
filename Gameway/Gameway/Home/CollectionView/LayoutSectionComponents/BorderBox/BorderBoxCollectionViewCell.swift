//
//  BorderBoxCollectionViewCell.swift
//  Gameway
//
//  Created by Luis Genesius on 09/11/24.
//

import UIKit

final class BorderBoxCollectionViewCell: UICollectionViewCell {
    private lazy var containerView: UIView = {
        let view: UIView = UIView()
        view.layer.cornerRadius = 8.0
        view.backgroundColor = UIColor.mainDarkBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentImageView: GiveawayImageView = {
        let view: GiveawayImageView = GiveawayImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .mainYellow
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceHorizontalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var freeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .mainYellow
        label.text = "FREE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var worthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        applyShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        worthLabel.isHidden = true
        worthLabel.text = nil
        contentImageView.resetImage()
    }
    
    func configure(with item: BorderBoxLayoutItemModel) {
        contentImageView.setImage(with: item.giveaway.thumbnail)
        contentTitleLabel.text = item.giveaway.title
        
        if item.giveaway.worth != "N/A" {
            worthLabel.isHidden = false
            worthLabel.text = item.giveaway.worth
        }
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        containerView.addSubview(contentContainerView)
        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6.0),
            contentContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6.0),
            contentContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6.0),
            contentContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6.0)
        ])
        
        contentContainerView.addSubview(contentImageView)
        NSLayoutConstraint.activate([
            contentImageView.heightAnchor.constraint(equalTo: contentContainerView.heightAnchor, multiplier: 0.5),
            contentImageView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            contentImageView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            contentImageView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor)
        ])
        
        contentContainerView.addSubview(contentTitleLabel)
        NSLayoutConstraint.activate([
            contentTitleLabel.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 8.0),
            contentTitleLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            contentTitleLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor)
        ])
        
        contentContainerView.addSubview(priceHorizontalStackView)
        NSLayoutConstraint.activate([
            priceHorizontalStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            priceHorizontalStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            priceHorizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentContainerView.trailingAnchor),
            
            contentTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: priceHorizontalStackView.topAnchor, constant: -4.0)
        ])
        
        priceHorizontalStackView.addArrangedSubview(freeLabel)
        priceHorizontalStackView.addArrangedSubview(worthLabel)
    }
    
    private func applyShadow() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 5.0
    }
}
