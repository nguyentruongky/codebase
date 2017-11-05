//
//  knDraggableViewCollection.swift
//  RewardShopr
//
//  Created by Ky Nguyen on 11/19/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit


import UIKit

// MARK: DRAGGABLE VIEW COLLECTION

protocol knDraggableViewCollectionDatasource {
    
    func numberOfItem(in draggableViewCollection: knDraggableViewCollection) -> Int
    
    func draggableViewCollection(draggableViewCollection: knDraggableViewCollection, itemAtIndex: Int) -> knDraggableView
}

protocol knDraggableViewCollectionDelegate {
    
    func swipeToLeft(at index: Int)
    func swipeToRight(at index: Int)
    
}

class knDraggableViewCollection: UIView, knDraggableViewDelegate {
    
    private var itemCount : Int {
        
        guard dataSource != nil else { return 0 }
        return dataSource!.numberOfItem(in: self)
    }
    
    var dataSource : knDraggableViewCollectionDatasource? {
        didSet {
            loadCards()
        }
    }
    var delegate: knDraggableViewCollectionDelegate?
    let MAX_BUFFER_SIZE = 3
    private var cardsLoadedIndex: Int = 0
    private var currentCardIndex: Int = -1
    private var onScreenCards: [knDraggableView]!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        onScreenCards = []
        cardsLoadedIndex = 0
        loadCards()
    }
    
    func reloadView() {
        clearSubviews()
        onScreenCards = []
        cardsLoadedIndex = 0
        loadCards()
    }
    
    private func createDraggableViewWithDataAtIndex(_ index: NSInteger) -> knDraggableView {
        let cardFrame = getCardFrame(at: onScreenCards.count)
        
        if let view = dataSource?.draggableViewCollection(draggableViewCollection: self, itemAtIndex: index) {

            view.frame = cardFrame
            view.delegate = self
            return view
        }
        
        let draggableView = knDraggableView(frame: cardFrame)
        draggableView.backgroundColor = UIColor.blue
        draggableView.delegate = self
        return draggableView
    }
    
    private func loadCards() {
        
        guard itemCount > 0 else { return }
        
        while onScreenCards.count < MAX_BUFFER_SIZE {
            
            let newCard = createDraggableViewWithDataAtIndex(cardsLoadedIndex)
            onScreenCards.append(newCard)
            
            insertSubview(newCard, belowSubview: onScreenCards[onScreenCards.count > 1 ? onScreenCards.count - 2 : 0])
            cardsLoadedIndex += 1
        }
    }
    
    private func updateOnScreenCards() {
        
        for i in 0 ..< onScreenCards.count {
            
            let cardFrame = getCardFrame(at: i % MAX_BUFFER_SIZE)
            let view = onScreenCards[i]
            view.frame = cardFrame
        }
    }
    
    private func getCardFrame(at index: Int) -> CGRect {
        let difference: CGFloat =  (-8) * CGFloat(index)
        return  CGRect(x: -difference,
                       y: difference + 24,
                       width: frame.size.width + difference * 2,
                       height: frame.size.height - 24)
    }
    
    func cardSwipedLeft(_ card: UIView) {
        swipeAction()
        delegate?.swipeToLeft(at: currentCardIndex)
    }
    
    func cardSwipedRight(_ card: UIView) {
        swipeAction()
        delegate?.swipeToRight(at: currentCardIndex)
    }
    
    private func swipeAction() {
        currentCardIndex += 1
        onScreenCards.remove(at: 0)
        updateOnScreenCards()
        
        if cardsLoadedIndex < itemCount  {
            loadCards()
        }
    }
    
}

// MARK: DRAGGABLE VIEW

protocol knDraggableViewDelegate {
    func cardSwipedLeft(_ card: UIView) -> Void
    func cardSwipedRight(_ card: UIView) -> Void
}

class knDraggableView: UIView {
    
    private struct EffectKitSetting {
        
        static let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
        static let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
        static let SCALE_MAX:Float = 0.93          //%%% upper bar for how much the card shrinks. Higher = shrinks less
        static let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
        static let ROTATION_STRENGTH: Float = 320  //%%% strength of rotation. Higher = weaker rotation
        static let ROTATION_ANGLE: Float = 3.14/8  //%%% Higher = stronger rotation angle
    }
    
    var delegate: knDraggableViewDelegate!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var originPoint: CGPoint!
    private var xFromCenter: Float = 0
    private var yFromCenter: Float = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(beingDragged(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func setupView() {}
    
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        xFromCenter = Float(gestureRecognizer.translation(in: self).x)
        yFromCenter = Float(gestureRecognizer.translation(in: self).y)
        
        switch gestureRecognizer.state {
            
        case UIGestureRecognizerState.began:
            self.originPoint = self.center
            
        case UIGestureRecognizerState.changed:
            self.transform = swipingEffectTransform()
            
        case UIGestureRecognizerState.ended:
            afterSwipeAction()
            
        case UIGestureRecognizerState.possible, .cancelled, .failed:
            break
        }
    }
    
    private func swipingEffectTransform() -> CGAffineTransform {
        let rotationStrength: Float = min(xFromCenter / EffectKitSetting.ROTATION_STRENGTH, EffectKitSetting.ROTATION_MAX)
        let rotationAngle = EffectKitSetting.ROTATION_ANGLE * rotationStrength
        let scale = max(1 - fabsf(rotationStrength) / EffectKitSetting.SCALE_STRENGTH, EffectKitSetting.SCALE_MAX)
        center = CGPoint(x: originPoint.x + CGFloat(xFromCenter), y: originPoint.y + CGFloat(yFromCenter))
        let transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
        return transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
    }
    
    private func afterSwipeAction() {
        
        let floatXFromCenter = Float(xFromCenter)
        if floatXFromCenter > EffectKitSetting.ACTION_MARGIN {
            
            rightAction()
        } else if floatXFromCenter < -EffectKitSetting.ACTION_MARGIN {
            
            leftAction()
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.center = self.originPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            })
        }
    }
    
    private func rightAction() {
        let finishPoint: CGPoint = CGPoint(x: 500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        swipeAction(finishPoint: finishPoint)
        delegate?.cardSwipedRight(self)
    }
    
    private func leftAction() {
        let finishPoint: CGPoint = CGPoint(x: -500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        swipeAction(finishPoint: finishPoint)
        delegate?.cardSwipedLeft(self)
    }
    
    private func swipeAction(finishPoint: CGPoint) {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.center = finishPoint
        }, completion: { (value: Bool) in
            
            self.removeFromSuperview()
        })
        
    }
}

