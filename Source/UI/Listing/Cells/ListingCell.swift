//
//  ListingCell.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import UIKit

class ListingCell: UITableViewCell {
    enum Action {
        case showImage
    }
    
    var actionHandler: Handler<Action>?
    
    @IBOutlet var stackView: UIStackView!
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
        let recognizer = UITapGestureRecognizer.init(target: self, action: #selector(imageTapped))
        thumbnailView.addGestureRecognizer(recognizer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailView.rdv_cancelLoading()
        thumbnailView.image = nil
    }
    // MARK: - Actions
    
    @IBAction private func imageTapped(_ sender: Any?) {
        actionHandler?(.showImage)
    }
    
    // MARK: - Fillers
    
    func fill(with r: Record) {
        titleLabel.text = r.title

        postedByLabel.text = "Posted by \(r.author) \(r.created.ago())"
        
        numberOfCommentsLabel.text = "\(r.num_comments ?? 0) comments"
        let ratio: CGFloat
        if let width = r.thumbnail_width,
           let height = r.thumbnail_height,
           let path = r.thumbnail,
           path.starts(with: "http"),
           let url = URL(string: path)
        {
            thumbnailView.isHidden = false
            thumbnailView.rdv_loadImageAsync(url, placeholder: #imageLiteral(resourceName: "reddit"))
            ratio = CGFloat(width) / CGFloat(height)
        } else {
            ratio = 5
            thumbnailView.image = nil
            thumbnailView.isHidden = true
        }
        updateRatioConstraint(withRatio: ratio)
        thumbnailView.layoutIfNeeded()
    }
    
    // MARK: - Private
    
    private func updateRatioConstraint(withRatio ratio: CGFloat) {
        let newConstraint = thumbnailRatioConstraint.constraintWithMultiplier(ratio)
        thumbnailView.removeConstraint(thumbnailRatioConstraint)
        thumbnailView.addConstraint(newConstraint)
        thumbnailRatioConstraint = newConstraint
    }
}
