//
//  ViewController.swift
//  Wesley_BookTown
//
//  Created by Wesley on 2/11/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var repassword: UITextField!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        configureTextFields()
        configureTapGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func post(_ sender: Any) {
        let fullname = fullName.text;
        let mail = email.text;
        let pass = password.text;
        let parameters:[String: Any] = ["fullName": fullname  as Any, "email": mail as Any, "password": pass as Any]
       
        if(fullname == "" || mail == "" || pass == ""){
            
        }
        guard let url = URL(string: "http://localhost:3000/user/signup") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                 print("1")
                print(response)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let user = json["userInfo"] as? [String: Any], let fullname = user["fullName"] as? String, let email = user["email"] as? String{
                        print(fullname)
                        print(email)
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
        
        if(true){
            performSegue(withIdentifier: "homepage", sender: self)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(){
        print("Handle tap was called!")
        view.endEditing(true)
    }
    
    @objc func keyboardWillChange(notification :Notification){
        print("Keyboard will show : \(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height + 100
        }else{
            view.frame.origin.y = 0
        }
        
    }
    
  
    
    private func configureTextFields(){
        fullName.delegate = self
        email.delegate = self
        password.delegate = self
        repassword.delegate = self
    }
    
    
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == fullName {
            textField.resignFirstResponder()
            email.becomeFirstResponder()
        } else if textField == email {
            textField.resignFirstResponder()
            password.becomeFirstResponder()
        } else if textField == password {
            textField.resignFirstResponder()
            repassword.becomeFirstResponder()
        }else if textField == repassword {
            textField.resignFirstResponder()
        }
        return true
    }
}

