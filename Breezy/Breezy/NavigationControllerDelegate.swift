//
//  NavigationControllerDelegate.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/28/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is TodayViewController && toVC is DailyWeatherDetailViewController {
            return ExpandTransitionAnimator()
        } else if fromVC is DailyWeatherDetailViewController && toVC is TodayViewController {
            return ShrinkTransitionAnimator()
        }
        
        return nil
        
    }
}
