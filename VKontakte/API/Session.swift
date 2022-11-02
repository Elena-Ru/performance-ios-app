//
//  Session.swift
//  VKontakte
//
//  Created by Елена Русских on 02.08.2022.
//

import Foundation

class Session{
    
    static let shared = Session()
    
    private init(){}
    
    var token: String = ""
    var userID: Int = 1
    var userName: String = ""
}
