//
//  ImageViewerViewController.swift
//  RDViewer
//
//  Created by chas on 7/12/20.
//

import UIKit

class ImageViewerViewController: UIViewController, UIScrollViewDelegate {

    var path: String?

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
  

        imageView.rdv_loadImageAsync(path)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.imageView
    }
}
