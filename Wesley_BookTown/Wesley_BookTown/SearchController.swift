//
//  SearchController.swift
//  Wesley_BookTown
//
//  Created by Wesley on 3/15/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

class SearchController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    let urlString = "http://localhost:3000/books"
    
    var bookNameArray = [String]()
    var authorArray = [String]()
    var priceArray = [Double]()
    var descriptionArray = [String]()
    var imgURLArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJsonWithTask()
        // Do any additional setup after loading the view.
    }
    
    func downloadJsonWithTask(){
        let url = NSURL(string: urlString)
        var downloadTask = URLRequest(url: (url as? URL)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        
        downloadTask.httpMethod = "GET"
        myActivityIndicator.startAnimating()
        URLSession.shared.dataTask(with: downloadTask, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                print(jsonObj!.value(forKey:"books"))
                if let bookArray = jsonObj!.value(forKey:"books") as? NSArray{
                    for book in bookArray{
                        if let bookDict = book as? NSDictionary{
                            if let name = bookDict.value(forKey:"bookName"){
                                self.bookNameArray.append(name as! String)
                            }
                            if let name = bookDict.value(forKey:"bookAuthor"){
                                self.authorArray.append(name as! String)
                            }
                            if let name = bookDict.value(forKey:"bookPrice"){
                                self.priceArray.append(name as! Double)
                            }
                            if let name = bookDict.value(forKey:"bookSummary"){
                                self.descriptionArray.append(name as! String)
                            }
                            if let name = bookDict.value(forKey:"bookImage"){
                                self.imgURLArray.append("http://localhost:3000/\(name)" as! String)
                            }
                            
                            
                            OperationQueue.main.addOperation {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
           
        }).resume()
         myActivityIndicator.stopAnimating()
    }
   
 
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return bookNameArray.count
    }
    
    
 
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
//        @IBOutlet weak var imgView: UIImageView!
//
//        @IBOutlet weak var bookNameLabel: UILabel!
//
//        @IBOutlet weak var authorNameLabel: UILabel!
//
//        @IBOutlet weak var priceLabel: UILabel!
//
//        @IBOutlet weak var descriptionLabel: UILabel!
        cell.bookNameLabel.text = bookNameArray[indexPath.row]
        cell.authorNameLabel.text = authorArray[indexPath.row]
        cell.priceLabel.text = priceArray[indexPath.row].toString()
        cell.descriptionLabel.text = descriptionArray[indexPath.row]
        let imgURL = NSURL(string: imgURLArray[indexPath.row])
        if imgURL != nil{
            let data = NSData(contentsOf: (imgURL as? URL)!)
            cell.imgView.image = UIImage(data: data as! Data)
        }
        return cell
    }

}
extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
