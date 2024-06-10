//
//  PostsViewController.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import UIKit
import Combine

class PostsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: PostsViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    
    init(viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "PostsViewController", bundle: nil)
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
        viewModel.postsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.postCell,
                                                       for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let post = viewModel.posts[indexPath.row]
        cell.title.text = post.title
        cell.bodyText.text = post.body
        cell.isFavorite = viewModel.isFavorite(post: post)
        cell.favoriteAction = { [weak self] in
            self?.viewModel.toggleFavorite(post: post)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.commentAction = { [weak self] in
            let nextViewController = CommentsViewController(viewModel: CommentsViewModel())
            nextViewController.postId = post.id
            self?.navigationController?.pushViewController(nextViewController, animated: true)
        }
        return cell
    }
}
