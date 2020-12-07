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
    
    deinit {
        thumbnailView.rdv_cancelLoading()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailView.rdv_cancelLoading()
        thumbnailView.image = nil
    }

    func fill(with r: Record) {
        titleLabel.text = r.title

        postedByLabel.text = "Posted by \(r.author) \(r.created.ago())"
        
        numberOfCommentsLabel.text = "\(r.num_comments ?? 0) comments"
        if let width = r.thumbnail_width,
           let height = r.thumbnail_height,
           let path = r.thumbnail,
           path.starts(with: "http"),
           let url = URL(string: path)
        {
            thumbnailView.isHidden = false
            
            let ratio = CGFloat(width) / CGFloat(height)
            let newConstraint = thumbnailRatioConstraint.constraintWithMultiplier(ratio)
            thumbnailView.removeConstraint(thumbnailRatioConstraint)
            thumbnailView.addConstraint(newConstraint)
            thumbnailRatioConstraint = newConstraint
            thumbnailView.rdv_loadImageAsync(url)
        } else {
            thumbnailView.isHidden = true
        }
        thumbnailView.layoutIfNeeded()
    }
}
