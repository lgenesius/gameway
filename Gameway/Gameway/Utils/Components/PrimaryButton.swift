//
//  PrimaryButton.swift
//  Gameway
//
//  Created by Luis Genesius on 23/06/22.
//

import UIKit

final class PrimaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupButton() {
        self.layer.cornerRadius = 12.0
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.backgroundColor = .mainYellow
        self.setTitleColor(.mainDarkBlue, for: .normal)
    }
}
