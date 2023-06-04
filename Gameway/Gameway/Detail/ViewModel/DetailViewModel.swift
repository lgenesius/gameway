//
//  DetailViewModel.swift
//  Gameway
//
//  Created by Luis Genesius on 26/06/22.
//

import Foundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    var platforms: [String] { get }
    
    func onViewModelDidLoad()
}

protocol DetailViewModelDelegate: NSObject {
    func notifyPresentGiveawayInfo(giveaway: Giveaway)
}

final class DetailViewModel: DetailViewModelProtocol {
    private(set) var platforms: [String]
    
    weak var delegate: DetailViewModelDelegate?
    
    private var giveaway: Giveaway
    
    init(giveaway: Giveaway) {
        self.giveaway = giveaway
        self.platforms = giveaway.platforms.components(separatedBy: ", ")
    }
    
    func onViewModelDidLoad() {
        delegate?.notifyPresentGiveawayInfo(giveaway: giveaway)
    }
}
