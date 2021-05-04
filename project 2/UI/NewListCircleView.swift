//
//  NewListCircleView.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

final class NewListCircleView: BaseView {
    
    private let imageView = UIImageView(image: #imageLiteral(resourceName: "codepayLogo").withTintColor(.white))
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }()
    
    var color: UIColor = .systemBlue {
        didSet {
            configureAppearance()
        }
    }
        
    override func setupView() {
        super.setupView()
                
        addSubview(imageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureAppearance()
    }
    
    private func configureAppearance() {
        roundCorners()
        configureShadow()
        configureGradient()
    }

    private func roundCorners() {
        layer.cornerRadius = bounds.height / 2
    }
    
    private func configureShadow() {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }
    
    private func configureGradient() {
        gradient.frame = bounds
        gradient.colors = [color.withAlphaComponent(0.7).cgColor, color.cgColor]
        gradient.cornerRadius = bounds.width / 2
    }
}
