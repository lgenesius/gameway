//
//  HomeViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 06/01/22.
//

import UIKit

class HomeViewController: UIViewController {
    private let sectionVM = SectionViewModel()
    private var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Giveaway>?

    override func viewDidLoad() {
        super.viewDidLoad()
        sectionVM.fetchSections()
        setCurrentViewInterface()
        setCollectionViewSettings()
    }
    
    private func setCurrentViewInterface() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.vividYellow]
        view.backgroundColor = .darkKnight
    }
    
    private func setCollectionViewSettings() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .darkKnight
        view.addSubview(collectionView)
    }
}
