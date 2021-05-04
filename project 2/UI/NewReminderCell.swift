//
//  NewReminderCell.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit
import SnapKit

final class NewReminderCell: UITableViewCell {

    enum CellType {
        case textField
        case details
        case list
    }

    private let newReminderTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        return textField
    }()

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = text
        return label
    }

    private let arrowIconView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    func setupCell(type: CellType) {
        switch type {
        case .textField:
            setupTextFieldCell()
        case .details, .list:
            setupClickableCell(type: type)
        }

        backgroundColor = .systemGray6
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        selectionStyle = .none
    }

    func setupTextFieldCell() {
        contentView.addSubview(newReminderTextField)

        newReminderTextField.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).inset(10)
        }
    }

    func setupClickableCell(type: CellType) {
        let primaryLabel: UILabel
        var secondaryLabel: UILabel?

        switch type {
        case .details:
            primaryLabel = makeLabel(text: "Details")
        case .list:
            primaryLabel = makeLabel(text: "List")

            secondaryLabel = makeLabel(text: "Reminders")
            secondaryLabel?.textColor = .lightGray
        default:
            fatalError("Unexpected type")
        }
        
        contentView.addSubview(primaryLabel)
        contentView.addSubview(arrowIconView)

        primaryLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
        }

        arrowIconView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(15)
        }

        if let secondaryLabel = secondaryLabel {
            contentView.addSubview(secondaryLabel)

            secondaryLabel.snp.makeConstraints { make in
                make.centerY.equalTo(contentView)
                make.leading.greaterThanOrEqualTo(primaryLabel.snp.trailing)
                make.trailing.equalTo(arrowIconView.snp.leading).multipliedBy(0.98)
            }
        }
    }

    func roundTopCorners() {
        contentView.layer.cornerRadius = 8
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    func roundBottomCorners() {
        contentView.layer.cornerRadius = 8
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    func roundAllCorners() {
        contentView.layer.cornerRadius = 8
        contentView.layer.maskedCorners = [
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
    }

    func removeRounding() {
        contentView.layer.cornerRadius = 0
    }
}
