//
//  GiveawayViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 08/01/22.
//

import UIKit

class GiveawayViewController: UIViewController {
    private var giveawayVM: GiveawayViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .mainDarkBlue
        tableView.separatorStyle = .none
        tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
        tableView.register(GiveawayTableViewCell.self, forCellReuseIdentifier: GiveawayTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(viewModel giveawayVM: GiveawayViewModelProtocol) {
        self.giveawayVM = giveawayVM
        super.init(nibName: nil, bundle: nil)
        self.giveawayVM.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setCurrentViewInterface()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewSettings()
        giveawayVM.onViewModelDidLoad()
    }

    private func setCurrentViewInterface() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.mainYellow]
        view.backgroundColor = .mainDarkBlue
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "slider.vertical.3"), for: .normal)
        button.tintColor = .mainYellow
        button.addTarget(self, action: #selector(rightBarButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func setTableViewSettings() {
        view.addSubview(tableView)
    }
}

// MARK: - Button Function

extension GiveawayViewController {
    @objc private func rightBarButtonTapped() {
        print("Right bar button tapped...")
    }
}

// MARK: - UITableView Protocol

extension GiveawayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giveawayVM.isFetched ? giveawayVM.onViewModelGetGiveaways().count: 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if giveawayVM.isFetched {
            let cell: GiveawayTableViewCell = tableView.dequeueReusableCell(withIdentifier: GiveawayTableViewCell.identifier, for: indexPath) as! GiveawayTableViewCell
            cell.configure(with: giveawayVM.onViewModelGetGiveaways()[indexPath.row])
            return cell
        } else {
            let cell: SkeletonTableViewCell = tableView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.identifier, for: indexPath) as! SkeletonTableViewCell
            cell.configure(with: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if giveawayVM.isFetched {
            let cuurrentGiveaway: Giveaway = giveawayVM.onViewModelGetGiveaways()[indexPath.row]
            let giveawayImageViewSize: CGFloat = 250
            
            let estimatedTitleFrame: CGRect = countEstimatedLabelFrame(cuurrentGiveaway.title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3)])
            
            let descLines: Int = countDescLabelLines(cuurrentGiveaway.description) - 1
            let estimatedDescFrame: CGRect = countEstimatedLabelFrame(cuurrentGiveaway.description, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)])
            let descHeight: CGFloat = (estimatedDescFrame.height / CGFloat(descLines)) * 2
            
            // 40 from space between element, 50 come from platform collection view height, 20 come from estimated free horizontal stack view height and 70 for estimated height of description label
            let total: CGFloat = 40 + 50 + 20
            return giveawayImageViewSize + total + estimatedTitleFrame.height + descHeight + 25
        } else {
            return 390
        }
    }
    
    private func countDescLabelLines(_ string: String) -> Int {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.text = string
        
        let labelSize: CGRect = countEstimatedLabelFrame(label.text!, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)])
        
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
    private func countEstimatedLabelFrame(_ string: String, attributes: [NSAttributedString.Key : UIFont]) -> CGRect {
        let size: CGSize = CGSize(width: UIScreen.main.bounds.width - 20, height: CGFloat.greatestFiniteMagnitude)
        
        return NSString(string: string).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension GiveawayViewController: GiveawayViewModelDelegate {
    func processGiveawaysFromViewModel(giveaways: [Giveaway]) {
        DispatchQueue.main.async { [weak self] in
            guard let self: GiveawayViewController = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func notifySuccessFetchSections() {
        
    }
    
    func notifyFailedFetchSections(error: Error) {
        
    }
}
