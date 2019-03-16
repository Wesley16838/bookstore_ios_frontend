//
//  ProfileViewController.swift
//  Wesley_BookTown
//
//  Created by Wesley on 3/2/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func logout(_ sender: Any) {
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "FullName")
        defaults.removeObject(forKey: "Email")
        defaults.removeObject(forKey: "SignupStatus")
        performSegue(withIdentifier: "login", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
