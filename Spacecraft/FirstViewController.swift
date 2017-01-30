//
//  FirstViewController.swift
//  Spacecraft
//
//  Created by Cassio Diego on 12/12/16.
//  Copyright (c) 2016 Cassio Diego. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

class FirstViewController : UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    override func viewDidLoad() {
        
        self.authenticateLocalPlayer()
        
        let test = AlreadyExist(key: "highscore")
        
        let musicStatus = UserDefaults.standard.object(forKey: "musicStatus")
        if musicStatus == nil { UserDefaults.standard.set(true, forKey: "musicStatus") }
        
        let soundStatus = UserDefaults.standard.object(forKey: "soundStatus")
        if soundStatus == nil { UserDefaults.standard.set(true, forKey: "soundStatus") }
        
        if test { self.syncScore() }

    }
    
    func authenticateLocalPlayer() {
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(FirstViewController, error) -> Void in
            
            if((FirstViewController) != nil) {
                
                self.present(FirstViewController!, animated: true, completion: nil)
                
            } else if (localPlayer.isAuthenticated) {
                
                self.gcEnabled = true
                
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer: String?, error: Error?) -> Void in
                    if error != nil {
                        print(error as Any)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else { self.gcEnabled = false }
        }
    }
    
    @IBAction func showLeaderboard(_ sender: UIButton) {
        
        let gc: GKGameCenterViewController = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = GKGameCenterViewControllerState.leaderboards
        gc.leaderboardIdentifier = "LeaderboardSpacecraftI"
        self.present(gc, animated: true, completion: nil)
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func AlreadyExist(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: key) != nil
    
    }
    
    func syncScore(){
        
        let highscore = UserDefaults.standard.object(forKey: "highscore")! as! String
        
        let leaderboardID = "LeaderboardSpacecraftI"
        
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        
        sScore.value = Int64(highscore)!
        
        GKScore.report([sScore], withCompletionHandler: { (error: Error?) -> Void in
            
            if error != nil {
                
                //print(error!.localizedDescription)
                
            } else {
                
                //print("Score refreshed")
                
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden : Bool {
        
        return true
        
    }

}
