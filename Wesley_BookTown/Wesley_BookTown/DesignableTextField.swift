//
//  DesignableTextField.swift
//  Wesley_BookTown
//
//  Created by Wesley on 2/25/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField {
    
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    
    @IBInspectable var leftImage: UIImage?{
        didSet{
            updateView()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        if let image = leftImage{
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x:leftPadding, y:0, width:16, height: 12))
            imageView.image = image
            imageView.tintColor = tintColor
            
            var width = leftPadding + 20
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line{
                width = width + 17
            }
            
            
            let view = UIView(frame: CGRect(x:0, y:0, width:width, height: 20))
            view.addSubview(imageView)
            leftView = view
            
        }else{
            leftViewMode = .never
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! :"", attributes: [NSAttributedString.Key.foregroundColor:tintColor])
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
