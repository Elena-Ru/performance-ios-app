//
//  LikePhotoControl.swift
//  VKontakte
//
//  Created by Елена Русских on 27.06.2022.
//


import UIKit

class LikePhotoControl: UIControl {

    var photoLikeCount: Int = 0 //here you need like count from request
    var photoIsLike: Int = 0 //here you need isLike from request
    let likeCount  = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let likeButton = UIButton(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
    let likePhoto: UIImage? = nil


    @objc func  likeButtonPressed(sender:UIButton){

        if photoIsLike != 0 {

            photoLikeCount -= 1
            photoIsLike = 0
            likeCount.textColor = .systemBlue
            animateLikeCountAppear()
            } else {
                photoLikeCount += 1
                photoIsLike = 1
                likeCount.textColor = .systemRed
                animateLikeCountAppear()
                rotateLikeCount()
                groupAnimation()
               }
        setLikeButton(isLike: photoIsLike)
    }

    func animateLikeCountAppear(){
        UIView.transition(with: likeCount,
                          duration: 0.5,
                          options: .transitionFlipFromRight) { [self] in
            likeCount.text = String(photoLikeCount)
    }
    }

    func rotateLikeCount() {
            let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = NSNumber(value: Double.pi * 2)
            rotation.duration = 1
            rotation.isCumulative = true
            rotation.repeatCount = 1
            likeCount.layer.add(rotation, forKey: "rotationAnimation")
        }

    func groupAnimation(){
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime() + 0.5
        groupAnimation.duration = 0.5

        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 3.5
        scaleDown.toValue = 1.0
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = .pi/10.0
        rotate.toValue = 0.0
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0

        groupAnimation.animations = [scaleDown, rotate,fade]
        likeButton.layer.add(groupAnimation, forKey: nil)
    }

    //сюда передали количество лайков и лайкнул ли пользователь фотку
    func setPhotoUser(isUserLike : Int, likesCount: Int, cellIndex: Int) {
        photoLikeCount = likesCount
        photoIsLike = isUserLike
        likeCount.text = String(likesCount)
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        likeButton.isUserInteractionEnabled = true
        likeCount.isUserInteractionEnabled = false
        setLikeButton(isLike: isUserLike)
        
        if   isUserLike == 0{
            likeCount.textColor = .systemBlue
        } else{
            likeCount.textColor = .systemRed
        }

        addSubview(likeButton)
        addSubview(likeCount)
    }

    func setLikeButton(isLike: Int) {
        if isLike != 0{
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .systemRed
        }else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .lightGray
        }
    }
}
