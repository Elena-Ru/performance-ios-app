//
//  GroupR.swift
//  VKontakte
//
//  Created by Елена Русских on 09.08.2022.
//

import Foundation
import RealmSwift

class GroupResponse: Decodable {
    let response: Groups
}

class Groups: Decodable{
    let items: [Group]
}

class Group: Object, Decodable{
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var photoGroup: String = ""
    
    @Persisted var owner: MainUser?
    @Persisted var owners = LinkingObjects(fromType: MainUser.self, property: "groups")
    
    enum CodingKeys: String, CodingKey {
        case name
        case photoGroup = "photo_50"
        case id = "id"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
