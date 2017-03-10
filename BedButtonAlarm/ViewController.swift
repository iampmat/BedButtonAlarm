//
//  ViewController.swift
//  BedButtonAlarm
//
//  Created by Patrick Matherly on 3/9/17.
//  Copyright © 2017 Patrick Matherly. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet var time: UIDatePicker!
    
    var timer = Timer()
    
    var player: AVAudioPlayer?
    
    var motionManager: CMMotionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startTimer(_ sender: Any) {
        let timeInterval = time.countDownDuration
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                          target: self,
                                          selector: #selector(timerDidEnd(timer:)),
                                          userInfo: "Wake up fool",
                                          repeats: false)
    }

    @IBAction func stopTimer(_ sender: Any) {
        self.timer.invalidate()
    }
    
    func timerDidEnd(timer:Timer) {
        self.playSound()
        self.motionManager = CMMotionManager()
        
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 0.01
            self.motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                print("\(accelData?.acceleration.x) \(accelData?.acceleration.y) \(accelData?.acceleration.z)")
            })
        }
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3")!
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        self.player?.pause()
    }
}

