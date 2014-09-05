//
//  GameScene.swift
//  FlappyBird
//
//  Created by Hossam Ghareeb on 9/5/14.
//  Copyright (c) 2014 AppCode. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //This variable is used to know if the game started or not
    var gameStarted = false

    var bird : SKSpriteNode
    
    init(coder aDecoder: NSCoder!)
    {
        bird = SKSpriteNode();
        super.init(coder: aDecoder);
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Scene physics, create edge loop
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        //our bird
        bird = self.childNodeWithName("bird") as SKSpriteNode
        bird.physicsBody.density = 1.5;
        bird.physicsBody.dynamic = false
        

        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
