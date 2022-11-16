//
//  NewsAuthorDataTableViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 17.10.2022.
//

import UIKit

class NewsAuthorDataTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatar: UIImageView! {
        didSet{
            avatar.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var author: UILabel! {
        didSet{
            author.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var date: UILabel! {
        didSet {
            date.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    let indents: CGFloat = 10.0
    let avatarSize: CGFloat = 60.0
    let indentItems: CGFloat = 30.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarFrame()
        authorLabelFrame()
        dateLabelFrame()
    }
    
    func avatarFrame() {
        
        let avatarSize = CGSize(width: avatarSize , height: avatarSize)
        let avatarX = indents
        let avatarOrigin = CGPoint(x: avatarX, y: indents)
        avatar.frame = CGRect(origin: avatarOrigin, size: avatarSize)
        
    }
    
    func setAvatar(url: URL) {
        avatarFrame()
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.sd_setImage(with: url)
       
    }
    
    func getLabelSize (text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - indents * 2 - indentItems - avatarSize
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func authorLabelFrame() {

        let nameLabelSize = getLabelSize(text: author.text ?? "No name", font: author.font)
        let nameLabelX = indents + avatarSize + indentItems
        let nameLabelY = indents
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        author.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    func setAuthor (text: String) {
        
        author.text = text
        authorLabelFrame()
    }
    
    func dateLabelFrame() {

        let nameLabelSize = getLabelSize(text: date.text ?? "No name", font: date.font)
        let nameLabelX = indents + avatarSize + indentItems
        let nameLabelY = indents * 2 + author.frame.height
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        date.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    func setDate(text: String) {
        
        date.text = text
        dateLabelFrame()
    }
    
    
    func configure(index: Int,  news: Response){
        var url = URL(string: "")
        
        if (news.items?[index].sourceID)! > 0{
            //profile
            setAuthor(text: news.profiles?.filter({ $0.id == (-1) * (news.items?[index].sourceID)!
            })[0].screenName ?? "No name")
            url = URL(string: news.profiles?.filter({ $0.id == (-1) * (news.items?[index].sourceID)!
            })[0].photo100  ?? "https://vk.com/images/camera_100.png")
            
        } else {
            //group
            setAuthor(text: news.groups?.filter({ $0.id == (-1) * (news.items?[index].sourceID)!
            })[0].name ?? "No name")
            url = URL(string: news.groups?.filter({ $0.id == (-1) * (news.items?[index].sourceID)!
            })[0].photo100  ?? "https://vk.com/images/camera_100.png")
        }
        setAvatar(url: url!)
       
        
        let timeResult = Double(news.items?[index].date ?? 0)
            let date = Date(timeIntervalSince1970: timeResult)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
        
        setDate(text: localDate)
    }

}
