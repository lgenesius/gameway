//
//  ExpandableView.swift
//  Gameway
//
//  Created by Luis Genesius on 11/07/22.
//

import UIKit

final class ExpandableView: UIView {
    
    private lazy var containerStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(contextView)
        stackView.addArrangedSubview(contentView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var contextView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .mainYellow
        view.isUserInteractionEnabled = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contextViewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contextTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .mainDarkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contextShowLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.text = showTitleText
        label.textColor = .mainDarkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view: UIView = UIView()
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.mainYellow.cgColor
        view.isHidden = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var contentViewHeightConstraint: NSLayoutConstraint?
    
    private var isExpanded: Bool = false
    
    private var showTitleText: String {
        return isExpanded ? "Show Less" : "Show More"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        addSubview(containerStackView)
        contextView.addSubview(contextTitleLabel)
        contextView.addSubview(contextShowLabel)
        
        NSLayoutConstraint.activate([
            contextTitleLabel.topAnchor.constraint(equalTo: contextView.topAnchor, constant: 16.0),
            contextTitleLabel.leadingAnchor.constraint(equalTo: contextView.leadingAnchor, constant: 16.0),
            contextTitleLabel.trailingAnchor.constraint(equalTo: contextShowLabel.leadingAnchor, constant: -16.0),
            contextTitleLabel.bottomAnchor.constraint(equalTo: contextView.bottomAnchor, constant: -16.0),
            
            contextShowLabel.topAnchor.constraint(equalTo: contextView.topAnchor, constant: 16.0),
            contextShowLabel.trailingAnchor.constraint(equalTo: contextView.trailingAnchor, constant: -16.0),
            contextShowLabel.bottomAnchor.constraint(equalTo: contextView.bottomAnchor, constant: -16.0),
            
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        contextTitleLabel.setContentHuggingPriority(contextShowLabel.contentHuggingPriority(for: .horizontal) - 1, for: .horizontal)
        contextShowLabel.setContentCompressionResistancePriority(contextTitleLabel.contentCompressionResistancePriority(for: .horizontal) + 1, for: .horizontal)
        
        contentView.alpha = 0.0
    }
    
    @objc private func contextViewTapped(_ tapGesture: UITapGestureRecognizer) {
        isExpanded = !isExpanded
        contextShowLabel.text = showTitleText
        animateView(isExpanded: isExpanded)
    }
    
    func animateView(isExpanded: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.contentView.subviews.forEach { $0.isHidden = !isExpanded }
            self?.contentView.alpha = isExpanded ? 1.0 : 0.0
            self?.contentView.isHidden = !isExpanded
        } completion: { [weak self] _  in
            UIView.animate(withDuration: 0.1) {
                self?.contentView.subviews.forEach { $0.alpha = isExpanded ? 1.0 : 0.0 }
            }
        }

    }
    
    func setupContentView(_ view: UIView, with title: String) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        view.isHidden = contentView.isHidden
        view.alpha = contentView.isHidden ? 0.0 : 1.0
        
        contextTitleLabel.text = title
    }
}
