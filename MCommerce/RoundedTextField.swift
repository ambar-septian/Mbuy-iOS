//
//  ASTextField.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField, RoundedProtocol, TextFieldWithImage {

    var imagePlaceholder: UIImage? {
        didSet {
            setTextFieldWithImage()
        }
    }

    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var shadeColor: UIColor {
        if let backgroundColor = self.backgroundColor {
            return backgroundColor.withAlphaComponent(0.4)
        } else {
            return borderColor.withAlphaComponent(0.4)
        }
    }
    
    var mainColor:UIColor? {
        didSet {
            backgroundColor = mainColor
        }
    }

    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSForegroundColorAttributeName:  Color.white])
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    init(borderColor:UIColor, borderWidth:CGFloat, mainColor:UIColor?, imagePlaceholder: UIImage?) {
        super.init(frame: CGRect.zero)
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.mainColor = mainColor
        self.imagePlaceholder = imagePlaceholder
        
        setupTextField()
    }
    
    
    func setupTextField(){
        borderStyle = .none
        backgroundColor = mainColor
        textColor = borderColor
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = Constants.cornerRadius
        
        layer.masksToBounds = true
        clipsToBounds = true
        font = Font.latoRegular.withSize(17)
        
        setTextFieldWithImage()
    }
}


protocol TextFieldWithImage {
    var imagePlaceholder: UIImage? { get set }
}
extension TextFieldWithImage where Self: UITextField {
    func setTextFieldWithImage(){
        guard imagePlaceholder != nil else {
            leftView = .none
            return
        }
        let height = 20
        let view = UIView(frame: CGRect(x: 0, y: 0, width: height * 2, height: height))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: height, height: height))
        imageView.image = imagePlaceholder
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        leftViewMode = .always
        leftView = view
    }

}



