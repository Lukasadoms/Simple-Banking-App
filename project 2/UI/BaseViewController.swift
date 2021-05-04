//
//  BaseViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

class BaseViewController: UIViewController {
        
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
}

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}