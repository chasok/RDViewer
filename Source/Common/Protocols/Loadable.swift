//
//  Loadable.swift
//  RDViewer
//
//  Created by chas on 8/12/20.
//

import UIKit

protocol Loadable {
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

// TODO: to implement
extension UIViewController: Loadable {
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
}
