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
        let remoteDataSource = RemoteDataSource()
        let remoteDataSourceRepository = RemoteDataSourceRepository(dataSource: remoteDataSource)
        let homeViewModel = HomeViewModel(repository: remoteDataSourceRepository)
        return HomeViewController(viewModel: homeViewModel)
    }
}
