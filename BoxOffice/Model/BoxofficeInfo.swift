//
//  BoxofficeInfo.swift
//  BoxOffice
//
//  Created by Andrew, 레옹아범 on 2023/03/28.
//

import UIKit

class BoxofficeInfo<T> {
    private let apiType: APIType
    private let model: NetworkingProtocol
    private var task: URLSessionDataTask?
    private var isRunningOnlyOneTask: Bool
    
    init(apiType: APIType, model: NetworkingProtocol, isRunningOnlyOneTask: Bool = false) {
        self.apiType = apiType
        self.model = model
        self.isRunningOnlyOneTask = isRunningOnlyOneTask
    }
    
    private func decodeData(_ data: Data) -> T? where T: Decodable {
        do {
            let decodingData = try JSONDecoder().decode(T.self, from: data)
            return decodingData
        } catch {
            return nil
        }
    }
    
    private func makeRequest() -> URLRequest? {
        guard let url = apiType.receiveUrl() else {
            return nil
        }
        
        if isRunningOnlyOneTask {
            cancelTask()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(apiType.header, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    private func cancelTask() {
        task?.cancel()
    }
    
    func fetchImage(handler: @escaping (Result<UIImage, BoxofficeError>) -> Void) {
        guard let request = makeRequest() else {
            handler(.failure(.urlError))
            return
        }
        
        task = model.search(request: request) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    handler(.failure(.decodingError))
                    return
                }
                handler(.success(image))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func fetchData(handler: @escaping (Result<T, BoxofficeError>) -> Void) where T: Decodable {
        guard let request = makeRequest() else {
            handler(.failure(.urlError))
            return
        }
        
        task = model.search(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodingData = self?.decodeData(data) else {
                    handler(.failure(.decodingError))
                    return
                }
                handler(.success(decodingData))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
