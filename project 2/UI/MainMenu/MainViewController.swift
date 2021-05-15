//
//  ViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    
    private var accountTransactions: [TransactionResponse]? = []
    private let apiManager = APIManager()
    var account: AccountResponse?

    // MARK: - UI elements

    private let myTransactionsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Transactions"
        label.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    init() {
        super.init(nibName: nil, bundle: nil) // Ar čia viskas gerai ?
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTouchesOnView()
        configureNavigationBar()
        getAccountTransactions()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func setupView() {
        super.setupView()
        
        actionButtonView.actionsDelegate = self
        
        applyTheming()
        configureNavigationBar()
        configureScrollView()
                
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(iconView)
        scrollView.addSubview(seeAllTransactionsButton)
        contentView.addSubview(myBalanceLabel)
        contentView.addSubview(myTransactionsLabel)
        contentView.addSubview(myTransactionsTableView)

        contentView.addSubview(actionButtonView)
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
            make.top.equalTo(actionButtonView.snp.bottom).offset(EdgeMargin)
        }
        
        myTransactionsTableView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(myTransactionsLabel.snp.bottom).offset(EdgeMargin)
            make.bottom.equalTo(contentView).inset(EdgeMargin)
        }
        
        actionButtonView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(myBalanceLabel.snp.bottom).offset(EdgeMargin)
            make.height.equalTo(80)
        }
        
        seeAllTransactionsButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(contentView.snp.bottom).offset(EdgeMargin)
            make.height.equalTo(80)
        }
    }
}

// MARK: - View configuration

private extension MainViewController {

    func applyTheming() {
        view.backgroundColor = .white
    }

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
        guard let account = account else { return }
        myBalanceLabel.text = "Balance: \(account.balance)"
        myTransactionsTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource methods

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let transactions = accountTransactions else { return 0 }
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        guard let transactionCell = cell as? TransactionCell else { return cell }
        guard let transaction = accountTransactions?[indexPath.row] else { return cell }
        transactionCell.configureCell(phoneNumber: transaction.receiverId , amount: transaction.amount )
        return transactionCell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let transaction = accountTransactions?[indexPath.row] else { return }
        
        let transactionDetailViewController = TransactionDetailViewController()
        let navigationController = UINavigationController(rootViewController: transactionDetailViewController)
        
        transactionDetailViewController.transaction = transaction
        present(navigationController, animated: true, completion: nil)
    }
}

extension MainViewController: ActionsButtonViewDelegate {
    func actionsButtonViewAddMoneyPressed() {
        let addMoneyViewController = AddMoneyViewController()
        addMoneyViewController.account = account
        let navigationController = UINavigationController(rootViewController: addMoneyViewController)
        present(navigationController, animated: true, completion: nil)
    }

    func actionsButtonViewSendMoneyPressed() {
        let sendMoneyViewController = SendMoneyViewController()
        sendMoneyViewController.account = account
        let navigationController = UINavigationController(rootViewController: sendMoneyViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - API Calls

extension MainViewController {
    func getAccountTransactions() {
        guard let account = account else { return }
        apiManager.getAccountTransactions(phoneNumber: account.phoneNumber, { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: error.errorDescription)
                }
            case .success(let transactions):
                DispatchQueue.main.async {
                    self?.accountTransactions = transactions
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
        guard let accountTransactions = accountTransactions else { return }
        transactionsViewController.transactions = accountTransactions
        let navigationController = UINavigationController(rootViewController: transactionsViewController)
        present(navigationController, animated: true, completion: nil)
    }
}


