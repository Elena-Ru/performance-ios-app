//
//  NewsAuthorDataTableViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 17.10.2022.
//

import UIKit

class NewsAuthorDataTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
