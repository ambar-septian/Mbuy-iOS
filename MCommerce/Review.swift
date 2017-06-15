//
//  Review.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/10/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class Review {
    var reviewID:String
    var title: String
    var description: String
    var rating: Int
    var product: Product
    var date: Date
    var formattedDate: String{
        return date.formattedDate(dateFormat: .full)
    }
    var user: User
    
    public init(reviewID: String, title: String, description: String, rating: Int, product: Product, user: User, date: Date) {
        self.reviewID = reviewID
        self.title = title
        self.description = description
        self.rating = rating
        self.product = product
        self.user = user
        self.date = date
    }
    
    

}
