//
//  NewListViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

final class AddMoneyViewController: BaseViewController {
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Your balance:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let moneyLabel: UILabel = {
        let label = UILabel()
        label.text = "$40"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let addMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "Add money:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private let addMoneyTextField: CurrencyTextField = {
        let textField = CurrencyTextField()
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.autocorrectionType = .no
        textField.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        let buttonColor = UIColor.systemBlue
        let buttonHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonHighlightedColor, for: .highlighted)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeTouchesOnView()
    }

    override func setupView() {
        super.setupView()
        configureNavigationBar()
        view.addSubview(balanceLabel)
        view.addSubview(moneyLabel)
        view.addSubview(addMoneyLabel)
        view.addSubview(addMoneyTextField)
        view.addSubview(addButton)
        
    }
    
    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        addMoneyLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        addMoneyTextField.snp.makeConstraints { make in
            make.top.equalTo(addMoneyLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(addMoneyTextField.snp.bottom).offset(20)
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
}


