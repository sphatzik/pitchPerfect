//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by minus one on 08/02/16.
//  Copyright © 2016 minus one. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingProgress: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var tapTheMic: UILabel!
    
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecording.hidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
        
        recordingProgress.hidden = false
        stopRecording.hidden = false
        tapTheMic.hidden = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
//        let currentDateTime = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "ddMMyyyy-HHmmss"
//        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"

        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)  //in order to play from speakers
        } catch _ {
        }
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
       
        if(flag){
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            var check: String!

            
            let refreshAlert = UIAlertController(title: "HEY!", message: "Who are you ???", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Marcy?", style: .Default, handler: { (action: UIAlertAction!) in
                
                check = "marcy"
                self.recordedAudio.owner = check
                self.performSegueWithIdentifier("stopRecording", sender: self.recordedAudio)

            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Lieutenant Dan", style: .Default, handler: { (action: UIAlertAction!) in
                check = "dan"
                self.recordedAudio.owner = check
                self.performSegueWithIdentifier("stopRecording", sender: self.recordedAudio)
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
        
            
        }
        else{
            print("error from recording")
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
        
    }
    
    
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingProgress.hidden = true
        tapTheMic.hidden = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        
        
        
        
    }
}

