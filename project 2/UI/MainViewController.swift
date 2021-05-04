//
//  ViewController.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    
    // MARK: - UI constants

    private let EdgeMargin: CGFloat = 20
    private let SearchBarHeight: CGFloat = 50
    private let CollectionViewCellHeight: CGFloat = 75
    

    private var collectionViewCellWidth: CGFloat {
        (view.frame.width / 2) - EdgeMargin * 2
    }

    // MARK: - UI elements

    private lazy var remindersTypeCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = .zero
        collectionViewLayout.itemSize = CGSize(width: collectionViewCellWidth, height: CollectionViewCellHeight)

        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .systemGray6

        return collectionView
    }()
    
    private let SearchBarTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Search Transactions"
        textField.font = UIFont(name: "HelveticaNeue", size: 15)
        textField.textColor = .black
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 8
        textField.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        return textField
    }()

    private let myTransactionsLabel: UILabel = {
        let label = UILabel()
        label.text = "My list"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let myBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance: 4.00"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    private let seeAllTransactionsButton: UIButton = {
        let button = UIButton()
        let buttonColor = UIColor.systemBlue
        let buttonHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.setTitle("See all transactions", for: .normal)
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonHighlightedColor, for: .highlighted)
        return button
    }()
    
    private let iconView = UIImageView(image: #imageLiteral(resourceName: "codepayLogo"))

    private lazy var myTransactionsTableView: UITableView = {
        let tableView = SelfSizingTableView(frame: view.frame)
        tableView.backgroundColor = .systemGray6
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.register(MyListsCell.self, forCellReuseIdentifier: "MyListsCell")

        tableView.layer.cornerRadius = 8
        tableView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        return tableView
    }()
    
    private let bottomView = ActionsBottomView()
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    
    init(myListText: String = "My Transactions") {
        super.init(nibName: nil, bundle: nil)
        self.myTransactionsLabel.text = myListText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTouchesOnView()
        let img = UIImage(systemName: "gear")!
        let imgWidth = img.size.width
        let imgHeight = img.size.height
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight))
        button.setBackgroundImage(img, for: .normal)
        //button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func setupView() {
        super.setupView()
        
        bottomView.actionsDelegate = self
        
        applyTheming()
        configureNavigationBar()
        configureScrollView()
                
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(iconView)
        contentView.addSubview(myBalanceLabel)
        contentView.addSubview(myTransactionsLabel)
        contentView.addSubview(SearchBarTextField)
        contentView.addSubview(myTransactionsTableView)
        contentView.addSubview(seeAllTransactionsButton)
        view.addSubview(bottomView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).offset(EdgeMargin)
            make.trailing.equalTo(view).inset(EdgeMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.top.equalTo(contentView)
        }
        
        
        myBalanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(iconView.snp.bottom).offset(EdgeMargin)
        }
        
        myTransactionsLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(bottomView.snp.bottom).offset(EdgeMargin)
        }
        
        SearchBarTextField.snp.makeConstraints { make in
            make.top.equalTo(myTransactionsLabel.snp.bottom).offset(EdgeMargin)
            make.leading.equalTo(myTransactionsTableView)
            make.trailing.equalTo(myTransactionsTableView)
            make.height.equalTo(SearchBarHeight)
        }
        
        myTransactionsTableView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(SearchBarTextField.snp.bottom).offset(EdgeMargin)
            make.bottom.equalTo(contentView).inset(EdgeMargin)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(myBalanceLabel.snp.bottom).offset(EdgeMargin)
            make.height.equalTo(80)
        }
        
        seeAllTransactionsButton.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(myTransactionsTableView.snp.bottom)
            make.height.equalTo(80)
        }
    }
}

// MARK: - View configuration

private extension MainViewController {

    func applyTheming() {
        view.backgroundColor = .white
    
    }

    func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    func configureScrollView() {
        scrollView.delegate = self
        scrollView.contentInset.bottom = 64
        scrollView.showsVerticalScrollIndicator = false
    }
}

// MARK: - UITableViewDataSource methods

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "MyListsCell", for: indexPath)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension MainViewController: ActionsBottomViewDelegate {
    func actionsBottomViewAddListPressed() {
        let newListViewController = NewListViewController()
        let navigationController = UINavigationController(rootViewController: newListViewController)
        
        present(navigationController, animated: true, completion: nil)
    }

    func actionsBottomViewNewReminderPressed() {
        let newReminderViewController = NewReminderViewController()
        let navigationController = UINavigationController(rootViewController: newReminderViewController)

        present(navigationController, animated: true, completion: nil)
    }
}



