//
//  Network.swift
//  Weather
//
//  Created by Vladimir Kurdiukov on 16.09.2024.
//

import Foundation

class Network {
    enum APIHandler {
        static let posts = "https://jsonplaceholder.typicode.com/posts"
        static let users = "https://jsonplaceholder.typicode.com/users"
    }
    
    func loadUsers(completion: @escaping ([User]) -> Void) {
        guard let url = URL(string: APIHandler.users) else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data else { return }
           
            let decoder = JSONDecoder()
            let users: [User] = try! decoder.decode([User].self, from: data)
            completion(users)
        }
        dataTask.resume()
    }
}
