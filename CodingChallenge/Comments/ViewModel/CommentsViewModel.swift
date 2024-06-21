//
//  CommentsViewModel.swift
//  CodingChallenge
//
//  Created by vijaybisht on 24/05/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol CommentsViewModelProtocol {
    var comments: [Comment] { get set }
    var commentsPublisher: Observable<[Comment]> { get }
    var errorMessage: String? { get set }
    var errorMessagePublisher: Observable<String?> { get }
    func fetchComments(for postId: Int)
}

class CommentsViewModel: CommentsViewModelProtocol {
    var commentsPublisher: Observable<[Comment]> {
        return _comments.asObservable()
    }
    var errorMessagePublisher: Observable<String?> {
        return _errorMessage.asObservable()
    }
    
    private let _comments = BehaviorSubject<[Comment]>(value: [])
    private let _errorMessage = BehaviorSubject<String?>(value: nil)
    
    var comments: [Comment] {
        get {
            return (try? _comments.value()) ?? []
        }
        set {
            _comments.onNext(newValue)
        }
    }
    
    var errorMessage: String? {
        get {
            return (try? _errorMessage.value()) ?? nil
        }
        set {
            _errorMessage.onNext(newValue)
        }
    }
    
    private let manager: ApiManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(manager: ApiManagerProtocol = ApiManager()) {
        self.manager = manager
    }
    
    func fetchComments(for postId: Int) {
        manager.request(urlString: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments")
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] (comments: [Comment]) in
                    self?.comments = comments
                },
                onFailure: { [weak self] error in
                    self?.errorMessage = error.localizedDescription
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
