//
//  ProductsService.swift
//  SampleMVVM
//
//  Created by Abderrahman Ajid on 24/5/2022.
//

import Foundation
import Combine

protocol ProductsServiceProtocol {
    func get() -> AnyPublisher<Products, Error>
}

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}

final class ProductsService: ProductsServiceProtocol {
    
    typealias FailedPublisher = Fail<Products, Error>
    
    func get() -> AnyPublisher<Products, Error> {
        
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<Products, Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest() else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let products = try JSONDecoder().decode(Products.self, from: data)
                    promise(.success(products))
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func getUrlRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "sephoraios.github.io"
        components.path = "/items.json"
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}
