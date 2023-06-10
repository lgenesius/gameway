//
//  GiveawayImageView.swift
//  Gameway
//
//  Created by Luis Genesius on 13/02/22.
//

import Combine
import UIKit

class GiveawayImageView: UIImageView {
    
    private var cancellable: AnyCancellable?
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        set()
    }
    
    init() {
        super.init(image: nil)
        set()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func set() {
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.contentMode = .scaleToFill
        self.backgroundColor = .mainDarkBlue
        
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func showLoadingImage() {
        activityIndicator.startAnimating()
        self.image = UIImage(named: "placeholder-image")
    }
    
    func stopLoadingImage() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func setImage(with urlString: String) {
        if activityIndicator.superview != nil {
            stopLoadingImage()
        }
        
        if let url = URL(string: urlString) {
            cancellable = ImageLoader.shared.loadImage(from: url)
                .sink(receiveValue: { [unowned self] image in
                    guard let image = image else { return }
                    
                    self.image = image
                })
        }
    }
    
    deinit {
        cancellable?.cancel()
        cancellable = nil
    }
}
