//
//  AnalogClockView.swift
//  TimeLearner
//
//  Created by Ky Nguyen on 8/18/16.
//  Copyright © 2016 phuot. All rights reserved.
//

import UIKit

extension NSObject {
    func performBlock(_ block: @escaping ()->(), onQueue: DispatchQueue, afterDelay: Double) {
        onQueue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(afterDelay) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: block)
    }
    
    func performBlockOnMainQueue(_ block: @escaping ()->(), afterDelay: Double) {
        performBlock(block, onQueue: DispatchQueue.main, afterDelay: afterDelay)
    }
}

struct HandAngles {
    var hour: CGFloat = 0
    var minute: CGFloat = 0
    var second: CGFloat = 0
}

class AnalogClockView: UIView {
    var clockTimer: Timer!
    var calendar = Calendar.current
    var timeTextLabel: UILabel!
    var timeFormatter: DateFormatter!
    var oldAngles: HandAngles!
    var enterBackgroundNotification: NSObjectProtocol!
    var enterForegroundNotification: NSObjectProtocol!

    var timePeriod = "" // AM or PM
    var shouldShowTimePeriod = true
    
    fileprivate var _aDate : Date!
    var aDate: Date! {
        get { return _aDate }
        set(date) {
            _aDate = date
            setTimeAnimated(false)
        }
    }
    
    @IBOutlet weak var hourHand: UIImageView!
    @IBOutlet weak var minuteHand: UIImageView!
    @IBOutlet weak var secondHand: UIImageView!
    
    fileprivate var _running = false
    var running: Bool {
        get { return _running }
        set(isRunning) {
            _running = running
            if clockTimer != nil {
                clockTimer.invalidate()
            }
            
            if running {
                let nextSecondInterval = floor(Date.timeIntervalSinceReferenceDate + 1)
                let nextSecond = Date(timeIntervalSinceReferenceDate: nextSecondInterval)
                let newTimer = Timer(fireAt: nextSecond, interval: 1, target: self, selector: #selector(displayTime), userInfo: nil, repeats: true)
                clockTimer = newTimer
                
                RunLoop.main.add(clockTimer!, forMode: RunLoopMode(rawValue: "NSRunLoopCommonModes"))
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        enterForegroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil, using: { (note) in
            self.setTimeAnimated(true)
        })
        
        enterBackgroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: nil, using: { (note) in
            guard self.clockTimer != nil else { return }
            self.clockTimer.invalidate()
        })
    }
    
    func setupView() {
//    override func awakeFromNib() {
        let circle = CALayer()
        var bounds = layer.frame
        bounds.size.height = layer.frame.size.width
        circle.frame = bounds
        circle.cornerRadius = bounds.size.width / 2
        circle.borderWidth = 1
        circle.borderColor = UIColor.lightGray.cgColor
        circle.backgroundColor = UIColor.white.cgColor
        let position = CGPoint(x: bounds.midX, y: bounds.midY)
        circle.position = position
        layer.superlayer?.insertSublayer(circle, below: layer)
        
        //Create an array of our labels for the clock face.
        let labelString: NSArray = ["12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
//        let labelString = ["12", "3", "6", "9"]

        //Calculate the radius of the circle where we put our time labels.
        let radius = bounds.width / 2 - 20

        labelString.enumerateObjects({ (string, index, stop) in
            
            let angle = Float(CGFloat(index) * CGFloat(Double.pi) * CGFloat(2) / CGFloat(labelString.count) - CGFloat(Double.pi / 2))
            let x = CGFloat(round(cosf(angle) * Float(radius))) + self.layer.bounds.midX
            let y = CGFloat(round(sinf(angle) * Float(radius))) + self.layer.bounds.midY + 5
            
            let center = CGPoint(x: x, y: y)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 18))
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = UIColor.black
            label.center = center
            label.textAlignment = NSTextAlignment.center
            label.text = string as? String
            self.addSubview(label)
            
            //Create a label for a
            //digital time at the bottom of the clock face.
            
            if self.timeTextLabel == nil {
                self.timeTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 28))
                self.timeTextLabel.textAlignment = NSTextAlignment.center
                self.timeTextLabel.font = UIFont.boldSystemFont(ofSize: 15)
                self.timeTextLabel.center = CGPoint(x: self.layer.bounds.midX / 2,
                                                    y: self.layer.bounds.midY)
                self.timeTextLabel.layer.borderWidth = 1
                self.timeTextLabel.layer.borderColor = UIColor.black.cgColor
                self.addSubview(self.timeTextLabel)
            }
            self.setTimeAnimated(false)
            self.hourHand.alpha = 0.5
            self.minuteHand.alpha = 0.5
            self.secondHand.alpha = 0.0
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(enterBackgroundNotification)
        NotificationCenter.default.removeObserver(enterForegroundNotification)
        enterForegroundNotification = nil
        enterForegroundNotification = nil
    }

    @objc func displayTime(_ timer: Timer) {
        setTimeAnimated(true)
    }
    
    func setTimeToDate(_ date: Date, animated: Bool) {
        let angle = calculateHandAngleForDate(date)
        if !animated {
            hourHand.transform = CGAffineTransform(rotationAngle: angle.hour)
            minuteHand.transform = CGAffineTransform(rotationAngle: angle.minute)
            secondHand.transform = CGAffineTransform(rotationAngle: angle.second)
        }
        else {
            var duration: Double!
            var big_change: Bool {
                let change = fabs(Double(angle.second - oldAngles.second)) > Double.pi / 4
                duration = change ? 0.6 : 0.3
                animateHandView(secondHand, toAngle: angle.second, duration: duration)
                return change
            }
            
            performBlockOnMainQueue({ 
                var duration: Double!
                var big_change: Bool = fabs(Double(angle.minute - self.oldAngles.minute)) > Double.pi / 4
                duration = big_change ? 0.6 : 0.3;
                self.animateHandView(self.minuteHand, toAngle: angle.minute, duration: duration)
                
                big_change = fabs(Double(angle.hour - self.oldAngles.hour)) > Double.pi / 4
                duration = big_change ? 0.6 : 0.3;
                self.animateHandView(self.minuteHand, toAngle: angle.hour, duration: duration)
                }, afterDelay: 0.05)

        }
        oldAngles = angle
        if timeFormatter == nil {
            timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm:ss"
        }
        
        guard timeTextLabel != nil else { return }
        timeTextLabel.isHidden = !shouldShowTimePeriod
        timeTextLabel.text = timePeriod
    }

    func calculateHandAngleForDate(_ date: Date) -> HandAngles {
        var result = HandAngles()
        
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let timeComponent = (calendar as NSCalendar).components([NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: date)
        
        let hour = timeComponent.hour! % 12
        let minute = timeComponent.minute
        let second = timeComponent.second
        let fractionalHours = CGFloat(hour) + CGFloat(minute!) / 60.0
        
        let pi2 = CGFloat(Double.pi) * 2
        result.hour = pi2 * fractionalHours / 12
        result.minute = pi2 * CGFloat(minute!) / 60.0
        result.second = pi2 * CGFloat(second!) / 60.0
        
        timePeriod = timeComponent.hour! > 12 ? "PM" : "AM"
        return result
    }

    func animateHandView(_ handView: UIView, toAngle: CGFloat, duration: Double) {
        var damping: CGFloat = 0.2
        if duration > 0.4 {
            damping = 0.6
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveEaseIn, animations: { 
                handView.transform = CGAffineTransform(rotationAngle: toAngle)
                }, completion: nil)
        }
    }

    func setTimeAnimated(_ animated: Bool) {
        guard aDate != nil else { return }
        setTimeToDate(aDate, animated: animated)
    }
}
