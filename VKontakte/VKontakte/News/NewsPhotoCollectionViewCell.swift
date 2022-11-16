//
//  NewsPhotoCollectionViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 18.10.2022.
//

import UIKit
import SDWebImage

class NewsPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsPhoto: UIImageView! {
        didSet {
            newsPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageNewsCostraint()
    }
    
    func imageNewsCostraint() {
        
        NSLayoutConstraint.activate([
            newsPhoto.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            newsPhoto.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            newsPhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }

    func setAvatar(img: URL) {
       
        newsPhoto.sd_setImage(with: img)
        imageNewsCostraint()
    }
    
}
