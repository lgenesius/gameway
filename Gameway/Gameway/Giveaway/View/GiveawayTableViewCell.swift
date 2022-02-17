//
//  GiveawayCell.swift
//  Gameway
//
//  Created by Luis Genesius on 15/02/22.
//

import Combine
import UIKit

class GiveawayTableViewCell: UITableViewCell, ConfigCell {
    typealias Request = Giveaway
    
    static var identifier: String = "GiveawayTableViewCell"
    
    private var platforms = [String]()
    
    private let giveawayImageView = GiveawayImageView()
    
    private var platformCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .darkKnight
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PlatformCollectionViewCell.self, forCellWithReuseIdentifier: PlatformCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .vividYellow
        label.numberOfLines = 0
        return label
    }()
    
    private let freeLabel: UILabel = {
        let label = UILabel()
        label.text = "FREE"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .vividYellow
        return label
    }()
    
    private let worthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .red
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()
    
    private var cancellable: AnyCancellable?
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.width = UIScreen.main.bounds.width
            super.frame = frame
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        worthLabel.attributedText = attributeString
        
        let priceHorizontalStackView = UIStackView(arrangedSubviews: [freeLabel, worthLabel])
        priceHorizontalStackView.axis = .horizontal
        priceHorizontalStackView.distribution = .fill
        priceHorizontalStackView.spacing = 10
        
        let horizontalStackView = UIStackView(arrangedSubviews: [priceHorizontalStackView, endDateLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        
        let verticalStackView = UIStackView(arrangedSubviews: [
            giveawayImageView,
            platformCollectionView,
            titleLabel,
            horizontalStackView,
            descriptionLabel
        ])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.spacing = 10
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            
            giveawayImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width - 20),
            giveawayImageView.heightAnchor.constraint(equalToConstant: 250),
            
            platformCollectionView.widthAnchor.constraint(equalToConstant: contentView.frame.width - 20),
            platformCollectionView.heightAnchor.constraint(equalToConstant: 30),
            
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        
        platformCollectionView.dataSource = self
        platformCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with item: Giveaway?) {
        guard let giveaway = item else { return }
        self.backgroundColor = .darkKnight
        contentView.backgroundColor = .darkKnight
        
        
        getImage(giveaway.thumbnail)
        
        platforms = giveaway.platforms.components(separatedBy: ", ")
        
        titleLabel.text = giveaway.title
        descriptionLabel.text = giveaway.description
        
        if giveaway.worth != "N/A" {
            worthLabel.text = giveaway.worth
        }
        
        configureExpireText(endDate: giveaway.endDate)
    }
    
    private func getImage(_ urlString: String) {
        giveawayImageView.startActivityIndicator()
        
        if let url = URL(string: urlString) {
            cancellable = ImageLoader.shared.loadImage(from: url)
                .sink(receiveValue: { [unowned self] image in
                    self.giveawayImageView.stopActivityIndicator()
                    guard let image = image else { return }
                    
                    self.giveawayImageView.image = image
                })
        } else {
            self.giveawayImageView.stopActivityIndicator()
        }
    }
    
    private func configureExpireText(endDate giveawayEndDate: String) {
        let endDate = convertStringToDate(giveawayEndDate)
        guard let endDate = endDate else {
            endDateLabel.text = ""
            return
        }
        
        let dayDiff = getDayDifference(from: Date(), to: endDate)
        guard let dayDiff = dayDiff else {
            endDateLabel.text = ""
            return
        }
        
        if dayDiff < 0 {
            endDateLabel.text = "Has Expired"
            endDateLabel.textColor = .gray
        } else {
            endDateLabel.text = dayDiff == 0 ? "Expire Today": "\(dayDiff) Days Left"
        }
    }
}

// MARK: - UICollectionView Protocol

extension GiveawayTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        platforms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = platformCollectionView.dequeueReusableCell(withReuseIdentifier: PlatformCollectionViewCell.identifier, for: indexPath) as! PlatformCollectionViewCell
        cell.configure(with: platforms[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionView Delegate Flow Layout

extension GiveawayTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = NSString(string: platforms[indexPath.row]).size(withAttributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .footnote)])
        return CGSize(width: itemSize.width + 20, height: platformCollectionView.bounds.height)
    }
}

// MARK: - Date Service

extension GiveawayTableViewCell: DateService {}