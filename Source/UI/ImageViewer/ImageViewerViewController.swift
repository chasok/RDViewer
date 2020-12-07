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
        
        fillImage()
    }
    
    // MARK: - Actions

    @IBAction func savePressed(_ sender: Any?) {
        saveImage()
    }

    // MARK: - Private
    
    private func fillImage() {
        guard let path = path else { return }
        imageView.rdv_loadImageAsync(path)
    }
    
    private func saveImage() {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showError(error, title: "Save error")
        } else {
            let message = "Your image has been saved to your photos."
            showMessage(message, title: "Saved!")
        }
    }
    
    // MARK: - UIStateRestoring

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)

        coder.encode(path, forKey: "imagePath")
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)

        path = coder.decodeObject(forKey: "imagePath") as? String
        fillImage()
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.imageView
    }
}
