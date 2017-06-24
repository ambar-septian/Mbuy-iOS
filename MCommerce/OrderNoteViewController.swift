//
//  OrderNoteViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/23/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class OrderNoteViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let cell = OrderPaymentCollectionViewCell.self
            collectionView.register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
            
        }
    }
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    
    
    fileprivate var payments: [OrderPayment] = [
        OrderPayment(name: "BCA", accountNumber: "4500 000 000", image: #imageLiteral(resourceName: "bank_bca")),
        OrderPayment(name: "BNI", accountNumber: "4500 000 000", image: #imageLiteral(resourceName: "bank_bni")),
        OrderPayment(name: "BRI", accountNumber: "4500 000 000", image: #imageLiteral(resourceName: "bank_bri")),
        OrderPayment(name: "Mandiri", accountNumber: "4500 000 000", image: #imageLiteral(resourceName: "bank_mandiri")),
        ]
    
    
    var passedOrder: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       collectionViewConstraint.constant = collectionView.contentSize.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OrderNoteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return payments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let payment = payments[indexPath.row]
        return OrderPaymentCollectionViewCell.configureCell(collectionView: collectionView, indexPath: indexPath, object: payment)
    }
}

extension OrderNoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2.3
        let size = CGSize(width: width, height: width)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
