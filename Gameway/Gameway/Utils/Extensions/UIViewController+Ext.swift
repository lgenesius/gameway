//
//  UIViewController+Ext.swift
//  Gameway
//
//  Created by Luis Genesius on 07/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
}
