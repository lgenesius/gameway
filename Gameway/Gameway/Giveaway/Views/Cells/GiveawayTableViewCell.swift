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
        collectionView.backgroundColor = .mainDarkBlue
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PlatformCollectionViewCell.self, forCellWithReuseIdentifier: PlatformCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .mainYellow
        label.numberOfLines = 0
        return label
    }()
    private let freeLabel: UILabel = {
        let label = UILabel()
        label.text = "FREE"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .mainYellow
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
    private let typeLabel: PaddingLabel = {
        let label = PaddingLabel(5, 5, 10, 10)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.backgroundColor = .mainDarkBlue
        label.textColor = .mainYellow
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        giveawayImageView.addSubview(typeLabel)
        
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
            
            typeLabel.trailingAnchor.constraint(equalTo: giveawayImageView.trailingAnchor, constant: -10),
            typeLabel.topAnchor.constraint(equalTo: giveawayImageView.topAnchor, constant: 10),
            
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
        self.backgroundColor = .mainDarkBlue
        contentView.backgroundColor = .mainDarkBlue
        
        
        getImage(giveaway.thumbnail)
        
        platforms = giveaway.platforms.components(separatedBy: ", ")
        typeLabel.text = giveaway.type
        titleLabel.text = giveaway.title
        descriptionLabel.text = giveaway.description
        
        if giveaway.worth != "N/A" {
            worthLabel.textColor = .darkGray
            worthLabel.text = giveaway.worth
        }
        else {
            worthLabel.textColor = .mainDarkBlue
            worthLabel.text = "N/A"
        }
        
        configureExpireText(endDate: giveaway.endDate)
    }
    
    private func getImage(_ urlString: String) {
        giveawayImageView.startActivityIndicator()
        giveawayImageView.image = UIImage(named: "placeholder-image")
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
        let endDate = DateHelper.convertStringToDate(giveawayEndDate)
        guard let endDate = endDate else {
            endDateLabel.text = ""
            return
        }
        
        let dayDiff = DateHelper.getDayDifference(from: Date(), to: endDate)
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
