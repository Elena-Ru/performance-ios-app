//
//  Service.swift
//  VKontakte
//
//  Created by Елена Русских on 20.10.2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import SDWebImage


class Service {
    
    let baseUrl = "https://api.vk.com"
    let clientId = "51445484" //id_приложения
    
 
        func getNewsPost(token: String, id: Int, completion: @escaping (News) -> Void){
            
            let path = "/method/newsfeed.get"
             let parameters: Parameters = [
                "access_token" : token,
                "user_id": id,
                "client_id": clientId,
                "filters": "post",
                "v": "5.131"
            ]
            let url = baseUrl+path
            
            AF.request(url, method: .get, parameters: parameters).responseData { response in
                guard let data = response.value  else { return}
                let news = try? JSONDecoder().decode(News.self, from: data)
                completion(news!)
            }
        }
    
}
