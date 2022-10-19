//
//  User.swift
//  VKontakte
//
//  Created by Елена Русских on 07.08.2022.
//

import Foundation
import RealmSwift

class FriendsResponse: Decodable {
    let response: Friends
}

class Friends: Decodable {
    let items: [User]
    
}

class User: Object, Decodable {
    @Persisted var id: Int = 0
    @Persisted var photo100: String = ""
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var fullName: String = ""
    @Persisted var isRealm: Bool = false
    
    @Persisted var photos = List<Photo>()
    @Persisted var owner: MainUser?
    @Persisted var owners = LinkingObjects(fromType: MainUser.self, property: "friends")

    enum CodingKeys: String, CodingKey {
        case id
        case photo100 = "photo_100"
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.photo100 = try values.decode(String.self, forKey: .photo100)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.fullName = self.firstName + " " + self.lastName
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
