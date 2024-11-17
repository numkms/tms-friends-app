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
    
    func getLaunch(flightNumber: Int) async -> Result<LaunchModels.Launch, ApiError> {
        guard let url = URL(string: Endpoints.launch + "\(flightNumber)") else {
            return .failure(.wrongURL)
        }
        let request = URLRequest(url: url)
        return await fetch(request: request)
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
        // Говорим клиенту сделать указанный запрос
        // Main
        let task = client.dataTask(with: request) { [weak self] data, response, error in // Обрабатываем ответ, когда он к нам пришел
            // Global
            // Проверяем есть ли данные в ответе
            guard let data else { return }
            // Пытаемся преобразовать данные в структуру
            guard let decodedResponse = try! self?.decoder.decode(T.self, from: data) else { return }
            // Возвращаемся на главный поток
            DispatchQueue.main.async {
                // Main
                // Вызываем кложуру, переданную в метод fetch
                completion(.success(decodedResponse))
            }
        }
        task.resume()
    }
    
    func fetch<T: Decodable>(
        request: URLRequest
    ) async -> Result<T, ApiError> {
        do {
            // Ждем ответ от сервера
            let result = try await client.data(for: request)
            let data = result.0
            // Пытаемся преобразовать данные в структуру
            /*guard*/  let decodedResponse = try! self.decoder.decode(T.self, from: data) // else { return .failure(.decodeError) }
            // Возвращаемся на главный поток
            print(String(data: data, encoding: .utf8)!)
            return .success(decodedResponse)
        } catch {
            // Если при запросе данных с сервера возникла ошибка, то мы возвращаем ошибку в результате
            return .failure(.serverError)
        }
    }
}
