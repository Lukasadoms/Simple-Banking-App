//
//  BaseView.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {}
    func setupConstraints() {}
}
