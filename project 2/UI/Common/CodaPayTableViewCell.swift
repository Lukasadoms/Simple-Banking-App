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
    
    private let currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let moneyTextField: CurrencyTextField = {
        let textField = CurrencyTextField()
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.autocorrectionType = .no
        textField.font = UIFont.boldSystemFont(ofSize: 20)
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
            setupTextPickerCell()
        case .moneyAmountField:
            setupMoneyAmountCell()
        case .passwordField, .phoneField:
            setupTextFieldCell(type: type)
        }
    }

    func setupTextFieldCell(type: CellType) {

        var primaryLabel = UILabel()
        var placeholder = String()
        
        switch type {
        case .phoneField:
            primaryLabel = makeLabel(text: "Phone number:")
            placeholder = "+370..."
        case .passwordField:
            primaryLabel = makeLabel(text: "Password:")
            placeholder = "*****"
        default:
            break
        }
        let textField = makeTextField
        contentView.addSubview(primaryLabel)
        contentView.addSubview(textField)
        
        primaryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
        }
        
        //primaryLabel.setContentCompressionResistancePriority(.defaultLow , for: .horizontal)
        
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(primaryLabel.snp.trailing).offset(10)
            //make.trailing.equalTo(contentView.snp.trailing).inset(10) // textfieldas nesiplecia
        }
        textField.placeholder = placeholder
        //textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal) // neveikia
    }
    
    func setupTextPickerCell() {
        let primaryLabel = makeLabel(text: "Currency:")
        currencyPicker.delegate = self as UIPickerViewDelegate
        currencyPicker.dataSource = self as UIPickerViewDataSource
        contentView.addSubview(primaryLabel)
        contentView.addSubview(currencyPicker)
        
        primaryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
        }
        
        currencyPicker.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(primaryLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
        }
    }
    
    func setupMoneyAmountCell() {
        let primaryLabel = makeLabel(text: "Amount:")
        
        contentView.addSubview(primaryLabel)
        contentView.addSubview(moneyTextField)
        
        primaryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
        }
        
        moneyTextField.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(primaryLabel.snp.trailing).offset(10)
        }
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

extension CodePayTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let currencyArray = ["EUR", "USD"]
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currencyArray = ["EUR", "USD"]
        return currencyArray[row]
    } // ar galima visa sita padaryti global ?
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

