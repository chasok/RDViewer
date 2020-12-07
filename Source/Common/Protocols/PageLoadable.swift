//
//  PageLoadable.swift
//  RDViewer
//
//  Created by chas on 8/12/20.
//

import UIKit

protocol PageLoadable {
    func showPageLoadingIndicator()
    func hidePageLoadingIndicator()
}

// TODO: to implement
extension UIViewController: PageLoadable {
    func showPageLoadingIndicator() {}
    func hidePageLoadingIndicator() {}
}
