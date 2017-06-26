//
//  SearchPlaceTableViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/26/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class SearchPlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SearchPlaceTableViewCell: ReuseTableCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath: IndexPath, object: T?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! SearchPlaceTableViewCell
        guard let place = object as? SearchPlace else { return cell }
        cell.nameLabel.text = place.name
        cell.detailLabel.text = place.descriptionPlace
        return cell
    }
}
