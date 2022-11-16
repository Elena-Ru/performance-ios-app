//
//  NewsThreadViewController.swift
//  VKontakte
//
//  Created by Елена Русских on 17.10.2022.
//

import UIKit

class NewsThreadViewController: UIViewController {

    
    @IBOutlet weak var newsTable: UITableView!
    
    let service = Service()
    let session = Session.shared
    var newsAll = [Response]()
    var newsList = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTable.dataSource = self
        newsTable.delegate = self

        DispatchQueue.global(qos: .userInitiated).async {
            
            self.service.getNewsPost(token: self.session.token, id: self.session.userID){ [weak self] items  in
                
                guard items.response?.items?.count ?? 0 > 0  else {return}
                self?.newsList = (items.response?.items)!
                self?.newsAll.append(items.response!)
                
                self?.newsTable.reloadData()
            }
        }
    }
    

}

extension NewsThreadViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard newsList.count > 0 else {return 0}
        guard (newsList[section].attachments?.contains(where: { $0.type == .photo})) != nil
                && newsList[section].text != "" else { return 2}
        guard (newsList[section].attachments?.contains(where: { $0.type == .photo})) != nil
                || newsList[section].text != "" else { return 3}
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsAuthor", for: indexPath) as! NewsAuthorDataTableViewCell
            
            cell.configure(index: indexPath.section, news: newsAll[0])
             
           return cell
        case 1:
            if newsList[indexPath.section].text != "" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextTableViewCell
                cell.setNewsText(text: newsList[indexPath.section].text!)
               // cell.newsText.text = newsList[indexPath.section].text
                return cell
            } else {
                if newsList[indexPath.section].attachments != nil
                    && newsList[indexPath.section].attachments?.contains(where: { $0.type == .photo}) != nil {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoTableViewCell", for: indexPath) as! NewsPhotoTableViewCell
                        return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikeCommentsCell", for: indexPath) as! NewsLikeCommentsTableViewCell

                    let newsItem  = newsList[indexPath.section]
               
                    cell.configure(newsItem: newsItem, cellIndex: indexPath.section)
                    
                    return cell
                }
            }
        case 2:
            if newsList[indexPath.section].attachments != nil
                && newsList[indexPath.section].attachments?.contains(where: { $0.type == .photo}) != nil {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoTableViewCell", for: indexPath) as! NewsPhotoTableViewCell
                    return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikeCommentsCell", for: indexPath) as! NewsLikeCommentsTableViewCell
                print(indexPath.section)

                let newsItem  = newsList[indexPath.section]
           
                cell.configure(newsItem: newsItem, cellIndex: indexPath.section)
                
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikeCommentsCell", for: indexPath) as! NewsLikeCommentsTableViewCell
            print(indexPath.section)

            let newsItem  = newsList[indexPath.section]
       
            cell.configure(newsItem: newsItem, cellIndex: indexPath.section)
            
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if let cell = cell as? NewsPhotoTableViewCell  {
            
            guard newsList[indexPath.section].attachments?[0].photo?.sizes?[0].url != nil else {return}

            cell.photoNewsCollectionView.dataSource = self
            cell.photoNewsCollectionView.delegate = self
            cell.photoNewsCollectionView.tag = indexPath.section
            cell.photoNewsCollectionView.reloadData()

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == 2  && newsList[indexPath.section].attachments?[0].photo != nil{
            return 180
        } else {
            newsTable.estimatedRowHeight = 44.0
                newsTable.rowHeight = UITableView.automaticDimension
            return newsTable.rowHeight
        }
        
    }

    
}


extension NewsThreadViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsPhotoCollectionViewCell", for: indexPath) as! NewsPhotoCollectionViewCell
       
       
        if  let url = URL(string: (newsList[collectionView.tag].attachments?[indexPath.row].photo?.sizes?[0].url)!) {
            cell.setAvatar(img: url)
        }
        return cell
    }
    
    
}
