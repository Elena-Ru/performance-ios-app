//
//  MyGroupsController.swift
//  VKontakte
//
//  Created by Елена Русских on 20.06.2022.
//

import UIKit
import SDWebImage
import RealmSwift

class MyGroupsController: UITableViewController {
    
    let apiManager = APIManager()
    let session = Session.shared
    var groupsReq = [Group]()
    
    let realm = try! Realm()
    
    var token: NotificationToken?
    var groupListRealm: Results<Group>?
    
    
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

  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainUser = realm.objects(MainUser.self)
        let arrayRealm = Array(mainUser.first!.groups)
        
        if arrayRealm.count > 0 {
            
            makeRequestWOSaving(realmArray: arrayRealm)
            
        } else {

            makeRequestWithSaving()
       }
        pairTableAndRealm()
    }

    func makeRequestWOSaving(realmArray : [Group]){
        apiManager.getUserGroupsFirst(token: session.token, id: session.userID){ [weak self] items  in

            self?.groupsReq = items
            let oldRealm = self?.findElements(realmArray, self!.groupsReq)
            print("Old values \(oldRealm?.count)")
            let newToRealm = self?.findElements(self!.groupsReq, realmArray)
            print("NewToRealm  \(newToRealm?.count)")
                       
            if newToRealm!.count > 0 || oldRealm!.count > 0 {
       
                self?.updateRealm(oldValues: oldRealm!, newValues: newToRealm!)

            }

        }
    }
    
    func updateRealm(oldValues: [Group], newValues: [Group]) {
        do{
            realm.beginWrite()
            let mainUser = realm.objects(MainUser.self).first
                //удалить старые и добавить новые
            if oldValues.count > 0 {
                mainUser?.groups.realm?.delete(oldValues)
            }
            if newValues.count > 0 {
                mainUser?.groups.append(objectsIn:  newValues)
            }
            for i in 0 ..< (self.groupsReq.count){
                self.groupsReq[i].owner = mainUser
            }

            try realm.commitWrite()
            }catch{
            print(error)
        }
    }
    
    
    
    func findElements(_ firstArray: [Group], _ secondArray: [Group]) -> [Group] {
        
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
        return elements
    }
    
    
    func makeRequestWithSaving(){
        
        apiManager.getUserGroups(token: session.token, id: session.userID){ [weak self] items  in

            self?.groupsReq = items

            do{

                self?.realm.beginWrite()
                let mainUser = self?.realm.objects(MainUser.self).first
                mainUser?.groups.append(objectsIn: items)

                for i in 0 ..< ((self?.groupsReq.count)!){
                    self?.groupsReq[i].owner = mainUser
                }

                try self?.realm.commitWrite()
            }catch{
                print(error)
            }

        }
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupListRealm?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsCell
        
        let group = groupListRealm?[indexPath.row].name
        let url = URL(string: (groupListRealm?[indexPath.row].photoGroup)!)
        cell.groupImage.sd_setImage(with: url)
        cell.groupName.text = group
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
