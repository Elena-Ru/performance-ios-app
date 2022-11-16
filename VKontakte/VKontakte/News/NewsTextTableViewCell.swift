//
//  NewsTextTableViewCell.swift
//  VKontakte
//
//  Created by Елена Русских on 17.10.2022.
//

import UIKit

class NewsTextTableViewCell: UITableViewCell {

    @IBOutlet weak var newsText: UILabel! {
        didSet{
            newsText.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    let indents: CGFloat = 10.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabelFrame()

    }
    
    func getTextSize (text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - indents * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func textLabelFrame() {

        let nameLabelSize = getTextSize(text: newsText.text ?? "No name", font: newsText.font)
        let nameLabelX = indents
        let nameLabelY = indents
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        newsText.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    func setNewsText (text: String) {
        
        newsText.text = text
        textLabelFrame()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
