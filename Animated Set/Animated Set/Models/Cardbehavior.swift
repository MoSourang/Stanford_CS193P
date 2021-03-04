//
//  Cardbehavior.swift
//  Animated Set
//
//  Created by Mouhamed Sourang on 2/15/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class Cardbehavior: UIDynamicBehavior {
    
    // create a collision Behavior
    lazy var collisionBehavior: UICollisionBehavior  = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    // create item behavior
    lazy var itembehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1.0
        behavior.resistance = 0
        behavior.allowsRotation = true
        return behavior
    }()
    
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat(2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(50.0).arc4random
        push.action = { [unowned push , weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    
    func snap(item: UIDynamicItem, snapTo: CGPoint) {
        let snap = UISnapBehavior(item: item, snapTo: snapTo)
        addChildBehavior(snap)
        //        snap.action = { [unowned snap , weak self] in
        //            self?.removeChildBehavior(snap)
        //        }
    }
    
    func addItem(item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itembehavior.addItem(item)
        push(item)
    }
    
    func removeItem(item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itembehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        self.addChildBehavior(collisionBehavior)
        self.addChildBehavior(itembehavior)
    }
    
    
    convenience init(animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
        
    }
}
