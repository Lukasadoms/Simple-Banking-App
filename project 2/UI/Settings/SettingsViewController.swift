//
//  SettingViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/8/21.
//

import UIKit

final class SettingsViewController: BaseViewController {

    private var EdgeInset: CGFloat = 16
    
    private let currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.isHidden = true
        return picker
    }()
    
    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings:"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
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

    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SendMoneyCell.self, forCellReuseIdentifier: "SendMoneyCell")
        return tableView
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
        
        observeKeyboardNotifications()
        observeTouchesOnView()
    }

    override func setupView() {
        super.setupView()
        view.backgroundColor = .white
        configureNavigationBar()
        view.addSubview(settingsTableView)
        view.addSubview(informationLabel)
        view.addSubview(settingsLabel)
    }

    override func setupConstraints() {
        super.setupConstraints()
        
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        settingsTableView.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(EdgeInset)
            make.bottom.equalTo(informationLabel.snp.top)
            make.leading.equalTo(view).offset(EdgeInset)
            make.trailing.equalTo(view).inset(EdgeInset)
        }
        
        informationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(EdgeInset)
            make.centerX.equalTo(view)
        }
    }
    
    override func keyboardWillAppear(_ keyboardHeight: CGFloat) {
        super.keyboardWillAppear(keyboardHeight)
        
        informationLabel.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(EdgeInset + keyboardHeight)
        }
        
        UIView.animate(withDuration: 1.5, animations: view.layoutIfNeeded)
    }
    
    override func keyboardWillDisappear() {
        super.keyboardWillDisappear()
        
        informationLabel.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(EdgeInset)
        }
        
        UIView.animate(withDuration: 1.5, animations: view.layoutIfNeeded)
    }

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
            action: #selector(donePressed)
        )
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func donePressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendMoneyCell", for: indexPath)

        guard let sendMoneyCell = cell as? SendMoneyCell else {
            return cell
        }

        switch indexPath.section {
        case 0:
            sendMoneyCell.setupCell(type: .passwordField)
            
        case 1:
            sendMoneyCell.setupCell(type: .phoneField)
            
        case 2:
            sendMoneyCell.setupCell(type: .currencyPicker)
        default:
            fatalError("Unexpected section!")
        }
        sendMoneyCell.roundAllCorners()
        return sendMoneyCell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
}
