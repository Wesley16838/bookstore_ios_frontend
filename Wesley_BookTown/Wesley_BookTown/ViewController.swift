//
//  ViewController.swift
//  Wesley_BookTown
//
//  Created by Wesley on 2/11/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bg: UIImageView!
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var fullNameBg: UIVisualEffectView!//
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var emailBg: UIVisualEffectView!//
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var passwordBg: UIVisualEffectView!//
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var repasswordBg: UIVisualEffectView!//
    
    @IBOutlet weak var repassword: UITextField!
    
    @IBOutlet weak var register: borderedButton!
    
    @IBOutlet weak var statement: UITextView!
    
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        configureTextFields()
        configureTapGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        bg.alpha = 1
        logo.alpha = 0
        fullName.alpha = 0
        email.alpha = 0
        password.alpha = 0
        repassword.alpha = 0
        register.alpha = 0
        statement.alpha = 0
        login.alpha = 0
        
        fullNameBg.alpha = 0
        emailBg.alpha = 0
        passwordBg.alpha = 0
        repasswordBg.alpha = 0
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0, animations:{
            self.bg.alpha = 1
        }) {
            (true) in
            self.showLogo()
        }
    }
    
    func showLogo(){
        UIView.animate(withDuration: 0.5, animations:{
            self.logo.alpha = 1
        }) {
            (true) in
            self.showFields()
        }
    }
    
    func showFields(){
        UIView.animate(withDuration: 0.5, animations:{
            self.fullName.alpha = 1
            self.email.alpha = 1
            self.password.alpha = 1
            self.repassword.alpha = 1
            self.fullNameBg.alpha = 1
            self.emailBg.alpha = 1
            self.passwordBg.alpha = 1
            self.repasswordBg.alpha = 1
            self.register.alpha = 1
            self.statement.alpha = 1
            self.login.alpha = 1
        })
    }

    
    @IBAction func post(_ sender: Any) {
        
        let fullname = fullName.text;
        let mail = email.text;
        let pass = password.text;
        let repass = repassword.text
        if(fullname == "" || mail == "" || pass == ""){
            let alert = UIAlertController(title:"Error", message:"Please fill all fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if(repass != pass){
            
            let alert = UIAlertController(title:"Re-password doesn't match password", message:"Please input re-password again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let parameters:[String: Any] = ["fullName": fullname  as Any, "email": mail as Any, "password": pass as Any]
            guard let url = URL(string: "http://localhost:3000/user/signup") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let token = json["token"] as? String,let user = json["createUser"] as? [String: Any], let fullname = user["fullName"] as? String, let email = user["email"] as? String{
                            let defaults = UserDefaults.standard
                            defaults.set(fullname, forKey:"FullName")
                            defaults.set(email, forKey:"Email")
                            defaults.set(token, forKey:"Token")
                        }
                    } catch {
                        print(error)
                    }
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code: \(httpResponse.statusCode)")
                    print("Response Header \(httpResponse.allHeaderFields)")
                    let status = httpResponse.statusCode
                    let defaults = UserDefaults.standard
                    defaults.set(status, forKey:"SignupStatus")
                    DispatchQueue.main.async() {
                        [unowned self] in
                        print(status)
                        if(status == 201){
                            self.performSegue(withIdentifier: "homepage", sender: self)
                        }else if(status == 409){
                            let alert = UIAlertController(title:"Error", message:"Mail exists", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController(title:"Error", message:"Servor error", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                }.resume()
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

