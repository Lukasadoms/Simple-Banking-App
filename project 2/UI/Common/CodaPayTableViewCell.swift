//
//  CodaPayTableViewCell.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/8/21.
//

import UIKit

class CodePayTableViewCell: UITableViewCell {
    
    enum CellType {
        case phoneField
        case moneyAmountField
        case passwordField
        case currencyPicker
    }
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Configuration

    let makeTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        return textField
    }()

    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = text
        return label
    }
    
    func setupCell(type: CellType) {
        backgroundColor = .white
        contentView.backgroundColor = .systemGray6
        contentView.layer.masksToBounds = true
        selectionStyle = .none
        
        switch type {
        case .currencyPicker:
            setupTextPickerCell(type: type)
        case .moneyAmountField, .passwordField, .phoneField:
            setupTextFieldCell(type: type)
        }
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
        case .passwordField:
            primaryLabel = makeLabel(text: "Password:")
            placeholder = "*****"
        default:
            break
        }
        
        contentView.addSubview(primaryLabel)
        contentView.addSubview(textField)
        
        primaryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
        }
        
        primaryLabel.setContentCompressionResistancePriority(.defaultLow , for: .horizontal)
        
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(primaryLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10) // textfieldas nesiplecia
        }
        textField.placeholder = placeholder
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal) // neveikia
    }
    
    func setupTextPickerCell(type: CellType) {
        
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

