//
//  GiveawayViewControllerFactory.swift
//  Gameway
//
//  Created by Luis Genesius on 15/02/22.
//

import Foundation
import UIKit.UIViewController

final class GiveawayViewControllerFactory: ViewControllerFactoryProtocol {
    
    func createViewController() -> UIViewController {
        let remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource()
        let remoteDataSourceRepository: RemoteDataSourceRepositoryProtocol = RemoteDataSourceRepository(dataSource: remoteDataSource)
        let giveawayVM: GiveawayViewModelProtocol = GiveawayViewModel(repository: remoteDataSourceRepository)
        return GiveawayViewController(viewModel: giveawayVM)
    }
}
