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
        let homeViewModel: HomeViewModelProtocol = HomeViewModel(dependency: HomeViewModelDependency())
        return HomeViewController(viewModel: homeViewModel)
    }
}
