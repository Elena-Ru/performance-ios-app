//
//  CommentsCountControl.swift
//  VKontakte
//
//  Created by Елена Русских on 19.10.2022.
//
import Foundation
import UIKit

class CommentCountControl: UIControl {

    var newsItem: Item!
    
    let commentCount  = UILabel(frame: CGRect(x: 32, y: 0, width: 30, height: 30))
    let commentButton = UIButton(frame: CGRect(x: 5, y: 0, width: 30, height: 30))
    
    func setCommentNewsControl(news : Item, cellIndex: Int) {
        newsItem = news
        let text: String = String(news.comments?.count ?? 0)
        commentCount.text = text
        commentButton.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        commentButton.tintColor = .lightGray
        commentCount.textColor = .lightGray
        addSubview(commentButton)
        addSubview(commentCount)
        
    }


}
