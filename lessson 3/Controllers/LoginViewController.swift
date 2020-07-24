//
//  ViewController.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 11.06.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
  
    
//    @IBAction func signinPressed(_ sender: UIButton){
//        //customAvtivityView.stopAnimate()
//        guard let login = loginTextField.text, let password = passwordTextField.text else {return}
//        if login == "admin" && password == "123" {
//            print("Ура, успешная авторизация")
//        } else {
//            print("неуспешная авторизация")
//        }
//        loginTextField.text = ""
//        passwordTextField.text = ""
//        
//       
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
   
    }
    
    @objc func keyboardWillShow(notification: Notification){
        guard let keybordSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keybordSize.height, right: 0)
        scrollView.contentInset = insets
    }
    @objc func keyboardWillHide(notification: Notification){
        scrollView.contentInset = .zero
    }
    
    @IBAction func scrollTapped(_ gesture:UIGestureRecognizer){
        scrollView.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
           if identifier == "Home" {
               let isValid = checkUserData()
               if !isValid {
                   showErrorAlert()
               }
            let session = Session.instance
            session.token = "testToken"
            session.userId = 555
               return isValid
           }
           return true
       }
       
       func checkUserData() -> Bool {
           return loginTextField.text == "admin" &&
               passwordTextField.text == "123"
       }
       
       func showErrorAlert() {
           let alert = UIAlertController(
               title: "Ошибка",
               message: "Неправильный логин или пароль",
               preferredStyle: .alert
           )
           let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alert.addAction(action)
           
           present(alert, animated: true, completion: nil)
       }


}

