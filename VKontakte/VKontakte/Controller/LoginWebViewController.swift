//
//  LoginWebViewController.swift
//  VKontakte
//
//  Created by Елена Русских on 04.08.2022.
//

import UIKit
import WebKit

class LoginWebViewController: UIViewController {
    
    let apiManager = APIManager()

    let session = Session.shared

    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    private var urlComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "8233581"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131")
    ]
        return urlComponents
    }()
    
    private lazy var request = URLRequest(url: urlComponents.url!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
          webView.load(request)
        
    }
}



extension LoginWebViewController: WKNavigationDelegate{
    
    
    func webView( _ webView: WKWebView,
                  decidePolicyFor navigationResponse: WKNavigationResponse,
                  decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
            
        let parameters = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, params in
                var dict = result
                let key = params[0]
                let value = params[1]
                dict[key] = value
                return dict
            }
            guard
                let token = parameters["access_token"],
                let userIDString = parameters["user_id"],
                let userID = Int(userIDString)
            else {decisionHandler(.allow)
               return  }
            
        session.token = token
        session.userID = userID
       
        performSegue(withIdentifier: "LoginWeb", sender: nil)

        decisionHandler(.cancel)
      
        }
    
}
