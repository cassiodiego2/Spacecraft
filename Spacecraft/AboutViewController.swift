//
//  FirstViewController.swift
//  Spacecraft
//
//  Created by Diego on 12/12/16.
//  Copyright © 2016 Cassio Diego. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class AboutViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var scoreLabelBr: UILabel!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        var highscore:String
        
        let preferredLanguage = NSLocale.preferredLanguages[0] as String
        
        let test = highscoreAlreadyExist(key: "highscore")
        
        if test {
            

            highscore = UserDefaults.standard.object(forKey: "highscore")! as! String
            
            if preferredLanguage != "pt-BR" {
                
                scoreLabel.text = highscore
            } else {
                
                scoreLabelBr.text = highscore
                
            }
            
        } else {
            
            highscore = "0"
            
            if preferredLanguage != "pt-BR" {
                
                scoreLabel.text = highscore
            } else {
                
                scoreLabelBr.text = highscore
                
            }
            
        }
        
    }
    
    func highscoreAlreadyExist(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
