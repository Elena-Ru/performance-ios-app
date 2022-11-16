//
//  MyGroupsController.swift
//  VKontakte
//
//  Created by Елена Русских on 20.06.2022.
//

import UIKit
import SDWebImage
import RealmSwift
import Alamofire

protocol GroupSavable: NSObject {
    func saveGroup(groups: [Group])
    func getGroup(groups: [Group])
    func getOldRealmGroups(groups: [Group])
    func getNewToRealm(groups: [Group])
}

class MyGroupsController: UITableViewController, GroupSavable {
  
    let apiManager = APIManager()
    let session = Session.shared
    var groupsReq = [Group]()
    
    let realm = try! Realm()
    
    var token: NotificationToken?
    var groupListRealm: Results<Group>?
    
    var oldRealmGroups = [Group]()
    var newToRealmGroups = [Group]()
    
    var photoService: PhotoService?
    
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
       
        if segue.identifier == "addGroup" {
            
        let allGroupsController = segue.source as! AllGroupsController
            
        if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
            
            let group : Group
            if allGroupsController.isFiltering() {
                
                group = allGroupsController.filteredGroups[indexPath.row]
                } else {
                     group = allGroupsController.groups[indexPath.row]
                }

            if !groupListRealm!.contains(where: {$0.id == group.id}){
             
                do {
                    
                    self.realm.beginWrite()
                    let mainUser = self.realm.objects(MainUser.self).first
                    group.owner = mainUser
                    mainUser?.groups.append(group)

                    try self.realm.commitWrite()
                } catch {
                    print(error)
                }
        }
        }
        }
    }

    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "serialQueue"
        queue.qualityOfService = .utility
        return queue
    }()
  
    
    func saveGroup(groups: [Group]) {
        
        getGroup(groups: groups)
        
        do{
           let realm = try Realm()
            print(realm.configuration.fileURL)
            realm.beginWrite()
            let mainUser = realm.objects(MainUser.self).first
                mainUser?.groups.append(objectsIn: groups)
            for i in 0 ..< self.groupsReq.count{
                groupsReq[i].owner = mainUser
            }
            try realm.commitWrite()
            
        } catch{
            print(error)
        }
    }
    
    func getGroup(groups: [Group]) {
        self.groupsReq = groups
        
    }
    
    func getOldRealmGroups(groups: [Group]) {
        self.oldRealmGroups = groups
    }
    
    func getNewToRealm(groups: [Group]){
        self.newToRealmGroups = groups
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainUser = realm.objects(MainUser.self)
        let arrayRealm = Array(mainUser.first!.groups)

        if arrayRealm.count > 0 {

            makeRequestWOSaving(realmArray: arrayRealm)

        } else {

            makeRequestWithSaving()
       }
        photoService = PhotoService(container: tableView)
        pairTableAndRealm()
    }

    
    func makeRequestWOSaving(realmArray : [Group]){
        
        let path = "/method/groups.get"
        
        let parameters: Parameters = [
            "access_token" : session.token,
            "user_id": session.userID,
            "client_id": apiManager.clientId,
            "extended": "1",
            "fields": "name, photo_50",  // название и фото группы
            "v": "5.131"
        ]
        
        let url = apiManager.baseUrl+path
        let request = AF.request(url, method: .get, parameters: parameters)
        
        let getData = GetDataOperation(request: request)
        let parseData = DataParseOperation()
        let findElementsOperation = FindNewElementsOperation(saver: self)
        
        let findOldRealm = FindOldRealm(saver: self, firstArr: realmArray, secondArr: self.groupsReq)
        let findNewToRealm = FindNewToRealm(saver: self, firstArr: self.groupsReq, secondArr: realmArray)
        let updateRealm = UpdateRealm(saver: self, newGroups: self.newToRealmGroups, oldGroups: self.oldRealmGroups, requestGr: self.groupsReq)
        
        parseData.addDependency(getData)
        findElementsOperation.addDependency(parseData)
        findOldRealm.addDependency(findElementsOperation)
        findNewToRealm.addDependency(findOldRealm)
        updateRealm.addDependency(findOldRealm)
        
        queue.addOperation(getData)
        queue.addOperation(parseData)
        queue.addOperation(findElementsOperation)
        queue.addOperation(findOldRealm)
        queue.addOperation(findNewToRealm)
        OperationQueue.main.addOperation(updateRealm)
        
    }
    
    
    func makeRequestWithSaving(){
        
        let path = "/method/groups.get"
        
        let parameters: Parameters = [
            "access_token" : session.token,
            "user_id": session.userID,
            "client_id": apiManager.clientId,
            "extended": "1",
            "fields": "name, photo_50",  // название и фото группы
            "v": "5.131"
        ]
        
        let url = apiManager.baseUrl+path
        let request = AF.request(url, method: .get, parameters: parameters)
        
        let getData = GetDataOperation(request: request)
        let parseData = DataParseOperation()
        let saveOperation = SaveOperation(saver: self)
        
        parseData.addDependency(getData)
        saveOperation.addDependency(parseData)
        
        
        queue.addOperation(getData)
        queue.addOperation(parseData)
        OperationQueue.main.addOperation(saveOperation)
        
    }
    
    
    func pairTableAndRealm(){
      
        groupListRealm = realm.objects(Group.self)
        
        token = groupListRealm?.observe {[weak self] ( changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {return}
            
            switch changes {
                
            case .initial(_):
                print(1)
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print("NOTIFICATION")
              
                tableView.beginUpdates()
                
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                
                tableView.endUpdates()

            case .error(let error):
                fatalError("\(error)")
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupListRealm?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsCell
        let group = groupListRealm?[indexPath.row].name
        let url = groupListRealm?[indexPath.row].photoGroup
        let image = photoService?.photo(atIndexPath: indexPath, byUrl: url!)
        
        cell.setAvatar(img: (image ?? UIImage(named: "friend1"))!)
        cell.setName(text: group ?? "no name")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                self.realm.beginWrite()
                let mainUser = self.realm.objects(MainUser.self).first
                mainUser?.groups.realm?.delete((groupListRealm?[indexPath.row])!)
                try self.realm.commitWrite()
            } catch {
                print(error)
            }
        } 
    }
    

    
}
