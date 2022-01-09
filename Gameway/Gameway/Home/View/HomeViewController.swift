//
//  HomeViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 06/01/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.vividYellow]
        view.backgroundColor = .darkKnight
    }
}
