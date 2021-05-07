//
//  SendMoneyCell.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/7/21.
//

import UIKit
import SnapKit

final class SendMoneyCell: UITableViewCell {

    enum CellType {
        case phoneField
        case moneyAmountField
        case details
        case list
    }

    private let newTransactionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount:"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        return textField
    }()

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = text
        return label
    }

    private let arrowIconView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    func setupCell(type: CellType) {
        
        setupTextFieldCell(type: type)
        
        backgroundColor = .white
        contentView.backgroundColor = .systemGray6
        contentView.layer.masksToBounds = true
        selectionStyle = .none
    }

    func setupTextFieldCell(type: CellType) {
        
        let primaryLabel: UILabel
        let placeholder: String
        
        switch type {
        case .phoneField:
            primaryLabel = makeLabel(text: "Phone number:")
            placeholder = "+370..."
        case .moneyAmountField:
            primaryLabel = makeLabel(text: "Amount:")
            placeholder = "$/€"
        default:
            fatalError("Unexpected type")
        }
        
        contentView.addSubview(primaryLabel)
        contentView.addSubview(newTransactionTextField)
        
        primaryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
        }
        
        primaryLabel.setContentCompressionResistancePriority(.defaultLow , for: .horizontal)
        
        newTransactionTextField.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(primaryLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10) // textfieldas nesiplecia
        }
        newTransactionTextField.placeholder = placeholder
        newTransactionTextField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    func roundAllCorners() {
        contentView.layer.cornerRadius = 8
        contentView.layer.maskedCorners = [
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
    }
}
