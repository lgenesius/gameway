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
        let remoteDataSource = RemoteDataSource()
        let remoteDataSourceRepository = RemoteDataSourceRepository(dataSource: remoteDataSource)
        let giveawayVM = GiveawayViewModel(repository: remoteDataSourceRepository)
        return GiveawayViewController(viewModel: giveawayVM)
    }
}
