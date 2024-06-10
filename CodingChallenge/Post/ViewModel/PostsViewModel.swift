//
//  PostsViewModel.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import Foundation
import Combine
import CoreData

protocol PostsViewModelProtocol {
    var posts: [Post] { get set }
    var postsPublisher: Published<[Post]>.Publisher { get }
    var favoritePosts: [Post] { get set }
    var favoritePostsPublisher: Published<[Post]>.Publisher { get }
    func loadPosts()
    func loadFavorites()
    func isFavorite(post: Post) -> Bool
    func toggleFavorite(post: Post)
}

class PostsViewModel: ObservableObject, PostsViewModelProtocol {
    @Published var posts: [Post] = []
    @Published var favoritePosts: [Post] = []
    var postsPublisher: Published<[Post]>.Publisher { $posts }
    var favoritePostsPublisher: Published<[Post]>.Publisher { $favoritePosts }
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
                // Convert CDPost to PostModel and append to posts
                posts = result.map { cdPost in
                    Post(userId: Int(cdPost.userId),
                              id: Int(cdPost.id),
                              title: cdPost.title ?? "",
                              body: cdPost.body ?? "")
                }
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
        Task { @MainActor in
            do {
                let posts: [Post] = try await manager.request(urlString: Constant.postUrl)
                self.posts = posts
                self.savePosts()
            } catch {
                print(error)
            }
        }
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
        if let index = favoritePosts.firstIndex(where: { $0.id == post.id }) {
            favoritePosts.remove(at: index)
        } else {
            favoritePosts.append(post)
        }
        saveFavorites()
    }
    
    func isFavorite(post: Post) -> Bool {
        return favoritePosts.contains(where: { $0.id == post.id })
    }
}
