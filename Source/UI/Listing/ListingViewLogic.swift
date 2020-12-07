//
//  ListingViewLogic.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

class ListingViewLogic: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let storage: Storage

    private weak var controller: ListingViewController?
    private weak var tableView: UITableView?
    private var records: [Record] = []
    private var request: Cancelable? { willSet { request?.cancel() }}
    private var lastItem: String?
    
    deinit {
        request?.cancel()
    }
    
    init(storage: Storage) {
        self.storage = storage
    }

    func activate(forController controller: ListingViewController, tableView: UITableView) {
        self.tableView = tableView
        self.controller = controller
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)

        tableView.reloadData()
    }

    // MARK: - Data

    @objc func loadData() {
        request = nil
        lastItem = nil
        load(reset: true)
    }
        
    private func loadNextData() {
        guard request == nil, lastItem != nil else { return }
        load(reset: false)
    }
    
    private func load(reset: Bool) {
        request = storage.loadTop(after: lastItem, then: { [weak self] result in
            self?.handleResponse(result, reset: reset)
        })
    }
    
    private func handleResponse(_ result: Result<Response<Record>>, reset: Bool) {
        tableView?.refreshControl?.endRefreshing()
        request = nil
        switch result {
        case .error(let error):
            controller?.showError(error)
        case .value(let value):
            records = (reset ? [] : records) + value.data.children.map({ $0.data })
            lastItem = value.data.after
            tableView?.reloadData()
        }
    }

    // MARK: - UITableViewDataSource, UITabBarDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= records.count - 5 {
            loadNextData()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell") as? ListingCell
        cell?.fill(with: records[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
