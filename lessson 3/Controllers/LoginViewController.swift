//
//  ViewController.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 11.06.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }

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
        
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7550671"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "wall,friends,photos,video,offline"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webview.load(request)
        
   
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

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        
        
        guard let token = params["access_token"],
            let userId  = Int(params["user_id"] ?? "") else {return}
        
       // print(userId)
       // print(token)
        
        let session = Session.instance
        session.token = token
        session.userId = userId
        
        passData()
        
        //navigationController
        
        
        decisionHandler(.cancel)
    }
    
    
    func passData() {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let secondViewController = storyboard.instantiateViewController(identifier: "navigationController")
       secondViewController.modalPresentationStyle = .fullScreen
       //navigationController?.pushViewController(secondViewController, animated: true)
       self.present(secondViewController, animated: false, completion: nil)
          //show(secondViewController, sender: nil)
      }
}
