import Foundation
import UIKit

/*
 
 HOW TO USE
 
 - Animation Button:
     - Easily start animation with TKTransitionSubmitButton animate function
     - Stop animation with a completion to present a new view controller
 - Source transition controller
     - Conform `UIViewControllerTransitioningDelegate`
 
     func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
     }
     
     func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         return nil
     }
 */



// MARK: Button animation

let PINK = UIColor(red:0.992157, green: 0.215686, blue: 0.403922, alpha: 1)
let DARK_PINK = UIColor(red:0.798012, green: 0.171076, blue: 0.321758, alpha: 1)

@IBDesignable
open class TKTransitionSubmitButton : UIButton, UIViewControllerTransitioningDelegate, CAAnimationDelegate {
    
    open var didEndFinishAnimation : (()->())? = nil

    let springGoEase = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    let shrinkCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    let shrinkDuration: CFTimeInterval  = 0.1

    lazy var spiner: SpinerLayer! = {
        let s = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(s)
        return s
    }()

    @IBInspectable open var highlightedBackgroundColor: UIColor? = DARK_PINK {
        didSet {
            self.setBackgroundColor()
        }
    }
    @IBInspectable open var normalBackgroundColor: UIColor? = PINK {
        didSet {
            self.setBackgroundColor()
        }
    }

    var cachedTitle: String?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    override open var isHighlighted: Bool {
        didSet {
            self.setBackgroundColor()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.setBackgroundColor()
    }

    func setBackgroundColor() {
        if (isHighlighted) {
            self.backgroundColor = highlightedBackgroundColor
        }
        else {
            self.backgroundColor = normalBackgroundColor
        }
    }

    open func startLoadingAnimation() {
        self.cachedTitle = title(for: UIControlState())
        self.setTitle("", for: UIControlState())
        self.shrink()
        Timer.schedule(delay: shrinkDuration - 0.25) { timer in
            self.spiner.animation()
        }
    }

    open func startFinishAnimation(_ completion:(()->())?) {
        Timer.schedule(delay: 0.5) { timer in
            self.didEndFinishAnimation = completion
            self.expand()
            self.spiner.stopAnimation()
        }
    }

    open func animate() {
        startLoadingAnimation()
    }

    open func stopAnimate(_ completion:(()->())?) {
        
        startFinishAnimation(completion)
    }
    
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let a = anim as! CABasicAnimation
        if a.keyPath == "transform.scale" {
            didEndFinishAnimation?()
            Timer.schedule(delay: 1) { timer in
                self.returnToOriginalState()
            }
        }
    }
    
    func returnToOriginalState() {
        self.layer.removeAllAnimations()
        self.setTitle(self.cachedTitle, for: UIControlState())
    }
    
    func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.isRemovedOnCompletion = false
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    func expand() {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 26.0
        expandAnim.timingFunction = expandCurve
        expandAnim.duration = 0.3
        expandAnim.delegate = self
        expandAnim.fillMode = kCAFillModeForwards
        expandAnim.isRemovedOnCompletion = false
        layer.add(expandAnim, forKey: expandAnim.keyPath)
    }
    
}

// MARK: View transition

open class TKFadeInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var transitionDuration: TimeInterval = 0.5
    var startingAlpha: CGFloat = 0.0
    
    public convenience init(transitionDuration: TimeInterval, startingAlpha: CGFloat){
        self.init()
        self.transitionDuration = transitionDuration
        self.startingAlpha = startingAlpha
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        toView.alpha = startingAlpha
        fromView.alpha = 0.8
        
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { () -> Void in
            
            toView.alpha = 1.0
            fromView.alpha = 0.0
            
        }, completion: {
            _ in
            fromView.alpha = 1.0
            transitionContext.completeTransition(true)
        })
    }
}

// MARK: Timer

extension Timer {
    @discardableResult
    class func schedule(delay: TimeInterval, handler: ((Timer?) -> Void)!) -> Timer! {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, .commonModes)
        return timer
    }
}

// MARK: Spinner

class SpinerLayer :CAShapeLayer {
    
    init(frame:CGRect) {
        super.init()
        
        let radius:CGFloat = (frame.height / 2) * 0.5
        self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        let centerY = bounds.origin.y + bounds.size.height / 2
        let center = CGPoint(x: frame.height / 2, y: centerY)
        let startAngle = 0 - Double.pi / 2
        let endAngle = Double.pi * 2 - Double.pi / 2
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).cgPath
        
        self.fillColor = nil
        self.strokeColor = UIColor.white.cgColor
        self.lineWidth = 1
        
        self.strokeEnd = 0.4
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animation() {
        self.isHidden = false
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = Double.pi * 2
        rotate.duration = 0.4
        rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        rotate.repeatCount = HUGE
        rotate.fillMode = kCAFillModeForwards
        rotate.isRemovedOnCompletion = false
        self.add(rotate, forKey: rotate.keyPath)
        
    }
    
    func stopAnimation() {
        self.isHidden = true
        self.removeAllAnimations()
    }
}
