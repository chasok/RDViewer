//
//  UIViewController+Messaging.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

extension UIViewController {
    func showMessage(_ message: String, title: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil ))
        present(alert, animated: true, completion: nil)
    }
    
    func showError(_ error: Error) {
        showMessage(error.localizedDescription, title: "Error")
    }
}
