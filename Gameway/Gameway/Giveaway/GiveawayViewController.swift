//
//  GiveawayViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 08/01/22.
//

import UIKit

class GiveawayViewController: UIViewController {
    private var giveawayVM: GiveawayViewModelProtocol
    
    private var horizontalBoxView: HorizontalBoxView?
    
    private var isPaginating: Bool = false
    
    private var traySettingsHeight: CGFloat {
        return view.bounds.size.height * 0.75
    }
    
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
    
    private lazy var blackView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .black
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackViewTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var filterSheetView: GiveawayFilterSheetView = {
        let view: GiveawayFilterSheetView = GiveawayFilterSheetView()
        view.backgroundColor = .mainDarkBlue
        view.delegate = self
        return view
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
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainYellow]
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
        giveawayVM.onViewModelSetFilterSheet()
    }
    
    @objc private func blackViewTapped() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                self.blackView.alpha = 0.0
                self.filterSheetView.frame = CGRect(
                    x: 0,
                    y: UIHelper.screenSize.height,
                    width: UIHelper.screenSize.width,
                    height: self.traySettingsHeight
                )
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.blackView.removeFromSuperview()
                self.filterSheetView.removeFromSuperview()
            }
        )
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
        horizontalBoxView = HorizontalBoxView(frame: CGRect(x: 16.0, y: 0, width:view.bounds.width, height: 120))
        horizontalBoxView?.addBoxView(BoxView())
        horizontalBoxView?.addBoxView(BoxView())
        horizontalBoxView?.setupColor(backgroundColor: .mainYellow,
                                      titleTextColor: .mainDarkBlue,
                                      infoTextColor: .mainDarkBlue)
        
        if let worth: Worth = giveawayVM.onViewModelGetWorth() {
            horizontalBoxView?.addInfo(to: 0,
                                       title: "Active Giveaway Number",
                                       info: String(worth.activeGiveawaysNumber))
            horizontalBoxView?.addInfo(to: 1,
                                       title: "Worth Estimation in USD",
                                       info: worth.worthEstimationUSD)
        }
        
        return horizontalBoxView
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
        giveawayVM.onViewModelDidSelectItem(at: indexPath)
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
            self.horizontalBoxView?.addInfo(to: 0,
                                       title: "Active Giveaway Number",
                                       info: String(worth.activeGiveawaysNumber))
            self.horizontalBoxView?.addInfo(to: 1,
                                       title: "Worth Estimation in USD",
                                       info: worth.worthEstimationUSD)
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
    
    func setFilterSheetView(
        platformFilters: [Filter],
        typeFilters: [Filter],
        sortFilters: [Filter]
    ) {
        guard blackView.superview == nil else { return }
        blackView.frame = view.bounds
        
        UIHelper.keyWindow?.addSubview(blackView)
        
        filterSheetView.setFiltersData(
            platformFilters: platformFilters,
            typeFilters: typeFilters,
            sortFilters: sortFilters
        )
        filterSheetView.frame = CGRect(
            x: 0,
            y: UIHelper.screenSize.height,
            width: UIHelper.screenSize.width,
            height: traySettingsHeight
        )
        filterSheetView.roundCorners([.topLeft, .topRight], radius: 8.0)
        UIHelper.keyWindow?.addSubview(filterSheetView)
        
        blackView.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                self.blackView.alpha = 0.5
                self.filterSheetView.frame = CGRect(
                    x: 0,
                    y: UIHelper.screenSize.height - self.traySettingsHeight,
                    width: UIHelper.screenSize.width,
                    height: self.traySettingsHeight
                )
            },
            completion: nil
        )
    }
    
    func notifyNavigateToDetailPage(with viewModel: DetailViewModelProtocol) {
        let detailVC: DetailViewController = DetailViewController(viewModel: viewModel)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - GiveawayFilterSheetView Delegate

extension GiveawayViewController: GiveawayFilterSheetViewDelegate {
    func updateGiveawayForFilter(
        platformFilters: [Filter],
        typeFilters: [Filter],
        sortFilters: [Filter]
    ) {
        giveawayVM.onViewModelProcessFilter(
            platformFilters: platformFilters,
            typeFilters: typeFilters,
            sortFilters: sortFilters
        )
    }
    
    func dismissFilterSheetView() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                self.blackView.alpha = 0.0
                self.filterSheetView.frame = CGRect(
                    x: 0,
                    y: UIHelper.screenSize.height,
                    width: UIHelper.screenSize.width,
                    height: self.traySettingsHeight
                )
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.blackView.removeFromSuperview()
                self.filterSheetView.removeFromSuperview()
            }
        )
    }
    
}

// MARK: - ErrorView Delegate

extension GiveawayViewController: ErrorViewDelegate {
    func retryErrorButtonOnTapped() {
        giveawayVM.onViewModelReloadData()
    }
}
