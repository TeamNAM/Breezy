//
//  ExpandTransitionAnimator.swift
//  Breezy
//
//  Created by Nikrad Mahdi on 10/28/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import UIKit

class ExpandShrinkTransitionBase: NSObject {
    let ANIMATION_DURATION = 0.4
    
    func selectedCellRectFromTodayViewController(todayViewController: TodayViewController) -> CGRect {
        let tableView = todayViewController.tableView
        let indexPath = tableView.indexPathForSelectedRow!
        let cellRectInTableView = tableView.rectForRowAtIndexPath(indexPath)
        let cellYPosition = cellRectInTableView.origin.y + tableView.frame.origin.y
        var cellRect = CGRect(x: cellRectInTableView.origin.x, y: cellYPosition, width: cellRectInTableView.width, height: cellRectInTableView.height)
        cellRect = CGRectOffset(cellRect, -tableView.contentOffset.x, -tableView.contentOffset.y)
        return cellRect
    }
}

class ExpandTransitionAnimator: ExpandShrinkTransitionBase, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.ANIMATION_DURATION
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let originRect = self.selectedCellRectFromTodayViewController(fromVC as! TodayViewController)
        let destinationRect = containerView.frame
        
        toVC.view.frame = originRect
        toVC.view.alpha = 1.0
        containerView.addSubview(toVC.view)
        
        UIView.animateKeyframesWithDuration(self.ANIMATION_DURATION, delay: 0.0, options: [], animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.15, animations: { () -> Void in
                fromVC.view.alpha = 0.0
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: self.ANIMATION_DURATION, animations: { () -> Void in
                toVC.view.frame = destinationRect
            })
            
        }) { (finished: Bool) -> Void in
            fromVC.view.removeFromSuperview()
            fromVC.view.alpha = 1.0
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

class ShrinkTransitionAnimator: ExpandShrinkTransitionBase, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return ANIMATION_DURATION
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let originRect = containerView.frame
        let destinationRect = self.selectedCellRectFromTodayViewController(toVC as! TodayViewController)
        
        toVC.view.frame = originRect
        containerView.addSubview(toVC.view)
        containerView.bringSubviewToFront(fromVC.view)
        
        UIView.animateKeyframesWithDuration(ANIMATION_DURATION, delay: 0.0, options: [], animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: self.ANIMATION_DURATION, animations: { () -> Void in
                fromVC.view.frame = destinationRect
            })
            UIView.addKeyframeWithRelativeStartTime(0.35, relativeDuration: 0.05, animations: { () -> Void in
                fromVC.view.alpha = 0.1
            })
            
        }) { (finished: Bool) -> Void in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

