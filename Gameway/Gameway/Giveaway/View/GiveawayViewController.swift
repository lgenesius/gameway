//
//  GiveawayViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 08/01/22.
//

import UIKit

class GiveawayViewController: UIViewController {
    private var giveawayVM: GiveawayViewModel
    
    private var tableView: UITableView!
    
    init(viewModel giveawayVM: GiveawayViewModel) {
        self.giveawayVM = giveawayVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentViewInterface()
        setTableViewSettings()
        
        giveawayVM.fetchGiveaways { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }

    private func setCurrentViewInterface() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.vividYellow]
        view.backgroundColor = .darkKnight
    }
    
    private func setTableViewSettings() {
        tableView = UITableView()
        tableView.backgroundColor = .darkKnight
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
        tableView.register(GiveawayTableViewCell.self, forCellReuseIdentifier: GiveawayTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableView Protocol

extension GiveawayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giveawayVM.isFetched ? giveawayVM.giveaways.count: 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if giveawayVM.isFetched {
            let cell = tableView.dequeueReusableCell(withIdentifier: GiveawayTableViewCell.identifier, for: indexPath) as! GiveawayTableViewCell
            cell.configure(with: giveawayVM.giveaways[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.identifier, for: indexPath) as! SkeletonTableViewCell
            cell.configure(with: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if giveawayVM.isFetched {
            let giveawayImageViewSize: CGFloat = 250
            
            let estimatedTitleFrame = countEstimatedLabelFrame(giveawayVM.giveaways[indexPath.row].title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3)])
            
            let descLines = countDescLabelLines(giveawayVM.giveaways[indexPath.row].description) - 1
            let estimatedDescFrame = countEstimatedLabelFrame(giveawayVM.giveaways[indexPath.row].description, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)])
            let descHeight = (estimatedDescFrame.height / CGFloat(descLines)) * 2
            let total: CGFloat = 40 + 50 + 20 // 40 from space between element, 50 come from platform collection view height, 20 come from estimated free horizontal stack view height and 70 for estimated height of description label
            return giveawayImageViewSize + total + estimatedTitleFrame.height + descHeight + 25
        } else {
            return view.bounds.height / 3 + 50
        }
    }
    
    private func countDescLabelLines(_ string: String) -> Int {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.text = string
        
        let labelSize = countEstimatedLabelFrame(label.text!, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)])
        
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
    private func countEstimatedLabelFrame(_ string: String, attributes: [NSAttributedString.Key : UIFont]) -> CGRect {
        let size = CGSize(width: UIScreen.main.bounds.width - 20, height: CGFloat.greatestFiniteMagnitude)
        
        return NSString(string: string).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

