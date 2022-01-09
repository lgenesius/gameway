//
//  SectionViewModel.swift
//  Gameway
//
//  Created by Luis Genesius on 09/01/22.
//

import Foundation
import Combine

final class SectionViewModel {
    @Published var sections = [Section]()
    
    private var anyCancellable = Set<AnyCancellable>()
    
    func fetchSections() {
        
    }
}
