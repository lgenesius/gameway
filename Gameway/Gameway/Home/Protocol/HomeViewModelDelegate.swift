//
//  HomeViewModelDelegate.swift
//  Gameway
//
//  Created by Luis Genesius on 03/11/24.
//

import Foundation

protocol HomeViewModelDelegate: NSObject {
    func notifyProcessSections(sections: [HomeLayoutSectionModel])
    func notifySuccessFetchSections()
    func notifyFailedFetchSections(error: Error)
    func notifyNavigateToDetailPage(with viewModel: DetailViewModelProtocol)
}
