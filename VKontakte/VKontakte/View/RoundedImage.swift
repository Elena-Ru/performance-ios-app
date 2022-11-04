//
//  RoundedImage.swift
//  VKontakte
//
//  Created by Елена Русских on 24.06.2022.
//

import UIKit

class RoundedImage: UIView {

    let imageView = UIImageView()
    
    let shadowView = UIView()
       
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return shadowView.layer.shadowRadius
        }
        set {
            shadowView.layer.shadowRadius = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor {
        get{
            return UIColor.init(cgColor: shadowView.layer.shadowColor!)
        }
        set {
            shadowView.layer.shadowColor = newValue.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
       var shadowOpacity : Float {
           get{
               return shadowView.layer.shadowOpacity
           }
           set {
               shadowView.layer.shadowOpacity = newValue
               setNeedsDisplay()
           }
       }
    
       override func awakeFromNib() {
           super.awakeFromNib()
           setup()
       }
       
       override func prepareForInterfaceBuilder() {
           super.prepareForInterfaceBuilder()
           setup()
       }
       
       func setup () {
           imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
           imageView.contentMode = .scaleAspectFill
           imageView.layer.cornerRadius = imageView.bounds.width / 2
           imageView.layer.masksToBounds = true
           
           
           shadowView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
           shadowView.layer.cornerRadius = shadowView.bounds.width / 2
           shadowView.layer.shadowColor = shadowColor.cgColor
           shadowView.layer.shadowOffset = .zero
           shadowView.layer.shadowRadius = shadowRadius
           shadowView.layer.shadowOpacity = shadowOpacity
           shadowView.layer.backgroundColor = UIColor.blue.cgColor
           shadowView.clipsToBounds = false
           
           addSubview(shadowView)
           addSubview(imageView)
       }
}
