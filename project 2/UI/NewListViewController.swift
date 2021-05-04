//
//  NewListViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

struct NewListManager {
    let supportedColors: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple, .brown]
}

final class NewListViewController: BaseViewController {
    private let newListManager = NewListManager()
    private let circleView = NewListCircleView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = .zero
        collectionViewLayout.itemSize = CGSize(width: 44, height: 44)
        
        let collectionView = UICollectionView(
            frame: view.frame,
            collectionViewLayout: collectionViewLayout
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ColorCircleCell.self, forCellWithReuseIdentifier: "ColorCircleCell")
        
        collectionView.backgroundColor = .white
        
        return collectionView
    }()

    private let listTitleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 8
        textField.textAlignment = .center
        textField.textColor = .systemBlue
        textField.autocorrectionType = .no
        textField.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return textField
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitialState()
    }

    override func setupView() {
        super.setupView()
        
        title = "New List"
        configureNavigationBar()
        
        view.addSubview(circleView)
        view.addSubview(collectionView)
        view.addSubview(listTitleTextField)
    }
    
    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        circleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.centerX.equalTo(view)
            make.width.height.equalTo(100)
        }

        listTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(listTitleTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

    }
}

extension NewListViewController {
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
            action: #selector(cancelPressed)
        )
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension NewListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newListManager.supportedColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCircleCell", for: indexPath)
        
        guard let colorCircleCell = cell as? ColorCircleCell else {
            return cell
        }
        
        colorCircleCell.color = newListManager.supportedColors[indexPath.row]
        
        return colorCircleCell
    }
}

extension NewListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = newListManager.supportedColors[indexPath.row]
        
        circleView.color = color
        listTitleTextField.textColor = color
    }
}

private extension NewListViewController {
    func setInitialState() {
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)

        if let firstColor = newListManager.supportedColors.first {
            circleView.color = firstColor
            listTitleTextField.textColor = firstColor
        }
    }
}
