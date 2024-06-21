//
//  PostsViewController.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import UIKit
import RxSwift
import RxCocoa

class PostsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: PostsViewModelProtocol
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        self.navigationController?.title = "Home"
    }
    
    init(viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "PostsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: Constant.postTableViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constant.postCell)
    }
    
    private func bindViewModel() {
        viewModel.postsPublisher
            .bind(to: tableView
                .rx
                .items(cellIdentifier: Constant.postCell, cellType: PostTableViewCell.self)) { (tableView, tableViewItem, postCell) in
                    postCell.title.text = tableViewItem.title
                    postCell.bodyText.text = tableViewItem.body
                    postCell.isFavorite = self.viewModel.isFavorite(post: tableViewItem)
                    postCell.favoriteAction = { [weak self] in
                        self?.viewModel.toggleFavorite(post: tableViewItem)
                    }
                    postCell.commentAction = { [weak self] in
                        let nextViewController = CommentsViewController(viewModel: CommentsViewModel())
                        nextViewController.postId = tableViewItem.id
                        self?.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                }
                .disposed(by: disposeBag)
        
        // Observe the favoriteToggled and reload the corresponding row
        viewModel.favoriteToggledPublisher
            .subscribe(onNext: { [weak self] toggledPost in
                if let index = self?.viewModel.posts.firstIndex(where: { $0.id == toggledPost.id }) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            })
            .disposed(by: disposeBag)
    }
}
