//
//  MyListsCell.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

final class TransactionCell: CodePayTableViewCell {

    private let RoundedEdgesRadius: CGFloat = 15

    // MARK: - UI elements

    private lazy var iconContainerView = UIView()
    private lazy var iconView = UIImageView()
    private var transactionPhoneNumberLabel = UILabel()
    private var amountLabel = UILabel()
    
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Configuration

    func setupCell(account: AccountResponse, phoneNumber: String, amount: Double) {
        transactionPhoneNumberLabel.text = "+\(phoneNumber)"
        
        if account.phoneNumber == phoneNumber {
            amountLabel.text = "+\(amount)"
        }
        else {
            amountLabel.text = "-\(amount)"
        }
        
        amountLabel.textColor = .systemGray3
    }
    
    func configureCell() {
        iconView = UIImageView(image: #imageLiteral(resourceName: "codepayLogo"))

        iconContainerView.layer.cornerRadius = RoundedEdgesRadius
        iconContainerView.clipsToBounds = true
        iconContainerView.backgroundColor = .systemBlue

        iconContainerView.addSubview(iconView)
        contentView.addSubview(iconContainerView)
        contentView.addSubview(transactionPhoneNumberLabel)
        contentView.addSubview(amountLabel)

        accessoryType = .disclosureIndicator
        selectionStyle = .none
        setupConstraints()
    }

    private func setupConstraints() {
        iconContainerView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.height.width.equalTo(30)
            make.centerY.equalTo(contentView)
        }

        iconView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(iconContainerView)
            make.width.height.equalTo(20)
        }

        transactionPhoneNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView.snp.trailing).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).inset(10)
        }
        
        transactionPhoneNumberLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        amountLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(transactionPhoneNumberLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.centerY.equalTo(contentView)
        }
        
        amountLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
}
