//
//  CustomSegue.swift
//  Happiness Calculator
//
//  Created by Charles on 2/19/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit

class SegueFromLeft: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { dst.view.transform = CGAffineTransform(translationX: 0, y: 0) },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        })
    }
}

class SegueFromRight: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { dst.view.transform = CGAffineTransform(translationX: 0, y: 0) },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        })
    }
}

class ScaleSegue: UIStoryboardSegue {
    override func perform() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }) { (success) in
            fromViewController.present(toViewController, animated: false, completion: nil)
        }
        
        
    }
}

class DissolveSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.alpha = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .transitionCrossDissolve,
                       animations: { dst.view.alpha = 1 },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        })
    }
}
