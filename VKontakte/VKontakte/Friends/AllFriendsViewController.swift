//
//  AllFriendsViewController.swift
//  VKontakte
//
//  Created by Елена Русских on 29.06.2022.
//

import UIKit
import SDWebImage
import WebKit
import RealmSwift

class AllFriendsViewController: UIViewController {
    
    
    @IBOutlet weak var friendsTable: UITableView!
    
    lazy var friendsNameControl = FriendsNamesControl()
    
    let session = Session.shared
    let apiManager = APIManager()
    let realm = try! Realm()
    var mainUser = [MainUser]()
        
    var friendsList = [User]() // для запроса списка друзей
    let nName = Notification.Name("logout")
    
    var firstLetterOfTheName = [Character]()
    var filterFriends = [User]()
    var structuredFriends: [Int: [User]] = [:]
    

    @IBAction func logOut(_ sender: UIButton) {
        resetWK()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        friendsTable.dataSource = self
        friendsTable.delegate = self
        
        
        var mainUserRealm = Array(realm.objects(MainUser.self))
       
        if mainUserRealm.first != nil {
            
            self.mainUser = mainUserRealm
            self.session.userName = self.mainUser[0].firstName
            self.navigationItem.title = "Пользователь "+self.session.userName
        
        } else {
            
            apiManager.getUserInfo(token: session.token, id: session.userID) { [weak self] response in
                self!.mainUser = response
                self!.session.userName = (self?.mainUser[0].firstName)!
                self!.navigationItem.title = "Пользователь "+self!.session.userName
                self?.friendsTable?.reloadData()
            }
        }
        
        if mainUserRealm.first?.friends != nil {
            
            self.friendsList = Array(mainUserRealm.first!.friends)
            self.setFirstLettersArray()
            
            if self.firstLetterOfTheName.count != 0{
                self.friendsNameControl.createFriendsNamesControl(controller: self)
            }
            
        } else {
            
            apiManager.getUrl()
                .then(on: .global(), apiManager.getData(_:))
                .then(apiManager.getParseData(_:))
                .then(apiManager.saveDataUsers(_:))
                .then(apiManager.saveMainUser(_:))
                .done(on: .main) { users in
                
                    self.friendsList = users
                    self.setFirstLettersArray()
                    
                    if !self.firstLetterOfTheName.isEmpty {
                        self.friendsNameControl.createFriendsNamesControl(controller: self)
                    }
                    
                    self.friendsTable?.reloadData()
                    
                }.catch { error in
                    print(error)
                }

        }

        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        friendsTable.backgroundColor = UIColor(red: 24/255, green: 15/255, blue: 36/255, alpha: 1)
        
    }
    
    func resetWK(){
        
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0)) {
            
            self.session.token = ""
            NotificationCenter.default.post(name: self.nName, object: nil)
        }
    }
}

extension AllFriendsViewController: UITableViewDelegate, UITableViewDataSource{

    
    //создает массив из первых символов имен друзей
    func setFirstLettersArray (){
        for i in 0..<friendsList.count {
            guard !firstLetterOfTheName.contains(friendsList[i].firstName.first!) else {
                continue
            }
            firstLetterOfTheName.append(friendsList[i].firstName.first!)
        }
    }
    
    //кол-во секций
     func numberOfSections(in tableView: UITableView) -> Int {
         return firstLetterOfTheName.count
    }

    // заголовки для секций
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 57/255, green: 47/255, blue: 68/255, alpha: 0.5)
        let label = UILabel(frame: CGRect(x: 50, y: 2, width: 100, height: 21))
        label.text = String(firstLetterOfTheName[section])
        label.textColor = UIColor.white
        view.addSubview(label)
        return view
   }
    
    //количество строк в секции
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return friendsList.filter({ $0.firstName.first?.lowercased() == firstLetterOfTheName[section].lowercased() }).count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         
         filterFriends = friendsList.filter({
             $0.firstName.first?.lowercased() == firstLetterOfTheName[indexPath.section].lowercased()})
         structuredFriends[indexPath.section] =  filterFriends
         
         
         
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableCell", for: indexPath) as! AllFriendsTableViewCell
     
         let name = filterFriends[indexPath.row].fullName

         UIView.animate(withDuration: 0.5, animations: {
             cell.FriendName.frame.origin.y -= 100
         })
    
        cell.FriendName.text = name
         cell.backgroundColor = UIColor.clear
         cell.FriendName.textColor = UIColor.white

        for subView in cell.AvatarShadow.subviews{
            if subView is UIImageView{
                let imageView = subView as! UIImageView
                
                let url = URL(string: filterFriends[indexPath.row].photo100)
                imageView.sd_setImage(with: url)
            }
        }
         
        return cell
    }
    
    
    //Не делать переход в галерею,  если нет фоток у друга
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let indexPath = friendsTable.indexPathForSelectedRow
        let section = structuredFriends[indexPath!.section]
        let photoUrl = section?[indexPath!.row].photo100
        guard photoUrl != "https://vk.com/images/camera_100.png" else {
        
            let alertVC = UIAlertController(
                        title: "Упс :(",
                        message: "У пользователя нет загруженных фотографий",
                        preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(action)
                    self.present(alertVC, animated: true, completion: nil)
            return false}
        return true
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto",
           
            
            let destinationVC = segue.destination as? PhotoViewController,
           let indexPath = friendsTable.indexPathForSelectedRow {
            
            let section = structuredFriends[indexPath.section]
            destinationVC.title = section?[indexPath.row].firstName
            destinationVC.friendID = section?[indexPath.row].id // передаем ID для запроса фото пользователя
            destinationVC.friend = section?[indexPath.row]
        }
    }
    
    
  
}
