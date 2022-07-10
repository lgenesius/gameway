//
//  GiveawayFilterSheetView.swift
//  Gameway
//
//  Created by Luis Genesius on 14/05/22.
//

import UIKit

private let standardPaddingConstant: CGFloat = 16.0
private let confirmationHeightConstant: CGFloat = 40.0

enum Choice {
    case none
    case platform
    case type
    case sort
}

protocol GiveawayFilterSheetViewDelegate {
    func updateGiveawayForFilter(
        platformFilters: [Filter],
        typeFilters: [Filter],
        sortFilters: [Filter]
    )
    func dismissFilterSheetView()
}

final class GiveawayFilterSheetView: UIView {
    var delegate: GiveawayFilterSheetViewDelegate?
    
    private var platformFilters: [Filter] = []
    private var typeFilters: [Filter] = []
    private var sortFilters: [Filter] = []
    
    private var choice: Choice = .none
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Filter"
        label.textColor = .mainYellow
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmationButton: PrimaryButton = {
        let button: PrimaryButton = PrimaryButton()
        button.setTitle("Confirm", for: .normal)
        button.addTarget(
            self,
            action: #selector(confirmationButtonTapped(_:)),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(
            self,
            action: #selector(cancelButtonTapped(_:)),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var platformChoiceView: ChoiceView = {
        let view: ChoiceView = ChoiceView()
        view.setTitleText("Platform")
        view.setButtonText("None")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var typeChoiceView: ChoiceView = {
        let view: ChoiceView = ChoiceView()
        view.setTitleText("Type")
        view.setButtonText("None")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sortChoiceView: ChoiceView = {
        let view: ChoiceView = ChoiceView()
        view.setTitleText("Sort By")
        view.setButtonText("None")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var choiceViewRect: CGRect {
        switch choice {
        case .none:
            return .zero
        case .platform:
            return platformChoiceView.frame
        case .type:
            return typeChoiceView.frame
        case .sort:
            return sortChoiceView.frame
        }
    }
    
    private lazy var choiceTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 8.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChoiceTableViewCell.self, forCellReuseIdentifier: ChoiceTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var choiceTransparentView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choiceTransparentViewTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFiltersData(
        platformFilters: [Filter],
        typeFilters: [Filter],
        sortFilters: [Filter]
    ) {
        self.platformFilters = platformFilters
        self.typeFilters = typeFilters
        self.sortFilters = sortFilters
        
        updateChoiceViewButtonText(platformChoiceView)
        updateChoiceViewButtonText(typeChoiceView)
        updateChoiceViewButtonText(sortChoiceView)
    }

    private func setupView() {
        addSubview(titleLabel)
        addSubview(cancelButton)
        addSubview(platformChoiceView)
        addSubview(typeChoiceView)
        addSubview(sortChoiceView)
        addSubview(confirmationButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: standardPaddingConstant),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: standardPaddingConstant),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardPaddingConstant),
            
            platformChoiceView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardPaddingConstant * 2),
            platformChoiceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardPaddingConstant),
            platformChoiceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardPaddingConstant),
            
            typeChoiceView.topAnchor.constraint(equalTo: platformChoiceView.bottomAnchor, constant: standardPaddingConstant),
            typeChoiceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardPaddingConstant),
            typeChoiceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardPaddingConstant),
            
            sortChoiceView.topAnchor.constraint(equalTo: typeChoiceView.bottomAnchor, constant: standardPaddingConstant),
            sortChoiceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardPaddingConstant),
            sortChoiceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardPaddingConstant),
            
            confirmationButton.heightAnchor.constraint(equalToConstant: confirmationHeightConstant),
            confirmationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardPaddingConstant),
            confirmationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(UIHelper.keyWindow?.safeAreaInsets.bottom ?? 0.0)),
            confirmationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardPaddingConstant),
        ])
    }
    
    private func setMultipleChoice() {
        UIView.animate(withDuration: 0) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.choiceTableView.reloadData()
            }
        } completion: { [weak self] _ in
            self?.setChoiceTransparentView()
            self?.setChoiceTableView()
        }
    }
    
    private func setChoiceTransparentView() {
        guard choiceTransparentView.superview == nil,
              let keyWindow: UIWindow = UIHelper.keyWindow else { return }
        choiceTransparentView.frame = keyWindow.bounds
        keyWindow.addSubview(choiceTransparentView)
    }
    
    private func setChoiceTableView() {
        
        choiceTableView.frame = CGRect(
            x: self.choiceViewRect.origin.x,
            y: self.choiceViewRect.origin.y + self.frame.origin.y + self.choiceViewRect.size.height + 8.0,
            width: self.choiceViewRect.size.width,
            height: 0
        )
        UIHelper.keyWindow?.addSubview(choiceTableView)
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.3,
            options: .curveLinear,
            animations: { [weak self] in
                guard let self = self else { return }
                
                self.choiceTableView.frame = CGRect(
                    x: self.choiceViewRect.origin.x,
                    y: self.choiceViewRect.origin.y + self.frame.origin.y + self.choiceViewRect.size.height + standardPaddingConstant / 2,
                    width: self.choiceViewRect.size.width,
                    height: self.getTotalHeightForChoice(self.choice)
                )
            },
            completion: nil
        )
    }
    
    private func getTotalHeightForChoice(_ choice: Choice) -> CGFloat {
        let totalOrigin: CGFloat = choiceViewRect.origin.y + frame.origin.y + choiceViewRect.height + standardPaddingConstant / 2
        
        switch choice {
        case .none:
            return .zero
        case .platform:
            return UIHelper.screenSize.height - totalOrigin - (UIHelper.keyWindow?.safeAreaInsets.bottom ?? 0.0)
        case .type:
            return choiceTableView.contentSize.height
        case .sort:
            return choiceTableView.contentSize.height
        }
    }
    
    private func updateChoiceViewButtonText(_ choiceView: ChoiceView) {
        var count: Int = 0
        switch choiceView {
        case platformChoiceView:
            count = platformFilters.reduce(0, { result, filter in
                if filter.isSelected {
                    return result + 1
                }
                return result
            })
        case typeChoiceView:
            count = typeFilters.reduce(0, { result, filter in
                if filter.isSelected {
                    return result + 1
                }
                return result
            })
        case sortChoiceView:
            count = sortFilters.reduce(0, { result, filter in
                if filter.isSelected {
                    return result + 1
                }
                return result
            })
        default:
            return
        }
        
        choiceView.selectedNumber = count
    }
}

// MARK: - Tap Function

extension GiveawayFilterSheetView {
    @objc private func confirmationButtonTapped(_ button: UIButton) {
        delegate?.updateGiveawayForFilter(
            platformFilters: platformFilters,
            typeFilters: typeFilters,
            sortFilters: sortFilters
        )
        delegate?.dismissFilterSheetView()
    }
    
    @objc private func cancelButtonTapped(_ button: UIButton) {
        delegate?.dismissFilterSheetView()
    }
    
    @objc private func choiceTransparentViewTapped() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.3,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                self.choiceTableView.frame = CGRect(
                    x: self.choiceViewRect.origin.x,
                    y: self.choiceViewRect.origin.y + self.frame.origin.y + self.choiceViewRect.size.height + standardPaddingConstant / 2,
                    width: self.choiceViewRect.size.width,
                    height: 0
                )
            },
            completion: { [weak self] _ in
                self?.choiceTransparentView.removeFromSuperview()
                self?.choiceTableView.removeFromSuperview()
            }
        )
    }
}

// MARK: - ChoiceView Delegate

extension GiveawayFilterSheetView: ChoiceViewDelegate {
    func notifyChoiceButtonTapped(_ view: ChoiceView) {
        switch view {
        case platformChoiceView:
            choice = .platform
        case typeChoiceView:
            choice = .type
        case sortChoiceView:
            choice = .sort
        default:
            break
        }
        
        setMultipleChoice()
    }
}

// MARK: - UITableView Delegate

extension GiveawayFilterSheetView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choiceTableView.deselectRow(at: indexPath, animated: false)
        if let cell: UITableViewCell = choiceTableView.cellForRow(at: indexPath) {
            switch choice {
            case .platform:
                platformFiltersSelectionProcessing(with: indexPath, and: cell)
            case .type:
                typeFiltersSelectionProcessing(with: indexPath, and: cell)
            case .sort:
                sortFiltersSelectionProcessing(with: indexPath, and: cell)
            default:
                break
            }
        }
    }
    
    private func platformFiltersSelectionProcessing(with indexPath: IndexPath,
                                                    and cell: UITableViewCell) {
        platformFilters[indexPath.row].isSelected = !platformFilters[indexPath.row].isSelected
        if platformFilters[indexPath.row].isSelected {
            cell.accessoryType = .checkmark
            platformChoiceView.selectedNumber += 1
        } else {
            cell.accessoryType = .none
            platformChoiceView.selectedNumber -= 1
        }
    }
    
    private func typeFiltersSelectionProcessing(with indexPath: IndexPath,
                                                    and cell: UITableViewCell) {
        typeFilters[indexPath.row].isSelected = !typeFilters[indexPath.row].isSelected
        if typeFilters[indexPath.row].isSelected {
            cell.accessoryType = .checkmark
            typeChoiceView.selectedNumber += 1
        } else {
            cell.accessoryType = .none
            typeChoiceView.selectedNumber -= 1
        }
    }
    
    private func sortFiltersSelectionProcessing(with indexPath: IndexPath,
                                                and cell: UITableViewCell) {
        //reset all selected only for sort filters
        for (index, filter) in sortFilters.enumerated() {
            guard index != indexPath.row,
                  filter.isSelected
            else {
                continue
            }
            
            sortFilters[index].isSelected = false
            sortChoiceView.selectedNumber -= 1
            if let targetCell: UITableViewCell = choiceTableView.cellForRow(at: IndexPath(row: index, section: 0)) {
                targetCell.accessoryType = .none
            }
        }
        
        sortFilters[indexPath.row].isSelected = !sortFilters[indexPath.row].isSelected
        if sortFilters[indexPath.row].isSelected {
            cell.accessoryType = .checkmark
            sortChoiceView.selectedNumber += 1
        } else {
            cell.accessoryType = .none
            sortChoiceView.selectedNumber -= 1
        }
    }
}

// MARK: - UITableView DataSource

extension GiveawayFilterSheetView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch choice {
        case .none:
            return 0
        case .platform:
            return platformFilters.count
        case .type:
            return typeFilters.count
        case .sort:
            return sortFilters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.selectionStyle = .none
        var config = cell.defaultContentConfiguration()
        
        config.text = ""
        cell.accessoryType = .none
        switch choice {
        case .none:
            config.text = ""
        case .platform:
            config.text = platformFilters[indexPath.row].name
            if platformFilters[indexPath.row].isSelected {
                cell.accessoryType = .checkmark
            }
        case .type:
            config.text = typeFilters[indexPath.row].name
            if typeFilters[indexPath.row].isSelected {
                cell.accessoryType = .checkmark
            }
        case .sort:
            config.text = sortFilters[indexPath.row].name
            if sortFilters[indexPath.row].isSelected {
                cell.accessoryType = .checkmark
            }
        }
        
        config.textProperties.colorTransformer = UIConfigurationColorTransformer { [weak cell] (color) in
            if let state = cell?.configurationState {
                if state.isSelected || state.isHighlighted {
                    return .white
                }
            }
            return .black
        }
        cell.contentConfiguration = config
        cell.backgroundColor = .white
        return cell
    }
    
    
}

protocol ChoiceViewDelegate {
    func notifyChoiceButtonTapped(_ view: ChoiceView)
}

final class ChoiceView: UIView {
    var delegate: ChoiceViewDelegate?
    
    var selectedNumber: Int {
        didSet {
            setButtonText(selectedNumber == 0 ? "None" : "\(selectedNumber) Selected")
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var choiceButton: UIButton = {
        let button: UIButton = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(choiceButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        selectedNumber = 0
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(choiceButton)
        
        addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
            
            choiceButton.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            choiceButton.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor)
        ])
    }
    
    @objc private func choiceButtonTapped(_ button: UIButton) {
        delegate?.notifyChoiceButtonTapped(self)
    }
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    func setButtonText(_ text: String) {
        choiceButton.setTitle(text, for: .normal)
    }
}
