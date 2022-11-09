//
//  AllFriendsTableViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 24.06.2022.
//

import UIKit

class AllFriendsTableViewCell: UITableViewCell {

    var controller : AllFriendsViewController!
    @IBOutlet weak var AvatarShadow: UIView!
    
    @IBOutlet weak var FriendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        AvatarShadow.addGestureRecognizer(tap)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
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
