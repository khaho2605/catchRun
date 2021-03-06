//
//  JoyStick.swift
//  catchRun
//
//  Created by seehao on 14/12/25.
//  Copyright (c) 2014 LUSS. All rights reserved.
//

import Foundation
import SpriteKit

class JoyStick: SKNode {
    init(defatultArrowImage: String, activeArrowImage:String, target: PlayerNode){
        super.init()
        var upButton = JoyStickButton(defaultButtonImage: defatultArrowImage, activeButtonImage: activeArrowImage, targetPlayerNode: target, direction: Direction.Up)
        var downButton = JoyStickButton(defaultButtonImage: defatultArrowImage, activeButtonImage: activeArrowImage, targetPlayerNode: target, direction: Direction.Down)
        var leftButton = JoyStickButton(defaultButtonImage: defatultArrowImage, activeButtonImage: activeArrowImage, targetPlayerNode: target, direction: Direction.Left)
        var rightButton = JoyStickButton(defaultButtonImage: defatultArrowImage, activeButtonImage: activeArrowImage, targetPlayerNode: target, direction: Direction.Right)
        upButton.position = CGPoint(x: self.position.x, y: self.position.x + upButton.size().height / 2 + upButton.size().width / 2)
        downButton.zRotation = CGFloat(M_PI)
        downButton.position = CGPoint(x: self.position.x, y: self.position.x - downButton.size().height / 2 - downButton.size().width / 2)
        rightButton.zRotation = -CGFloat(M_PI_2)
        rightButton.position = CGPoint(x: self.position.x + rightButton.size().height / 2 + rightButton.size().width / 2, y: self.position.y)
        leftButton.zRotation = CGFloat(M_PI_2)
        leftButton.position = CGPoint(x: self.position.x - leftButton.size().height / 2 - leftButton.size().width / 2, y: self.position.y)
        addChild(upButton)
        addChild(downButton)
        addChild(rightButton)
        addChild(leftButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("needed")
    }
}

class JoyStickButton: SKNode {
    var defaultButton: SKSpriteNode
    var activeButton: SKSpriteNode
    var target: PlayerNode
    var movingDirection: Direction
    
    init(defaultButtonImage: String, activeButtonImage: String, targetPlayerNode: PlayerNode, direction: Direction){
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        activeButton = SKSpriteNode(imageNamed: activeButtonImage)
        target = targetPlayerNode
        movingDirection = direction
        super.init()
        userInteractionEnabled = true
        activeButton.hidden = true
        addChild(defaultButton)
        addChild(activeButton)
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        activeButton.hidden = false
        defaultButton.hidden = true
        target.moving(movingDirection)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: UITouch = (touches as NSSet).allObjects[0] as! UITouch
        var location: CGPoint = touch.locationInNode(self)
        
        if defaultButton.containsPoint(location) {
            activeButton.hidden = false
            defaultButton.hidden = true
        } else {
            activeButton.hidden = true
            defaultButton.hidden = false
            target.stopMoving()
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        activeButton.hidden = true
        defaultButton.hidden = false
        target.stopMoving()
    }
    
    func size() -> (width:CGFloat, height:CGFloat) {
        return (width: defaultButton.size.width, height: defaultButton.size.height)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("needed")
    }
}