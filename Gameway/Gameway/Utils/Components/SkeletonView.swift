//
//  SkeletonView.swift
//  Gameway
//
//  Created by Luis Genesius on 03/05/22.
//

import UIKit

class SkeletonView: UIView {

    private let gradient: CAGradientLayer = CAGradientLayer()
    
    private let gradientView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        gradientView.backgroundColor = .mainDarkBlue
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradientView.layer.addSublayer(gradient)
        let animGroup: CAAnimationGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        gradient.add(animGroup, forKey: "backgroundColor")
        
        addSubview(gradientView)
    }
    
    override func layoutSubviews() {
        gradientView.frame = bounds
        gradient.frame = gradientView.bounds
        gradient.cornerRadius = 4.0
    }
}

extension SkeletonView: SkeletonLoader {}
