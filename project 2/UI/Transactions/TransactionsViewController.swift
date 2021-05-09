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

    private let contentView = UIView()
    
    let searchController = UISearchController(searchResultsController: nil)

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
    
    override func setupView() {
        super.setupView()
        
//        applyTheming()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelPressed)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(donePressed)
        )
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func donePressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
      if isFiltering {
        return filteredTransactions.count
      }
        
      return transactions.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let transaction: Transaction
        if isFiltering {
            transaction = filteredTransactions[indexPath.row]
        } else {
            transaction = transactions[indexPath.row]
        }
        
        guard let transactionCell = cell as? TransactionCell else {
            return cell
        }
        transactionCell.configureCell(phoneNumber: transaction.receiverId!, amount: transaction.amount!)
        return transactionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let transaction: Transaction
        if isFiltering {
          transaction = filteredTransactions[indexPath.row]
        } else {
          transaction = transactions[indexPath.row]
        }
        let transactionDetailViewController = TransactionDetailViewController()
        let navigationController = UINavigationController(rootViewController: transactionDetailViewController)
        
        transactionDetailViewController.transaction = transaction
        present(navigationController, animated: true, completion: nil)
    }
}

extension TransactionsViewController: UISearchResultsUpdating {
    
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

extension TransactionsViewController {
    
    func filterContentForSearchText(_ searchText: String) {
      //TODO
      
      myTransactionsTableView.reloadData()
    }
}

