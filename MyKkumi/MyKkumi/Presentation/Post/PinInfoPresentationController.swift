//
//  PinInfoPresentationController.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/7/24.
//

import Foundation
import UIKit

class PinInfoPresentationController : UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        let width = containerView.bounds.width
        let height : CGFloat = 152
        let x : CGFloat = .zero
        let y = containerView.bounds.height - height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
        containerView.addSubview(dimmingView)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1.0
        })
        
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.containerView?.subviews.first?.alpha = 0.0
        })
    }
}

final class PinInfoPresentationControllerDelegate : NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PinInfoPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
