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
    
    lazy var nameLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubiews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        let subviews = [nameLabel, descriptionLabel]
        
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            descriptionLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)
        ])
    }
    
    private func setUpViewModel() {
        nameLabel.text = viewModel?.name
        descriptionLabel.text = viewModel?.description
    }
}

final class ProductCellViewModel {
    
    @Published var name: String = ""
    @Published var description: String = ""
        
    private let product: Product
    
    init(product: Product) {
        self.product = product
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        name = product.productName
        description = product.productDescription
    }
}
