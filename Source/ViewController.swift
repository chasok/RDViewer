//
//  ViewController.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

class ViewController: UIViewController {

    private var session = Session.current
    private var storage: Storage { session.storage }
    private var request: Cancelable?

    override func viewDidLoad() {
        super.viewDidLoad()

        request = storage.loadTop(then: { result in
            switch result {
            case .error(let error):
                print(error)
            case .value(let value):
                print(value.data.children.map({ $0.data.id }))
            }
        })
    }
}
