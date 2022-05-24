//
//  Products.swift
//  SampleMVVM
//
//  Created by Abderrahman Ajid on 24/5/2022.
//

import Foundation

typealias Products = [Product]

// MARK: - Product
struct Product: Decodable, Hashable {
    
    let productID: Int
    let productName, description: String
    let price: Int
    let imagesURL: ImagesURL
    let cBrand: CBrand
    let isProductSet, isSpecialBrand: Bool

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case description, price
        case imagesURL = "images_url"
        case cBrand = "c_brand"
        case isProductSet = "is_productSet"
        case isSpecialBrand = "is_special_brand"
    }
}

// MARK: - CBrand
struct CBrand: Decodable, Hashable {
    let id, name: String
}

// MARK: - ImagesURL
struct ImagesURL: Decodable, Hashable {
    let small: String
    let large: String
}
