//
//  CategoryHomeTableViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/10/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Anchorage

class CategoryHomeTableViewCell: UITableViewCell {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.black.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white
        label.font = Font.latoBold.withSize(17)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
        setupConstraints()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }
    
    init(){
        super.init(style: .default, reuseIdentifier: CategoryHomeTableViewCell.identifier)
        setupSubviews()
        setupConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
    }
}

extension CategoryHomeTableViewCell: BaseViewProtocol {
    func setupSubviews() {
        contentView.backgroundColor = .clear
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(transparentView)
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        backgroundImageView.edgeAnchors == contentView.edgeAnchors
        transparentView.edgeAnchors == contentView.edgeAnchors
        titleLabel.centerYAnchor == contentView.centerYAnchor
        titleLabel.horizontalAnchors == contentView.horizontalAnchors + 20
    }
}

extension CategoryHomeTableViewCell: ReuseTableCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath: IndexPath, object: T?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as!
        CategoryHomeTableViewCell
        guard let category = object as? Category else { return cell }
       
        cell.backgroundImageView.setImage(urlString: category.imageURL)
        cell.titleLabel.text = category.name
        return cell
        
    }
}
