//
//  OrderHistoryTableViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Anchorage

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    fileprivate let timeLineTag = 11
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


extension OrderHistoryTableViewCell {
    func createTimelineView(index:Int){
        guard self.subviews.contains(where: ({ $0.tag == timeLineTag})) == false else {
            return
        }
        
        let circleView = UIView()
//        circleView.translatesAutoresizingMaskIntoConstraints
        circleView.tag = timeLineTag
        circleView.backgroundColor = Color.white
        let lineView = UIView()
        
        addSubview(lineView)
        addSubview(circleView)
  
        circleView.leadingAnchor == self.leadingAnchor + 20
        circleView.topAnchor == self.topAnchor + 10
        circleView.heightAnchor == self.heightAnchor * 0.25
        circleView.widthAnchor == circleView.heightAnchor
        circleView.layer.borderColor = Color.green.cgColor
        circleView.layer.borderWidth = 3
        
        lineView.backgroundColor = Color.green
        lineView.widthAnchor == circleView.widthAnchor * 0.2
        lineView.centerXAnchor == circleView.centerXAnchor
        lineView.bottomAnchor == self.bottomAnchor
        let topAnchor = index == 0 ? circleView.bottomAnchor : self.topAnchor
        lineView.topAnchor == topAnchor
       
        circleView.layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.bounds.width / 2
        circleView.layer.masksToBounds = true
       
    }
}

extension OrderHistoryTableViewCell: ReuseTableCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath: IndexPath, object: T?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderHistoryTableViewCell
        guard let orderHistory = object as? OrderHistory else { return cell }
        cell.dateLabel.text = orderHistory.date.formattedDate(dateFormat: .dateLong)
        cell.timeLabel.text = orderHistory.date.formattedDate(dateFormat: .timeMedium)
        cell.statusLabel.text = orderHistory.statusDescription
        cell.createTimelineView(index: indexPath.row)
        
        return cell
    }
}
