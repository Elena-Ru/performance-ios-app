//
//  PrintOperation.swift
//  VKontakte
//
//  Created by Елена Русских on 26.10.2022.
//

import Foundation
import RealmSwift

class SaveOperation: Operation {
        
    weak var saver: (GroupSavable)?

    init(saver: GroupSavable) {
        self.saver = saver
    }

    override func main() {
        guard let parseData = dependencies.first as? DataParseOperation else {
            print("Data not parsed")
            return
        }
        let groups = parseData.outputData
        saver?.saveGroup(groups: groups)
    }
}


