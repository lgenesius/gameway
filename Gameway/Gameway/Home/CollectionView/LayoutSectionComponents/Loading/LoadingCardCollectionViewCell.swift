//
//  LoadingCardCollectionViewCell.swift
//  Gameway
//
//  Created by Luis Genesius on 04/06/23.
//

import UIKit

final class LoadingCardCollectionViewCell: UICollectionViewCell {
    private let sectionTitleSkeletonView: SkeletonView = SkeletonView()
    private let sectionSubtitleSkeletonView: SkeletonView = SkeletonView()
    private let contentImageSkeletonView: SkeletonView = SkeletonView()
    private let contentTitleSkeletonView: SkeletonView = SkeletonView()
    private let contentWorthSkeletonView: SkeletonView = SkeletonView()
    
    private let verticalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.spacing = 8.0
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeletonView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSkeletonView() {
        backgroundColor = .mainDarkBlue
        verticalStackView.addArrangedSubview(sectionTitleSkeletonView)
        verticalStackView.addArrangedSubview(sectionSubtitleSkeletonView)
        verticalStackView.addArrangedSubview(contentImageSkeletonView)
        verticalStackView.addArrangedSubview(contentTitleSkeletonView)
        verticalStackView.addArrangedSubview(contentWorthSkeletonView)
        
        sectionTitleSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        sectionSubtitleSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        contentImageSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        contentTitleSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        contentWorthSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        
        contentImageSkeletonView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            sectionTitleSkeletonView.widthAnchor.constraint(equalToConstant: 300.0),
            sectionTitleSkeletonView.heightAnchor.constraint(equalToConstant: 30.0),
            
            sectionSubtitleSkeletonView.widthAnchor.constraint(equalToConstant: 300.0),
            sectionSubtitleSkeletonView.heightAnchor.constraint(equalToConstant: 18.0),
            
            contentImageSkeletonView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            
            contentTitleSkeletonView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            contentTitleSkeletonView.heightAnchor.constraint(equalToConstant: 24.0),
            
            contentWorthSkeletonView.widthAnchor.constraint(equalToConstant: 70.0),
            contentWorthSkeletonView.heightAnchor.constraint(equalToConstant: 20.0),
            
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ])
    }
}
