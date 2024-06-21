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
            .bind(to: tableView
                .rx
                .items(cellIdentifier: Constant.commentTableViewCell)) { (tableView, tableViewItem, cell) in
                    guard let commentCell = cell as? CommentTableViewCell else {
                        return
                    }
                    commentCell.configure(with: tableViewItem)
                }
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
