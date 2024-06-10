//
//  CommentsViewController.swift
//  CodingChallenge
//
//  Created by vijaybisht on 24/05/24.
//

import Foundation
import UIKit
import Combine

class CommentsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: CommentsViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    var postId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constant.commentTableViewCell, bundle: nil),
                           forCellReuseIdentifier: Constant.commentTableViewCell)
        
        viewModel = CommentsViewModel()
        bindViewModel()
        viewModel.fetchComments(for: postId)
    }
    
    init(viewModel: CommentsViewModelProtocol = CommentsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: "CommentsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.commentsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showError(errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
    
extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.commentTableViewCell,
                                                       for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        let comment = viewModel.comments[indexPath.row]
        cell.configure(with: comment)
        return cell
    }
}

