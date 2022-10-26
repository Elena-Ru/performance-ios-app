//
//  NewsTextTableViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 17.10.2022.
//

import UIKit
import ReadMoreTextView

class NewsTextTableViewCell: UITableViewCell {

    @IBOutlet weak var newsText: UILabel!
    var lines: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
