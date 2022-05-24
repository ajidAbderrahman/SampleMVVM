//
//  ProductsListViewModelTests.swift
//  SampleMVVMTests
//
//  Created by Abderrahman Ajid on 24/5/2022.
//

import XCTest
import Combine
@testable import SampleMVVM

final class ProductListViewModelTests: XCTestCase {
    private var sut: ProductListViewModel!
    private var mockProductsService: MockProductsService!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockProductsService = MockProductsService()
        sut = ProductListViewModel(productsService: mockProductsService)
    }

    override func tearDown() {
        cancellables.removeAll()
        mockProductsService = nil
        sut = nil

        super.tearDown()
    }

    func test_fetchProducts_callService() {
        // when
        sut.fetchProducts()

        // then
        XCTAssertEqual(mockProductsService.getCallsCount, 1)
    }

    func test_fetchProducts_givenServiceCallSucceeds_shouldUpdateProducts() {
        // given
        mockProductsService.getResult = .success(Constants.products)

        // when
        sut.fetchProducts()

        // then
        XCTAssertEqual(mockProductsService.getCallsCount, 1)
        sut.$products
            .sink { XCTAssertEqual($0.count, 2) }
            .store(in: &cancellables)

        sut.$state
            .sink { XCTAssertEqual($0, .finishedLoading) }
            .store(in: &cancellables)
    }

    func test_fetchProducts_givenServiceCallFails_shouldUpdateStateWithError() {
        // given
        mockProductsService.getResult = .failure(MockError.error)

        // when
        sut.fetchProducts()

        // then
        XCTAssertEqual(mockProductsService.getCallsCount, 1)
        sut.$products
            .sink { XCTAssert($0.isEmpty) }
            .store(in: &cancellables)

        sut.$state
            .sink { XCTAssertEqual($0, .error(.productsFetch)) }
            .store(in: &cancellables)
    }
    
    func test_fetchProducts_givenServiceCallSucceeds_SpecialBandsShouldBeTopOfTheList() {
        //given
        let sortedProducts = Constants.products.sorted {
            
            $0.isSpecialBrand && !$1.isSpecialBrand
        }
        mockProductsService.getResult = .success(sortedProducts)
        
        
        //when
        sut.fetchProducts()
        
        //then
        XCTAssertEqual(mockProductsService.getCallsCount, 1)
        sut.$products
            .sink { XCTAssertEqual($0, sortedProducts) }
            .store(in: &cancellables)
        
    }
}

// MARK: - Helpers

extension ProductListViewModelTests {
    enum Constants {
        static let products = [
            Product(productID: 1, productName: "First Product",
                    productDescription: "First Product Description",
                    price: 20.00, imagesURL: ImagesURL(small: "", large: ""),
                    cBrand: CBrand(id: "SEPHO", name: "SEPHORA COLLECTION"),
                    isProductSet: false, isSpecialBrand: false),
            
            Product(productID: 2, productName: "Second Product",
                    productDescription: "Second Product Description",
                    price: 10.00, imagesURL: ImagesURL(small: "", large: ""),
                    cBrand: CBrand(id: "DIO", name: "DIOR"),
                    isProductSet: false, isSpecialBrand: true)
        ]
    }
}
