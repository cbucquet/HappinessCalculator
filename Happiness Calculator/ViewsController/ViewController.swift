//
//  ViewController.swift
//  Happiness Calculator
//
//  Created by Charles on 2/8/19.
//  Copyright © 2019 charles. All rights reserved.
//

import UIKit
import FirebaseFirestore

var date = "01012019"
var day = 1
var emotionNumber = 0
//var themeColor = UIColor(red: 46/250, green: 104/250, blue: 184/250, alpha: 1)
var themeColor = UIColor(red: 57/250, green: 130/250, blue: 231/250, alpha: 1)
var currentColor = themeColor
var numberToEmotion = [1: "sad", 2: "mediumSad", 3: "medium", 4: "mediumHappy", 5: "happy"]

class ViewController: UIViewController {
    var numberToColor = [1: UIColor(red: 090/255, green: 015/255, blue: 134/255, alpha: 1),
                         2: UIColor(red: 165/255, green: 054/255, blue: 099/255, alpha: 1),
                         3: UIColor(red: 184/255, green: 070/255, blue: 065/255, alpha: 1),
                         4: UIColor(red: 000/255, green: 167/255, blue: 174/255, alpha: 1),
                         5: UIColor(red: 071/255, green: 184/255, blue: 077/255, alpha: 1)
    ]
    var emotionsNumber = ["happy": 0, "mediumHappy": 0, "medium": 0, "mediumSad": 0, "sad": 0, "total": 0]
    var alreadySubmitted = false
    
    
    @IBOutlet var EmotionButtons: [UIButton]!
    @IBOutlet weak var StatsButtonOutlet: UIButton!
    @IBOutlet weak var PercentageLabel: UILabel!
    @IBOutlet weak var PercentageDescriptionLabel: UILabel!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var SettingsButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.isHidden = true
        
        if UserDefaults.standard.bool(forKey: "notFirstTime") == false {
            DispatchQueue.main.async() {
                self.performSegue(withIdentifier: "first", sender: self)
            }
        }
        
        
        if let identifier = UserDefaults.standard.value(forKey: "id") as? String{
            id = identifier
        }
        //id = "SUf5fRTVmuWM9soKJk8F"
        date = getDate()
        day = getDay()
        
        //Set up stats button
        StatsButtonOutlet.layer.cornerRadius = 10
        StatsButtonOutlet.layer.borderColor = UIColor.white.cgColor
        StatsButtonOutlet.layer.borderWidth = 1
        StatsButtonOutlet.setTitle(" More Stats ", for: .normal)
        
        //Hide the labels
        PercentageLabel.isHidden = true
        PercentageDescriptionLabel.isHidden = true
        
        //Set up Settings Button
        SettingsButtonOutlet.imageView?.image = UIImage(named: "settings")!.withRenderingMode(.alwaysTemplate)
        SettingsButtonOutlet.imageView?.tintColor = UIColor.white
        
        
        alreadySubmittedCheck()
        getEmotionNumber()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            getAllData()
        }
    }
    

    @IBAction func EmotionsAction(_ sender: UIButton) {
        if alreadySubmitted == false{
            let database = Firestore.firestore()
            database.collection("users").document(id).collection("emotions").document(date).setData(["day": day, "emotion": sender.tag, "emotionNumber": emotionNumber]) { (error) in
                if error != nil{
                    errorDescription = error?.localizedDescription ?? "Please try again"
                    self.performSegue(withIdentifier: "errorSegue", sender: self)
                }
            }
        
            database.collection("stats").document(date).getDocument { (document, error) in
                if error != nil{
                    errorDescription = error?.localizedDescription ?? "Please try again"
                    self.performSegue(withIdentifier: "errorSegue", sender: self)
                }
                else{
                    if (document?.exists)!{
                        database.collection("stats").document(date).updateData([numberToEmotion[sender.tag] : (document?.data()![numberToEmotion[sender.tag]!] as! Int)+1])
                    }
                    else{
                        database.collection("stats").document(date).setData(["happy": 0, "mediumHappy": 0, "medium": 0, "mediumSad": 0, "sad": 0])
                        DispatchQueue.main.async() {
                            database.collection("stats").document(date).updateData([numberToEmotion[sender.tag] : 1])
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.alreadySubmittedCheck()
            self.getEmotionNumber()
            getAllData()
            
        }
        
    }
    @IBAction func StatsButtonAction(_ sender: Any) {
        getAllData()
        performSegue(withIdentifier: "StatsSegue", sender: self)
        
        
    }
        
    


}

