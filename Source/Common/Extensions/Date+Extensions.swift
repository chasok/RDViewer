//
//  Date+Extensions.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

private let formatter: RelativeDateTimeFormatter = {
    let f = RelativeDateTimeFormatter()
    f.unitsStyle = .full
    return f
}()

extension Date {
    func ago() -> String {
        formatter.localizedString(for: self, relativeTo: Date())
    }
}
