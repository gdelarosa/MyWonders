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
    
    
    @IBAction func soundSaveButton(_ sender: UIBarButtonItem) {
        
        let wonderSoundsAppDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let wonderSoundsContext:NSManagedObjectContext = wonderSoundsAppDel.managedObjectContext
        
        let sound = NSEntityDescription.insertNewObject(forEntityName: "Sounds", into: wonderSoundsContext) as! Sounds
        
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
    
    @IBAction func recordButton(_ sender: UIButton) {
        //Stop the audio player before recording
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
                soundPlayStatus.isSelected = false
            }
        }
        //Setup Audio Session
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(true)
                } catch _ {
                }
                
                // Start Recording
                recorder.record()
                
                soundStatusLabel.text = "Recording.."
                soundStopStatus.isEnabled = true
                soundRecordStatus.isSelected = true
            }
            
            else {
                // Pause recording
                recorder.pause()
                soundStatusLabel.text = "Paused"
                soundStopStatus.isEnabled = false
                soundPlayStatus.isEnabled = false
                soundRecordStatus.isEnabled = false
            }
        }
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        soundStatusLabel.text = "Stopped"
        soundPlayStatus.isEnabled = true
        soundStopStatus.isEnabled = false
        soundRecordStatus.isEnabled = true
        
        soundRecordStatus.isSelected = false
        soundPlayStatus.isSelected = false
       
        //Stop Recorder
        if let recorder = audioRecorder {
            if recorder.isRecording {
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
        if player.isPlaying {
            player.stop()
        }
    }
}
    
    @IBAction func playButton(_ sender: UIButton) {
        
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
                
                soundStatusLabel.text = "Playing.."
                soundStopStatus.isEnabled = true
                soundRecordStatus.isEnabled = false
                soundPlayStatus.isSelected = true
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundWonderNameLabel.text = soundsWonderName
        soundSaveConfirmLabel.alpha = 0 // Hides the label 
        
        //Disable stop/play button when application launches
        soundStopStatus.isEnabled = false
        soundPlayStatus.isEnabled = false
        
        self.soundTitleTextField.delegate = self
        setupRecorder()
    }
    
    // Keyboard Control
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        soundTitleTextField.resignFirstResponder()
        return false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    //Completion of recording 
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            soundStatusLabel.text = "Audio Recording Completed!"
            soundRecordStatus.isEnabled = true
            soundPlayStatus.isEnabled = true
            soundStopStatus.isEnabled = true
        }
    }
    
    // Completion of Playing 
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        soundStatusLabel.text = "Audio Playing Completed!"
        soundRecordStatus.isEnabled = true
        soundPlayStatus.isEnabled = false
        soundStopStatus.isEnabled = false
    }
        
        func setupRecorder() {
            //Set the audio file
            
            let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
            
            let audioFileName = UUID().uuidString + ".m4a"
            let audioFileURL = directoryURL!.appendingPathComponent(audioFileName)
            soundURL = audioFileName //Sound URL stored in Core Data
            
            //Setup audio session
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            } catch _ {
            }
            
            let recorderSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                                   AVSampleRateKey: 44100.0,
                                   AVNumberOfChannelsKey: 2]
            
            //Initiate and prepare the recorder
            
            audioRecorder = try? AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            
            soundStatusLabel.text = "Ready to Record. Touch Microphone!"
        }

}


