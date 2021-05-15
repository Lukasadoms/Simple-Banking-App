
import UIKit

final class SendMoneyViewController: BaseViewController {

    var account: AccountResponse?
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Your balance:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let moneyLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let sendMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "Send money:"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()

    private lazy var sendMoneyTableView: UITableView = {
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
        label.text = "Enter information of your transaction"
        label.textColor = .systemGray3
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
        observeTouchesOnView()
        updateUI()
    }

    override func setupView() {
        super.setupView()
        view.backgroundColor = .white
        configureNavigationBar()
        view.addSubview(sendMoneyTableView)
        view.addSubview(informationLabel)
        view.addSubview(balanceLabel)
        view.addSubview(moneyLabel)
        view.addSubview(sendMoneyLabel)
    }

    override func setupConstraints() {
        super.setupConstraints()
        
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(EdgeMargin)
        }
        
        sendMoneyLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(EdgeMargin)
        }

        sendMoneyTableView.snp.makeConstraints { make in
            make.top.equalTo(sendMoneyLabel.snp.bottom).offset(EdgeMargin)
            make.bottom.equalTo(informationLabel.snp.top)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
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
    
    func updateUI() {
        guard let account = account else { return }
        moneyLabel.text = "\(account.balance)"
    }
}

extension SendMoneyViewController: UITableViewDataSource {
    
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
            sendMoneyCell.setupCell(type: .phoneField)
            
        case 1:
            sendMoneyCell.setupCell(type: .moneyAmountField)
        default:
            fatalError("Unexpected section!")
        }
        sendMoneyCell.roundAllCorners()
        return sendMoneyCell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
}

extension SendMoneyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
}
