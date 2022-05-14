//
//  GiveawayWorthView.swift
//  Gameway
//
//  Created by Luis Genesius on 04/05/22.
//

import UIKit

final class GiveawayWorthView: UIView {
    private lazy var horizontalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var activeGiveawayBoxView: BoxView = BoxView()
    private lazy var worthEstimationBoxView: BoxView = BoxView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        horizontalStackView.addArrangedSubview(activeGiveawayBoxView)
        horizontalStackView.addArrangedSubview(worthEstimationBoxView)
        
        addSubview(horizontalStackView)
        
        activeGiveawayBoxView.translatesAutoresizingMaskIntoConstraints = false
        worthEstimationBoxView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activeGiveawayBoxView.heightAnchor.constraint(equalTo: heightAnchor),
            
            worthEstimationBoxView.heightAnchor.constraint(equalTo: heightAnchor),
            
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupBoxDataView() {
        activeGiveawayBoxView.setupView()
        worthEstimationBoxView.setupView()
    }
    
    func addInfoText(_ activeGiveawayNumber: String, _ worthEstimationUSD: String) {
        activeGiveawayBoxView.addText(title: "Active Giveaway Number", info: activeGiveawayNumber)
        worthEstimationBoxView.addText(title: "Worth Estimation in USD", info: "$\(worthEstimationUSD)")
    }
}
