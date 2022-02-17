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
        let sectionVM = SectionViewModel(repository: remoteDataSourceRepository)
        return HomeViewController(viewModel: sectionVM)
    }
}
