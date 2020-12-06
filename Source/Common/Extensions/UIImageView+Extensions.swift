//
//  UIImageView+Extensions.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

private let imageCache = NSCache<NSString, UIImage>()
private var requests = [String: URLSessionDataTask]()

// please, use rdv_cancelLoading in the deinit method of every class that use this extension in way of prevent memory leaks
extension UIImageView {
    
    // memory address as storing key
    private var storingKey: String { Unmanaged.passUnretained(self).toOpaque().debugDescription }
    
    func rdv_loadImageAsync(_ path: String?, placeholder: UIImage? = nil) {
        if let path = path, let cachedImage = imageCache.object(forKey: path as NSString) {
            self.image = cachedImage
            return
        }

        if let path = path, let url = URL(string: path) {
            requests[storingKey]?.cancel()
            let request = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                DispatchQueue.main.async { [weak self] in
                    if let data = data,
                       let downloadedImage = UIImage(data: data)
                    {
                        imageCache.setObject(downloadedImage, forKey: path as NSString)
                        self?.image = downloadedImage
                    } else {
                        self?.image = placeholder
                    }
                }
            })
            requests[storingKey] = request
            request.resume()
        } else {
            image = placeholder
        }
    }
    
    func rdv_cancelLoading() {
        requests[storingKey]?.cancel()
        requests[storingKey] = nil
    }
}
