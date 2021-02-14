//
//  RMPZoomTransitonNavigationController.swift
//  AnimatingTransitionDemo
//
//  Created by Vikash Kumar on 08/04/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class RMPZoomTransitonNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let zoomAnimator = RMPZoomTransitionAnimator()
        zoomAnimator.goingForward = operation == UINavigationControllerOperation.push
        zoomAnimator.sourceTransition = fromVC as!  (RMPZoomTransitionAnimating & RMPZoomTransitionDelegate)

        
        zoomAnimator.destinationTransition = toVC as! (RMPZoomTransitionAnimating & RMPZoomTransitionDelegate)
        return zoomAnimator
    }
}
