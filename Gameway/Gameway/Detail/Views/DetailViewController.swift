//
//  DetailViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 08/01/22.
//

import UIKit


private let kDefaultPadding: CGFloat = 8.0

final class DetailViewController: UIViewController {
    private var detailVM: DetailViewModelProtocol
    
    private var giveawayLink: String?
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.bounces = true
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
        giveawayImageView.contentMode = .scaleToFill
        giveawayImageView.layer.cornerRadius = 0.0
        return giveawayImageView
    }()
    
    private lazy var darkGradientView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var platformCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mainDarkBlue
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PlatformCollectionViewCell.self, forCellWithReuseIdentifier: PlatformCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 27.0, weight: .bold)
        label.textColor = .mainYellow
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var horizontalBoxView: HorizontalBoxView = {
        let view: HorizontalBoxView = HorizontalBoxView()
        view.addBoxView(BoxView())
        view.addBoxView(BoxView())
        view.addBoxView(priceBox)
        view.setupColor(backgroundColor: .darkGray,
                        titleTextColor: .lightGray,
                        infoTextColor: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var priceBox: BoxView = {
        let boxView: BoxView = BoxView()
        return boxView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        label.textColor = .white
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var expandedView: ExpandableView = {
        let view: ExpandableView = ExpandableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var boxAndDescriptionSeparatorView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var expandableAndInformationSeparatorView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        platformCollectionView.delegate = self
        platformCollectionView.dataSource = self
        detailVM.onViewModelDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarWithBackground(isTransparent: true)
        setupGradientColor()
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
    
    private func setupGradientColor() {
        let topColor: CGColor = UIColor.clear.cgColor
        let bottomColor: CGColor = UIColor.mainDarkBlue.cgColor
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIHelper.screenSize.width, height: UIHelper.screenSize.height / 6)
        
        darkGradientView.layer.insertSublayer(gradientLayer, at: 0)
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
        mainContainerView.addSubview(darkGradientView)
        mainContainerView.addSubview(platformCollectionView)
        mainContainerView.addSubview(titleLabel)
        mainContainerView.addSubview(horizontalBoxView)
        mainContainerView.addSubview(boxAndDescriptionSeparatorView)
        mainContainerView.addSubview(descriptionLabel)
        mainContainerView.addSubview(expandedView)
        mainContainerView.addSubview(expandableAndInformationSeparatorView)
        
        NSLayoutConstraint.activate([
            //giveaway image view constraints
            giveawayImageView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor),
            giveawayImageView.heightAnchor.constraint(equalToConstant: UIHelper.screenSize.height / 3),
            giveawayImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            giveawayImageView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            giveawayImageView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            
            //dark gradient view constraints
            darkGradientView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor),
            darkGradientView.heightAnchor.constraint(equalToConstant: UIHelper.screenSize.height / 6),
            darkGradientView.bottomAnchor.constraint(equalTo: giveawayImageView.bottomAnchor),
            darkGradientView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            darkGradientView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            
            //platform collection view constraints
            platformCollectionView.heightAnchor.constraint(equalToConstant: 30),
            platformCollectionView.topAnchor.constraint(equalTo: giveawayImageView.bottomAnchor, constant: kDefaultPadding),
            platformCollectionView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: kDefaultPadding * 2),
            platformCollectionView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -kDefaultPadding * 2),
            
            //title label constraints
            titleLabel.topAnchor.constraint(equalTo: platformCollectionView.bottomAnchor, constant: kDefaultPadding),
            titleLabel.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: kDefaultPadding * 2),
            titleLabel.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -kDefaultPadding * 2),
            
            //horizontal double box view constraints
            horizontalBoxView.heightAnchor.constraint(equalToConstant: 100.0),
            horizontalBoxView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: kDefaultPadding * 2),
            horizontalBoxView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            horizontalBoxView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            
            //boxAndDescriptionSeparatorView view constraints
            boxAndDescriptionSeparatorView.heightAnchor.constraint(equalToConstant: 1.0),
            boxAndDescriptionSeparatorView.topAnchor.constraint(equalTo: horizontalBoxView.bottomAnchor, constant: kDefaultPadding * 2),
            boxAndDescriptionSeparatorView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: kDefaultPadding * 2),
            boxAndDescriptionSeparatorView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -kDefaultPadding * 2),
            
            //description label constraints
            descriptionLabel.topAnchor.constraint(equalTo: boxAndDescriptionSeparatorView.bottomAnchor, constant: kDefaultPadding * 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: kDefaultPadding * 2),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -kDefaultPadding * 2),
            
            //expanded view consttraints
            expandedView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: kDefaultPadding * 2),
            expandedView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: kDefaultPadding * 2),
            expandedView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -kDefaultPadding * 2),
            
            //boxAndDescriptionSeparatorView view constraints
            expandableAndInformationSeparatorView.heightAnchor.constraint(equalToConstant: 1.0),
            expandableAndInformationSeparatorView.topAnchor.constraint(equalTo: expandedView.bottomAnchor, constant: kDefaultPadding * 2),
            expandableAndInformationSeparatorView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: kDefaultPadding * 2),
            expandableAndInformationSeparatorView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -kDefaultPadding * 2),
            expandableAndInformationSeparatorView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -kDefaultPadding * 2),
        ])
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailVM.platforms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = platformCollectionView.dequeueReusableCell(withReuseIdentifier: PlatformCollectionViewCell.identifier, for: indexPath) as! PlatformCollectionViewCell
        cell.configure(with: detailVM.platforms[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = NSString(string: detailVM.platforms[indexPath.row]).size(withAttributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .footnote)])
        return CGSize(width: itemSize.width + 20, height: platformCollectionView.bounds.height)
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func notifyPresentGiveawayInfo(giveaway: Giveaway) {
        setupDetailImage(giveaway.image)
        setupDetailLabel(title: giveaway.title, description: giveaway.description)
        setupInfoBox(type: giveaway.type, worth: giveaway.worth, endDate: giveaway.endDate)
        setupHowToClaimInstructions(text: giveaway.instructions, link: giveaway.openGiveawayURL)
        
        DispatchQueue.main.async { [weak self] in
            self?.platformCollectionView.reloadData()
        }
    }
    
    private func setupDetailImage(_ image: String) {
        giveawayImageView.stopLoadingImage()
        giveawayImageView.setImage(with: image)
    }
    
    private func setupDetailLabel(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    private func setupInfoBox(type: String, worth: String, endDate: String) {
        horizontalBoxView.addInfo(to: 0,
                                  title: "Type",
                                  info: type)
        horizontalBoxView.addInfo(to: 1,
                                  title: "Original Price",
                                  info: worth)
        if let endDate: Date = DateHelper.convertStringToDate(endDate),
           let dayDiff: Int = DateHelper.getDayDifference(from: Date(), to: endDate) {
            var titleText: String = "Will Ends In"
            var infoText: String = ""
            
            if dayDiff > 0 {
                infoText = "\(dayDiff) Days"
                priceBox.changeTitleTextColor(to: .mainDarkBlue)
                priceBox.changeInfoTextColor(to: .mainDarkBlue)
                
                if dayDiff > 7 {
                    priceBox.backgroundColor = .systemGreen
                } else if dayDiff > 3 {
                    priceBox.backgroundColor = .systemOrange
                } else {
                    priceBox.backgroundColor = .systemRed
                }
            }
            else if dayDiff == 0 {
                infoText = "Today"
                priceBox.backgroundColor = .systemRed
                priceBox.changeTitleTextColor(to: .mainDarkBlue)
                priceBox.changeInfoTextColor(to: .mainDarkBlue)
            }
            else {
                titleText = ""
                infoText = "Has Expired"
            }
            horizontalBoxView.addInfo(to: 2,
                                      title: titleText,
                                      info: infoText)
        }
        else {
            horizontalBoxView.addInfo(to: 2,
                                      title: "End of Giveaway",
                                      info: "Unknown")
        }
    }
    
    private func setupHowToClaimInstructions(text: String, link: String) {
        giveawayLink = link
        
        let view: UIView = UIView()
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.numberOfLines = 0
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: kDefaultPadding * 2),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kDefaultPadding * 2),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kDefaultPadding * 2)
        ])
        
        let button: UIButton = UIButton()
        button.backgroundColor = .mainYellow
        button.layer.cornerRadius = 8.0
        button.setTitle("Claim Giveaway", for: .normal)
        button.setTitleColor(.mainDarkBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.addTarget(self, action: #selector(giveawayLinkButtonTapped), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: kDefaultPadding * 2),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kDefaultPadding * 2),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -kDefaultPadding * 2),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kDefaultPadding * 2)
        ])
        
        expandedView.setupContentView(view, with: "How To Claim")
    }
    
    @objc private func giveawayLinkButtonTapped() {
        let application: UIApplication = UIApplication.shared
        
        if let urlString: String = giveawayLink,
           let url: URL = URL(string: urlString),
           application.canOpenURL(url) {
            application.open(url, options: [:])
        }
    }
}
