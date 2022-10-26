//
//  CustomNavigationController.swift
//  VKontakte
//
//  Created by Елена Русских on 11.07.2022.
//

import Foundation
import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var customInteractiveTransition = CustomInteractiveTransition()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) ->
    UIViewControllerAnimatedTransitioning? {
    if operation == .push {
        self.customInteractiveTransition.viewController = toVC
    return CustomPushAnimator()
    } else if operation == .pop {
        if navigationController.viewControllers.first != toVC {
        self.customInteractiveTransition.viewController = toVC
        }
    return CustomPopAnimator()
    }
    return nil
    }

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
        return customInteractiveTransition.hasStarted ? customInteractiveTransition : nil
    }
    
}
