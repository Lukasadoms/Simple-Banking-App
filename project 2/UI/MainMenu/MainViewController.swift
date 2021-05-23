//
//  ViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    
    // MARK: - UI elements

    private let myTransactionsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Transactions"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let myBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance: 4.00"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    private let seeAllTransactionsButton: UIButton = {
        let button = UIButton()
        let buttonColor = UIColor.systemBlue
        let buttonHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("See all transactions", for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonHighlightedColor, for: .highlighted)
        button.addTarget(self, action: #selector(seeTransactionsPressed), for: .touchUpInside)
        return button
    }()
    
    private let iconView = UIImageView(image: #imageLiteral(resourceName: "codepayLogo"))

    private lazy var myTransactionsTableView: UITableView = {
        let tableView = SelfSizingTableView(frame: view.frame)
        tableView.backgroundColor = .systemGray6
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")

        tableView.layer.cornerRadius = 8
        tableView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        return tableView
    }()
    
    private let actionButtonView = ActionButtonView()
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeTouchesOnView()
        configureNavigationBar()
        updateAccountInfo()
        updateUI()
    }
    
    // MARK: - UI Constraints Setup
    
    override func setupView() {
        super.setupView()
        
        actionButtonView.actionsDelegate = self
        configureNavigationBar()
        configureScrollView()
        
        view.backgroundColor = .white
                
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(iconView)
        scrollView.addSubview(seeAllTransactionsButton)
        contentView.addSubview(myBalanceLabel)
        contentView.addSubview(myTransactionsLabel)
        scrollView.addSubview(myTransactionsTableView)

        view.addSubview(actionButtonView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.top.equalTo(contentView)
        }
        
        myBalanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(iconView.snp.bottom).offset(EdgeMargin)
        }
        
        myTransactionsLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(myBalanceLabel.snp.bottom).offset(EdgeMargin)
        }
        
        myTransactionsTableView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(myTransactionsLabel.snp.bottom).offset(EdgeMargin)
            make.bottom.equalTo(contentView).inset(EdgeMargin)
        }
        
        actionButtonView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        seeAllTransactionsButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(contentView.snp.bottom).offset(EdgeMargin)
            make.height.equalTo(40)
        }
    }
}

// MARK: - View configuration

private extension MainViewController {

    func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        let img = UIImage(systemName: "gear")!
        let imgWidth = img.size.width
        let imgHeight = img.size.height
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight))
        button.setBackgroundImage(img, for: .normal)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func configureScrollView() {
        scrollView.delegate = self
        scrollView.contentInset.bottom = 64
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func updateUI() {
        guard let account = accountManager.currentAccount else { return }
        myBalanceLabel.text = "Balance: \(account.balance) \(account.currency)"
        myTransactionsTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource methods

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let transactions = transactionManager.getTransactionsFromDataBase() else { return 0 }
        if transactions.count > 5 {
            return 5
        } else {
            return transactions.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        guard
            let currentAccount = accountManager.currentAccount,
            let transactionCell = cell as? TransactionCell,
            let accountTransactions = transactionManager.getTransactionsFromDataBase()
        else { return cell }
        
        let sortedTransactions = accountTransactions.sorted { $0.createdOn > $1.createdOn }
        let transaction = sortedTransactions[indexPath.row]
        transactionCell.setupCell(
            account: currentAccount,
            senderPhoneNumber: transaction.senderId!,
            receiverPhoneNumber: transaction.receiverId!,
            amount: transaction.amount!.stringValue
        )
        return transactionCell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sortedTransactions = transactionManager.getTransactionsFromDataBase()?.sorted(by: { $0.createdOn > $1.createdOn }) else { return }
        let transaction = sortedTransactions[indexPath.row]
        
        let transactionDetailViewController = TransactionDetailViewController()
        let navigationController = UINavigationController(rootViewController: transactionDetailViewController)
        
        transactionDetailViewController.transaction = transaction
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - ActionToolbar Methods

extension MainViewController: ActionsButtonViewDelegate {
    func actionsButtonViewAddMoneyPressed() {
        let addMoneyViewController = AddMoneyViewController()
        addMoneyViewController.delegate = self
        addMoneyViewController.accountManager = accountManager
        let navigationController = UINavigationController(rootViewController: addMoneyViewController)
        present(navigationController, animated: true, completion: nil)
    }

    func actionsButtonViewSendMoneyPressed() {
        let sendMoneyViewController = SendMoneyViewController()
        sendMoneyViewController.delegate = self
        sendMoneyViewController.accountManager = accountManager
        let navigationController = UINavigationController(rootViewController: sendMoneyViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - API Calls

extension MainViewController {
    func updateAccountInfo() {
        guard let currentAccount = accountManager.currentAccount else { return }
        apiManager.checkIfAccountExists(phoneNumber: currentAccount.phoneNumber, { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: error.errorDescription)
                }
            case .success(let account):
                DispatchQueue.main.async {
                    self?.accountManager.currentAccount = account
                    self?.updateUI()
                }
            }
        })
        apiManager.getAccountTransactions(phoneNumber: currentAccount.phoneNumber, { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: error.errorDescription)
                }
            case .success(let transactions):
                DispatchQueue.main.async {
                    do {
                        try self?.transactionManager.saveTransactionsToDataBase(transactions: transactions)
                    }
                    catch {
                        self?.showAlert(message: "error saving to database, please try again")
                    }
                    self?.updateUI()
                }
            }
        })
    }
}

// MARK: - Helpers

extension MainViewController {
    @objc func settingsButtonPressed() {
        let settingsViewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func seeTransactionsPressed() {
        let transactionsViewController = TransactionsViewController()
        transactionsViewController.accountManager.currentAccount = accountManager.currentAccount
        transactionsViewController.transactions = transactionManager.getTransactionsFromDataBase()!
        let navigationController = UINavigationController(rootViewController: transactionsViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - BalanceChangeDelegate methods

extension MainViewController: BalanceChangeDelegate {
    func balanceHasChanged() {
       updateAccountInfo()
    }
}


