//
//  BaseViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

class BaseViewController: UIViewController {
        
    // MARK: - UI constants
    
    let EdgeMargin: CGFloat = 20
    let SearchBarHeight: CGFloat = 50
    let TitleSize: CGFloat = 30
    let currencyArray = ["EUR", "USD"]
    var selectedCurrency: String = ""
    
    private let currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.isHidden = true
        return picker
    }()
    
    let moneyTextField: CurrencyTextField = {
        let textField = CurrencyTextField()
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.autocorrectionType = .no
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {}
    func setupConstraints() {}
    
    func keyboardWillAppear(_ keyboardHeight: CGFloat) {}
    func keyboardWillDisappear() {}
}

extension BaseViewController {
    
    func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notifaction: NSNotification) {
        guard let keyboardFrame = (notifaction.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.keyboardWillAppear(keyboardFrame.height)
    }
    
    @objc private func keyboardWillHide() {
        keyboardWillDisappear()
    }
    
    func observeTouchesOnView() {
        let recognizer = UITapGestureRecognizer(
            target: view,
            action: #selector(view.endEditing(_:))
        )
        view.addGestureRecognizer(recognizer)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func backPressed() {
        dismiss(animated: true, completion: nil)
    }
}



extension BaseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencyArray[row]
    }
}
