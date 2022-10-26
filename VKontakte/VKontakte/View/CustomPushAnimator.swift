//
//  CustomPushAnimator.swift
//  VKontakte
//
//  Created by Елена Русских on 11.07.2022.
//

import Foundation
import UIKit

final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else {
        return }
        guard let destination = transitionContext.viewController(forKey: .to) else {
        return }
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        
        destination.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        let deltaY  = destination.view.frame.minY
        let deltaX =  destination.view.frame.minX
        let startSourceX = source.view.frame.width


        let destinationRotate = CGAffineTransform(rotationAngle: -.pi / 2)
        let destinationTranslation = CGAffineTransform(translationX: source.view.frame.width - deltaX,
                                                       y: -deltaY)
       destination.view.transform = destinationRotate.concatenating(destinationTranslation)
        
      
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using:
        transitionContext),
        delay: 0,
        options: .calculationModePaced,
        animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: 0.75,
                           animations: {
        let translation = CGAffineTransform(translationX: -source.view.frame.width + deltaX, y: -deltaY)
                let rotation = CGAffineTransform(rotationAngle: .pi / 2)
        source.view.transform = rotation.concatenating(translation)
        })
        UIView.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: 0.5,
                           animations: {
        let translation = CGAffineTransform(translationX: startSourceX - deltaX, y: -deltaY)
            let rotation = CGAffineTransform(rotationAngle: -.pi / 2)
        destination.view.transform = rotation.concatenating(translation)
        })
        UIView.addKeyframe(withRelativeStartTime: 0.6,
                           relativeDuration: 0.4,
                           animations: {
        destination.view.transform = .identity
        })
        }) { finished in
        if finished && !transitionContext.transitionWasCancelled {
        source.view.transform = .identity
        }
        transitionContext.completeTransition(finished &&
        !transitionContext.transitionWasCancelled)
        }
         
}
}
