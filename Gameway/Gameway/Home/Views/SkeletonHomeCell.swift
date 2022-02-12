//
//  SkeletonHomeCell.swift
//  Gameway
//
//  Created by Luis Genesius on 10/02/22.
//

import UIKit

class SkeletonHomeCell: UITableViewCell, ConfigCell {
    typealias Request = Any
    
    static var identifier: String = "SkeletonHomeCell"
    private let paddingLeading: CGFloat = 10
    
    private let sectionTitle = UILabel()
    private let sectionSubtitle = UILabel()
    private let itemImageView = UIImageView()
    private let title = UILabel()
    private let worth = UILabel()
    
    private let sectionTitleGradient = CAGradientLayer()
    private let sectionSubtitleGradient = CAGradientLayer()
    private let itemImageViewGradient = CAGradientLayer()
    private let titleGradient = CAGradientLayer()
    private let freeGradient = CAGradientLayer()
    private let worthGradient = CAGradientLayer()
    
    private let sectionTitleView = UIView()
    private let sectionSubtitleView = UIView()
    private let theImageView = UIView()
    private let titleView = UIView()
    private let worthView = UIView()
    
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
        
        let fullScreenWidth = contentView.frame.width - 20
        let imageYSum = sectionTitleView.bounds.height + sectionSubtitleView.bounds.height + 20
        let imageHeight = contentView.bounds.height - (imageYSum + 20 + 24 + 40)
        theImageView.frame = CGRect(x: paddingLeading, y: imageYSum, width: fullScreenWidth, height: imageHeight)
        itemImageViewGradient.frame = theImageView.bounds
        itemImageViewGradient.cornerRadius = 5
        
        let titleYSum = imageYSum + theImageView.bounds.height + 10
        titleView.frame = CGRect(x: paddingLeading, y: titleYSum, width: fullScreenWidth, height: 24)
        titleGradient.frame = titleView.bounds
        titleGradient.cornerRadius = 5
        
        let worthYSum = titleYSum + titleView.bounds.height + 10
        worthView.frame = CGRect(x: paddingLeading, y: worthYSum, width: 70, height: 20)
        worthGradient.frame = worthView.bounds
        worthGradient.cornerRadius = 5
    }
    
    private func setSectionTitleView() {
        sectionTitleView.backgroundColor = .darkKnight
        
        sectionTitleGradient.startPoint = CGPoint(x: 0, y: 0.5)
        sectionTitleGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        sectionTitleView.layer.addSublayer(sectionTitleGradient)
        let animGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        sectionTitleGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(sectionTitleView)
    }
    
    private func setSectionSubtitleView() {
        sectionSubtitleView.backgroundColor = .darkKnight
        
        sectionSubtitleGradient.startPoint = CGPoint(x: 0, y: 0.5)
        sectionSubtitleGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        sectionSubtitleView.layer.addSublayer(sectionSubtitleGradient)
        let animGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        sectionSubtitleGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(sectionSubtitleView)
    }
    
    private func setTheImageView() {
        theImageView.backgroundColor = .darkKnight
        
        itemImageViewGradient.startPoint = CGPoint(x: 0, y: 0.5)
        itemImageViewGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        theImageView.layer.addSublayer(itemImageViewGradient)
        let animGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        itemImageViewGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(theImageView)
    }
    
    private func setTitleView() {
        titleView.backgroundColor = .darkKnight
        
        titleGradient.startPoint = CGPoint(x: 0, y: 0.5)
        titleGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        titleView.layer.addSublayer(titleGradient)
        let animGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        titleGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(titleView)
    }
    
    private func setWorthView() {
        worthView.backgroundColor = .darkKnight
        
        worthGradient.startPoint = CGPoint(x: 0, y: 0.5)
        worthGradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        worthView.layer.addSublayer(worthGradient)
        let animGroup = makeAnimationGroup(previousGroup: nil)
        animGroup.beginTime = 0.0
        worthGradient.add(animGroup, forKey: "backgroundColor")
        
        contentView.addSubview(worthView)
    }
    
    func configure(with item: Any?) {
        
    }
}

extension SkeletonHomeCell: SkeletonLoader {}
