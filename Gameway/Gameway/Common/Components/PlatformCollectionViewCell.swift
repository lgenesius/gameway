//
//  PlatformCell.swift
//  Gameway
//
//  Created by Luis Genesius on 13/02/22.
//

import UIKit

class PlatformCollectionViewCell: UICollectionViewCell {
    typealias Request = String
    
    static var identifier: String = "PlatformCollectionViewCell"
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .mainDarkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8.0
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with text: String) {
        self.backgroundColor = .mainYellow
        titleLabel.text = text
        titleLabel.sizeToFit()
    }
}
