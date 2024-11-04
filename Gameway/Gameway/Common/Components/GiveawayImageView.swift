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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init() {
        super.init(image: nil)
        setupViews()
    }
    
    deinit {
        cancellable?.cancel()
        cancellable = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoadingImage() {
        addActivityIndicatorIfNeeded()
        activityIndicator.startAnimating()
        image = UIImage(named: "placeholder-image")
    }
    
    func stopLoadingImage() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func resetImage() {
        cancellable?.cancel()
        cancellable = nil
        
        stopLoadingImage()
        image = nil
    }
    
    func setImage(with urlString: String) {
        showLoadingImage()
        if let url = URL(string: urlString) {
            cancellable = ImageLoader.shared.loadImage(from: url)
                .sink(receiveValue: { [unowned self] resultImage in
                    stopLoadingImage()
                    image = resultImage
                })
        }
        else {
            stopLoadingImage()
        }
    }
    
    private func addActivityIndicatorIfNeeded() {
        guard activityIndicator.superview == nil else { return }
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupViews() {
        layer.cornerRadius = 8.0
        clipsToBounds = true
        contentMode = .scaleToFill
        backgroundColor = .mainDarkBlue
    }
}
