//
//  UserService.swift
//  VKontakte
//
//  Created by Елена Русских on 11.11.2022.
//

import Foundation
import Alamofire
import RealmSwift

class UserService {
    let session = Session.shared
    let baseUrl = "https://api.vk.com"
    let clientId = "51445484" //id_приложения
    
    func setMainUser(_ mainUserRealm: MainUser?, _ vc: AllFriendsViewController) {
                vc.mainUser = mainUserRealm!
                vc.session.userName = vc.mainUser.firstName
   }
    
    func creatMainUser(_ mainUserRealm: MainUser?, _ vc: AllFriendsViewController) {
        self.getUserInfo(token: self.session.token, id: self.session.userID) { [weak self] response in
            vc.mainUser = response[0]
            vc.session.userName = vc.mainUser.firstName
        }
    }
    
    func getUserInfo(token: String, id: Int, completion: @escaping ([MainUser]) -> Void){
        
        let path = "/method/users.get"
        
        let parameters: Parameters = [
            "access_token" : token,
            "user_id": id,
            "client_id": clientId,
            "v": "5.131"
        ]
        let url = baseUrl+path
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value  else { return}

            let user = try! JSONDecoder().decode( UserResponse.self, from: data).response
            
            self.saveData(user)
            
            completion(user)
        }
    }
    
    private  func saveData  <T: Object>(_ sData: [T]){

        do{
            
           let realm = try Realm()
            print(realm.configuration.fileURL)
            realm.beginWrite()
            realm.add(sData, update: .all)
            try realm.commitWrite()
            
        } catch {
            
            print(error)
            
        }
      }
    
    func setFirstLettersArray (_ friendAr: [User], _ firstLetterAr: inout [Character]){
        for i in 0..<friendAr.count {
            guard !firstLetterAr.contains(friendAr[i].firstName.first!) else {
                continue
            }
            firstLetterAr.append(friendAr[i].firstName.first!)
        }
    }
    
  
}
