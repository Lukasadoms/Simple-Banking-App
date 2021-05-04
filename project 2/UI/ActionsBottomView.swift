//
//  ActionsBottomView.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

protocol ActionsBottomViewDelegate: AnyObject {
    func actionsBottomViewAddListPressed()
    func actionsBottomViewNewReminderPressed()
}

class ActionsBottomView: UIToolbar {
    private var defaultShadowImage: UIImage?
    private var defaultBackgroundImage: UIImage?
    private var defaultBarTintColor: UIColor?
    
    
    weak var actionsDelegate: ActionsBottomViewDelegate?
    
    private let newReminderButton: UIBarButtonItem = {
        let color = UIColor.systemBlue
        let highlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        let button = UIButton()
        button.setTitle("  Add money", for: .normal)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(highlightedColor, for: .highlighted)
        button.layer.borderWidth = 5
        button.layer.borderColor = CGColor(gray: 1, alpha: 0)
        let normalImage = UIImage(systemName: "dock.arrow.down.rectangle")!.withTintColor(color)
        let highlightedImage = UIImage(systemName: "dock.arrow.down.rectangle")!.withTintColor(highlightedColor)
        button.setImage(normalImage, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        let fontSize = button.titleLabel?.font.pointSize ?? 12
        button.titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        button.addTarget(self, action: #selector(newReminderPressed), for: .touchUpInside)
        

        return UIBarButtonItem(customView: button)
    }()
    
    private let addListButton: UIBarButtonItem = {
       
        let color = UIColor.systemBlue
        let highlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        let button = UIButton()
        button.setTitle("  Send Money", for: .normal)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(highlightedColor, for: .highlighted)
        let normalImage = UIImage(systemName: "arrowshape.zigzag.right")!.withTintColor(color)
        let highlightedImage = UIImage(systemName: "arrowshape.zigzag.right")!.withTintColor(highlightedColor)
        button.setImage(normalImage, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        let fontSize = button.titleLabel?.font.pointSize ?? 12
        button.titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        button.addTarget(self, action: #selector(addListPressed), for: .touchUpInside)

        return UIBarButtonItem(customView: button)
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        defaultBackgroundImage = backgroundImage(forToolbarPosition: .any, barMetrics: .default)
        defaultShadowImage = shadowImage(forToolbarPosition: .any)
        defaultBarTintColor = barTintColor
        
        setItems(
            [
                newReminderButton,
                UIBarButtonItem(systemItem: .flexibleSpace),
                addListButton
            ],
            animated: false)
    }
}

// MARK: - Transparency Effect

extension ActionsBottomView {
    
    @objc private func addListPressed() {
        actionsDelegate?.actionsBottomViewAddListPressed()
    }

    @objc private func newReminderPressed() {
        actionsDelegate?.actionsBottomViewNewReminderPressed()
    }
}
