//
//  NewReminderViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

final class SendMoneyViewController: BaseViewController {

    private var EdgeInset: CGFloat = 16

    private lazy var newReminderTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.rowHeight = 50
        return tableView
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter information about your reminders"
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
        title = "Send Money"
        view.backgroundColor = .systemGray6
        configureNavigationBar()
        view.addSubview(newReminderTableView)
        view.addSubview(informationLabel)
    }

    override func setupConstraints() {
        super.setupConstraints()

        newReminderTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addPressed)
        )
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func addPressed() {
      
    }

    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
