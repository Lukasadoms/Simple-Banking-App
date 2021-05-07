//
//  MyListsCell.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

final class TransactionCell: UITableViewCell {

    private let RoundedEdgesRadius: CGFloat = 15

    // MARK: - UI elements

    private lazy var iconContainerView = UIView()
    private lazy var iconView = UIImageView()
    private lazy var listNameLabel = configuredLabel(text: "Transaction text", color: .black)
    private lazy var countLabel = configuredLabel(text: "10000", color: .placeholderText)

    private func configuredLabel(text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        return label
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Configuration

    func configureCell() {
        iconView = UIImageView(image: #imageLiteral(resourceName: "codepayLogo"))

        iconContainerView.layer.cornerRadius = RoundedEdgesRadius
        iconContainerView.clipsToBounds = true
        iconContainerView.backgroundColor = .systemBlue

        iconContainerView.addSubview(iconView)
        contentView.addSubview(iconContainerView)
        contentView.addSubview(listNameLabel)
        contentView.addSubview(countLabel)

        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        listNameLabel.numberOfLines = 0

        setupConstraints()
    }

    private func setupConstraints() {
        iconContainerView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(10)
            make.height.width.equalTo(30)
            make.centerY.equalTo(contentView)
        }

        iconView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(iconContainerView)
            make.width.height.equalTo(18)
        }

        listNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView.snp.trailing).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).inset(10)
        }
        
        listNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        countLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(listNameLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.centerY.equalTo(contentView)
        }
        
        countLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
}
