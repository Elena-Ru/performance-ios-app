//
//  NewsLikeCommentsTableViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 17.10.2022.
//

import UIKit

class NewsLikeCommentsTableViewCell: UITableViewCell {

   
    @IBOutlet weak var likeNewsControl: LikeNewsThreadControl!
    

    @IBOutlet weak var commentsNewsControl: CommentCountControl!
    
    var cornerRadius: CGFloat = 15
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        likeNewsControl.addGestureRecognizer(tap)
    }

    
    @objc func handleTap(_: UITapGestureRecognizer){

        if likeNewsControl.newsItem.likes?.userLikes == 1 {

            likeNewsControl.newsItem.likes?.userLikes = 0
            likeNewsControl.newsItem.likes?.count! -= 1
            likeNewsControl.likeCount.textColor = .lightGray
        animateLikeCountAppear()
        } else {
            likeNewsControl.newsItem.likes?.userLikes = 1
            likeNewsControl.newsItem.likes?.count! += 1
            likeNewsControl.likeCount.textColor = .systemRed
            animateLikeCountAppear()
            groupAnimation()
           }
        likeNewsControl.setLikeButton(isLike: likeNewsControl.newsItem.likes?.userLikes ?? 0)
}

func animateLikeCountAppear(){
    UIView.transition(with: likeNewsControl.likeCount,
                      duration: 0.5,
                      options: .transitionFlipFromRight) { [self] in
        self.likeNewsControl.likeCount.text = String(likeNewsControl.newsItem.likes?.count ?? 0)
}
}

func groupAnimation(){
    let groupAnimation = CAAnimationGroup()
    groupAnimation.beginTime = CACurrentMediaTime() + 0.5
    groupAnimation.duration = 0.5

    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 3.5
    scaleDown.toValue = 1.0
    let fade = CABasicAnimation(keyPath: "opacity")
    fade.fromValue = 0.0
    fade.toValue = 1.0

    groupAnimation.animations = [scaleDown,fade]
    likeNewsControl.likeButton.layer.add(groupAnimation, forKey: nil)
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
  
    func configure(newsItem: Item, cellIndex: Int) {
    
        setControl(control: likeNewsControl)
       self.likeNewsControl.setLikeNewsControl(news: newsItem, cellIndex: cellIndex)
        setControl(control: commentsNewsControl)
       self.commentsNewsControl.setCommentNewsControl(news: newsItem, cellIndex: cellIndex)

   
        
    }
    
    func setControl(control: UIControl) {
        control.layer.cornerRadius = cornerRadius
        control.layer.masksToBounds = true
    }

    
    
}
