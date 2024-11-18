//
//  NetworkManager.swift
//  A3
//
//  Created by Vin Bui on 10/31/23.
//

import Alamofire
import Foundation

class NetworkManager {
    
    /// Shared singleton instance
    static let shared = NetworkManager()
    
    /// init
    private init() { }
    
    // Get Posts
    func getPosts(completion: @escaping ([Post]) -> Void){
        let endpoint = "https://chatdev-wuzwgwv35a-ue.a.run.app/api/posts/"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(endpoint, method: .get)
            .validate()
            .responseDecodable(of: [Post].self, decoder: decoder) { response in
                switch response.result {
                case .success(let posts):
                    completion(posts)
                case .failure(let error):
                    print ("Error in NetworkManager.getPosts: \(error.localizedDescription)")
                    completion([])
                }
            }
    }
    
    // MARK: - Requests
    func fetchPosts(completion: @escaping ([Post]) -> Void){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let devEndpoint = "https://chatdev-wuzwgwv35a-ue.a.run.app/api/posts/"
        
        AF.request(devEndpoint, method: .get)
            .validate()
            .responseDecodable(of: [Post].self, decoder: decoder) {response in
                switch response.result {
                case .success(let posts):
                    print("Successfully fetched \(posts.count) posts")
                    completion(posts)
                case .failure(let error):
                    print("Error in NetworkManager.fetchPosts: \(error.localizedDescription)")
                    completion([])
                }
            }
    }
    
    
    func addToPosts(message: String, completion: @escaping (Bool) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let devEndpoint = "https://chatdev-wuzwgwv35a-ue.a.run.app/api/posts/create/"
        
        let parameters: Parameters = [
            "message": message
        ]
        
        AF.request(devEndpoint, method: .post, parameters: parameters)
            .validate() 
            .responseDecodable(of: Post.self, decoder: decoder) { response in
                switch response.result {
                case.success(_):
                    completion(true)
                case.failure(let error):
                    print("Error in NetworkManager.addtoPosts: \(error)")
                }
            }
    }
    
    func likePost (id: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "post_id": id,
            "net_id": "cf533"
        ]
        
        let devEndpoint = "https://chatdev-wuzwgwv35a-ue.a.run.app/api/posts/like/"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        
        AF.request(devEndpoint, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: Post.self, decoder: decoder) { response in
                switch response.result {
                case.success(_):
                    completion(true)
                case.failure(let error):
                    print("Error in NetworkManager.likePost: \(error)")
                }
                }
        }
    
}
