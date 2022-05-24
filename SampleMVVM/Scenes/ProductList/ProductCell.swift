//
//  ProductCell.swift
//  SampleMVVM
//
//  Created by Abderrahman Ajid on 24/5/2022.
//

import UIKit

final class ProductCell: UITableViewCell {
    static let identifier = "ProductCell"
    
    var viewModel: ProductCellViewModel? {
        didSet { setUpViewModel() }
    }
    
    lazy var container = UIView()
    lazy var nameLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    lazy var priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubiews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let containerSubviews = [nameLabel, descriptionLabel, priceLabel]
        container.addSubviews(containerSubviews)
    }
    
    private func setUpConstraints() {
        
        let margin: CGFloat = 10
        
        NSLayoutConstraint.activate([
            
            container.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: margin),
            container.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: margin),
            container.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -margin),
            container.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -margin),
            
            nameLabel.topAnchor.constraint(
                equalTo: container.topAnchor, constant: margin),
            nameLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor, constant: margin),
            nameLabel.trailingAnchor.constraint(
                equalTo: priceLabel.leadingAnchor, constant: margin),
            
            priceLabel.topAnchor.constraint(
                equalTo: container.topAnchor, constant: margin),
            priceLabel.trailingAnchor.constraint(
                equalTo: container.trailingAnchor, constant: -margin),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor, constant: margin),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor, constant: margin),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: container.trailingAnchor, constant: -margin),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: container.bottomAnchor, constant: -margin)
        ])
    }
    
    private func setUpViews() {
        
        container.backgroundColor = .white
        container.layer.cornerRadius = 5
        container.addShadow(opacity: 0.1, radius: 3)
        
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func setUpViewModel() {
        nameLabel.text = viewModel?.name
        descriptionLabel.text = viewModel?.description
        priceLabel.text = viewModel?.price
    }
}

final class ProductCellViewModel {
    
    var name: String = ""
    var description: String = ""
    var price: String = ""
        
    private let product: Product
    
    init(product: Product) {
        self.product = product
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        name = product.productName
        description = product.productDescription
        price = String(format: "%.2f", product.price) + " $"
    }
}
