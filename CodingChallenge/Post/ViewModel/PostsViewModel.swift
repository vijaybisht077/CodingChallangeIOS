//
//  PostsViewModel.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

protocol PostsViewModelProtocol {
    var posts: [Post] { get set }
    var postsPublisher: Observable<[Post]> { get }
    var favoritePosts: [Post] { get set }
    var favoritePostsPublisher: Observable<[Post]> { get }
    var favoriteToggledPublisher: Observable<Post> { get }
    func loadPosts()
    func loadFavorites()
    func isFavorite(post: Post) -> Bool
    func toggleFavorite(post: Post)
}

class PostsViewModel: PostsViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    private let _posts = BehaviorRelay<[Post]>(value: [])
    var postsPublisher: Observable<[Post]> {
        return _posts.asObservable()
    }
    var posts: [Post] {
        get {
            return _posts.value
        }
        set {
            _posts.accept(newValue)
        }
    }
    
    private let _favoritePosts = BehaviorRelay<[Post]>(value: [])
    var favoritePostsPublisher: Observable<[Post]> {
        return _favoritePosts.asObservable()
    }
    var favoritePosts: [Post] {
        get {
            return _favoritePosts.value
        }
        set {
            _favoritePosts.accept(newValue)
        }
    }
    
    private let _favoriteToggled = PublishSubject<Post>()
    var favoriteToggledPublisher: Observable<Post> {
        return _favoriteToggled.asObservable()
    }
    
    private let manager: ApiManagerProtocol
    private let persistentStorage: PersistentStorageProtocol
    
    private let postsKey = "posts"
    private let favoritesKey = "favorites"
    
    init(manager: ApiManagerProtocol = ApiManager(),
         persistentStorage: PersistentStorageProtocol = PersistentStorage.shared) {
        self.manager = manager
        self.persistentStorage = persistentStorage
        loadPosts()
        loadFavorites()
    }
    
    func loadPosts() {
        let fetchRequest: NSFetchRequest<CDPost> = CDPost.fetchRequest()
        do {
            let result = try persistentStorage.context.fetch(fetchRequest)
            if !result.isEmpty {
                // Convert CDPost to PostModel and set to posts
                let postList = result.map { cdPost in
                    Post(userId: Int(cdPost.userId),
                         id: Int(cdPost.id),
                         title: cdPost.title ?? "",
                         body: cdPost.body ?? "")
                }
                self.posts = postList
            } else {
                fetchPostsFromNetwork()
            }
        } catch {
            debugPrint("Failed to fetch posts from Core Data: \(error)")
        }
    }
    
    private func savePosts() {
        let context = persistentStorage.context
        posts.forEach { postObject in
            let post = CDPost(context: context)
            post.id = Int16(postObject.id)
            post.userId = Int16(postObject.userId)
            post.title = postObject.title
            post.body = postObject.body
        }
        persistentStorage.saveContext()
    }
    
    func fetchPostsFromNetwork() {
        manager.request(urlString: Constant.postUrl)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] (posts: [Post]) in
                    self?.posts = posts
                    self?.savePosts()
                },
                onFailure: { error in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.data(forKey: favoritesKey),
           let decodedFavorites = try? JSONDecoder().decode([Post].self, from: savedFavorites) {
            favoritePosts = decodedFavorites
        }
    }
    
    private func saveFavorites() {
        if let encodedFavorites = try? JSONEncoder().encode(favoritePosts) {
            UserDefaults.standard.set(encodedFavorites, forKey: favoritesKey)
        }
    }
    
    func toggleFavorite(post: Post) {
        var currentFavorites = favoritePosts
        if let index = currentFavorites.firstIndex(where: { $0.id == post.id }) {
            currentFavorites.remove(at: index)
        } else {
            currentFavorites.append(post)
        }
        favoritePosts = currentFavorites
        saveFavorites()
        _favoriteToggled.onNext(post)  // Notify about the favorite toggle
    }
    
    func isFavorite(post: Post) -> Bool {
        return favoritePosts.contains(where: { $0.id == post.id })
    }
}
