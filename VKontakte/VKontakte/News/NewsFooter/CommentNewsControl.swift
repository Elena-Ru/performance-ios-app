//
//  CommentNewsControl.swift
//  VKontakte
//
//  Created by Елена Русских on 03.07.2022.
//

import UIKit

class CommentNewsControl: UIControl {

    var newsItem: NewsItem!
    
    let commentCount  = UILabel(frame: CGRect(x: 32, y: 0, width: 30, height: 30))
    let commentButton = UIButton(frame: CGRect(x: 5, y: 0, width: 30, height: 30))
    
    func setCommentNewsControl(news : NewsItem, cellIndex: Int) {
        newsItem = news
        commentCount.text = String((news.commentsCount))
        commentButton.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        commentButton.tintColor = .lightGray
        commentCount.textColor = .lightGray
        addSubview(commentButton)
        addSubview(commentCount)
        
    }


}
