//
//  LikeNewsControl.swift
//  VKontakte
//
//  Created by Елена Русских on 03.07.2022.
//

import UIKit

class LikeNewsControl: UIControl {
    
    var newsItem: NewsItem!
    let likeButton = UIButton(frame: CGRect(x: 5, y: 0, width: 30, height: 30))
    let likeCount  = UILabel(frame: CGRect(x: 32, y: 0, width: 30, height: 30))
    
    func setLikeNewsControl(news : NewsItem, cellIndex: Int) {
        newsItem = news
        var text: String = String((news.likesCount))
        likeCount.text = text
        setLikeButton(isLike: (news.userLikes))
        likeCount.textColor = news.userLikes == 1 ? .systemRed : .lightGray
        likeButton.isUserInteractionEnabled = false
        likeCount.isUserInteractionEnabled = true
        addSubview(likeButton)
        addSubview(likeCount)
    }
    
    func setLikeButton(isLike: Int) {
        if isLike != 0{
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .systemRed
        }else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .lightGray
        }
    }

}
