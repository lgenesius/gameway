//
//  UIColor+Ext.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import UIKit

extension UIColor {
    static var mainDarkBlue: UIColor {
        return UIColor(named: "161B33") ?? .black
    }
    
    static var mainYellow: UIColor {
        return UIColor(named: "FFE404") ?? .yellow
    }
    
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }

    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
}
