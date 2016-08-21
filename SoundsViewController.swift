//
//  SoundsViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 8/8/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class SoundsViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate {
    
    var soundsWonderName: String! //variables used to record and play sounds.
    var soundURL: String!
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?

    @IBOutlet weak var soundWonderNameLabel: UILabel!
    @IBOutlet weak var soundSaveConfirmLabel: UILabel!
    @IBOutlet weak var soundTitleTextField: UITextField!
    @IBOutlet weak var soundStatusLabel: UILabel!
    
    
    @IBOutlet weak var soundRecordStatus: UIButton!
    @IBOutlet weak var soundStopStatus: UIButton!
    @IBOutlet weak var soundPlayStatus: UIButton!
    
    
    @IBAction func soundSaveButton(sender: UIBarButtonItem) {
        
        let wonderSoundsAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let wonderSoundsContext:NSManagedObjectContext = wonderSoundsAppDel.managedObjectContext
        
        let sound = NSEntityDescription.insertNewObjectForEntityForName("Sounds", inManagedObjectContext: wonderSoundsContext) as! Sounds
        
        sound.wonderName = soundsWonderName
        sound.wonderSoundURL = soundURL
        sound.wonderSoundTitle = soundTitleTextField.text!
        
        do {
            try wonderSoundsContext.save()
            soundSaveConfirmLabel.alpha = 1
            soundSaveConfirmLabel.text = "Saved" + soundTitleTextField.text!
            soundTitleTextField.text = " "
        } catch _ {
        }
        
        //Set the audio recorder up to record new audio with own audioFileName.
        
        setupRecorder()
        
    }
    
    @IBAction func recordButton(sender: UIButton) {
        //Stop the audio player before recording
        if let player = audioPlayer {
            if player.playing {
                player.stop()
                soundPlayStatus.selected = false
            }
        }
        //Setup Audio Session
        if let recorder = audioRecorder {
            if !recorder.recording {
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(true)
                } catch _ {
                }
                
                // Start Recording
                recorder.record()
                
                soundStatusLabel.text = "Recording.."
                soundStopStatus.enabled = true
                soundRecordStatus.selected = true
            }
            
            else {
                // Pause recording
                recorder.pause()
                soundStatusLabel.text = "Paused"
                soundStopStatus.enabled = false
                soundPlayStatus.enabled = false
                soundRecordStatus.enabled = false
            }
        }
    }
    
    @IBAction func stopButton(sender: UIButton) {
        soundStatusLabel.text = "Stopped"
        soundPlayStatus.enabled = true
        soundStopStatus.enabled = false
        soundRecordStatus.enabled = true
        
        soundRecordStatus.selected = false
        soundPlayStatus.selected = false
       
        //Stop Recorder
        if let recorder = audioRecorder {
            if recorder.recording {
            audioRecorder?.stop()
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
            } catch _ {
                
            }
        }
    }
    //Stop audio player if playing
    if let player = audioPlayer {
        if player.playing {
            player.stop()
        }
    }
}
    
    @IBAction func playButton(sender: UIButton) {
        
        if let recorder = audioRecorder {
            if !recorder.recording {
                audioPlayer = try? AVAudioPlayer(contentsOfURL: recorder.url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
                
                soundStatusLabel.text = "Playing.."
                soundStopStatus.enabled = true
                soundRecordStatus.enabled = false
                soundPlayStatus.selected = true
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundWonderNameLabel.text = soundsWonderName
        soundSaveConfirmLabel.alpha = 0 // Hides the label 
        
        //Disable stop/play button when application launches
        soundStopStatus.enabled = false
        soundPlayStatus.enabled = false
        
        self.soundTitleTextField.delegate = self
        setupRecorder()
    }
    
    // Keyboard Control
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        soundTitleTextField.resignFirstResponder()
        return false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    //Completion of recording 
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            soundStatusLabel.text = "Audio Recording Completed!"
            soundRecordStatus.enabled = true
            soundPlayStatus.enabled = true
            soundStopStatus.enabled = true
        }
    }
    
    // Completion of Playing 
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        soundStatusLabel.text = "Audio Playing Completed!"
        soundRecordStatus.enabled = true
        soundPlayStatus.enabled = false
        soundStopStatus.enabled = false
    }
        
        func setupRecorder() {
            //Set the audio file
            
            let directoryURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first
            
            let audioFileName = NSUUID().UUIDString + ".m4a"
            let audioFileURL = directoryURL!.URLByAppendingPathComponent(audioFileName)
            soundURL = audioFileName //Sound URL stored in Core Data
            
            //Setup audio session
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
            } catch _ {
            }
            
            let recorderSetting = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC),
                                   AVSampleRateKey: 44100.0,
                                   AVNumberOfChannelsKey: 2]
            
            //Initiate and prepare the recorder
            
            audioRecorder = try? AVAudioRecorder(URL: audioFileURL, settings: recorderSetting)
            audioRecorder?.delegate = self
            audioRecorder?.meteringEnabled = true
            audioRecorder?.prepareToRecord()
            
            soundStatusLabel.text = "Ready to Record. Touch Microphone!"
        }

}


