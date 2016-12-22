//
//  GameScene.swift
//  Spacecraft
//
//  Created by Cassio Diego on 31/05/16.
//  Copyright (c) 2016 Cassio Diego. All rights reserved.

import SpriteKit
import CoreMotion
import AudioToolbox.AudioServices

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode = SKSpriteNode()
    var motionManager = CMMotionManager()
    var xAcceleration:CGFloat  = 0.0
    
    var lastYieldTimeIntervalRock:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalRock:TimeInterval = TimeInterval()
    
    var lastYieldTimeIntervalStar:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalStar:TimeInterval = TimeInterval()
    
    var rocksDestroyed:Int = 0
    
    struct CollisionCategories{
        static let rockCategory:UInt32 = 0x1 << 1
        static let shotCategory:UInt32 = 0x1 << 0
        static let playerCategory:UInt32 = 0x1 << 0
        static let EdgeBody: UInt32 = 0x1 << 4
    }
    
    var scoreLabel:SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        setupPlayer()
        
        setupAcelerometer()
    }

    
    override init(size:CGSize){
        
        super.init(size: size)
        
        self.view?.isMultipleTouchEnabled = false

        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.allowsRotation = false
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        var Background:SKSpriteNode = SKSpriteNode()

        self.backgroundColor = SKColor.black
        
        let screenSize = UIScreen.main.bounds
        _ = screenSize.width
        _ = screenSize.height
        
        Background = SKSpriteNode(imageNamed: "background")
        
        Background.position = CGPoint(x: (screenSize.width * 0.40), y: (screenSize.height * 0.700))
        
        Background.zPosition = 1
        
        self.addChild(Background)
        
        scoreLabel.position = CGPoint(x: (screenSize.width * 0.10), y: (screenSize.height * 0.92))
        
        scoreLabel.zPosition = 2
        
        self.addChild(scoreLabel)
        
        scoreLabelUpdate(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setupAcelerometer(){
        
        if motionManager.isAccelerometerAvailable == true {
            
            motionManager.accelerometerUpdateInterval = 0.2
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                
                data, error in
                
                let currentX = self.player.position.x
                
                if (data!.acceleration.x < 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500)}
                    
                else if (data!.acceleration.x > 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500) }
                
            })
        }
        
    }
    
    func setupPlayer(){
        
        player = SKSpriteNode(imageNamed: "spacecraft")
        player.position = CGPoint(x: self.frame.size.width/2, y: player.size.height/2 + 20)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody!.isDynamic = true
        player.physicsBody!.categoryBitMask = CollisionCategories.playerCategory
        player.physicsBody!.contactTestBitMask = CollisionCategories.rockCategory
        player.physicsBody!.categoryBitMask = CollisionCategories.EdgeBody
        player.physicsBody!.collisionBitMask = 0
        player.physicsBody!.usesPreciseCollisionDetection = true
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * 900, dy: 0)
        player.zPosition = 4
        self.addChild(player)
        
    }
    
    func setupRock(_ rockType:NSString, score:Int){
        
        let rock:SKSpriteNode = SKSpriteNode(imageNamed: rockType as String)
        
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.physicsBody!.isDynamic = true
        rock.physicsBody!.categoryBitMask = CollisionCategories.rockCategory
        rock.physicsBody!.contactTestBitMask = CollisionCategories.shotCategory
        rock.physicsBody!.contactTestBitMask = CollisionCategories.playerCategory
        rock.physicsBody!.collisionBitMask = 0
        rock.zPosition = 3
        
        let minX = rock.size.width/2
        let maxX = self.frame.size.width - rock.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(rangeX)) + CGFloat(minX)
        
        rock.position = CGPoint(x: position, y: self.frame.size.height+rock.size.height)
        
        self.addChild(rock)
        
        var minDuration = 2
        var maxDuration = 4
        
        if score > 50 {
            
            minDuration = 1
            maxDuration = 4
            
        } else if score > 100{
            
            minDuration = 1
            maxDuration = 1
            
        }
        
        let rangeDuration = maxDuration - minDuration
        
        let duration = Int(arc4random_uniform(20)) % Int(rangeDuration) + Int(minDuration)
        
        //let duration = 2
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -rock.size.height), duration:TimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        rock.run(SKAction.sequence(actionArray))
    }
    
    func setupStar(){
        
        let star:SKSpriteNode = SKSpriteNode(imageNamed: "star")
        
        star.zPosition = 2
        
        let minX = star.size.width/2
        let maxX = self.frame.size.width - star.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(rangeX)) + CGFloat(minX)
        
        star.position = CGPoint(x: position, y: self.frame.size.height+star.size.height)
        
        self.addChild(star)
        
        let minDuration = 2
        let maxDuration = 6
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random_uniform(20)) % Int(rangeDuration) + Int(minDuration)
        
        //let duration = 2
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -star.size.height), duration:TimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        star.run(SKAction.sequence(actionArray))
        
    }
    
    func updateWithTimeSinceLastUpdate(_ timeSinceLastUpdate:CFTimeInterval){
        
        lastYieldTimeIntervalRock += timeSinceLastUpdate
        
        lastYieldTimeIntervalStar += timeSinceLastUpdate
        
        var speed:Double = 3
        
        speed = speed - 0.1
        
        if (lastYieldTimeIntervalRock > 1){
            
            lastYieldTimeIntervalRock = 0
            
            setupRock("rock_1", score: 1)
        }
        
        if (lastYieldTimeIntervalStar > 0.0001){
            
            lastYieldTimeIntervalStar = 0
            
            setupStar()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let action = SKAction.moveTo(x: xAcceleration, duration: 1)
        
        self.player.run(action)
        
        var timeSinceLastUpdate = currentTime - lastUpdateTimerIntervalRock
        
        lastUpdateTimerIntervalRock = currentTime
        
        if (timeSinceLastUpdate > 1){
            
            timeSinceLastUpdate = 1/60
            
            lastUpdateTimerIntervalRock = currentTime
            
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
    }
    
    func scoreLabelUpdate(_ newscore:Int){
        
        scoreLabel.text = "\(newscore)"
        
        if(newscore > 25) && (newscore < 50){ setupRock("rock_1", score: newscore) }
        
        if(newscore > 50) { setupRock("rock_2", score: newscore) }
        
        if(newscore > 200) { setupRock("rock_3", score: newscore) }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.run(SKAction.playSoundFileNamed("Shot", waitForCompletion: false))
        
        //let touch = touches.first
        //let location = touch!.location(in: self.view)
        
        let location = CGPoint(x: player.position.x, y:player.position.y+500)
        
        let shot:SKSpriteNode = SKSpriteNode(imageNamed: "shot")
        shot.position = player.position
        shot.physicsBody = SKPhysicsBody(circleOfRadius: shot.size.width/2)
        shot.physicsBody!.isDynamic = false
        shot.physicsBody!.categoryBitMask = CollisionCategories.shotCategory
        shot.physicsBody!.contactTestBitMask = CollisionCategories.rockCategory
        shot.physicsBody!.collisionBitMask = 0
        shot.physicsBody!.usesPreciseCollisionDetection = true
        shot.zPosition = 3
        
        let offset:CGPoint = vecSub(location, b: shot.position)
        
        if (offset.y < 0){ return }
        
        self.addChild(shot)
        
        let direction:CGPoint = vecNormalize(offset)
        
        let shotLength:CGPoint = vecMult(direction, b: 300)
        
        let finalDestination:CGPoint = vecAdd(shotLength, b: shot.position)
        
        let velocity = 200/1
        
        let moveDuration:Float = Float(self.size.width) / Float(velocity)
        
        //let moveDuration:TimeInterval = 0.3
        
        var actionArray = [SKAction]()
      
        actionArray.append(SKAction.move(to: finalDestination, duration: TimeInterval(moveDuration)))
        
        actionArray.append(SKAction.removeFromParent())
        
        shot.run(SKAction.sequence(actionArray))
        
    }

    func didBegin(_ contact: SKPhysicsContact){
        
        let firstBody:SKPhysicsBody
        
        var secondBody:SKPhysicsBody
        
        var thirdBody:SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            
            firstBody = contact.bodyA
            
            secondBody = contact.bodyB
            
            thirdBody = contact.bodyB
            
        } else {
            
            firstBody = contact.bodyB
            
            secondBody = contact.bodyA
            
            thirdBody = contact.bodyB
            
        }

        if (firstBody.categoryBitMask & CollisionCategories.shotCategory) != 0 && (secondBody.categoryBitMask & CollisionCategories.rockCategory) != 0 {
            
            shotDidCollideWithRock(shot: firstBody.node as! SKSpriteNode, rock: secondBody.node as! SKSpriteNode)
            
        }
        
        if (player.position.x == firstBody.node!.position.x) || (player.position.y == firstBody.node!.position.y) || (player.position.x == thirdBody.node!.position.x) /* || (player.position.y == thirdBody.node!.position.y) */{
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            
            let score = scoreLabel.text
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene:SKScene = GameOverScene(size: self.size, won: false, score: score!)
            self.view!.presentScene(gameOverScene, transition: transition)

        }
        
        if(scoreLabel.text == "99999"){
            let score = scoreLabel.text
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene:SKScene = GameOverScene(size: self.size, won: true, score: score!)
            self.view!.presentScene(gameOverScene, transition: transition)
        }
        
    }
    
    func shotDidCollideWithRock(shot:SKSpriteNode, rock:SKSpriteNode){

        rock.removeFromParent()
    
        rocksDestroyed += 1
        
        scoreLabelUpdate(rocksDestroyed)
        
    }
    
    func vecAdd(_ a:CGPoint, b:CGPoint)->CGPoint{
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    func vecSub(_ a:CGPoint, b:CGPoint)->CGPoint{
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
    
    func vecMult(_ a:CGPoint, b:CGFloat)->CGPoint{
        return CGPoint(x: a.x * b, y: a.y * b)
    }
    
    func vecLength(_ a:CGPoint)->CGFloat{
        return CGFloat(sqrtf(CFloat(a.x)*CFloat(a.x)+CFloat(a.y)*CFloat(a.y)))
    }
    
    func vecNormalize(_ a:CGPoint)->CGPoint{
        let length:CGFloat = vecLength(a)
        return CGPoint(x: a.x / length, y: a.y / length)
    }
    
}
