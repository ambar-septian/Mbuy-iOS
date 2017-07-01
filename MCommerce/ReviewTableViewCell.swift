//
//  ReviewTableViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/12/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingView: RatingStarsView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        userImageView.circleImageView()
        // Initialization code
        
        addObserver(self, forKeyPath: "frame", options: [], context: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "frame" else { return }
        userImageView.circleImageView()
    }
    
}

extension ReviewTableViewCell: ReuseTableCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath: IndexPath, object: T?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as!
        ReviewTableViewCell
        guard let review = object as? Review else { return cell }
        cell.nameLabel.text = review.user.name
        cell.titleLabel.text = review.title
        cell.dateLabel.text = review.formattedDate
        cell.descriptionLabel.text = review.description
        cell.ratingView.numberOfStars = review.rating
        cell.userImageView.circleImageView()
        
        guard let imageURL = review.user.photoURL else { return cell }
        cell.userImageView.setImage(urlString:imageURL)
        
        
        return cell
        
    }
}

