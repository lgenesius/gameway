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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSectionTitleView()
        setSectionSubtitleView()
        setTheImageView()
        setTitleView()
        setWorthView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        sectionTitleView.frame = CGRect(x: paddingLeading, y: 0, width: 300, height: 30)
        sectionTitleGradient.frame = sectionTitleView.bounds
        sectionTitleGradient.cornerRadius = 5
        
        sectionSubtitleView.frame = CGRect(x: paddingLeading, y: sectionTitleView.bounds.height + 10, width: 300, height: 18)
        sectionSubtitleGradient.frame = sectionSubtitleView.bounds
        sectionSubtitleGradient.cornerRadius = 5
        
        let fullScreenWidth: CGFloat = contentView.frame.width - 20
        let imageYSum: CGFloat = sectionTitleView.bounds.height + sectionSubtitleView.bounds.height + 20
        let imageHeight: CGFloat = contentView.bounds.height - (imageYSum + 20 + 24 + 40)
        theImageView.frame = CGRect(x: paddingLeading, y: imageYSum, width: fullScreenWidth, height: imageHeight)
        itemImageViewGradient.frame = theImageView.bounds
        itemImageViewGradient.cornerRadius = 5
        
        let titleYSum: CGFloat = imageYSum + theImageView.bounds.height + 10
        titleView.frame = CGRect(x: paddingLeading, y: titleYSum, width: fullScreenWidth, height: 24)
        titleGradient.frame = titleView.bounds
        titleGradient.cornerRadius = 5
        
        let worthYSum: CGFloat = titleYSum + titleView.bounds.height + 10
        worthView.frame = CGRect(x: paddingLeading, y: worthYSum, width: 70, height: 20)
        worthGradient.frame = worthView.bounds
        worthGradient.cornerRadius = 5
    }
    
    private func setSectionTitleView() {
        sectionTitleView.backgroundColor = .mainDarkBlue
        
        sectionTitleGradient.startPoint = CGPoint(x: 0, y: 0.5)
        sectionTitleGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        sectionTitleView.layer.addSublayer(sectionTitleGradient)
        let animGroup: CAAnimationGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        sectionTitleGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(sectionTitleView)
    }
    
    private func setSectionSubtitleView() {
        sectionSubtitleView.backgroundColor = .mainDarkBlue
        
        sectionSubtitleGradient.startPoint = CGPoint(x: 0, y: 0.5)
        sectionSubtitleGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        sectionSubtitleView.layer.addSublayer(sectionSubtitleGradient)
        let animGroup: CAAnimationGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        sectionSubtitleGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(sectionSubtitleView)
    }
    
    private func setTheImageView() {
        theImageView.backgroundColor = .mainDarkBlue
        
        itemImageViewGradient.startPoint = CGPoint(x: 0, y: 0.5)
        itemImageViewGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        theImageView.layer.addSublayer(itemImageViewGradient)
        let animGroup: CAAnimationGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        itemImageViewGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(theImageView)
    }
    
    private func setTitleView() {
        titleView.backgroundColor = .mainDarkBlue
        
        titleGradient.startPoint = CGPoint(x: 0, y: 0.5)
        titleGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        titleView.layer.addSublayer(titleGradient)
        let animGroup: CAAnimationGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        titleGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(titleView)
    }
    
    private func setWorthView() {
        worthView.backgroundColor = .mainDarkBlue
        
        worthGradient.startPoint = CGPoint(x: 0, y: 0.5)
        worthGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        worthView.layer.addSublayer(worthGradient)
        let animGroup: CAAnimationGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        worthGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(worthView)
    }
    
    func configure(with item: Any?) {
        
    }
}

extension SkeletonTableViewCell: SkeletonLoader {}
