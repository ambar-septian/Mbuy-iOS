//
//  TagViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class TagViewController: UIViewController {

    @IBOutlet weak var collectionView: TagCollectionView!
    
    var dataSource: TagCollectionViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tag1 = ProductTag(name: "Blue 38", tagID: "1")
        let tag2 = ProductTag(name: "Yellow 38", tagID: "1")
        let tag3 = ProductTag(name: "Red 38", tagID: "1")
        let tag4 = ProductTag(name: "Green 38", tagID: "1")
        let tag5 = ProductTag(name: "Aqua 38", tagID: "1")
        let tag6 = ProductTag(name: "Silver 38", tagID: "1")
        let tag7 = ProductTag(name: "Black 38", tagID: "1")
        let tag8 = ProductTag(name: "Blue 38", tagID: "1")
        let tags = [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8]
        dataSource = TagCollectionViewDataSource(tags: tags)
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
