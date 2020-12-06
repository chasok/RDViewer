//
//  Defines.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

typealias VoidBlock = () -> Void
typealias Handler<T> = (T) -> Void

enum Result<T> {
    case error(Error)
    case value(T)
    
    var error: Error? {
        switch self {
        case .error(let e): return e
        case .value:        return nil
        }
    }
    var value: T? {
        switch self {
        case .error:        return nil
        case .value(let v): return v
        }
    }
}

typealias Completion<T> = Handler<Result<T>>
