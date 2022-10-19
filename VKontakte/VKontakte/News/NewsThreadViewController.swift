//
//  NewsThreadViewController.swift
//  VKontakte
//
//  Created by Елена Русских on 17.10.2022.
//

import UIKit
import SDWebImage

class NewsThreadViewController: UIViewController {


    @IBOutlet weak var newsTable: UITableView!
   
    var news = DataNews().news
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsTable.dataSource = self
        newsTable.delegate = self
      
    }
    

}

extension NewsThreadViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard news[section].photos != nil else { return 3}
        
        return 4

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsAuthor", for: indexPath) as! NewsAuthorDataTableViewCell
            
            cell.author.text = news[indexPath.section].author
            let url = URL(string: news[indexPath.section].avatarAuthor)
           
            print(cell.avatar.frame.size.height)
            print(cell.avatar.frame.size.width)
            cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width / 2
          
            cell.avatar.contentMode = .scaleAspectFill
            cell.avatar.clipsToBounds = true
            cell.avatar.sd_setImage(with: url)
           
            cell.date.text = news[indexPath.section].timePublication
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextTableViewCell
            
            cell.newsText.text = news[indexPath.section].text
            
            return cell
        } else if indexPath.row == 2 && news[indexPath.section].photos != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoTableViewCell", for: indexPath) as! NewsPhotoTableViewCell
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikeCommentsCell", for: indexPath) as! NewsLikeCommentsTableViewCell
            
            let newsItem  = news[indexPath.section]
       
            cell.configure(newsItem: newsItem, cellIndex: indexPath.section)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if let cell = cell as? NewsPhotoTableViewCell  {
            
            guard news[indexPath.section].photos != nil else {return}

            cell.photoNewsCollectionView.dataSource = self
            cell.photoNewsCollectionView.delegate = self
            cell.photoNewsCollectionView.tag = indexPath.section
            cell.photoNewsCollectionView.reloadData()

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == 2  && news[indexPath.section].photos != nil{
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
       
        return news[collectionView.tag].photos?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsPhotoCollectionViewCell", for: indexPath) as! NewsPhotoCollectionViewCell
       
        let url = URL(string: (news[collectionView.tag].photos?[indexPath.row])!)
        cell.newsPhoto.sd_setImage(with: url)
      
        return cell
    }
    
    
}
