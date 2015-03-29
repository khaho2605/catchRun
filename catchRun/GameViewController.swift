//
//  GameViewController.swift
//  catchRun
//
//  Created by Ji Pei on 12/16/14.
//  Copyright (c) 2014 LUSS. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, sceneDelegate{
    var networkEngine: Multiplayer!
    var fullAd:GADInterstitial?
    var audioControl : AudioController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAuthenticaionViewController", name: presentAuthentication, object: nil)
        GameCenterConnector.sharedInstance().authenticatePlayer()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMultiButton", name: LocalPlayerIsAuthenticated, object: nil)
     
        audioControl = AudioController()
        audioControl!.tryPlayMusic()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.myDelegate = self
            scene.soundOn = true
            skView.presentScene(scene)
        }
    }
    
    
    func showAuthenticaionViewController(){
        self.presentViewController(GameCenterConnector.sharedInstance().authenticationViewController!, animated: true, completion: nil)
    }
    
    func showMultiButton(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerAuthenticated", name: multiplayerButtonPressed, object: nil)
    }
    

    func playerAuthenticated(){
        print("game scene")
        // DELEGATE POINT TO MULTIPLAYER 
//        var skview: SKView! = self.view as SKView
//        var scene : GameScene! = skview.scene as GameScene
//        var playScene: GamePlayScene? = GamePlayScene.sharedInstance(scene.size)
        self.networkEngine = Multiplayer()
//        networkEngine.delegate = playScene
//        playScene?.networkEngine = self.networkEngine
        //networkEngine.delegate = playerScene
        //playerScene.networkEngine = self.networkEngine
        //networkEngine.delegate = scene
        //scene.networkEngine = self.networkEngine
        GameCenterConnector.sharedInstance().findMatchWithMinPlayer(2, maxPlayers: 2, viewControllers: self, delegate: self.networkEngine)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }
    
    //MARK: GADIntersititialDelegate
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        fullAd!.presentFromRootViewController(self)
    }
    
    //MARK: Scene Delegate
    func didChangeSound() {
        if audioControl!.backgroundMusicPlaying{
            audioControl!.stopMusic()
        }else{
            audioControl!.tryPlayMusic()
        }
    }
    
    func autoMatch() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerAuthenticated", name: LocalPlayerIsAuthenticated, object: nil)
        print("notification is triggered")
    }
    
    //MARK: match delegate
    func match(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: NSString) {
        print("receive data")
    }
    
    func matchEnded() {
        print("match ended")
    }
    
    func matchStarted() {
        print("match started")
    }
}
