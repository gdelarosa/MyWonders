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

class SoundsViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
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
        
    }
    
    @IBAction func recordButton(sender: UIButton) {
        
    }
    
    @IBAction func stopButton(sender: UIButton) {
        
    }
    
    
    @IBAction func playButton(sender: UIButton) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundWonderNameLabel.text = soundsWonderName
        soundSaveConfirmLabel.alpha = 0 // Hides the label 
        
        //Disable stop/play button when application launches
        soundStopStatus.enabled = false
        soundPlayStatus.enabled = false
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
