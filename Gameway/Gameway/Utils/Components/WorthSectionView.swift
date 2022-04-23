//
//  WorthSectionView.swift
//  Gameway
//
//  Created by Luis Genesius on 17/02/22.
//

import UIKit

class WorthSectionView: UIView {
    private let activeGiveawaysContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .vividYellow
        return view
    }()
    private let worthEstimationContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .vividYellow
        return view
    }()
    
    private let activeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Active Giveaways"
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    private let activeNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "12345"
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    private let worthTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Worth Estimation(USD)"
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    private let worthNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "$12345"
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activeGiveawaysContainerView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        worthEstimationContainerView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    }
    
    func setLabelText(active: String, worth: String) {
        
    }

    private func setView() {
        let activeVerticalStackView = UIStackView(arrangedSubviews: [
            activeTitleLabel,
            activeNumberLabel
        ])
        activeVerticalStackView.axis = .vertical
//        activeVerticalStackView.spacing = 10
        activeGiveawaysContainerView.addSubview(activeVerticalStackView)
        
        let worthVerticalStackView = UIStackView(arrangedSubviews: [
            worthTitleLabel,
            worthNumberLabel
        ])
        worthVerticalStackView.axis = .vertical
//        worthVerticalStackView.spacing = 10
        worthEstimationContainerView.addSubview(worthVerticalStackView)
        
        let horizontalStackView = UIStackView(arrangedSubviews: [
            activeGiveawaysContainerView,
            worthEstimationContainerView
        ])
        horizontalStackView.axis = .horizontal
//        horizontalStackView.spacing = 5
        addSubview(horizontalStackView)
    }
    
    
}
