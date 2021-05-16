//
//  SettingViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/8/21.
//

import UIKit

final class SettingsViewController: BaseViewController {
    
    let apiManager = APIManager()
    var currentAccount: AccountResponse?
    
    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings:"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let currencyTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Currency"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.autocorrectionType = .no
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let phoneNumberTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Phone Number"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.autocorrectionType = .no
        textField.textColor = .black
        textField.keyboardType = .decimalPad
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let passwordTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Password"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.autocorrectionType = .no
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        let buttonColor = UIColor.systemBlue
        let buttonHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonHighlightedColor, for: .highlighted)
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter information you want to change"
        label.textColor = .systemGray3
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTextField.text = currentAccount?.currency
        observeKeyboardNotifications()
        observeTouchesOnView()
        createSeasonPickerView()
        dismissPickerView()
    }

    override func setupView() {
        super.setupView()
        view.backgroundColor = .white
        configureNavigationBar()
        view.addSubview(phoneNumberTextField)
        view.addSubview(passwordTextField)
        view.addSubview(currencyTextField)
        view.addSubview(informationLabel)
        view.addSubview(settingsLabel)
        view.addSubview(saveButton)
    }

    override func setupConstraints() {
        super.setupConstraints()
        
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }

        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.height.equalTo(50)
        }
        
        currencyTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(currencyTextField.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.height.equalTo(50)
        }
        
        informationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
            make.centerX.equalTo(view)
        }
    }
    
    override func keyboardWillAppear(_ keyboardHeight: CGFloat) {
        super.keyboardWillAppear(keyboardHeight)
        
        informationLabel.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin + keyboardHeight)
        }
        
        UIView.animate(withDuration: 1.5, animations: view.layoutIfNeeded)
    }
    
    override func keyboardWillDisappear() {
        super.keyboardWillDisappear()
        
        informationLabel.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
        }
        
        UIView.animate(withDuration: 1.5, animations: view.layoutIfNeeded)
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
    
    func createSeasonPickerView() {
        let currencyPickerView = UIPickerView()
        currencyPickerView.delegate = self
        currencyTextField.inputView = currencyPickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePressed))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        currencyTextField.inputAccessoryView = toolBar
    }
    
    @objc private func savePressed() {
        guard
            let currentAccount = currentAccount,
            let phoneNumber = phoneNumberTextField.text,
            !phoneNumber.isEmpty
        else { return }
        apiManager.checkIfAccountExists(phoneNumber: phoneNumber, {  [weak self] result in
            switch result {
            case .failure(let error):
                switch error {
                case .userDoesntExist:
                    continueAccountUpdate()
                default:
                    DispatchQueue.main.async {
                        self?.showAlert(message: error.errorDescription)
                    }
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(message: AccountManager.AccountManagerError.accountAlreadyExists.errorDescription)
                }
            }
        })
        func continueAccountUpdate() {
            apiManager.updateAccount(account: currentAccount, currency: currencyTextField.text, phoneNumber: phoneNumberTextField.text, amount: moneyTextField.value, { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(message: error.errorDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.showAlert(message:"updated current account information")
                    }
                }
            })
        }
        
        
    }
    
    @objc private func donePressed() {
        view.endEditing(true)
    }
}

extension SettingsViewController: UIDocumentPickerDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = currencyArray[row]
    }
}
