//
//  DataParseOperation.swift
//  VKontakte
//
//  Created by Елена Русских on 26.10.2022.
//

import Foundation

class DataParseOperation : Operation{
    
    private(set) var outputData: [Group] = []
    private let decoder = JSONDecoder()
    
    override func main() {
        guard let getDataOperation = dependencies.first(where: { $0 is GetDataOperation}) as? GetDataOperation, let data = getDataOperation.data
        else {
            print("Data not loaded")
            return
        }
        do{
            let groups = try! JSONDecoder().decode( GroupResponse.self, from: data).response.items
            outputData = groups
        } catch {
            print("Data to decode failed")
        }
    }
}
