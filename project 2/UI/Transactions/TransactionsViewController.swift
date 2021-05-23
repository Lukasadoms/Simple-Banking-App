//
//  TransactionsViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/8/21.
//

import UIKit
import SnapKit

class TransactionsViewController: BaseViewController {
    
    var transactions: [Transaction] = []
    var filteredTransactions: [Transaction] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - UI Elements

    private let myTransactionsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Transactions"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var myTransactionsTableView: UITableView = {
        let tableView = SelfSizingTableView(frame: view.frame)
        tableView.backgroundColor = .systemGray6
        tableView.dataSource = self
        tableView.delegate = self
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Transactions"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }
    
    // MARK: - UI Setup
    
    override func setupView() {
        super.setupView()
        
        configureNavigationBar()
        view.backgroundColor = .white
        view.addSubview(myTransactionsLabel)
        view.addSubview(myTransactionsTableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        myTransactionsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }
        
        myTransactionsTableView.snp.makeConstraints { make in
            make.top.equalTo(myTransactionsLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backPressed)
        )
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

// MARK: - TableView methods

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTransactions.count
        }
        
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let transaction: Transaction
        
        if isFiltering {
            let sortedTransactions = filteredTransactions.sorted { $0.createdOn > $1.createdOn }
            transaction = sortedTransactions[indexPath.row]
        } else {
            let sortedTransactions = transactions.sorted { $0.createdOn > $1.createdOn }
            transaction = sortedTransactions[indexPath.row]
        }
        
        guard
            let transactionCell = cell as? TransactionCell,
            let account = accountManager.currentAccount
            else {
            return cell
        }
        transactionCell.setupCell(account: account, senderPhoneNumber: transaction.senderId!, receiverPhoneNumber: transaction.receiverId!, amount: transaction.amount!.stringValue)
        return transactionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let transaction: Transaction
        if isFiltering {
            let sortedTransactions = filteredTransactions.sorted { $0.createdOn > $1.createdOn }
            transaction = sortedTransactions[indexPath.row]
        } else {
            let sortedTransactions = transactions.sorted { $0.createdOn > $1.createdOn }
            transaction = sortedTransactions[indexPath.row]
        }
        let transactionDetailViewController = TransactionDetailViewController()
        let navigationController = UINavigationController(rootViewController: transactionDetailViewController)
        
        transactionDetailViewController.transaction = transaction
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - UISearchBar methods

extension TransactionsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension TransactionsViewController {
    
    func filterContentForSearchText(_ searchText: String) {
        filteredTransactions = transactions.filter { (transaction: Transaction) -> Bool in
            return  transaction.receiverId!.contains(searchText) || transaction.reference!.lowercased().contains(searchText.lowercased())
        }
        myTransactionsTableView.reloadData()
    }
}

