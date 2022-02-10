//
//  SectionHeader.swift
//  Gameway
//
//  Created by Luis Genesius on 05/02/22.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    private let title = UILabel()
    private let subtitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.textColor = .vividYellow
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 25, weight: .bold))
        
        subtitle.textColor = .secondaryLabel
        subtitle.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 15))
        
        let stackView = UIStackView(arrangedSubviews: [title, subtitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error Section Header")
    }
    
    func setTitleText(title titleText: String, subtitle subtitleText: String) {
        title.text = titleText
        subtitle.text = subtitleText
    }
}
