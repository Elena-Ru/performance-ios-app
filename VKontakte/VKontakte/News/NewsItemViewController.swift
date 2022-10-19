//
//  NewsItemViewController.swift
//  VKontakte
//
//  Created by Елена Русских on 03.07.2022.
//

import UIKit

class NewsItemViewController: UIViewController {
    
    var newsItem: NewsItem!

    @IBOutlet weak var newsItemTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.newsItemTable.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        
        self.newsItemTable.dataSource = self
        self.newsItemTable.delegate = self
        newsItemTable.backgroundColor = UIColor(red: 24/255, green: 15/255, blue: 36/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        newsItemTable.reloadData()
    }
}

extension NewsItemViewController: UITableViewDelegate,
                              UITableViewDataSource,
                              UITextViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return 1
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        cell.newsPhoto.contentMode = .scaleAspectFill
        cell.configure(newsItem: newsItem, cellIndex: 0)
       
        return cell
        
        }
    
}
     

