//
//  ColorCirlceCell.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

final class ColorCircleCell: UICollectionViewCell {
    private let innerView = UIView()
    
    override var isSelected: Bool {
        didSet {
            configureBorder()
        }
    }
    
    var color: UIColor = .systemBlue {
        didSet {
            innerView.backgroundColor = color
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundCorners()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(innerView)
    }
    
    private func setupConstraints() {
        innerView.snp.makeConstraints { make in
            let inset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            make.margins.equalTo(contentView).inset(inset)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ColorCircleCell {
    func roundCorners() {
        layer.cornerRadius = bounds.height / 2
        innerView.layer.cornerRadius = innerView.bounds.height / 2
    }
    
    func configureBorder() {
        if isSelected {
            layer.borderColor = UIColor.systemGray3.cgColor
            layer.borderWidth = 3.0
        } else {
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0
        }
    }
}
