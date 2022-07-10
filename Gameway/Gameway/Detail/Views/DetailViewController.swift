//
//  DetailViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 08/01/22.
//

import UIKit

final class DetailViewController: UIViewController {
    private var detailVM: DetailViewModelProtocol
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var mainContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var giveawayImageView: GiveawayImageView = {
        let giveawayImageView: GiveawayImageView = GiveawayImageView()
        giveawayImageView.translatesAutoresizingMaskIntoConstraints = false
        giveawayImageView.clipsToBounds = true
        giveawayImageView.contentMode = .scaleAspectFill
        giveawayImageView.layer.cornerRadius = 0.0
        return giveawayImageView
    }()
    
    init(viewModel detailVM: DetailViewModelProtocol) {
        self.detailVM = detailVM
        super.init(nibName: nil, bundle: nil)
        self.detailVM.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainDarkBlue
        
        setupScrollView()
        setupViews()
        detailVM.onViewModelDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarWithBackground(isTransparent: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupNavBarWithBackground(isTransparent: false)
    }
    
    private func setupNavBarWithBackground(isTransparent: Bool) {
        if isTransparent {
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.tintColor = UIColor.mainYellow
        } else {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
        }
    }
    
    private func setupScrollView() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(mainContainerView)
        
        NSLayoutConstraint.activate([
            //main scroll view constraints
            mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //main container view constraints
            mainContainerView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            mainContainerView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainContainerView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainContainerView.bottomAnchor.constraint(greaterThanOrEqualTo: mainScrollView.bottomAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor)
        ])
    }

    private func setupViews() {
        mainContainerView.addSubview(giveawayImageView)
        
        NSLayoutConstraint.activate([
            giveawayImageView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor),
            giveawayImageView.heightAnchor.constraint(equalToConstant: UIHelper.screenSize.height / 3),
            giveawayImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            giveawayImageView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            giveawayImageView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor)
        ])
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func notifyPresentGiveawayInfo(giveaway: Giveaway) {
        giveawayImageView.stopLoadingImage()
        giveawayImageView.setImage(with: giveaway.thumbnail)
    }
}
