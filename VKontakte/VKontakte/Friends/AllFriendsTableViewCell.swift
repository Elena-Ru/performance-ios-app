//
//  AllFriendsTableViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 24.06.2022.
//

import UIKit

class AllFriendsTableViewCell: UITableViewCell {

    var controller : AllFriendsViewController!
    let indents: CGFloat = 10.0
    let rightIndents: CGFloat = 80.0
    let sizeAvatar: CGFloat = 80.0
    
    @IBOutlet weak var AvatarShadow: UIView! {
        didSet {
            AvatarShadow.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var FriendName: UILabel! {
        didSet {
            FriendName.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        AvatarShadow.addGestureRecognizer(tap)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        friendNameFrame()
        avatarFrame()
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        
        let maxWidth = bounds.width - indents * 2 - rightIndents - sizeAvatar
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
        
    }

    func friendNameFrame() {
        
        let nameLabelSize = getLabelSize(text: FriendName.text ?? "No name", font: FriendName.font)
        let nameLabelX = indents
        let nameLabelY = (bounds.height - FriendName.bounds.height) / 2
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        FriendName.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    func avatarFrame() {
        
        let avatarSize = CGSize(width: sizeAvatar, height: sizeAvatar)
        let avatarX = bounds.width - rightIndents - sizeAvatar
        let avatarOrigin = CGPoint(x: avatarX, y: indents)
        AvatarShadow.frame = CGRect(origin: avatarOrigin, size: avatarSize)
        
    }
    
    func setName (text: String) {
        FriendName.text = text
        friendNameFrame()
    }
    
    
    func setAvatar(img: UIImage) {

        for subView in self.AvatarShadow.subviews{
            if subView is UIImageView {
                let imageView = subView as! UIImageView
                    imageView.image = img
            }
        }

        avatarFrame()
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer){

            let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.8
        animation.toValue = 1
        animation.stiffness = 20
        animation.mass = 2
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        self.AvatarShadow.layer.add(animation, forKey: nil)

    }
    
}
