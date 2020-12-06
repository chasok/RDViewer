//
//  ListingCell.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

class ListingCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var postedByLabel: UILabel!
    @IBOutlet var numberOfCommentsLabel: UILabel!
    @IBOutlet var thumbnailView: UIImageView!
    @IBOutlet var thumbnailRatioConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailView.rdv_cancelLoading()
        thumbnailView.image = nil
    }

    func fill(with r: Record) {
        titleLabel.text = r.title

        postedByLabel.text = "Posted by \(r.author) \(r.created.ago())"
        
        numberOfCommentsLabel.text = "\(r.num_comments ?? 0) comments"
        thumbnailView.rdv_loadImageAsync(r.thumbnail)
        thumbnailView.isHidden = r.thumbnail?.isEmpty != false

        let ratio = CGFloat(r.thumbnail_width ?? 1) / CGFloat(r.thumbnail_height ?? 1)
        let newConstraint = thumbnailRatioConstraint.constraintWithMultiplier(ratio)
        thumbnailView.removeConstraint(thumbnailRatioConstraint)
        thumbnailView.addConstraint(newConstraint)
        thumbnailView.layoutIfNeeded()
        thumbnailRatioConstraint = newConstraint
    }
}
