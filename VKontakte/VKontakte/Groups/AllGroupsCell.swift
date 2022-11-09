//
//  AllGroupsCell.swift
//  VKontakte
//
//  Created by Елена Русских on 20.06.2022.
//

import UIKit

class AllGroupsCell: UITableViewCell {

    @IBOutlet weak var GroupName: UILabel!
    
    @IBOutlet weak var GroupImage: UIImageView!
    
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
