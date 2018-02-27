//
//  GameScene.swift
//  Spacecraft
//
//  Created by Cassio Diego on 31/05/16.
//  Copyright (c) 2016 Cassio Diego. All rights reserved.

import SpriteKit
import CoreMotion
import AudioToolbox.AudioServices
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode = SKSpriteNode()
    var leftJet:SKSpriteNode = SKSpriteNode()
    var rightJet:SKSpriteNode = SKSpriteNode()
    var motionManager = CMMotionManager()
    var xAcceleration:CGFloat  = 0.0
    
    var explosion:SKSpriteNode!
    
    var fire1:SKSpriteNode!
    var fire2:SKSpriteNode!
    
    var lastYieldTimeIntervalRock:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalRock:TimeInterval = TimeInterval()
    
    var lastYieldTimeIntervalStar:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalStar:TimeInterval = TimeInterval()
    
    var lastYieldTimeIntervalAurora:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalAurora:TimeInterval = TimeInterval()
    var lastYieldTimeIntervalYellowStar:TimeInterval = TimeInterval()
    
    var rocksDestroyed:Int = 0
    //var life:Int = 3
    
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
        
        setupJetLeft(x: self.player.position.x-10, y: self.player.position.y-30)
        
        setupJetRight(x: self.player.position.x+10, y: self.player.position.y-30)
        
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
        
        Background.position = CGPoint(x: (screenSize.width * 0.40), y: (screenSize.height * 0.500))
        
        Background.zPosition = 1
        
        self.addChild(Background)
        
        scoreLabel.position = CGPoint(x: (screenSize.width * 0.10), y: (screenSize.height * 0.88))
        
        scoreLabel.zPosition = 2
        
        self.addChild(scoreLabel)
        
        scoreLabelUpdate(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setupAcelerometer(){
        
        if motionManager.isAccelerometerAvailable == true {
            
            motionManager.accelerometerUpdateInterval = 0.1
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                
                data, error in

                let currentX = self.player.position.x
                
                if (data!.acceleration.x < 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500) }
                    
                else if (data!.acceleration.x > 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500) }
                
                
            })
            
            
        }
        
    }
    
    func alreadyExist(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: key) != nil
        
    }
    
    func setupPlayer(){
        
        let ship = self.getKindShip()
        
        var spritePlayer:String = ""
        
        if (ship == 0) { spritePlayer = "spacecraft" }
            
        else if (ship == 1) { spritePlayer = "spacecraft2" }
            
        else { spritePlayer = "spacecraft"}
        
        player = SKSpriteNode(imageNamed: spritePlayer)
        player.position = CGPoint(x: self.frame.size.width/2, y: player.size.height/2 + 30)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody!.isDynamic = true
        player.physicsBody!.categoryBitMask = CollisionCategories.playerCategory
        player.physicsBody!.contactTestBitMask = CollisionCategories.rockCategory
        player.physicsBody!.categoryBitMask = CollisionCategories.EdgeBody
        player.physicsBody!.collisionBitMask = 0
        player.physicsBody!.usesPreciseCollisionDetection = true
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * 900, dy: 0)
        player.zPosition = 5
        self.addChild(player)
    }
    
    func setupJetLeft(x:CGFloat, y:CGFloat){
        let fire1Texture1 = SKTexture(imageNamed: "f-1")
        fire1Texture1.filteringMode = .nearest
        
        let fire1Texture2 = SKTexture(imageNamed: "f-2")
        fire1Texture2.filteringMode = .nearest
        
        let fire1Texture3 = SKTexture(imageNamed: "f-3")
        fire1Texture3.filteringMode = .nearest
        
        let fire1Texture4 = SKTexture(imageNamed: "f-4")
        fire1Texture4.filteringMode = .nearest
        
        let fire1Texture5 = SKTexture(imageNamed: "f-5")
        fire1Texture5.filteringMode = .nearest
        
        let fire1Texture6 = SKTexture(imageNamed: "f-6")
        fire1Texture6.filteringMode = .nearest
        
        let fire1Texture7 = SKTexture(imageNamed: "f-7")
        fire1Texture7.filteringMode = .nearest
        
        let fire1Texture8 = SKTexture(imageNamed: "f-8")
        fire1Texture8.filteringMode = .nearest
        
        let fire1Texture9 = SKTexture(imageNamed: "f-9")
        fire1Texture9.filteringMode = .nearest
        
        let fire1Texture10 = SKTexture(imageNamed: "f-10")
        fire1Texture10.filteringMode = .nearest
        
        let fire1Texture11 = SKTexture(imageNamed: "f-11")
        fire1Texture11.filteringMode = .nearest
        
        let fire1Texture12 = SKTexture(imageNamed: "f-12")
        fire1Texture12.filteringMode = .nearest
        
        let fire1Texture13 = SKTexture(imageNamed: "f-13")
        fire1Texture13.filteringMode = .nearest
        
        let fire1Texture14 = SKTexture(imageNamed: "f-14")
        fire1Texture14.filteringMode = .nearest
        
        let fire1Texture15 = SKTexture(imageNamed: "f-15")
        fire1Texture15.filteringMode = .nearest
        
        let fire1Texture16 = SKTexture(imageNamed: "f-16")
        fire1Texture16.filteringMode = .nearest
        
        let fire1Texture17 = SKTexture(imageNamed: "f-17")
        fire1Texture17.filteringMode = .nearest
        
        let fire1Texture18 = SKTexture(imageNamed: "f-18")
        fire1Texture18.filteringMode = .nearest
        
        let fire1Texture19 = SKTexture(imageNamed: "f-19")
        fire1Texture19.filteringMode = .nearest
        
        let fire1Texture20 = SKTexture(imageNamed: "f-20")
        fire1Texture20.filteringMode = .nearest
        
        let fire1Texture21 = SKTexture(imageNamed: "f-21")
        fire1Texture21.filteringMode = .nearest
        
        let fire1Texture22 = SKTexture(imageNamed: "f-22")
        fire1Texture22.filteringMode = .nearest
        
        let fire1Texture23 = SKTexture(imageNamed: "f-23")
        fire1Texture23.filteringMode = .nearest
        
        let fire1Texture24 = SKTexture(imageNamed: "f-24")
        fire1Texture24.filteringMode = .nearest
        
        let fire1Texture25 = SKTexture(imageNamed: "f-25")
        fire1Texture25.filteringMode = .nearest
        
        let fire1Texture26 = SKTexture(imageNamed: "f-26")
        fire1Texture26.filteringMode = .nearest
        
        let fire1Texture27 = SKTexture(imageNamed: "f-27")
        fire1Texture27.filteringMode = .nearest
        
        let fire1Texture28 = SKTexture(imageNamed: "f-28")
        fire1Texture28.filteringMode = .nearest
        
        let fire1Texture29 = SKTexture(imageNamed: "f-29")
        fire1Texture29.filteringMode = .nearest
        
        let fire1Texture30 = SKTexture(imageNamed: "f-30")
        fire1Texture30.filteringMode = .nearest
        
        let fire1Texture31 = SKTexture(imageNamed: "f-31")
        fire1Texture31.filteringMode = .nearest
        
        let fire1Texture32 = SKTexture(imageNamed: "f-32")
        fire1Texture32.filteringMode = .nearest
        
        let fire1Texture33 = SKTexture(imageNamed: "f-33")
        fire1Texture33.filteringMode = .nearest
        
        let fire1Texture34 = SKTexture(imageNamed: "f-34")
        fire1Texture34.filteringMode = .nearest
        
        let fire1Texture35 = SKTexture(imageNamed: "f-35")
        fire1Texture35.filteringMode = .nearest
        
        let fire1Texture36 = SKTexture(imageNamed: "f-36")
        fire1Texture36.filteringMode = .nearest
        
        let fire1Texture37 = SKTexture(imageNamed: "f-37")
        fire1Texture37.filteringMode = .nearest
        
        let fire1Texture38 = SKTexture(imageNamed: "f-38")
        fire1Texture38.filteringMode = .nearest
        
        let fire1Texture39 = SKTexture(imageNamed: "f-39")
        fire1Texture39.filteringMode = .nearest
        
        
        let anim = SKAction.animate(with: [fire1Texture1, fire1Texture2, fire1Texture3, fire1Texture4, fire1Texture5, fire1Texture6, fire1Texture7, fire1Texture8, fire1Texture9, fire1Texture10, fire1Texture11, fire1Texture12, fire1Texture13, fire1Texture14, fire1Texture15, fire1Texture16, fire1Texture17, fire1Texture18, fire1Texture19, fire1Texture20, fire1Texture21, fire1Texture22, fire1Texture23, fire1Texture24, fire1Texture25, fire1Texture26, fire1Texture27, fire1Texture28, fire1Texture29, fire1Texture30, fire1Texture31, fire1Texture32, fire1Texture33, fire1Texture34, fire1Texture35, fire1Texture36, fire1Texture37, fire1Texture38, fire1Texture39], timePerFrame: 0.09)
        
        let boom = SKAction.repeatForever(anim)
        
        fire1 = SKSpriteNode(texture: fire1Texture1)
        fire1.setScale(0.05)
        fire1.position = CGPoint(x: x, y: y)
        fire1.zPosition = 4
        
        fire1.run(boom)
        
        self.addChild(fire1)
        
    }
    
    func setupJetRight(x:CGFloat, y:CGFloat){
        
        let fire2Texture1 = SKTexture(imageNamed: "f-1")
        fire2Texture1.filteringMode = .nearest
        
        let fire2Texture2 = SKTexture(imageNamed: "f-2")
        fire2Texture2.filteringMode = .nearest
        
        let fire2Texture3 = SKTexture(imageNamed: "f-3")
        fire2Texture3.filteringMode = .nearest
        
        let fire2Texture4 = SKTexture(imageNamed: "f-4")
        fire2Texture4.filteringMode = .nearest
        
        let fire2Texture5 = SKTexture(imageNamed: "f-5")
        fire2Texture5.filteringMode = .nearest
        
        let fire2Texture6 = SKTexture(imageNamed: "f-6")
        fire2Texture6.filteringMode = .nearest
        
        let fire2Texture7 = SKTexture(imageNamed: "f-7")
        fire2Texture7.filteringMode = .nearest
        
        let fire2Texture8 = SKTexture(imageNamed: "f-8")
        fire2Texture8.filteringMode = .nearest
        
        let fire2Texture9 = SKTexture(imageNamed: "f-9")
        fire2Texture9.filteringMode = .nearest
        
        let fire2Texture10 = SKTexture(imageNamed: "f-10")
        fire2Texture10.filteringMode = .nearest
        
        let fire2Texture11 = SKTexture(imageNamed: "f-11")
        fire2Texture11.filteringMode = .nearest
        
        let fire2Texture12 = SKTexture(imageNamed: "f-12")
        fire2Texture12.filteringMode = .nearest
        
        let fire2Texture13 = SKTexture(imageNamed: "f-13")
        fire2Texture13.filteringMode = .nearest
        
        let fire2Texture14 = SKTexture(imageNamed: "f-14")
        fire2Texture14.filteringMode = .nearest
        
        let fire2Texture15 = SKTexture(imageNamed: "f-15")
        fire2Texture15.filteringMode = .nearest
        
        let fire2Texture16 = SKTexture(imageNamed: "f-16")
        fire2Texture16.filteringMode = .nearest
        
        let fire2Texture17 = SKTexture(imageNamed: "f-17")
        fire2Texture17.filteringMode = .nearest
        
        let fire2Texture18 = SKTexture(imageNamed: "f-18")
        fire2Texture18.filteringMode = .nearest
        
        let fire2Texture19 = SKTexture(imageNamed: "f-19")
        fire2Texture19.filteringMode = .nearest
        
        let fire2Texture20 = SKTexture(imageNamed: "f-20")
        fire2Texture20.filteringMode = .nearest
        
        let fire2Texture21 = SKTexture(imageNamed: "f-21")
        fire2Texture21.filteringMode = .nearest
        
        let fire2Texture22 = SKTexture(imageNamed: "f-22")
        fire2Texture22.filteringMode = .nearest
        
        let fire2Texture23 = SKTexture(imageNamed: "f-23")
        fire2Texture23.filteringMode = .nearest
        
        let fire2Texture24 = SKTexture(imageNamed: "f-24")
        fire2Texture24.filteringMode = .nearest
        
        let fire2Texture25 = SKTexture(imageNamed: "f-25")
        fire2Texture25.filteringMode = .nearest
        
        let fire2Texture26 = SKTexture(imageNamed: "f-26")
        fire2Texture26.filteringMode = .nearest
        
        let fire2Texture27 = SKTexture(imageNamed: "f-27")
        fire2Texture27.filteringMode = .nearest
        
        let fire2Texture28 = SKTexture(imageNamed: "f-28")
        fire2Texture28.filteringMode = .nearest
        
        let fire2Texture29 = SKTexture(imageNamed: "f-29")
        fire2Texture29.filteringMode = .nearest
        
        let fire2Texture30 = SKTexture(imageNamed: "f-30")
        fire2Texture30.filteringMode = .nearest
        
        let fire2Texture31 = SKTexture(imageNamed: "f-31")
        fire2Texture31.filteringMode = .nearest
        
        let fire2Texture32 = SKTexture(imageNamed: "f-32")
        fire2Texture32.filteringMode = .nearest
        
        let fire2Texture33 = SKTexture(imageNamed: "f-33")
        fire2Texture33.filteringMode = .nearest
        
        let fire2Texture34 = SKTexture(imageNamed: "f-34")
        fire2Texture34.filteringMode = .nearest
        
        let fire2Texture35 = SKTexture(imageNamed: "f-35")
        fire2Texture35.filteringMode = .nearest
        
        let fire2Texture36 = SKTexture(imageNamed: "f-36")
        fire2Texture36.filteringMode = .nearest
        
        let fire2Texture37 = SKTexture(imageNamed: "f-37")
        fire2Texture37.filteringMode = .nearest
        
        let fire2Texture38 = SKTexture(imageNamed: "f-38")
        fire2Texture38.filteringMode = .nearest
        
        let fire2Texture39 = SKTexture(imageNamed: "f-39")
        fire2Texture39.filteringMode = .nearest
        
        
        let anim = SKAction.animate(with: [fire2Texture1, fire2Texture2, fire2Texture3, fire2Texture4, fire2Texture5, fire2Texture6, fire2Texture7, fire2Texture8, fire2Texture9, fire2Texture10, fire2Texture11, fire2Texture12, fire2Texture13, fire2Texture14, fire2Texture15, fire2Texture16, fire2Texture17, fire2Texture18, fire2Texture19, fire2Texture20, fire2Texture21, fire2Texture22, fire2Texture23, fire2Texture24, fire2Texture25, fire2Texture26, fire2Texture27, fire2Texture28, fire2Texture29, fire2Texture30, fire2Texture31, fire2Texture32, fire2Texture33, fire2Texture34, fire2Texture35, fire2Texture36, fire2Texture37, fire2Texture38, fire2Texture39], timePerFrame: 0.09)
        
        let boom = SKAction.repeatForever(anim)
        
        fire2 = SKSpriteNode(texture: fire2Texture1)
        fire2.setScale(0.05)
        fire2.position = CGPoint(x: x, y: y)
        fire2.zPosition = 4
        
        fire2.run(boom)
        
        self.addChild(fire2)

    }
    
    func setupRock(_ rockType:NSString, score:Int){
        
        let rock:SKSpriteNode = SKSpriteNode(imageNamed: rockType as String)
        
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.physicsBody!.isDynamic = true
        rock.physicsBody!.categoryBitMask = CollisionCategories.rockCategory
        rock.physicsBody!.contactTestBitMask = CollisionCategories.shotCategory
        rock.physicsBody!.contactTestBitMask = CollisionCategories.playerCategory
        rock.physicsBody!.collisionBitMask = 0
        rock.zPosition = 4
        
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
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -rock.size.height), duration:TimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        rock.run(SKAction.sequence(actionArray))
    }
    
    
    func setupYellowStar(){
        
        let yellowStar:SKSpriteNode = SKSpriteNode(imageNamed: "yellowStar")
        
        yellowStar.zPosition = 3
        
        let minX = yellowStar.size.width/2
        let maxX = self.frame.size.width - yellowStar.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(rangeX)) + CGFloat(minX)
        
        yellowStar.position = CGPoint(x: position, y: self.frame.size.height+yellowStar.size.height)
        
        self.addChild(yellowStar)
        
        let minDuration = 8
        let maxDuration = 10
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random_uniform(40)) % Int(rangeDuration) + Int(minDuration)
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -yellowStar.size.height), duration:TimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        yellowStar.run(SKAction.sequence(actionArray))
        
    }
    
    func setupStar(){
        
        let star:SKSpriteNode = SKSpriteNode(imageNamed: "star")
        
        star.zPosition = 3
        
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
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -star.size.height), duration:TimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        star.run(SKAction.sequence(actionArray))
        
    }
    
    func setupAurora(){
        
        let aurora:SKSpriteNode = SKSpriteNode(imageNamed: "aurora-1")
        
        aurora.zPosition = 2
        
        let minX = aurora.size.width/2
        let maxX = self.frame.size.width - aurora.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(rangeX)) + CGFloat(minX)
        
        aurora.position = CGPoint(x: position, y: self.frame.size.height+aurora.size.height)
        
        self.addChild(aurora)
        
        let duration = 25
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -aurora.size.height), duration:TimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        aurora.run(SKAction.sequence(actionArray))
        
    }
    
    
    func setupExplosion(x:CGFloat, y:CGFloat){
        
        let explosionTexture1 = SKTexture(imageNamed: "e-1")
        explosionTexture1.filteringMode = .nearest
        
        let explosionTexture2 = SKTexture(imageNamed: "e-2")
        explosionTexture2.filteringMode = .nearest
        
        let explosionTexture3 = SKTexture(imageNamed: "e-3")
        explosionTexture3.filteringMode = .nearest
        
        let explosionTexture4 = SKTexture(imageNamed: "e-4")
        explosionTexture4.filteringMode = .nearest
        
        let explosionTexture5 = SKTexture(imageNamed: "e-5")
        explosionTexture5.filteringMode = .nearest
        
        let explosionTexture6 = SKTexture(imageNamed: "e-6")
        explosionTexture6.filteringMode = .nearest
        
        let explosionTexture7 = SKTexture(imageNamed: "e-7")
        explosionTexture7.filteringMode = .nearest
        
        let explosionTexture8 = SKTexture(imageNamed: "e-8")
        explosionTexture8.filteringMode = .nearest
        
        let explosionTexture9 = SKTexture(imageNamed: "e-9")
        explosionTexture9.filteringMode = .nearest
        
        let anim = SKAction.animate(with: [explosionTexture1, explosionTexture2, explosionTexture3, explosionTexture4, explosionTexture5, explosionTexture6, explosionTexture7, explosionTexture8, explosionTexture9], timePerFrame: 0.09)
        
        let boom = SKAction.repeatForever(anim)
        
        explosion = SKSpriteNode(texture: explosionTexture1)
        explosion.setScale(0.6)
        explosion.position = CGPoint(x: x, y: y)
        explosion.zPosition = 6

        explosion.run(boom)
 
        self.addChild(explosion)
    }
    
    func updateWithTimeSinceLastUpdate(_ timeSinceLastUpdate:CFTimeInterval){
        
        lastYieldTimeIntervalRock += timeSinceLastUpdate
        
        lastYieldTimeIntervalStar += timeSinceLastUpdate
        
        lastYieldTimeIntervalAurora += timeSinceLastUpdate
        
        lastYieldTimeIntervalYellowStar += timeSinceLastUpdate
        
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
        
        if (lastYieldTimeIntervalAurora > 5){
            
            lastYieldTimeIntervalAurora = 0
            
            setupAurora()
        }
        
        if (lastYieldTimeIntervalYellowStar > 1){
            
            lastYieldTimeIntervalYellowStar = 0
            
            setupYellowStar()
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let action = SKAction.moveTo(x: xAcceleration, duration: 1)
        
        let actionJetLeft = SKAction.moveTo(x: xAcceleration-10, duration: 1)
        
        let actionJetRight = SKAction.moveTo(x: xAcceleration+10, duration: 1)

        self.player.run(action)
        
        self.fire1.run(actionJetLeft)
        
        self.fire2.run(actionJetRight)
        
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
    
    func getKindShip() -> Int {
        
        let playerChoosedShip = alreadyExist(key: "ship")
        
        if playerChoosedShip == false { UserDefaults.standard.set(0, forKey: "ship") }
        
        return UserDefaults.standard.object(forKey: "ship")! as! Int
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let soundIsOn = UserDefaults.standard.bool(forKey: "soundStatus")
        
        if soundIsOn{ self.run(SKAction.playSoundFileNamed("Shot", waitForCompletion: false)) }
        
        //let touch = touches.first
        //let location = touch!.location(in: self.view)
        
        let location = CGPoint(x: player.position.x, y:player.position.y+500)
        
        let ship = self.getKindShip()
        
        var spriteShot:String = ""
        
        if (ship == 0) { spriteShot = "shot" }
            
        else if (ship == 1) { spriteShot = "shot2" }
            
        else { spriteShot = "shot"}
        
        let shot:SKSpriteNode = SKSpriteNode(imageNamed: spriteShot)
        
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

        if (firstBody.categoryBitMask & CollisionCategories.shotCategory) != 0 && (secondBody.categoryBitMask & CollisionCategories.rockCategory) != 0
        {
            if(firstBody.node != nil && secondBody.node != nil){
                shotDidCollideWithRock(shot: firstBody.node as! SKSpriteNode, rock: secondBody.node as! SKSpriteNode)
            }
        }
        
        if (player.position.x == firstBody.node!.position.x) || (player.position.y == firstBody.node!.position.y) || (player.position.x == thirdBody.node!.position.x) || (player.position.y == thirdBody.node!.position.y) {
            
            setupExplosion(x: player.position.x, y: player.position.y)
        
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            
            //life = life - 1
            //if life == 0 {
                let score = scoreLabel.text
                let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene:SKScene = GameOverScene(size: self.size, won: false, score: score!)
                self.view!.presentScene(gameOverScene, transition: transition)
            //}
            
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
