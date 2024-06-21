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
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: Constant.postTableViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constant.postCell)
    }
    
    private func bindViewModel() {
        viewModel.favoritePostsPublisher
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoritePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.postCell,
                                                       for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let post = viewModel.favoritePosts[indexPath.row]
        cell.title.text = post.title
        cell.bodyText.text = post.body
        cell.bottomStackView.isHidden = true
        return cell
    }
}
