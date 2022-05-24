//
//  ProductListViewModel.swift
//  SampleMVVM
//
//  Created by Abderrahman Ajid on 24/5/2022.
//

import Combine

enum ProductListViewModelError: Error, Equatable {
    case productsFetch
}

enum ProductListViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(ProductListViewModelError)
}

final class ProductListViewModel {
    
    enum Section { case products }
    
    @Published private(set) var products: Products = []
    @Published private(set) var state: ProductListViewModelState = .loading
    
    private let productsService: ProductsServiceProtocol
    private var bindings = Set<AnyCancellable>()
    
    init(productsService: ProductsServiceProtocol) {
        self.productsService = productsService
    }
}

extension ProductListViewModel {
    func fetchProducts() {
        state = .loading
        
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.productsFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let valueHandler: (Products) -> Void = { [weak self] products in
            self?.products = products
        }
        
        productsService
            .get()
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &bindings)
    }
}
