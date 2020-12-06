//
//  ListingViewController.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

class ListingViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    lazy private var logic = ListingViewLogic(storage: Session.current.storage)

    override func viewDidLoad() {
        super.viewDidLoad()

        logic.activate(forController: self, tableView: tableView)
        logic.loadData()
    }
}
