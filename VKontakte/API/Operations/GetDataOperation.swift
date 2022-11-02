//
//  GetDataOperation.swift
//  VKontakte
//
//  Created by Елена Русских on 26.10.2022.
//

import Foundation
import Alamofire

class GetDataOperation: AsyncOperation {
    private var request: DataRequest
    var data: Data?
    
    init(request: DataRequest) {
        self.request = request
    }
    
    override func main() {
        request.responseData(queue: .global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
            print("data loaded")
        }
        print("GetDataOperation finished")
    }
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
}
