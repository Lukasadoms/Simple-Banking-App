
import UIKit


final class SendMoneyViewController: BaseViewController {

    var currentAccount: AccountResponse?
    let apiManager = APIManager()
    weak var delegate: AddMoneyViewControllerDelegate?
    
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
    
    private let sendToLabel: UILabel = {
        let label = UILabel()
        label.text = "To: +"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let referenceLabel: UILabel = {
        let label = UILabel()
        label.text = "Reference:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter information of your transaction"
        label.textColor = .systemGray3
        label.textAlignment = .center
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        let buttonColor = UIColor.systemBlue
        let buttonHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonHighlightedColor, for: .highlighted)
        button.addTarget(self, action: #selector(sendMoneyPressed), for: .touchUpInside)
        return button
    }()
    
    private let phoneNumberTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "370..."
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.autocorrectionType = .no
        textField.textColor = .black
        textField.keyboardType = .decimalPad
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let referenceTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Reference"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.autocorrectionType = .no
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        return textField
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
        view.addSubview(moneyTextField)
        view.addSubview(sendToLabel)
        view.addSubview(referenceLabel)
        view.addSubview(phoneNumberTextField)
        view.addSubview(referenceTextField)
        view.addSubview(referenceLabel)
        view.addSubview(informationLabel)
        view.addSubview(balanceLabel)
        view.addSubview(moneyLabel)
        view.addSubview(sendMoneyLabel)
        view.addSubview(sendButton)
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

        moneyTextField.snp.makeConstraints { make in
            make.top.equalTo(sendMoneyLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.height.equalTo(50)
            make.trailing.equalTo(view).inset(EdgeMargin)
        }
        
        sendToLabel.snp.makeConstraints { make in
            make.top.equalTo(moneyTextField.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.width.equalTo(45)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.centerY.equalTo(sendToLabel)
            make.leading.equalTo(sendToLabel.snp.trailing).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.height.equalTo(30)
        }
        
        referenceLabel.snp.makeConstraints { make in
            make.top.equalTo(sendToLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(view).offset(EdgeMargin)
        }
        
        referenceTextField.snp.makeConstraints { make in
            make.centerY.equalTo(referenceLabel)
            make.leading.equalTo(referenceLabel.snp.trailing).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.height.equalTo(30)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(referenceTextField.snp.bottom).offset(EdgeMargin)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight)
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
            action: #selector(backPressed)
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
    
    @objc func sendMoneyPressed() {
        guard
            let currentAccount = currentAccount,
            let phoneNumber = phoneNumberTextField.text,
            let reference = referenceTextField.text
        else { return }
        apiManager.checkIfAccountExists(phoneNumber: phoneNumber, { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: error.errorDescription)
                }
            case .success(let account):
                DispatchQueue.main.async {
                    guard let amount = self?.moneyTextField.text else { return }
                    
                    if currentAccount.currency == account.currency && Double(amount)! <= currentAccount.balance {
                        continueSendMoney(account: account)
                    } else {
                        self?.showAlert(message: "not sufficient funds or the currency in receiving account is not the same")
                    }
                }
                
            }
        })
        
        func continueSendMoney(account: AccountResponse) {
            apiManager.postTransaction(
                senderAccount: currentAccount,
                receiverAccount: account,
                amount: Double(moneyTextField.text!)!,
                currency: currentAccount.currency,
                reference: reference,
                { [weak self] result in
                    
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(message: error.errorDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.showAlert(message: "Transaction submitted succesfully")
                        self?.updateUI()
                    }
                }
            })
            apiManager.updateAccount(account: account, currency: nil, phoneNumber: nil, amount: Double(moneyTextField.text!)!, { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(message: error.errorDescription)
                    }
                case .success:
                    print("updated receiving account balance")
                }
            })
            
            apiManager.updateAccount(account: currentAccount, currency: nil, phoneNumber: nil, amount: -Double(moneyTextField.text!)!, { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(message: error.errorDescription)
                    }
                case .success(let account):
                    self?.currentAccount = account
                    print("updated current account balance")
                    self?.delegate?.balanceHasChanged()
                    self?.updateUI()
                }
            })
        }
    }
    
    func updateUI() {
        guard let account = currentAccount else { return }
        moneyLabel.text = "\(account.balance)"
    }
}

