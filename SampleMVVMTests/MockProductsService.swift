//
//  MockProductsService.swift
//  SampleMVVMTests
//
//  Created by Abderrahman Ajid on 24/5/2022.
//

import Foundation
import Combine
@testable import SampleMVVM

final class MockProductsService: ProductsServiceProtocol {
    var getCallsCount: Int = 0

    var getResult: Result<Products, Error> = .success([])

    func get() -> AnyPublisher<Products, Error> {
        getCallsCount += 1

        return getResult.publisher.eraseToAnyPublisher()
    }
}

// MARK: - MockError
enum MockError: Error {
    case error
}

