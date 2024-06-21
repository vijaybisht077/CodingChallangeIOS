//
//  CommentsViewController.swift
//  CodingChallenge
//
//  Created by vijaybisht on 24/05/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CommentsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: CommentsViewModelProtocol
    private let disposeBag = DisposeBag()
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
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessagePublisher
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showError(errorMessage)
                }
            })
            .disposed(by: disposeBag)
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
