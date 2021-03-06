//
//  ViewController.swift
//  CupOmatic v2
//
//  Created by Andrew Johnson on 31.10.17.
//  Copyright © 2017 Rinson. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit


class ViewController: UIViewController{
    
    let attrs = [
        NSAttributedStringKey.foregroundColor: UIColor.black,
        NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)
    ]
    
    var advancedMode = false
    var runs = 0
    var bowlSetting: Int?
    
    var vibrate = false
    
    
    var parentTimer : ParentTimer?
    var timerSegue = false
    var audio: Audio?
    
    
    @IBOutlet var mainTimerLabel: UILabel!
    
    //   toolbar items
    
    @IBOutlet var bottomToolBar: UINavigationBar!
    @IBAction func settingsButton(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if let nextVc = segue.destination as? bowlsViewController{
            nextVc.delegate =  self
        }
    }

    @IBAction func getReadyStopButton(_ sender: Any) {
        
        if parentTimer?.getMainTimerStatus() == false {
            performSegue(withIdentifier: "numberOfBowls", sender: self)
        } else {
            bottomToolBar.frame = CGRect(x: 0, y: view.frame.size.height - 44, width: view.frame.size.width, height: 375)
            parentTimer?.startTimer.invalidate()
            parentTimer?.invalidateMainTimer()
            parentTimer?.reset()
            parentTimer?.setMainTimerStatus(status: false)
            changeButton()
            runs += 1
            UserDefaults.standard.set(runs, forKey: "runs")
            print("Runs: \(runs)")
            appStoreReview()
            initialProgressView()
            
        }
    }
    @IBOutlet weak var getReadystop: UIButton!
    
    func changeButton(){
        
        if parentTimer?.getMainTimerStatus() == true {
            
            self.getReadystop.setTitle("Stop", for: UIControlState.normal)
            self.getReadystop.backgroundColor = UIColor(red: 200.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
            
            
        } else {
            
            getReadystop.setTitle("Get Ready ", for: UIControlState.normal)
            self.getReadystop.backgroundColor = UIColor(red: 10.0/255.0, green: 200.0/255.0, blue: 10.0/255.0, alpha: 1.0)
            
        }
    }
    
    
    @objc func start(){
        parentTimer?.setIntervalBowls(bowlAmount: bowlSetting!)
        parentTimer?.setTimerCellBowls(bowlAmount: bowlSetting!)
        parentTimer?.bowl = bowlSetting!
     
        
        if parentTimer?.initiateMainTimer == true {
            parentTimer?.startStartTimer()
            parentTimer?.initiateMainTimer = false
            parentTimer?.setMainTimerStatus(status: true)
            
        }else{
            
            parentTimer?.invalidateMainTimer()
            parentTimer?.initiateMainTimer = true
            parentTimer?.setMainTimerStatus(status: false)
            
        }
    }
    
    // `timer outlets
    
    @IBOutlet weak var intervalProgress: MKMagneticProgress!
    @IBOutlet weak var pourProgress: MKMagneticProgress!
    @IBOutlet weak var breakProgress: MKMagneticProgress!
    @IBOutlet weak var sampleProgress: MKMagneticProgress!
    
    func advancedModeUpdate(){
        if advancedMode == false{
            breakProgress.isHidden = true
        }
    }
    
    
    func updateProgressViews(){
        
        //intervalProgress
        
        if parentTimer?.intervalTimer?.active == false {
            intervalProgress.percentLabelFormat = ""
            
        }else{
            intervalProgress.percentLabelFormat = (parentTimer!.intervalTimer?.getTimeLabel())!
            
        }
        
        updateIntervalViews()
        
        pourProgress.percentLabelFormat = String(parentTimer!.timers[0].getBowlsPassed())
        pourProgress.setProgress(progress: parentTimer!.timers[0].getPercentage(), animated: true)
        pourProgress.titleLabel.sizeToFit()
        
        breakProgress.percentLabelFormat = String(parentTimer!.timers[1].getBowlsPassed())
        breakProgress.setProgress(progress: parentTimer!.timers[1].getPercentage(), animated: true)
        breakProgress.titleLabel.adjustsFontSizeToFitWidth = true
        
        
        
        if advancedMode == true {
            
            sampleProgress.percentLabelFormat = String(parentTimer!.timers[2].getBowlsPassed())
            sampleProgress.setProgress(progress: parentTimer!.timers[2].getPercentage(), animated: true)
            
        }else{
            
            sampleProgress.title = "Br"
            sampleProgress.titleLabel.text = "Br"
            sampleProgress.percentLabelFormat = String(parentTimer!.timers[1].getBowlsPassed())
            sampleProgress.setProgress(progress: parentTimer!.timers[1].getPercentage(), animated: true)
            
        }
    }
    
    func updateIntervalViews(){
        
        if parentTimer?.intervalTimer?.active == false {
            intervalProgress.setProgress(progress: 0.0, animated: false)
        }else{
            intervalProgress.setProgress(progress: (parentTimer?.intervalTimer?.getIntervalPercentage())!, animated: false)
        }
    }
    
    
    func initialProgressView(){
        
        intervalProgress.percentLabelFormat = ""
        intervalProgress.setProgress(progress: 0.0, animated: false)
        
        pourProgress.percentLabelFormat = String(0)
        pourProgress.setProgress(progress: 0, animated: true)
        
        breakProgress.percentLabelFormat = String(parentTimer!.timers[1].getBowlsPassed())
        breakProgress.setProgress(progress: parentTimer!.timers[1].getPercentage(), animated: true)
        
        sampleProgress.percentLabelFormat = String(parentTimer!.timers[2].getBowlsPassed())
        sampleProgress.setProgress(progress: parentTimer!.timers[2].getPercentage(), animated: true)
        
    }
    
    func isKeyPresentInUserDefaults(){
        
        if (UserDefaults.standard.object(forKey: "isInitiated") == nil){
            
            UserDefaults.standard.set(false, forKey: "advancedMode")
            UserDefaults.standard.set(false, forKey: "vibrate")
            
            UserDefaults.standard.set(12, forKey: "numberOfBowlsSave")
            
            UserDefaults.standard.set(20, forKey: "intervalSettingSave")
            UserDefaults.standard.set(0, forKey: "minutesResultSave")
            UserDefaults.standard.set(20, forKey: "secondsResultSave")
            
            UserDefaults.standard.set(240, forKey: "breakSettingSave")
            UserDefaults.standard.set(4, forKey: "breakMinutesResultSave")
            UserDefaults.standard.set(0, forKey: "breakSecondsResultSave")
            
            UserDefaults.standard.set(600, forKey: "sampleSettingSave")
            UserDefaults.standard.set(10, forKey: "sampleMinutesResultSave")
            UserDefaults.standard.set(0, forKey: "sampleSecondsResultSave")
            
            UserDefaults.standard.set(780, forKey: "roundOneSettingSave")
            UserDefaults.standard.set(13, forKey: "roundOneMinutesResultSave")
            UserDefaults.standard.set(0, forKey: "roundOneSecondsResultSave")
            
            UserDefaults.standard.set(1080, forKey: "roundTwoSettingSave")
            UserDefaults.standard.set(18, forKey: "roundTwoMinutesResultSave")
            UserDefaults.standard.set(0, forKey: "roundTwoSecondsResultSave")
            
            UserDefaults.standard.set(1320, forKey: "roundThreeSettingSave")
            UserDefaults.standard.set(22, forKey: "roundThreeMinutesResultSave")
            UserDefaults.standard.set(0, forKey: "roundThreeSecondsResultSave")
            
            UserDefaults.standard.set(["Index": 20, "Sound": 1336], forKey: "alarmSoundSave")
            
            UserDefaults.standard.set(4, forKey: "startTimerSetting")
            UserDefaults.standard.set(0, forKey: "runs")
            UserDefaults.standard.set(true, forKey: "isInitiated")
        }
    }
    
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    func setupGoStopButton(){
        getReadystop.layer.cornerRadius = 30.0
        getReadystop.layer.shadowOffset = CGSize(width: 2, height: 2)
        getReadystop.layer.shadowRadius = 2;
        getReadystop.layer.shadowOpacity = 0.5;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parentTimer?.isKeyPresentInUserDefaults()
        isKeyPresentInUserDefaults()
        runs = UserDefaults.standard.object(forKey: "runs") as! Int
        print("Timer Segue status = \(timerSegue)")
        advancedMode = UserDefaults.standard.object(forKey: "advancedMode") as! Bool
        vibrate = UserDefaults.standard.object(forKey: "vibrate") as! Bool
        print("Advanced mode = \(advancedMode)")
        print("Vibrate mode = \(vibrate)")
        
        if parentTimer == nil{
            parentTimer = ParentTimer(viewController : self,  bowlSetting: bowlSetting)
        }
        
        
        
        setupGoStopButton()
        mainTimerLabel.text = parentTimer?.getMainTimerString(timerInput: (parentTimer?.mainTimer)! )
        intervalProgress.font = intervalProgress.font.withSize(50.0)
        
        initialProgressView()
        
        advancedModeUpdate()
     
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
   
    func setupView(){
        
        if timerSegue == true {
            //  bottomToolBar.removeConstraints(bottomToolBar.constraints)
            bottomToolBar.frame = CGRect(x: 0, y: view.frame.size.height - 0, width: view.frame.size.width, height:0 )
        }else{
            bottomToolBar.frame = CGRect(x: 0, y: view.frame.size.height - 44, width: view.frame.size.width, height: 375)
        }
        updateProgressViews()
        self.navigationController?.isNavigationBarHidden = true
        
        changeButton()
        
    }
    
    
    func appStoreReview(){
        if runs % 5 == 0 {
            if #available( iOS 10.3,*){
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func updateIntervalViewsForRounds(){
        if parentTimer?.intervalTimer?.active == false {
            intervalProgress.setProgress(progress: 0.0, animated: false)
        }
    }
    
    
}

extension ViewController: BowlsPopupDelegate{
    func passBackData(timerSegue: Bool, bowlSetting: Int) {
        self.timerSegue = timerSegue
        self.bowlSetting = bowlSetting
        self.start()
        self.changeButton()
        setupView()

    }

}

