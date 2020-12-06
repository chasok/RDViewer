//
//  UIImageView+Extensions.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

private let QUEUE = OperationQueue()

// TODO: with cache and canceling
extension UIImageView {
    func rdv_loadImageAsync(_ path: String?) {
        DispatchQueue.global().async { [weak self] in
            var image: UIImage?
            if let path = path,
               let url = URL(string: path),
               let data = try? Data(contentsOf: url)
            {
                image = UIImage(data: data)
            }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
    
    func rdv_cancelLoading() {
    }
}
