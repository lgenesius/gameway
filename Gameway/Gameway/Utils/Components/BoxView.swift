//
//  BoxView.swift
//  Gameway
//
//  Created by Luis Genesius on 04/05/22.
//

import UIKit

final class BoxView: UIView {
    private lazy var verticalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.textColor = .mainDarkBlue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.textColor = .mainDarkBlue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var skeletonView: SkeletonView = SkeletonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeletonView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupSkeletonView() {
        addSubview(skeletonView)
        
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skeletonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            skeletonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            skeletonView.topAnchor.constraint(equalTo: topAnchor),
            skeletonView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupView() {
        skeletonView.removeFromSuperview()
        
        backgroundColor = .mainYellow
        layer.cornerRadius = 8.0
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(infoLabel)
        
        addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: -8.0),
            
            infoLabel.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: 8.0),
            infoLabel.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: -8.0),
            
            verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func addText(title: String, info: String) {
        titleLabel.text = title
        infoLabel.text = info
    }
}
