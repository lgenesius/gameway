//
//  GiveawayViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 08/01/22.
//

import UIKit

class GiveawayViewController: UIViewController {
    private var giveawayVM: GiveawayViewModelProtocol
    
    private var headerTableView: GiveawayWorthView?
    
    private var isPaginating: Bool = false
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .mainDarkBlue
        tableView.separatorStyle = .none
        tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
        tableView.register(GiveawayTableViewCell.self, forCellReuseIdentifier: GiveawayTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var errorView: ErrorView = {
        let errorView: ErrorView = ErrorView(frame: view.bounds)
        errorView.delegate = self
        return errorView
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
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.style = .large
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
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
        return giveawayVM.onViewModelGetGiveaways().count > 0 ? giveawayVM.onViewModelGetGiveaways().count: 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if giveawayVM.onViewModelGetGiveaways().count > 0 {
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
        if giveawayVM.onViewModelGetGiveaways().count > 0 {
            return UITableView.automaticDimension
        } else {
            return 390
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerTableView = GiveawayWorthView(frame: CGRect(x: 16.0, y: 0, width:view.bounds.width, height: 120))
        
        if let worth: Worth = giveawayVM.onViewModelGetWorth() {
            headerTableView?.setupBoxDataView()
            headerTableView?.addInfoText(
                String(worth.activeGiveawaysNumber),
                String(worth.worthEstimationUSD)
            )
        }
        
        return headerTableView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
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

// MARK: - ScrollView Delegate

extension GiveawayViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position: CGFloat = scrollView.contentOffset.y
        guard position + topbarHeight != 0,
              giveawayVM.onViewModelCanPaginate()
        else {
            return
        }
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) && !isPaginating {
            tableView.tableFooterView = createSpinnerFooter()
            isPaginating = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.isPaginating = false
                self?.tableView.tableFooterView = nil
                self?.giveawayVM.onViewModelLoadMore()
            }
        }
    }
}

// MARK: - GiveawayViewModel Delegate

extension GiveawayViewController: GiveawayViewModelDelegate {
    func processGiveawaysFromViewModel(giveaways: [Giveaway]) {
        DispatchQueue.main.async { [weak self] in
            guard let self: GiveawayViewController = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func processWorthFromViewModel(worth: Worth) {
        DispatchQueue.main.async { [weak self] in
            guard let self: GiveawayViewController = self else { return }
            // reload the header only
            self.headerTableView?.setupBoxDataView()
            self.headerTableView?.addInfoText(
                String(worth.activeGiveawaysNumber),
                String(worth.worthEstimationUSD)
            )
        }
    }
    
    func notifySuccessFetchSections() {
        DispatchQueue.main.async { [weak self] in
            guard let self: GiveawayViewController = self else { return }
            
            if self.errorView.superview != nil {
                self.errorView.removeFromSuperview()
            }
        }
    }
    
    func notifyFailedFetchSections(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self: GiveawayViewController = self else { return }
            
            if self.errorView.superview == nil {
                self.view.addSubview(self.errorView)
                self.errorView.addMessage(error.localizedDescription)
            } else {
                self.errorView.stopActivityIndicator()
            }
        }
    }
}

// MARK: - ErrorView Delegate

extension GiveawayViewController: ErrorViewDelegate {
    func retryErrorButtonOnTapped() {
        giveawayVM.onViewModelReloadData()
    }
}
