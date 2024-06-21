//
//  FavoritesViewController.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: PostsViewModelProtocol
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    init(viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "FavoritesViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: Constant.postTableViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constant.postCell)
    }
    
    private func bindViewModel() {
        viewModel.favoritePostsPublisher
            .bind(to: tableView
                .rx
                .items(cellIdentifier: Constant.postCell)) { (tableView, tableViewItem, cell) in
                    guard let postCell = cell as? PostTableViewCell else {
                        return
                    }
                    postCell.title.text = tableViewItem.title
                    postCell.bodyText.text = tableViewItem.body
                    postCell.bottomStackView.isHidden = true
                }
                .disposed(by: disposeBag)
    }
}
