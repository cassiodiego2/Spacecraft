//
//  GameOverScene.swift
//  Spacecraft
//
//  Created by Cassio Diego on 31/05/16.
//  Copyright (c) 2016 Cassio Diego. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameKit

class GameOverScene: SKScene {
    
    var Background:SKSpriteNode = SKSpriteNode()
    
    //let buttonHome:SKSpriteNode = SKSpriteNode(imageNamed: "back")
    
    var viewController: UIViewController?
    
    init(size:CGSize, won:Bool, score:String){
        
        super.init(size: size)
        
        let preferredLanguage = NSLocale.preferredLanguages[0] as String

        self.backgroundColor = SKColor.black
        
        var message:NSString = NSString()
        var scoreLabel:NSString = NSString()
        
        let screenSize = UIScreen.main.bounds
        _ = screenSize.width
        _ = screenSize.height
        
        Background = SKSpriteNode(imageNamed: "background")
        Background.position = CGPoint(x: (screenSize.width * 0.40), y: (screenSize.height * 0.700))
        
        if (won){
            if preferredLanguage == "pt-BR" {
                message = "VOCÊ GANHOU, PARABÉNS!"
                scoreLabel = "SCORE: \(score)" as NSString
            } else {
                message = "YOU WIN, CONGRATULATIONS!"
                scoreLabel = "SCORE: \(score)" as NSString
            }
        } else {
            
            if preferredLanguage == "pt-BR" {

                message = "VOCÊ PERDEU"
                scoreLabel = "PONTUAÇÃO: \(score)" as NSString
            } else {
                
                message = "GAME OVER"
                scoreLabel = "SCORE: \(score)" as NSString
                
            }
            
                
        }
        
        var highscore:String
        
        let test = highscoreAlreadyExist(key: "highscore")
        
        if test {
            highscore = UserDefaults.standard.object(forKey: "highscore")! as! String
            
        } else {
            
            highscore = "0"
            
        }
        
        if (Int(score))! > (Int(highscore))!{
            
            UserDefaults.standard.set(score, forKey: "highscore")
            
            let leaderboardID = "LeaderboardSpacecraftI"
            let sScore = GKScore(leaderboardIdentifier: leaderboardID)
            sScore.value = Int64(score)!
            
            GKScore.report([sScore], withCompletionHandler: { (error: Error?) -> Void in
                if error != nil {
                    //print(error!.localizedDescription)
                } else {
                    //print("Score submitted")
                    
                }
            })
            
        } else {
            
            if test {
                
                highscore = UserDefaults.standard.object(forKey: "highscore")! as! String
                
            } else {
                
                highscore = "0"
                
            }            
        }
        
        if test {
            
            highscore = UserDefaults.standard.object(forKey: "highscore")! as! String
            
        } else {
            
            highscore = "0"
            
        }
        
        self.addChild(Background)
        
        let bgScore:SKSpriteNode = SKSpriteNode(imageNamed: "score2")
        bgScore.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.790))

        bgScore.zPosition = 3
        self.addChild(bgScore)
        
        let label1 = SKLabelNode(fontNamed: "Helvetica")
        label1.text = message as String
        label1.fontColor = SKColor.white
        label1.fontSize = 33
        label1.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.580))
        label1.zPosition = 3
        self.addChild(label1)
        
        let label2 = SKLabelNode(fontNamed: "Helvetica")
        label2.text = scoreLabel as String
        label2.fontSize = 20
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.505))
        label2.zPosition = 4
        self.addChild(label2)
        
        let label3 = SKLabelNode(fontNamed: "Helvetica")
        label3.text = "\(highscore)"
        label3.fontSize = 35
        label3.fontColor = SKColor.white
        label3.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.790))
        label3.zPosition = 2
        self.addChild(label3)
        
        let label4 = SKLabelNode(fontNamed: "Helvetica")
        if preferredLanguage == "pt-BR" {
            label4.text = "TOQUE NA TELA PARA RECOMEÇAR"
        } else {
            label4.text = "TOUCH TO RESTART"
        }
        label4.fontSize = 10
        label4.fontColor = SKColor.white
        label4.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.400))
        label4.zPosition = 1
        self.addChild(label4)
        
        let label5 = SKLabelNode(fontNamed: "Helvetica")
        label5.text = "spacecraft.com.br"
        label5.fontSize = 18
        label5.fontColor = SKColor.yellow
        label5.position = CGPoint(x: (
            screenSize.width * 0.50), y: (screenSize.height * 0.100))
        label5.zPosition = 1
        self.addChild(label5)
        
        let label6 = SKLabelNode(fontNamed: "Helvetica")
        label6.text = "contato@cassiodiego.com"
        label6.fontSize = 14
        label6.fontColor = SKColor.yellow
        label6.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.070))
        label6.zPosition = 1
        self.addChild(label6)
        
        //buttonHome.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        //buttonHome.zPosition = 1
        //self.addChild(buttonHome)
    
        //CODE FOR REDIRECT AUTO DA VERSAO BETA
        //self.run(SKAction.sequence([SKAction.wait(forDuration: 3.0), SKAction.run({
        //let transtion:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
        //let scene:SKScene = GameScene(size: self.size)
        //self.view!.presentScene(scene, transition: transtion)})]))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func didMove(to view: SKView) { }
    
    func highscoreAlreadyExist(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: key) != nil}

    //override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    let touch = touches.first
    //    let touchLocation = touch!.location(in: self)
    //    if buttonHome.contains(touchLocation) { }
    //}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if touchLocation.x != 0 {
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameScene:SKScene = GameScene(size: self.size)
            self.view!.presentScene(gameScene, transition: transition)
        }
    }
    
}
