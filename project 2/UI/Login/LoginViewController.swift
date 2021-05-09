//
//  LoginViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/6/21.
//

import UIKit
import SnapKit

final class LoginViewController: BaseViewController {
    
    let apiManager = APIManager()
    
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
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        return textField
    }()

    private let passwordTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Password"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        return textField
    }()
    
    private let passwordReenterTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Re-enter Password"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.isSecureTextEntry = true
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
    
    private let iconView = UIImageView(image: #imageLiteral(resourceName: "codepayLogo"))
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTouchesOnView()
        currencyPicker.delegate = self as UIPickerViewDelegate
        currencyPicker.dataSource = self as UIPickerViewDataSource
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func setupView() {
        super.setupView()

        view.addSubview(contentView)
        contentView.addSubview(iconView)
        contentView.addSubview(loginSegmentedControl)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(phoneNumberTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordReenterTextField)
        stackView.addArrangedSubview(currencyPicker)
        stackView.addArrangedSubview(loginButton)
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
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
        
        phoneNumberTextField.snp.makeConstraints { make in
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
            make.height.equalTo(50)
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
            UIView.animate(withDuration: 1.5, animations: view.layoutIfNeeded)
        case 1:
            passwordReenterTextField.isHidden = false
            currencyPicker.isHidden = false
            UIView.animate(withDuration: 1.5, animations: view.layoutIfNeeded)
        default:
            break
        }
    }
    
    @objc func loginPressed() {
        guard
            let phoneNumber = phoneNumberTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        
        apiManager.checkIfUserExists(phoneNumber: phoneNumber, { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: error.errorDescription)
                }
            case .success(let user):
                DispatchQueue.main.async {
                    guard let passwordIsCorrect = self?.checkPasswordIsMatching(user: user.first!) else {
                        self?.showAlert(message: "Password is incorrect try again")
                        return
                    }
                    if passwordIsCorrect {
                        self?.proceedToMainView()
                    }
                }
            }
        })
        
        
    }
    
    func checkPasswordIsMatching(user: UserResponse) -> Bool {
        passwordTextField.text == user.password
    }
    
    func proceedToMainView() {
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}


