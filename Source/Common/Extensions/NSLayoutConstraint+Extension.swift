//
//  NSLayoutConstraint+Extension.swift
//  RDViewer
//
//  Created by chas on 7/12/20.
//

import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstItem as Any, attribute: firstAttribute, relatedBy: relation,
                                  toItem: secondItem, attribute: secondAttribute,
                                  multiplier: multiplier, constant: constant)
    }
}
