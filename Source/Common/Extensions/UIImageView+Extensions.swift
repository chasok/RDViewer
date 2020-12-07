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
    
    func rdv_loadImageAsync(_ url: URL?, placeholder: UIImage? = nil, then: Handler<UIImage?>? = nil) {
        rdv_loadImageAsync(url?.absoluteString, placeholder: placeholder, then: then)
    }
    
    func rdv_loadImageAsync(_ path: String?, placeholder: UIImage? = nil, then: Handler<UIImage?>? = nil) {
        if let path = path, let cachedImage = imageCache.object(forKey: path as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
                then?(cachedImage)
            }
            return
        }

        if let path = path, let url = URL(string: path) {
            requests[storingKey]?.cancel()
            let request = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                DispatchQueue.main.async { [weak self] in
                    var image: UIImage? = placeholder
                    if let data = data,
                       let downloadedImage = UIImage(data: data)
                    {
                        imageCache.setObject(downloadedImage, forKey: path as NSString)
                        image = downloadedImage
                    }
                    self?.image = image
                    then?(image)
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
