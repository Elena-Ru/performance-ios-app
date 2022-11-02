//
//  MainUser.swift
//  VKontakte
//
//  Created by Елена Русских on 06.08.2022.
//

import Foundation
import RealmSwift

class UserResponse: Decodable {
    let response: [MainUser]
}

class MainUser: Object, Decodable {
    @Persisted var id: Int = 0
    @Persisted var lastName: String = ""
    @Persisted var firstName: String = ""
    
    @Persisted var groups = List<Group>()
    @Persisted var friends = List<User>()
    //@Persisted var news = List<NewsItem>()

    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case id = "id"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
