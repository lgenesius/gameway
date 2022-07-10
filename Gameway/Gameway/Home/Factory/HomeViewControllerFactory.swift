//
//  ViewControllerFactory.swift
//  Gameway
//
//  Created by Luis Genesius on 26/01/22.
//

import Foundation
import UIKit.UIViewController

final class HomeViewControllerFactory: ViewControllerFactoryProtocol {
    
    func createViewController() -> UIViewController {
        let remoteDataSource: RemoteDataSource = RemoteDataSource()
        let remoteDataSourceRepository: RemoteDataSourceRepository = RemoteDataSourceRepository(dataSource: remoteDataSource)
        let homeViewModel: HomeViewModelProtocol = HomeViewModel(repository: remoteDataSourceRepository)
        return HomeViewController(viewModel: homeViewModel)
    }
}
