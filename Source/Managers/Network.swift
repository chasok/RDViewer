//
//  Network.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import Foundation

private let kDEfaultHost = "https://www.reddit.com"

extension URLSessionDataTask: Cancelable {}

enum HTTPMethod: String {
    case get = "GET"
}

private extension Request {
    var natworkPath: String {
        switch self {
        case .top:      return "/top.json"
        }
    }
}

class Network {
    let host: String
    
    private var session: URLSession
    private let decoder = JSONDecoder()

    init(host: String = kDEfaultHost) {
        self.host = host
        session = URLSession(configuration: .default)
    }
    
    @discardableResult
    func get<T: Decodable>(
        _ request: Request,
        params: [String: Any]? = nil,
        then: Completion<T>?
    ) -> Cancelable? {
        guard var urlComponents = URLComponents(string: host + request.natworkPath)
        else {
            then?(.error(AppError.reason("Bad URL")));
            return nil
        }
        urlComponents.queryItems = params?.keys.map { URLQueryItem(name: $0, value: params?[$0] as? String) }
        guard let url = urlComponents.url
        else {
            then?(.error(AppError.reason("Bad URL")));
            return nil
        }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            do {
                guard let data = data else { throw(error ?? AppError.unknown) }
                let result: T = try self.decoder.decode(T.self, from: data)
                then?(.value(result))
            }
            catch {
                then?(.error(error))
            }
        }
        task.resume()
        return task
    }
}
