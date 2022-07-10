//
//  StatusViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 08/01/22.
//

import UIKit

class StatusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.mainYellow]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainYellow]
        view.backgroundColor = .mainDarkBlue
    }

}
