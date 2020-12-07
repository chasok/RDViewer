//
//  ListingViewLogic.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

private let kItemsLeftForNextPortion = 5
private let kCellIdentifier = "ListingCell"

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
        controller?.showLoadingIndicator()
        load(reset: true)
    }
        
    private func loadNextData() {
        guard request == nil, lastItem != nil else { return }
        controller?.showPageLoadingIndicator()
        load(reset: false)
    }
    
    private func load(reset: Bool) {
        request = storage.loadTop(after: lastItem, then: { [weak self] result in
            self?.handleResponse(result, reset: reset)
        })
    }
    
    private func handleResponse(_ result: Result<Response<Record>>, reset: Bool) {
        controller?.hideLoadingIndicator()
        controller?.hidePageLoadingIndicator()
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
        if indexPath.row >= records.count - kItemsLeftForNextPortion {
            loadNextData()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as? ListingCell
        let record = records[indexPath.row]
        cell?.fill(with: record)
        cell?.actionHandler = { [weak self] action in
            self?.controller?.naviagteToImageViewer(record.thumbnail)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
