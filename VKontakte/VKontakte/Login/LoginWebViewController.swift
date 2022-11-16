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
    let authService = AuthService()


    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(authService.creatRequest())
        
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
        
       guard authService.isSetSessionData(urlFragment: fragment)
            else {
           decisionHandler(.allow)
               return
       }
       
        performSegue(withIdentifier: "LoginWeb", sender: nil)

        decisionHandler(.cancel)
      
        }
    
}
