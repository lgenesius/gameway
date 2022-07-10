//
//  DetailViewModel.swift
//  Gameway
//
//  Created by Luis Genesius on 26/06/22.
//

import Foundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    
    func onViewModelDidLoad()
}

protocol DetailViewModelDelegate: NSObject {
    func notifyPresentGiveawayInfo(giveaway: Giveaway)
}

final class DetailViewModel: DetailViewModelProtocol {
    weak var delegate: DetailViewModelDelegate?
    
    private var giveaway: Giveaway
    
    init(giveaway: Giveaway) {
        self.giveaway = giveaway
    }
    
    func onViewModelDidLoad() {
        delegate?.notifyPresentGiveawayInfo(giveaway: giveaway)
    }
}
