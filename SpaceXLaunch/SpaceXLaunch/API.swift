//
//  API.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 21.10.2024.
//

import Foundation

class API {
    private var client: URLSession = .shared
    private var decoder: JSONDecoder = .init()
    static let shared = API()
    
    enum ApiError: Error {
        case decodeError
        case serverError
        case wrongURL
    }
    
    enum Endpoints {
        static let launch = "https://api.spacexdata.com/v3/launches/"
    }
    
    func getLaunch(
        flightNumber: Int,
        completion: @escaping (Result<LaunchModels.Launch, ApiError>) -> Void
    ) {
        guard let url = URL(string: Endpoints.launch + "\(flightNumber)") else {
            completion(.failure(.wrongURL))
            return
        }
        let request = URLRequest(url: url)
        fetch(request: request, completion: completion)
    }
    
    func loadLaunch(
        completion: @escaping (Result<[Models.Launch], ApiError>) -> Void
    ) {
        guard let url = URL(string: Endpoints.launch) else {
            completion(.failure(.wrongURL))
            return
        }
        let request = URLRequest(url: url)
        fetch(request: request, completion: completion)
    }
    
    func fetch<T: Decodable>(
        request: URLRequest,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        let task = client.dataTask(with: request) { [weak self] data, response, error in
            guard let data else { return }
            guard let decodedResponse = try! self?.decoder.decode(T.self, from: data) else { return }
            DispatchQueue.main.async {
                completion(.success(decodedResponse))
            }
        }
        task.resume()
    }
}
