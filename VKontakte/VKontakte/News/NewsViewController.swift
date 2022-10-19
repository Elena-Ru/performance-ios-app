//
//  NewsViewController.swift
//  VKontakte
//
//  Created by Елена Русских on 02.07.2022.
//

import UIKit
import RealmSwift

class NewsViewController: UIViewController {
    
    let session = Session.shared
    let apiManager = APIManager()

    var newsList = [NewsItem]() // для запроса групп

    @IBOutlet weak var newsTable: UITableView!
    var realm = try! Realm()
    var token: NotificationToken?
    var newsListRealm: Results<NewsItem>?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.newsTable.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        self.newsTable.dataSource = self
        self.newsTable.delegate = self
        
        var mainUser = realm.objects(MainUser.self)
        let arrayRealm = Array(mainUser.first!.news)
        
        if arrayRealm.count > 0 {
            
            makeRequestWOSaving(realmArray: arrayRealm)
            
        } else {

            makeRequestWithSaving()
       }
        
        pairTableAndRealm()
    }
    
    
    func makeRequestWOSaving(realmArray : [NewsItem]){
        apiManager.getNewsFirst(token: session.token, id: session.userID){ [weak self] items  in

            self?.newsList = items
            let oldRealm = self?.findElements(realmArray, self!.newsList)
            print("Old values \(oldRealm?.count)")
            let newToRealm = self?.findElements(self!.newsList, realmArray)
            print("NewToRealm  \(newToRealm?.count)")
                       
            if newToRealm!.count > 0 || oldRealm!.count > 0 {
       
                self?.updateRealm(oldValues: oldRealm!, newValues: newToRealm!)

            }

        }
    }
    
    
    func updateRealm(oldValues: [NewsItem], newValues: [NewsItem]) {
        do{
            realm.beginWrite()
            let mainUser = realm.objects(MainUser.self).first
                //удалить старые и добавить новые
            if oldValues.count > 0 {
                mainUser?.news.realm?.delete(oldValues)
            }
            if newValues.count > 0 {
                mainUser?.news.append(objectsIn:  newValues)
            }
            for i in 0 ..< (self.newsList.count){
                self.newsList[i].owner = mainUser
            }

            try realm.commitWrite()
            }catch{
            print(error)
        }
    }
    
    
    
    func findElements(_ firstArray: [NewsItem], _ secondArray: [NewsItem]) -> [NewsItem] {
        
        var elements = [NewsItem]()
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
    
    func makeRequestWithSaving() {
        
        apiManager.getNewsFirst(token: session.token, id: session.userID){ [weak self] items  in
                        self?.newsList = items
        
                        do{
        
                            self?.realm.beginWrite()
                            var mainUser = self?.realm.objects(MainUser.self).first
                            mainUser?.news.append(objectsIn: items)
        
                            for i in 0 ..< ((self?.newsList.count)!){
                                self?.newsList[i].owner = mainUser
                            }
        
                            try self?.realm.commitWrite()
                        }catch{
                            print(error)
                        }
        
                        self?.newsTable.reloadData()
                    }

        }
    
    
    
    func pairTableAndRealm(){
      
        newsListRealm = realm.objects(NewsItem.self)
        
        token = newsListRealm?.observe {[weak self] ( changes: RealmCollectionChange) in
            
            guard let self = self else { return }
            
            guard let tableView = self.newsTable else {return}
            
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
   
}




extension NewsViewController: UITableViewDelegate,
                              UITableViewDataSource,
                              UITextViewDelegate{
    
    
   
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return newsListRealm?.count ?? 0
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        let newsItem  = newsListRealm?[indexPath.item]
        cell.newsPhoto.contentMode = .scaleAspectFill
        cell.prepareForReuse()
        cell.configure(newsItem: newsItem!, cellIndex: indexPath.item)
     
        return cell
        
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowNewsItem", sender: nil)
    }
    

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowNewsItem",
           let destinationVC = segue.destination as? NewsItemViewController,
           let indexPath = newsTable.indexPathForSelectedRow {
            let newsItem = newsListRealm?[indexPath.item]
            destinationVC.title = "Запись"
            destinationVC.newsItem = newsItem
            newsTable.reloadData()
        }
    }
    
}



