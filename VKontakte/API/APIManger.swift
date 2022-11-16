//
//  APIManger.swift
//  VKontakte
//
//  Created by Елена Русских on 04.08.2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import SDWebImage
import PromiseKit




class APIManager{
    
    let baseUrl = "https://api.vk.com"
    let clientId = "51477716" //id_приложения
    let session = Session.shared
    
    
    // 1. Создаем URL для запроса
    
    func getUrl() -> Promise<String> {
        
        let path = "/method/friends.get"
        let url = baseUrl+path
        return Promise { resolver in
            resolver.fulfill(url)
        }
    }
    
    // 2. Создаем запрос
    
    func getData(_ url: String) -> Promise<Data> {
        
        print(url)
        
        let parameters: Parameters = [
            "access_token" : session.token,
            "user_id": session.userID,
            "client_id": clientId,
            "order": "name",// сортировка по имени
           "fields": "photo_100",
            "v": "5.131"
        ]
        return Promise { resolver in
            AF.request(url, method: .get, parameters: parameters).responseData { response in
                guard let data = response.value  else {
                    resolver.reject(AppError(.valueNotFound))
                    return}
                resolver.fulfill(data)
            }
        }
    }
    
    // 3. Парсим data
    
    func getParseData(_ data: Data) -> Promise<[User]> {
        return Promise { resolver in
            do{
                let response = try! JSONDecoder().decode( FriendsResponse.self, from: data).response.items
                resolver.fulfill(response)
            } catch {
                resolver.reject(AppError.httpRequestFailed as! Error)
            }
        }
    }
    
    // 4. Save data
    
    func saveDataUsers(_ users: [User]) -> Promise<[User]>{
        
        return Promise { resolver in
            do{
                
               let realm = try Realm()
                print(realm.configuration.fileURL)
                realm.beginWrite()
                realm.add(users, update: .all)
                try realm.commitWrite()
                resolver.fulfill(users)
                
            } catch{
                print(error)
            }
        }
        
    }
    
// 5. Save mainUser
    
    func saveMainUser(_ users: [User]) -> Promise<[User]>{
        
        return Promise { resolver in
            do{
                let realm = try Realm()
                realm.beginWrite()
                var mainUser = realm.objects(MainUser.self).first
                mainUser?.friends.append(objectsIn: users)
            
                for i in 0 ..< users.count {
                    users[i].owner = mainUser
                }
            
                try realm.commitWrite()
                resolver.fulfill(users)
            
                } catch {
                    print(error)
                    }
        }
       
    }
    
    
    
    
 
    

    
    func getUserPhotos(token: String, idFriend: Int, completion: @escaping ([Photo]) -> Void){
        
        let path = "/method/photos.get"
        
        let parameters: Parameters = [
            "access_token" : token,
            "owner_id": idFriend,
            "album_id": "profile",
            "extended": "likes",
            "photo_sizes": "0",
            "client_id": clientId,
            "v": "5.131"
        ]
        
        let url = baseUrl+path
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value  else { return}
            let photos = try! JSONDecoder().decode( FriendPhotoResponse.self, from: data).response.items
            
            self.saveData(photos)
            
            completion(photos)
        }
        

    }
    
    
    func getUserPhotosRealm(token: String, idFriend: Int, friend: User, completion: @escaping () -> Void){
        
        let path = "/method/photos.get"
        
        let parameters: Parameters = [
            "access_token" : token,
            "owner_id": idFriend,
            "album_id": "profile",
            "extended": "likes",
            "photo_sizes": "0",
            "client_id": clientId,
            "v": "5.131"
        ]
        
        let url = baseUrl+path
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value  else { return}
            let photos = try! JSONDecoder().decode( FriendPhotoResponse.self, from: data).response.items
            
            photos.forEach { $0.owner = friend}
            
           self.saveData(photos)
            
            completion()
        }
    }
    
    
    
    
    func getUserGroups(token: String, id: Int, completion: @escaping ([Group]) -> Void){
        
        let path = "/method/groups.get"
        
        let parameters: Parameters = [
            "access_token" : token,
            "user_id": id,
            "client_id": clientId,
            "extended": "1",
            "fields": "name, photo_50",  // название и фото группы
            "v": "5.131"
        ]
        
        let url = baseUrl+path
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value  else { return}
            let groups = try! JSONDecoder().decode( GroupResponse.self, from: data).response.items
    
           self.saveData(groups)
            completion(groups)
        }
    }
    
    
    
    func getUserGroupsFirst(token: String, id: Int, completion: @escaping ([Group]) -> Void){

        let path = "/method/groups.get"

        let parameters: Parameters = [
            "access_token" : token,
            "user_id": id,
            "client_id": clientId,
            "extended": "1",
            "fields": "name, photo_50",  // название и фото группы
            "v": "5.131"
        ]

        let url = baseUrl+path

        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value  else { return}
            let groups = try! JSONDecoder().decode( GroupResponse.self, from: data).response.items

            completion(groups)
        }
    }
    
    //Поиск группы по тексту
    func getUserGroupsSearch(token: String, text: String, completion: @escaping ([Group]) -> Void){
        
        let path = "/method/groups.search"
        
        let parameters: Parameters = [
            "q": text,
            "type": "group",
            "count": "20",
            "sort": 6,
            "access_token" : token,
            "client_id": clientId,
            "v": "5.131"
        ]
        
        let url = baseUrl+path
        
        AF.request(url, parameters: parameters).responseData { response in
            guard let data = response.value  else { return}
            let groups = try! JSONDecoder().decode( GroupResponse.self, from: data).response.items
            
            
            completion(groups)
        }
    }
    
    
    
    func getGroupsAll(token: String, completion: @escaping ([Group]) -> Void){
        
        let path = "/method/groups.search"
        
        let parameters: Parameters = [
            "q": "group",
            "type": "group",
            "count": "100",
            "sort": 6,
            "access_token" : token,
            "client_id": clientId,
            "v": "5.131"
        ]
        
        let url = baseUrl+path
        
        AF.request(url, parameters: parameters).responseData { response in
            guard let data = response.value  else { return}
            let groups = try! JSONDecoder().decode( GroupResponse.self, from: data).response.items
            
            completion(groups)
        }
    }
    
    

    

    
    
    //_______________REALM

  private  func saveData  <T: Object>(_ sData: [T]){

      do{
          
         let realm = try Realm()
          print(realm.configuration.fileURL)
          realm.beginWrite()
          realm.add(sData, update: .all)
          try realm.commitWrite()
          
      } catch{
          print(error)
      }
    }
    

    
    
    func readRealm (_ sData: [Group]){
        
        do{
            
           let realm = try Realm()
            print(realm.configuration.fileURL)
            realm.beginWrite()
            var  data1 = realm.objects(Group.self)
            data1.forEach {
                print($0)
            }
            try realm.commitWrite()
            
        } catch{
            print(error)
        }
    }
    
    
    
}
