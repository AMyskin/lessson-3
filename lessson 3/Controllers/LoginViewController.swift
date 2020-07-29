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


    
  


    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7552602"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "wall,friends"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webview.load(request)
        
   
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
