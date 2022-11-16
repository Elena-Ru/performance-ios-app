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
    let userService = UserService()
    let authService = AuthService()
    let realm = try! Realm()
    var mainUser = MainUser()
    var friendsList = [User]()
    var firstLetterOfTheName = [Character]()
    var filterFriends = [User]()
    var structuredFriends: [Int: [User]] = [:]
    var photoService: PhotoService?

    @IBAction func logOut(_ sender: UIButton) {
        authService.resetWK()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        friendsTable.dataSource = self
        friendsTable.delegate = self
    
        let mainUserRealmAr = Array(realm.objects(MainUser.self))
      
        let mainUserRealm = mainUserRealmAr.isEmpty ? nil : mainUserRealmAr[0]
        
        if mainUserRealm != nil {
            let mainUserRealmSafe = ThreadSafeReference(to: mainUserRealm!)
            Dispatch.background {
                
                let realmBackground = try! Realm()
                guard let data = realmBackground.resolve(mainUserRealmSafe) else {
                    return
                }
                self.userService.setMainUser(data, self)
                
                Dispatch.main {
                    
                    self.navigationItem.title = "Пользователь "+self.session.userName
                    
                }
            }
        } else {
            
            Dispatch.background {

                self.userService.creatMainUser(mainUserRealm, self)
             
            }
        }
        
        if mainUserRealmAr.first?.friends != nil {
            
            self.friendsList = Array(mainUserRealmAr.first!.friends)
            self.userService.setFirstLettersArray(self.friendsList, &self.firstLetterOfTheName)
            
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
                    self.userService.setFirstLettersArray(self.friendsList, &self.firstLetterOfTheName)
                    
                    if !self.firstLetterOfTheName.isEmpty {
                        self.friendsNameControl.createFriendsNamesControl(controller: self)
                    }
                    self.navigationItem.title = "Пользователь "+self.session.userName
                    self.friendsTable?.reloadData()
                    
                }.catch { error in
                    print(error)
                }

        }
        photoService = PhotoService(container: friendsTable)
        friendsTable.sectionHeaderTopPadding = 0.0
      
    }

}

extension AllFriendsViewController: UITableViewDelegate, UITableViewDataSource {

    
     func numberOfSections(in tableView: UITableView) -> Int {
         return firstLetterOfTheName.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9599501491, green: 0.9648430943, blue: 0.9819943309, alpha: 1)
        let label = UILabel(frame: CGRect(x: 50, y: 2, width: 100, height: 21))
        label.text = String(firstLetterOfTheName[section])
        label.font = .boldSystemFont(ofSize: 16)
        view.addSubview(label)
        return view
   }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return friendsList.filter({ $0.firstName.first?.lowercased() == firstLetterOfTheName[section].lowercased() }).count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         
         filterFriends = friendsList.filter({ $0.firstName.first?.lowercased() == firstLetterOfTheName[indexPath.section].lowercased() })
         structuredFriends[indexPath.section] =  filterFriends
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableCell", for: indexPath) as! AllFriendsTableViewCell
         
         let friend = filterFriends[indexPath.row]
         let name = friend.fullName

         UIView.animate(withDuration: 0.5, animations: {
             cell.FriendName.frame.origin.y -= 100
         })
         
         cell.setName(text: name)
         let imageView = photoService?.photo(atIndexPath: indexPath, byUrl: friend.photo100) ?? UIImage(named: "friend1")
         cell.setAvatar(img: (imageView ?? UIImage(named: "friend1"))!)
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    

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
            destinationVC.friendID = section?[indexPath.row].id
            destinationVC.friend = section?[indexPath.row]
        }
    }
  
}
