//
//  NewListViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

final class AddMoneyViewController: BaseViewController {
    
    var account: AccountResponse?
    let apiManager = APIManager()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Your balance:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let moneyLabel: UILabel = {
        let label = UILabel()
        label.text = "40"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let addMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "Add money:"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        let buttonColor = UIColor.systemBlue
        let buttonHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonHighlightedColor, for: .highlighted)
        button.addTarget(self, action: #selector(addMoneyPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        observeTouchesOnView()
    }

    override func setupView() {
        super.setupView()
        configureNavigationBar()
        view.addSubview(balanceLabel)
        view.addSubview(moneyLabel)
        view.addSubview(addMoneyLabel)
        view.addSubview(moneyTextField)
        view.addSubview(addButton)
    }
    
    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
        }
        
        addMoneyLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }

        moneyTextField.snp.makeConstraints { make in
            make.top.equalTo(addMoneyLabel.snp.bottom).offset(EdgeMargin)
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(moneyTextField.snp.bottom).offset(EdgeMargin)
            make.centerX.equalTo(view)
        }
    }
}

extension AddMoneyViewController {
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
            action: #selector(cancelPressed)
        )
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func addMoneyPressed() {
        guard let account = account else { return }
        apiManager.sendMoneyToAccount(account: account, amount: moneyTextField.value, { [weak self] result in
            switch result {
            case .success:
                self?.showAlert(message: "Account Balance updated")
                self?.updateUI()
            case .failure(let error):
                self?.showAlert(message: error.errorDescription)
            }
        })
    }
    
    func updateUI() {
        guard let account = account else { return }
        moneyLabel.text = "\(account.balance)"
    }
}


