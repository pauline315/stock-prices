//
//  ViewController.swift
//  Stock Prices
//
//  Created by Gracie on 20/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

class StockViewController: UIViewController {
    
    private let viewModel = StockViewModel()
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        setupUI()
        bindViewModel()
        
        // Trigger fetch when the view loads
        viewModel.triggerfetch.onNext(())
    }
    
    private func setupUI() {
        tableView.backgroundColor = .yellow
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        // Bind stockAPIData to UITableView
        viewModel.stockAPIData
            .observe(on: MainScheduler.instance)
        
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { _, stock, cell in
                cell.textLabel?.text = "\(stock.open) - \(stock.close)"
            }
        
            .disposed(by: disposeBag)
        
        // Handle row selection
        tableView.rx.modelSelected(Stock.self)
            .subscribe(onNext: { stock in
                print("Selected: \(stock.open)")
            })
            .disposed(by: disposeBag)
    }
}
