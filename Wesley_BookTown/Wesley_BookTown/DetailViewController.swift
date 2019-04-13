//
//  DetailViewController.swift
//  Wesley_BookTown
//
//  Created by Wesley on 4/12/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookPrice: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    @IBOutlet weak var quantity: UITextField!
    
    var name = "";
    var author = "";
    var price = "";
    var des = "";
    var img = UIImage();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookName.text = name;
        bookAuthor.text = author;
        bookPrice.text = price;
        bookDescription.text = des;
        bookImage.image = img;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
    }
    
}
