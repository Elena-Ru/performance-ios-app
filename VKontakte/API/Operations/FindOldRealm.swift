//
//  FindOldRealm.swift
//  VKontakte
//
//  Created by Елена Русских on 01.11.2022.
//

import Foundation
class FindOldRealm: Operation{
    
    weak var saver: (GroupSavable)?
    var firstArray: [Group]
    var secondArray: [Group]

    init(saver: GroupSavable, firstArr: [Group], secondArr: [Group]) {
        self.saver = saver
        self.firstArray = firstArr
        self.secondArray = secondArr
    }

    override func main() {
      
        var elements = [Group]()
        firstArray.forEach {

        var isFinded = false
        for i in 0 ..< secondArray.count{
            guard !isFinded else {break}
            
            if secondArray[i].id == $0.id {
                isFinded.toggle()
                break
            }
        }
        if !isFinded {
            elements.append($0)
        }
    }
        saver?.getOldRealmGroups(groups: elements)
    }
    
}
