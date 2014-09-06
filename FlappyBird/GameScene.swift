//
//  GameScene.swift
//  FlappyBird
//
//  Created by Hossam Ghareeb on 9/5/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import SpriteKit

enum ObstacleType : Int
{
    case Top = 0,
    Bottom
}

class GameScene: SKScene {
    
    //This variable is used to know if the game started or not
    var gameStarted = false
    
    //set to true when collison happened to stop the game
    var gameOver = false
    // accumelate this in update function till we reach the horizontal spacing
    // to add a new obstacle
    var spacing:CGFloat = 0.0
    
    //The speed of obstacle
    let kSpeed : CGFloat = 1.5
    //Save the size of obstacle to used in logic of removing of screen
    var obstacleSize : CGSize = CGSizeMake(0, 0);
    
    var verticalSplaceBetweenObstacles = 180
    
    //Array of current obstacles. The mutable version used to add new obstacles
    // or remove from screen
    var obstacles:NSMutableArray
    
    var bird : SKSpriteNode
    
    init(coder aDecoder: NSCoder!)
    {
        bird = SKSpriteNode();
        obstacles = NSMutableArray()
        super.init(coder: aDecoder);
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Scene physics, create edge loop
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        //our bird
        bird = self.childNodeWithName("bird") as SKSpriteNode
        bird.physicsBody.density = 0.25;
        bird.physicsBody.dynamic = false
        

        
    }
    
    func bounceMyBird()
    {
        let birdDirection  = bird.zRotation + M_PI_2
        let bounceImpulse: CFloat = 20.5
        bird.physicsBody.velocity = CGVectorMake(0, 0);
        
        var vec = CGVectorMake(CGFloat( bounceImpulse*cosf(CFloat(birdDirection))), CGFloat(
            bounceImpulse*sinf(CFloat(birdDirection))));
        
        bird.physicsBody.applyImpulse(vec);
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch : AnyObject in touches
        {
            if !gameStarted{
                gameStarted = true
                bird.physicsBody.dynamic = true
            }
            else
            {
                // bounce my bird
                bounceMyBird();
            }
        }
        
    }
    
    let kObstacleImageTop = "obstacle0.png"
    let kObstacleImageBottom  = "obstacle1.png"
    let kHorizontalSpace : CGFloat = 200
    //The horizontal space between obstacles
    
    
    func createObstacle(type: ObstacleType) -> SKSpriteNode
    {
        var fileName = kObstacleImageTop
        if type == ObstacleType.Bottom{
            fileName = kObstacleImageBottom
        }
        var obstacle = SKSpriteNode(imageNamed: fileName)

        return obstacle
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return Int(rand()) % (max - min);
    }
    
    func addObstacle()
    {
        //The top and bottom obstacle
        var top : SKSpriteNode = createObstacle(ObstacleType.Top);
        var bottom : SKSpriteNode = createObstacle(ObstacleType.Bottom);
        
        //Set the size of obstacle
        obstacleSize = top.size;
        var screenSize : CGSize = self.frame.size;
        
        var p1 : CGPoint = CGPointMake(screenSize.width + obstacleSize.width / 2, screenSize.height + obstacleSize.height / 2);
        top.position =  p1
        var p2 : CGPoint = CGPointMake(top.position.x, -obstacleSize.height / 2);
        bottom.position = p2
        
        var minimum = screenSize.height / 8
        var maximum = screenSize.height / 2
    
        var randomTopHeight : Int = randomInt(Int(minimum),  max: Int( maximum))
        
        //Add margin to top and bottom obstacles
        top.position = CGPointMake(p1.x, p1.y - CGFloat( randomTopHeight));
        
        var bottomHeight = Int(screenSize.height) - randomTopHeight - verticalSplaceBetweenObstacles
        bottom.position = CGPointMake(p2.x, p2.y + CGFloat( bottomHeight));
        
        self.addChild(top);
        self.addChild(bottom);
        
        obstacles.addObject(top)
        obstacles.addObject(bottom)
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if (!gameOver && gameStarted) {
            
            var toBeRemovedFromScene : NSMutableArray = NSMutableArray()
            spacing += kSpeed;
            
            if (spacing > (kHorizontalSpace + obstacleSize.width)) {
                spacing = 0;
                
                addObstacle();
            }
            
           
            for ob in obstacles
            {
                var obstacle = ob as SKSpriteNode
                
                obstacle.position = CGPointMake(obstacle.position.x - kSpeed, obstacle.position.y)
                if obstacle.intersectsNode(self.bird)
                {
                    gameOver = true
                    self.bird.physicsBody.dynamic = false
                }
                
                
                if (obstacle.position.x < -obstacleSize.width) {
                    //remove
                    obstacle.removeFromParent()
                    toBeRemovedFromScene.addObject(obstacle)
                }
            }
            
            self.obstacles.removeObjectsInArray(toBeRemovedFromScene)

        }
    }
}
