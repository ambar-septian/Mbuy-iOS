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
    
    
    @IBOutlet weak var thankYouLabel: UILabel!
    
    @IBOutlet weak var greetingLabel: UILabel! {
        didSet {
            guard let order = passedOrder else { return }
            let hiString = NSAttributedString(string: "Hi, ", attributes: [NSFontAttributeName: Font.latoRegular.withSize(16), NSForegroundColorAttributeName: Color.darkGray])
            let nameString = NSAttributedString(string: order.profile.name, attributes: [NSFontAttributeName: Font.latoBold.withSize(16), NSForegroundColorAttributeName: Color.darkGray])
            let mutableString = NSMutableAttributedString()
            mutableString.append(hiString)
            mutableString.append(nameString)
            
            greetingLabel.attributedText = mutableString
        }
    }
    
    @IBOutlet weak var instructionLabel: UILabel! {
        didSet {
            guard let order = passedOrder else { return }
            let instructionFirstString = NSAttributedString(string: "orderInstructionFirst".localize, attributes: [NSFontAttributeName: Font.latoRegular.withSize(16), NSForegroundColorAttributeName: Color.darkGray])
            let amountString = NSAttributedString(string: order.formattedTotal, attributes: [NSFontAttributeName: Font.latoBold.withSize(16), NSForegroundColorAttributeName: Color.orange])
            let instructionLastString = NSAttributedString(string: "orderInstructionLast".localize, attributes: [NSFontAttributeName: Font.latoRegular.withSize(16), NSForegroundColorAttributeName: Color.darkGray])
            
            let mutableString = NSMutableAttributedString()
            mutableString.append(instructionFirstString)
            mutableString.append(amountString)
            mutableString.append(instructionLastString)
            
            instructionLabel.attributedText = mutableString
        }
    }
    
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    
    fileprivate var margin:CGFloat {
        return collectionView.bounds.width * 0.01
    }
    
    fileprivate var collectionViewInset:UIEdgeInsets {
        return  UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    
    
    fileprivate var payments : [BankPayment] = [.bca, .bni, .bri, .mandiri]
    
    var passedOrder: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButton()

        navigationItem.title = "note".localize
        collectionView.reloadData()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       collectionViewConstraint.constant = collectionView.contentSize.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.segueID.order.payment else { return }
        guard let index = sender as? Int else { return }
        guard let vc = segue.destination as? OrderPaymentViewController else { return }
        vc.accountPayment = payments[index]
        vc.passedOrder = passedOrder
    }
}

extension OrderNoteViewController {
    func setupBarButton(){
        guard tabBarController == nil else { return }
        navigationItem.hidesBackButton = true
        addDismissBarButton(rightPosition: false)
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

extension OrderNoteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.segueID.order.payment, sender: indexPath.row)
    }
}

extension OrderNoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width / 3.5)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionViewInset
    }
    
}
