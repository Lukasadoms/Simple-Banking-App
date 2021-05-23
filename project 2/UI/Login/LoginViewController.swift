//
//  LoginViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/6/21.
//

import UIKit
import SnapKit

final class LoginViewController: BaseViewController {

    let userManager = UserManager()
    
    private let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "currency:"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.isHidden = true
        return picker
    }()
    
    private let loginSegmentedControl: UISegmentedControl = {
        let loginModes = ["Login", "Register"]
        let loginSegmentedControl = UISegmentedControl(items: loginModes)
        loginSegmentedControl.selectedSegmentIndex = 0
        loginSegmentedControl.addTarget(self, action: #selector(changeLoginMode), for: .valueChanged)
        return loginSegmentedControl
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
    
    private let passwordReenterTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Re-enter Password"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.autocorrectionType = .no
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.isHidden = true
        textField.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        let buttonColor = UIColor.systemBlue
        let buttonHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonHighlightedColor, for: .highlighted)
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private let contentView = UIView()
    private let phoneNumberView = UIView()
    private let iconView = UIImageView(image: #imageLiteral(resourceName: "codepayLogo"))
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        checkIfUserIsLoggedIn()
        observeTouchesOnView()
        currencyPicker.delegate = self as UIPickerViewDelegate
        currencyPicker.dataSource = self as UIPickerViewDataSource
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func setupView() {
        super.setupView()
        
        phoneNumberView.backgroundColor = .systemGray6
        phoneNumberView.layer.cornerRadius = 8
        
        view.addSubview(contentView)
        contentView.addSubview(iconView)
        contentView.addSubview(loginSegmentedControl)
        contentView.addSubview(stackView)
        phoneNumberView.addSubview(phoneNumberTextField)
        phoneNumberView.addSubview(plusLabel)
        stackView.addArrangedSubview(phoneNumberView)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordReenterTextField)
        stackView.addArrangedSubview(currencyPicker)
        stackView.addArrangedSubview(loginButton)
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        plusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(phoneNumberView)
            make.leading.equalTo(phoneNumberView).offset(5)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.centerY.equalTo(plusLabel)
            make.leading.equalTo(plusLabel.snp.trailing).offset(EdgeMargin/4)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.height.equalTo(150)
            make.width.equalTo(150)
            make.top.equalTo(contentView).offset(EdgeMargin)
        }
        
        loginSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.height.equalTo(40)
            
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(loginSegmentedControl.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
        }
        
        phoneNumberView.snp.makeConstraints { make in
            make.leading.equalTo(stackView)
            make.trailing.equalTo(stackView)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(stackView)
            make.trailing.equalTo(stackView)
            make.height.equalTo(50)
        }
        
        passwordReenterTextField.snp.makeConstraints { make in
            make.leading.equalTo(stackView)
            make.trailing.equalTo(stackView)
            make.height.equalTo(50)
        }
        
        currencyPicker.snp.makeConstraints { make in
            make.leading.equalTo(stackView)
            make.trailing.equalTo(stackView)
            make.height.equalTo(80)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc func changeLoginMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            passwordReenterTextField.isHidden = true
            currencyPicker.isHidden = true
            loginButton.setTitle("Login", for: .normal)
            UIView.animate(withDuration: 0.5, animations: view.layoutIfNeeded)
        case 1:
            passwordReenterTextField.isHidden = false
            currencyPicker.isHidden = false
            loginButton.setTitle("Register", for: .normal)
            UIView.animate(withDuration: 0.5, animations: view.layoutIfNeeded)
        default:
            break
        }
    }
    
    @objc func loginPressed() {
        switch loginSegmentedControl.selectedSegmentIndex{
        case 0:
            guard
                let phoneNumber = phoneNumberTextField.text,
                let password = passwordTextField.text,
                !phoneNumber.isEmpty,
                !password.isEmpty
            else {
                showAlert(message: AccountManager.AccountManagerError.missingValues.errorDescription)
                return
            }
            loginUser(phoneNumber: phoneNumber, password: password)
            //proceedToMainView(account: AccountResponse(id: "99", phoneNumber: "+99", currency: "EUR", balance: 199.99))
        case 1:
            guard
                let phoneNumber = phoneNumberTextField.text,
                let password = passwordTextField.text,
                let reEnterPassword = passwordReenterTextField.text,
                passwordReenterTextField.text == passwordTextField.text,
                !phoneNumber.isEmpty,
                !password.isEmpty,
                !reEnterPassword.isEmpty
            else {
                showAlert(message: AccountManager.AccountManagerError.missingValues.errorDescription)
                return
            }
            registerUser(phoneNumber: phoneNumber, password: password)
        default:
            return
        }
    }
}

// MARK: - Login functionality

extension LoginViewController {
    func loginUser(phoneNumber: String, password: String) {
        apiManager.checkIfUserExists(phoneNumber: phoneNumber, {  [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: error.errorDescription)
                }
            case .success(let user):
                self?.getUserToken(user: user)
                DispatchQueue.main.async {
                    guard let passwordCheck = self?.accountManager.checkIfPasswordIsCorrect(password: password, user: user) else { return }
                    if passwordCheck {
                        self?.loginAccountWith(phoneNumber: phoneNumber)
                    }
                    else {
                        self?.showAlert(message: AccountManager.AccountManagerError.wrongPassword.errorDescription)
                    }
                }
            }
        })
    }
    
    func loginAccountWith(phoneNumber: String) {
        apiManager.checkIfAccountExists(phoneNumber: phoneNumber, {  [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: error.errorDescription)
                }
            case .success(let account):
                DispatchQueue.main.async {
                    self?.proceedToMainView(account: account)
                }
            }
        })
    }
}

// MARK: - Register functionality

extension LoginViewController {
    
    func registerUser(phoneNumber: String, password: String) {
        
        apiManager.checkIfUserExists(phoneNumber: phoneNumber, {  [weak self] result in
            switch result {
            case .failure(let error):
                switch error {
                case .userDoesntExist:
                    continueUserCreation()
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
        
        func continueUserCreation() {
            guard accountManager.validatePhoneNumberAndPassword(phoneNumber: phoneNumber, password: password) else {
                DispatchQueue.main.async {
                    self.showAlert(message: AccountManager.AccountManagerError.missingValues.errorDescription)
                }
                return
            }
            apiManager.createUser(phoneNumber: phoneNumber, password: password, { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(message: error.errorDescription)
                    }
                case .success(let user):
                    self?.getUserToken(user: user)
                }
            })
            apiManager.createAccount(phoneNumber: phoneNumber, currency: selectedCurrency, { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(message: error.errorDescription)
                    }
                case .success(let account):
                    DispatchQueue.main.async {
                        self?.proceedToMainView(account: account)
                    }
                }
            })
        }
    }
    
    func getUserToken(user: UserResponse) {
        apiManager.getUserToken(user: user, { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: error.errorDescription)
                }
            case .success(let token):
                self?.userManager.saveToken(token.accessToken, phoneNumber: user.phoneNumber)
                self?.userManager.saveTokenExpiration(token.expiresIn)
                self?.userManager.saveUserPhoneNumber(phoneNumber: user.phoneNumber)
            }
        })
    }
}

// MARK: - Navigation

extension LoginViewController {
    
    func checkIfUserIsLoggedIn() {
        if userManager.isUserLoggedIn() {
            guard let phoneNumber = userManager.getUserphoneNumber()
            else {
                showAlert(message: "Session expired please login again")
                return
            }
            loginAccountWith(phoneNumber: phoneNumber)
        }
    }
    
    func proceedToMainView(account: AccountResponse) {
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.modalPresentationStyle = .fullScreen
        mainViewController.accountManager.currentAccount = account
        present(navigationController, animated: true, completion: nil)
    }
}








