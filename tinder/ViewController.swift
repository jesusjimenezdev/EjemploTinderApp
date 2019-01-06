//
//  ViewController.swift
//  tinder
//
//

import UIKit

class ViewController: UIViewController {
    
    var cardView: CardView!
    
    enum SwipeDirection {
        
        case left, right
        
    }
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        
        let recognizer = UIPanGestureRecognizer()
        
        recognizer.addTarget(self, action: #selector(cardViewPanned(recognizer:)))
        
        return recognizer
        
    }()
    
    var animator = UIViewPropertyAnimator()
    
    var currentSwipeDirection: SwipeDirection = SwipeDirection.right
    
    private var animationProgress: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createNewCard()
        
    }

    @objc func cardViewPanned(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
            
        case .began:
            
            let translation = recognizer.translation(in: cardView)
            
            if translation.x > 0 {
                
                animateSwipe(direction: SwipeDirection.right)
                
            }
            else {
                
                animateSwipe(direction: SwipeDirection.left)
                
            }
            
            animator.pauseAnimation()
            
            animationProgress = animator.fractionComplete
            
        case .changed:
            
            let translation = recognizer.translation(in: cardView)
            
            var fraction = translation.x / (view.frame.width)
            
            if currentSwipeDirection == .left {
                
                fraction *= -1
                
            }
            
            animator.fractionComplete = fraction + animationProgress
            
            if animator.fractionComplete == CGFloat(0) {
                
                if currentSwipeDirection == .left && translation.x > 0 {
                    
                    refreshAnimator(direction: .right)
                    
                }
                else if currentSwipeDirection == .right && translation.x < 0 {
                    
                    refreshAnimator(direction: .left)
                    
                }
                
            }
            
        case .ended:
            
            let velocity = recognizer.velocity(in: cardView)
            
            if velocity.x > 100 || animator.fractionComplete > 0.6 || velocity.x < -100 {
                
                animator.addCompletion { (position) in
                    
                    self.cardView.removeFromSuperview()
                    
                    self.createNewCard()
                    
                }
                
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                
                break
                
            }
            
            animator.isReversed = true
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default:
            ()
            
        }
        
    }
    
    private func refreshAnimator(direction: SwipeDirection) {
        
        currentSwipeDirection = direction
        
        animator.stopAnimation(true)
        
        animator = UIViewPropertyAnimator(duration: 0.8, curve: .easeIn, animations: {
            
            let transform = CGAffineTransform(translationX: direction == .right ? self.view.frame.width : -self.view.frame.width, y: 0)
            
            self.cardView.transform = CGAffineTransform(rotationAngle: direction == .right ? CGFloat(Double.pi / 8) : -CGFloat(Double.pi / 8)).concatenating(transform)
            
        })
        
        animator.startAnimation()
        
        animator.pauseAnimation()
        
        animationProgress = animator.fractionComplete
        
    }
    
    private func animateSwipe(direction: SwipeDirection) {
        
        if animator.isRunning { return }
        
        currentSwipeDirection = direction
        
        animator = UIViewPropertyAnimator(duration: 0.8, curve: .easeIn, animations: {
            
            let transform = CGAffineTransform(translationX: direction == .right ? self.view.frame.width : -self.view.frame.width, y: 0)
            
            self.cardView.transform = CGAffineTransform(rotationAngle: direction == .right ? CGFloat(Double.pi / 8) : -CGFloat(Double.pi / 8)).concatenating(transform)
            
            //self.cardView.transform = CGAffineTransform(translationX: self.view.frame.width / 2, y: 0)
            
        })
        
        animator.startAnimation()
        
    }
    
    func createNewCard() {
        
        cardView = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CardView
        
        cardView.frame = CGRect(x: 30, y: (view.frame.height - CGFloat(290)) / 2, width: view.frame.width - CGFloat(60), height: 290)
        
        view.addSubview(cardView)
        
        cardView.addGestureRecognizer(panRecognizer)
        
        cardView.alpha = 0
        
        cardView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 0.6) {
            
            self.cardView.alpha = 1.0
            
            self.cardView.transform = CGAffineTransform.identity
            
        }
        
    }


}

