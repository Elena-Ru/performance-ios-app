//
//  LikeNesThreadControll.swift
//  VKontakte
//
//  Created by Елена Русских on 19.10.2022.
//

import UIKit

class LikeNewsThreadControl: UIControl{
    var newsItem: NewsThread!
    let likeButton = UIButton(frame: CGRect(x: 5, y: 0, width: 30, height: 30))
    let likeCount  = UILabel(frame: CGRect(x: 32, y: 0, width: 50, height: 30))
    
    func setLikeNewsControl(news : NewsThread, cellIndex: Int) {
        newsItem = news
        let text: String = String((news.likeCount))
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
