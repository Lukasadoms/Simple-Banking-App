//
//  TransactionDetailViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation
import UIKit

class TransactionDetailViewController: BaseViewController {
    
    var transaction: TransactionResponse?
    
    private let transactionLabel: UILabel = {
        let label = UILabel()
        label.text = "Transaction Details:"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date: "
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let senderLabel: UILabel = {
        let label = UILabel()
        label.text = "Sender:"
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let receiverLabel: UILabel = {
        let label = UILabel()
        label.text = "Receiver:"
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Note:"
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount:"
        label.textColor = .systemGray2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let repeatButton: UIButton = {
        let button = UIButton()
        let buttonColor = UIColor.systemBlue
        let buttonHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("Repeat", for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonHighlightedColor, for: .highlighted)
        button.addTarget(self, action: #selector(repeatPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func setupView() {
        super.setupView()
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubview(transactionLabel)
        view.addSubview(dateLabel)
        view.addSubview(senderLabel)
        view.addSubview(receiverLabel)
        view.addSubview(noteLabel)
        view.addSubview(amountLabel)
        view.addSubview(repeatButton)
    }

    override func setupConstraints() {
        super.setupConstraints()
        
        transactionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(transactionLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }
        
        senderLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }

        receiverLabel.snp.makeConstraints { make in
            make.top.equalTo(senderLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(receiverLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(noteLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }
        
        repeatButton.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
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
    
    private func configureView() {
        guard let transaction = transaction else {
            showAlert(message: "error occured")
            return
        }
        let date = Date(timeIntervalSince1970: Double(transaction.createdOn))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC +3")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = dateFormatter.string(from: date)
        dateLabel.text = "Created on: \(strDate)"
        senderLabel.text = "Sender: \(transaction.senderId)"
        receiverLabel.text = "Receiver: \(transaction.receiverId)"
        noteLabel.text = "Note: \(transaction.reference)"
        amountLabel.text = "Amount: \(transaction.amount)"
    }
    
    @objc func repeatPressed() {
        
    }
}
