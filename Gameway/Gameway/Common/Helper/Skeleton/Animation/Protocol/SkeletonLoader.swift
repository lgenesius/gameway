//
//  SkeletonLoader.swift
//  Gameway
//
//  Created by Luis Genesius on 10/02/22.
//

import UIKit

protocol SkeletonLoader {}

extension SkeletonLoader {
    func makeAnimationGroup(previousGroup: CAAnimationGroup?) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 0.5
        
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.gradientDarkGrey.cgColor
        anim1.toValue = UIColor.gradientLightGrey.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0
        
        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.gradientLightGrey.cgColor
        anim2.toValue = UIColor.gradientDarkGrey.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration
        
        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false
        
        if let previousGroup = previousGroup {
            group.beginTime = previousGroup.beginTime + 0.33
        }
        
        return group
    }
}
