//
//  NewsAuthorDataTableViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 17.10.2022.
//

import UIKit

class NewsAuthorDataTableViewCell: UITableViewCell {

    
   // var newsVC: NewsThreadViewController!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func configure(index: Int,  news: Response){
        var url = URL(string: "")
        
        if (news.items?[index].sourceID)! > 0{
            //profile
            self.author.text = news.profiles?.filter({ $0.id == (-1) * (news.items?[index].sourceID)!
            })[0].screenName
            url = URL(string: news.profiles?.filter({ $0.id == (-1) * (news.items?[index].sourceID)!
            })[0].photo100  ?? "https://vk.com/images/camera_100.png")
            
        } else {
            //group
            self.author.text = news.groups?.filter({ $0.id == (-1) * (news.items?[index].sourceID)!
            })[0].name
            url = URL(string: news.groups?.filter({ $0.id == (-1) * (news.items?[index].sourceID)!
            })[0].photo100  ?? "https://vk.com/images/camera_100.png")
        }
  
        self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2
        self.avatar.contentMode = .scaleAspectFill
        self.avatar.clipsToBounds = true
        self.avatar.sd_setImage(with: url)
       
        
        let timeResult = Double(news.items?[index].date ?? 0)
            let date = Date(timeIntervalSince1970: timeResult)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
        

        self.date.text = localDate
    }

}
