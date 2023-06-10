//
//  SkeletonHomeCell.swift
//  Gameway
//
//  Created by Luis Genesius on 10/02/22.
//

import UIKit

class SkeletonTableViewCell: UITableViewCell, ConfigCell {
    typealias Request = Any
    
    static var identifier: String = "SkeletonTableViewCell"
    private let paddingLeading: CGFloat = 10
    
    private let sectionTitleGradient: CAGradientLayer = CAGradientLayer()
    private let sectionSubtitleGradient: CAGradientLayer = CAGradientLayer()
    private let itemImageViewGradient: CAGradientLayer = CAGradientLayer()
    private let titleGradient: CAGradientLayer = CAGradientLayer()
    private let freeGradient: CAGradientLayer = CAGradientLayer()
    private let worthGradient: CAGradientLayer = CAGradientLayer()
    
    private let sectionTitleView: UIView = UIView()
    private let sectionSubtitleView: UIView = UIView()
    private let theImageView: UIView = UIView()
    private let titleView: UIView = UIView()
    private let worthView: UIView = UIView()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSkeletonView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
        
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            sectionTitleSkeletonView.widthAnchor.constraint(equalToConstant: 300.0),
            sectionTitleSkeletonView.heightAnchor.constraint(equalToConstant: 30.0),
            
            sectionSubtitleSkeletonView.widthAnchor.constraint(equalToConstant: 300.0),
            sectionSubtitleSkeletonView.heightAnchor.constraint(equalToConstant: 18.0),
            
            contentImageSkeletonView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            contentImageSkeletonView.heightAnchor.constraint(equalToConstant: 250.0),
            
            contentTitleSkeletonView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor),
            contentTitleSkeletonView.heightAnchor.constraint(equalToConstant: 24.0),
            
            contentWorthSkeletonView.widthAnchor.constraint(equalToConstant: 70.0),
            contentWorthSkeletonView.heightAnchor.constraint(equalToConstant: 20.0),
            
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
        ])
        
    }
    
    func configure(with item: Any?) {
        
    }
}

extension SkeletonTableViewCell: SkeletonLoader {}
