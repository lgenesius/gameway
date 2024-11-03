//
//  HomeViewModelProtocol.swift
//  Gameway
//
//  Created by Luis Genesius on 03/11/24.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    
    func onViewModelDidLoad()
    func onViewModelReloadData()
    func onViewModelDidSelectItem(at indexPath: IndexPath)
    func onViewModelReturnSections() -> [HomeLayoutSectionModel]
}
