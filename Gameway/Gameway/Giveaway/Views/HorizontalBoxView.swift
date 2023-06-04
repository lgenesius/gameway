//
//  GiveawayWorthView.swift
//  Gameway
//
//  Created by Luis Genesius on 04/05/22.
//

import UIKit

final class HorizontalBoxView: UIView {
    private lazy var horizontalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var boxViews: [BoxView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(horizontalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func addBoxView(_ boxView: BoxView) {
        boxViews.append(boxView)
        horizontalStackView.addArrangedSubview(boxView)
        
        boxView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boxView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    func setupColor(backgroundColor: UIColor,
                    titleTextColor: UIColor,
                    infoTextColor: UIColor) {
        boxViews.forEach {
            $0.backgroundColor = backgroundColor
            $0.changeTitleTextColor(to: titleTextColor)
            $0.changeInfoTextColor(to: infoTextColor)
        }
    }
    
    func addInfo(to index: Int, title: String, info: String) {
        guard index < boxViews.count else { return }
        let boxView: BoxView = boxViews[index]
        boxView.setupView()
        boxView.addText(title: title, info: info)
    }
}
