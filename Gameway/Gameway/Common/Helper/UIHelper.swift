//
//  UIHelper.swift
//  Gameway
//
//  Created by Luis Genesius on 15/05/22.
//

import Foundation
import UIKit

final class UIHelper {
    static var keyWindow: UIWindow? {
        if #available(iOS 15, *) {
            return UIApplication
                .shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        }
        else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
    
    static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
}
