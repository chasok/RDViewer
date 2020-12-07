//
//  Storage.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import Foundation

protocol Cancelable {
    func cancel()
}

struct Response<T: Codable>: Codable {
    let kind: String
    let data: Listing<T>
}

struct Listing<T: Codable>: Codable {
    let children: [Item<T>]
    let after: String?
    let before: String?
}

struct Item<T: Codable>: Codable {
    let kind: String
    let data: T
}

enum Request {
    case top
}

class Storage {
    let network = Network()
    
    func loadTop(after: String? = nil, then: @escaping Completion<Response<Record>>) -> Cancelable? {
        network.get(.top, params: paramsForPage(after: after), then: then)
    }
    
    private func paramsForPage(after: String?) -> [String: Any]{
        var params = [String: Any]()
        params["after"] = after
        return params
    }
}
