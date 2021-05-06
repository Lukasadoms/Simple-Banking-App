//
//  LoginViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/6/21.
//

import UIKit
import SnapKit

final class LoginViewController: BaseViewController {
    
    private let EdgeMargin: CGFloat = 20
    
    private let loginSegmentedControl: UISegmentedControl = {
        let loginModes = ["Login", "Register"]
        let loginSegmentedControl = UISegmentedControl(items: loginModes)
        loginSegmentedControl.selectedSegmentIndex = 0
        loginSegmentedControl.addTarget(self, action: #selector(changeLoginMode), for: .valueChanged)
        return loginSegmentedControl
    }()
    
    private let usernameTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Username"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.textColor = .black
        textField.backgroundColor = .systemGray5
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
        textField.backgroundColor = .systemGray5
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
        textField.backgroundColor = .systemGray5
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
    
    private let seeAllTransactionsButton: UIButton = {
        let button = UIButton()
        let buttonColor = UIColor.systemBlue
        let buttonHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonHighlightedColor, for: .highlighted)
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        return button
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func setupView() {
        super.setupView()
        
        
        //applyTheming()
                
        view.addSubview(contentView)
        contentView.addSubview(iconView)
        contentView.addSubview(loginSegmentedControl)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(passwordReenterTextField)
        contentView.addSubview(seeAllTransactionsButton)
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
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.top.equalTo(contentView).offset(100)
        }
        
        loginSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(EdgeMargin)
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalTo(contentView)
        }

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(loginSegmentedControl.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        passwordReenterTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        seeAllTransactionsButton.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(passwordReenterTextField.snp.bottom)
            make.height.equalTo(80)
        }
    }
    
    @objc func changeLoginMode(sender: UISegmentedControl) {
          switch sender.selectedSegmentIndex {
          case 0:
            passwordReenterTextField.isHidden = true
            
          case 1:
            passwordReenterTextField.isHidden = false
          default:
            break
          }
      }
    
    @objc func loginPressed() {
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
