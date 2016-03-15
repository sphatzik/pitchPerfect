//
//  PlaySoundViewController.swift
//  pitchPerfect
//
//  Created by minus one on 09/02/16.
//  Copyright © 2016 minus one. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       if  receivedAudio.owner == "dan"{
        
        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
            let fileUrl = NSURL.fileURLWithPath(filePath)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: fileUrl)
                audioPlayer.enableRate = true
            }
            catch{
                print("Error");
            }
            do{
                audioFile = try AVAudioFile(forReading: fileUrl)
            }
            catch{
                print("error from chipmunk")
            }
            
        }
        else{
            print("Error");
        }
        
        }
       else{
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
                audioPlayer.enableRate = true
            }
            catch{
                print("Error");
            }
            do{
                audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl)
            }
            catch{
                print("error from chipmunk")
            }
        
        }
        
        
        
        audioEngine = AVAudioEngine()
        
        
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func slowSoundButton(sender: UIButton) {
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }

    @IBAction func fastAudioButton(sender: UIButton) {
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0
        audioPlayer.play()

    }

    @IBAction func stopAudioButton(sender: UIButton) {
        
        audioPlayer.stop()
    }
    
    
    
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
}
