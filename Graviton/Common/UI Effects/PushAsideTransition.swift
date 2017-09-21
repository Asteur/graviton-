//
//  PushAsideTransition.swift
//  Graviton
//
//  Created by Ben Lu on 4/24/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import UIKit

/// The animation that pushes and pops two views side by side like default navigation transition does, while persisting the background shared between them.
class PushAsideTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool
    var destinationBackgroundImage: UIImage?

    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let container = transitionContext.containerView
        let pushedInView = toVC.view!
        let pushedOutView = fromVC.view!
        let pushedInBeginFrame = presenting ? container.frame.offsetBy(dx: container.frame.width, dy: 0) : container.frame.offsetBy(dx: -container.frame.width, dy: 0)
        let pushedInFinalFrame = container.frame
        let pushedOutBeginFrame = container.frame
        let pushedOutFinalFrame = presenting ? container.frame.offsetBy(dx: -container.frame.width, dy: 0) : container.frame.offsetBy(dx: container.frame.width, dy: 0)

        let backgroundView = UIImageView.init(image: destinationBackgroundImage)
        backgroundView.frame = container.frame
        container.addSubview(backgroundView)

        pushedInView.frame = pushedInBeginFrame
        pushedOutView.frame = pushedOutBeginFrame
        container.addSubview(pushedInView)
        container.addSubview(pushedOutView)

        [fromVC, toVC].forEach { viewController in
            if let menuVC = viewController as? MenuWithBackground {
                menuVC.backgroundImage = nil
            }
        }

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: [.curveEaseInOut], animations: {
            pushedInView.frame = pushedInFinalFrame
            pushedOutView.frame = pushedOutFinalFrame
        }, completion: { (_) in
            let canceled = transitionContext.transitionWasCancelled

            if self.presenting {
                if let menuController = toVC as? MenuWithBackground {
                    menuController.backgroundImage = self.destinationBackgroundImage
                }
            }

            transitionContext.completeTransition(!canceled)
        })
    }
}
