//
//  ProductListVC.swift
//  SampleMVVM
//
//  Created by Abderrahman Ajid on 24/5/2022.
//

import UIKit
import Combine

final class ProductListVC: UIViewController {

    private typealias DataSource = UITableViewDiffableDataSource<ProductListViewModel.Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ProductListViewModel.Section, Product>
    
    private lazy var contentView = ListView()
    private let viewModel: ProductListViewModel
    private var bindings = Set<AnyCancellable>()
    
    private var dataSource: DataSource?
    
    init(_ viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        setUpTableView()
        configureDataSource()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProducts()
    }
    
    private func setUpTableView() {
        contentView.tableView.register(
            ProductCell.self,
            forCellReuseIdentifier: ProductCell.identifier)
    }
    
    private func setUpBindings() {
        viewModel.$products
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateSections()
            })
            .store(in: &bindings)
        
        let stateValueHandler: (ProductListViewModelState) -> Void = { [weak self] state in
            switch state {
            case .loading:
                self?.contentView.startLoading()
            case .finishedLoading:
                self?.contentView.finishLoading()
            case .error(let error):
                self?.contentView.finishLoading()
                self?.showError(error)
            }
        }
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.products])
        snapshot.appendItems(viewModel.products)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: - UICollectionViewDataSource

extension ProductListVC {
    private func configureDataSource() {
        dataSource = DataSource(
            tableView: contentView.tableView,
            cellProvider: { (tableView, indexPath, product) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ProductCell.identifier,
                for: indexPath) as? ProductCell
                cell?.viewModel = ProductCellViewModel(product: product)
                return cell
        })
    }
}

