//
//  NewsTableViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 02.07.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    var NewsViewController: UIViewController!
    
    @IBOutlet weak var newsText: UILabel!
        
    @IBOutlet weak var newsLike: LikeNewsControl!
    @IBOutlet weak var newsComment: CommentNewsControl!
    @IBOutlet weak var newsShare: ShareNewsControl!
    @IBOutlet weak var newsViewsCounter: ViewNewsCounter!
    @IBOutlet weak var newsStatistic: UIView!
    @IBOutlet weak var newsPhoto: UIImageView!
    
    var backgroundColorControlDeselect = UIColor(red: 57/255, green: 47/255, blue: 68/255, alpha: 1)
    var backgroundColorControlSelect = UIColor.systemRed.withAlphaComponent(0.3)
    var backgroundColorCell = UIColor(red: 24/255, green: 15/255, blue: 36/255, alpha: 1)
    var cornerRadius: CGFloat = 15
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        newsLike.addGestureRecognizer(tap)
    }

    
    @objc func handleTap(_: UITapGestureRecognizer){

        if newsLike.newsItem.userLikes == 1 {

            newsLike.newsItem.userLikes = 0
            newsLike.newsItem.likesCount -= 1
        newsLike.likeCount.textColor = .lightGray
        animateLikeCountAppear()
        } else {
            newsLike.newsItem.userLikes = 1
            newsLike.newsItem.likesCount += 1
            newsLike.likeCount.textColor = .systemRed
            animateLikeCountAppear()
            groupAnimation()
           }
        newsLike.setLikeButton(isLike: newsLike.newsItem.userLikes)
}

func animateLikeCountAppear(){
    UIView.transition(with: newsLike.likeCount,
                      duration: 0.5,
                      options: .transitionFlipFromRight) { [self] in
        self.newsLike.likeCount.text = String(newsLike.newsItem.likesCount)
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
    newsLike.likeButton.layer.add(groupAnimation, forKey: nil)
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
  
    func configure(newsItem: NewsItem, cellIndex: Int) {
        self.backgroundColor = backgroundColorCell
        self.newsStatistic.backgroundColor = backgroundColorCell
        self.newsText.backgroundColor = backgroundColorCell
        self.newsText.textColor = .white
        setControl(control: newsLike)
       self.newsLike.setLikeNewsControl(news: newsItem, cellIndex: cellIndex)
        setControl(control: newsComment)
        self.newsComment.setCommentNewsControl(news: newsItem, cellIndex: cellIndex)
        setControl(control: newsShare)
        self.newsShare.setShareNewsControl(news: newsItem, cellIndex: cellIndex)
        self.newsViewsCounter.backgroundColor = backgroundColorCell
        self.newsViewsCounter.setViewNewsCounter(news: newsItem)
        
   
        if newsItem.url != "" {
            let url = URL(string: (newsItem.url))
        self.newsPhoto.sd_setImage(with: url)
            self.newsText.text = newsItem.text
        } else{
            self.newsText.text = newsItem.historyText
            let url = URL(string: (newsItem.historyUrl))
        self.newsPhoto.sd_setImage(with: url)
        }
   
        
    }
    
    func setControl(control: UIControl){
        control.backgroundColor = backgroundColorControlDeselect
        control.layer.cornerRadius = cornerRadius
        control.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
    super.prepareForReuse()
    self.newsText.text = nil
    self.newsPhoto.image = nil
    }
    
    
}
