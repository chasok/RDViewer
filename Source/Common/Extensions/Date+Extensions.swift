//
//  Date+Extensions.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

extension Date {
    func ago() -> String {
        // TODO
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("d/M/YYYY H:m")
        return df.string(from: self)
    }
}
