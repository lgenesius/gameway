//
//  ErrorView.swift
//  Gameway
//
//  Created by Luis Genesius on 30/04/22.
//

import Foundation
import UIKit

protocol ErrorViewDelegate {
    func retryErrorButtonOnTapped()
}

final class ErrorView: UIView {
    var delegate: ErrorViewDelegate?
    
    private var lastDate: Date = Date()
    
    private lazy var errorImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "network-error-image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var mainLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .mainYellow
        label.text = "Error Occured"
        label.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: nil)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .mainYellow
        label.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: nil)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.mainDarkBlue, for: .normal)
        button.layer.cornerRadius = 4.0
        button.backgroundColor = .mainYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .mainDarkBlue
        
        verticalStackView.addArrangedSubview(errorImageView)
        verticalStackView.addArrangedSubview(mainLabel)
        verticalStackView.addArrangedSubview(subLabel)
        verticalStackView.addArrangedSubview(retryButton)
        addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(activityIndicator)
        activityIndicator.isHidden = true
        
        NSLayoutConstraint.activate([
            //Set image view width and height
            errorImageView.widthAnchor.constraint(equalToConstant: 100),
            errorImageView.heightAnchor.constraint(equalToConstant: 100),
            
            //Set button width and height
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
            
            //Set stack view constraints
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        verticalStackView.setCustomSpacing(16.0, after: subLabel)
        retryButton.addTarget(self, action: #selector(retryButtonOnTapped(_:)), for: .touchUpInside)
    }
    
    private func setActivityIndicator() {
        retryButton.isHidden = true
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
    }
    
    @objc
    private func retryButtonOnTapped(_ button: UIButton) {
        setActivityIndicator()
        lastDate = Date()
        delegate?.retryErrorButtonOnTapped()
    }
    
    func addMessage(_ text: String) {
        subLabel.text = text
    }
    
    func stopActivityIndicator() {
        guard let seconds: Int = DateHelper.getSecondDifference(from: lastDate, to: Date()) else { return }
        
        if seconds > 1 {
            activityIndicator.stopAnimating()
            
            activityIndicator.isHidden = true
            retryButton.isHidden = false
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self: ErrorView = self else { return }
                
                self.activityIndicator.stopAnimating()
                
                self.activityIndicator.isHidden = true
                self.retryButton.isHidden = false
            }
        }
    }
}
