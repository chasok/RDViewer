//
//  UIViewController+Navigation.swift
//  RDViewer
//
//  Created by chas on 7/12/20.
//

import UIKit

extension UIViewController {
    func naviagteToImageViewer(_ path: String?) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let identifier = "ImageViewerViewController"
        if let controller = storyboard.instantiateViewController(identifier: identifier) as? ImageViewerViewController {
            controller.path = path
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
