//
//  AllGroupsCell.swift
//  VKontakte
//
//  Created by Елена Русских on 20.06.2022.
//

import UIKit
import SDWebImage


class AllGroupsCell: UITableViewCell {

    @IBOutlet weak var GroupName: UILabel! {
        didSet {
            GroupName.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var GroupImage: UIImageView! {
        didSet {
            GroupImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    let indents: CGFloat = 10.0
    let sizeAvatarGroup: CGFloat = 80.0
    let distanceItems: CGFloat = 30.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grupLabelFrame()
        avatarGroupFrame()
    }
    
    func getLabelSize (text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - indents * 2 - distanceItems - sizeAvatarGroup
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func grupLabelFrame() {
        
        let nameLabelSize = getLabelSize(text: GroupName.text ?? "No name", font: GroupName.font)
        let nameLabelX = indents + sizeAvatarGroup + distanceItems
        let nameLabelY = (bounds.height - GroupName.bounds.height) / 2
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        GroupName.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    func avatarGroupFrame() {
        
        let avatarSize = CGSize(width: sizeAvatarGroup, height: sizeAvatarGroup)
        let avatarX = indents
        let avatarOrigin = CGPoint(x: avatarX, y: indents)
        GroupImage.frame = CGRect(origin: avatarOrigin, size: avatarSize)
        
    }
    
    func setName (text: String) {
        
        GroupName.text = text
        grupLabelFrame()
    }


    func setAvatar(img: URL) {

        GroupImage.sd_setImage(with: img)
        avatarGroupFrame()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GroupImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        GroupImage.addGestureRecognizer(tap)

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
        self.GroupImage.layer.add(animation, forKey: nil)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
