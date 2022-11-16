//
//  AuthService.swift
//  VKontakte
//
//  Created by Елена Русских on 10.11.2022.
//

import Foundation
import WebKit

class AuthService {
    
    let session = Session.shared
    let nName = Notification.Name("logout")
    
    private var urlComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "51477716"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131")
    ]
        return urlComponents
    }()
    
    func creatRequest() -> URLRequest{
        var request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func isSetSessionData(urlFragment: String) -> Bool{
        let parameters = urlFragment
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
            else {
               return false }
        
        session.token = token
        session.userID = userID
        return true
    }
    
    func resetWK(){
        
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0)) {
            
            self.session.token = ""
            NotificationCenter.default.post(name: self.nName, object: nil)
        }
    }
    
}
