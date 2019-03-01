//
//  borderButton.swift
//  Wesley_BookTown
//
//  Created by Wesley on 2/26/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

class borderedButton: UIButton{
    override func awakeFromNib(){
        super.awakeFromNib()
        layer.borderWidth = 6/UIScreen.main.nativeScale
        layer.borderColor = UIColor.white.cgColor
    }
}
