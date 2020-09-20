//
//  Functions.swift
//  Happiness Calculator
//
//  Created by Charles on 2/18/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

var percentageLikeYou = 0.0

extension ViewController{
    //Get the current date in the form ddMMyyyy
    func getDate() -> String{
        let date = Date()
        let calendar = Calendar.current
        var day: String = String(calendar.component(.day, from: date))
        var month: String = String(calendar.component(.month, from: date))
        var year: String = String(calendar.component(.year, from: date))
        
        if Int(day)! < 10 {
            day = "0\(day)"
        }
        if Int(month)! < 10 {
            month = "0\(month)"
        }
        if Int(year)! < 10 {
            year = "0\(year)"
        }
        return "\(day)\(month)\(year)"
    }
    
    //Get the current day (1=Sunday)
    func getDay() -> Int{
        let date = Date()
        let calendar = Calendar.current
        var day: Int = Int(calendar.component(.weekday, from: date))
        return day
    }
    
    //Check if the user has already submitted his emotions
    //+ changes the appearance of view if returns true
    func alreadySubmittedCheck(){
        let database = Firestore.firestore()
        let ref = database.collection("users").document(id).collection("emotions").document(date)
        ref.getDocument { (document, error) in
            if error != nil{
                errorDescription = error?.localizedDescription ?? "Please try again"
                self.performSegue(withIdentifier: "errorSegue", sender: self)
            }
            else{
                if let document = document{
                    if document.exists{
                        if let currentEmotion = document.data()!["emotion"] as? Int{
                            self.changeButton(emotion: currentEmotion)
                            self.alreadySubmitted = true
                            self.view.backgroundColor = self.numberToColor[currentEmotion]
                            
                            self.QuestionLabel.text = "Come back tomorrow for more happiness!"
                            self.getNumberOfPeoplePerEmotion(emotion: currentEmotion)
                        }
                        if let color = self.view.backgroundColor{
                            currentColor = color
                        }
                    }
                }
            }
            UIView.transition(with: self.view,
                              duration: 0.6,
                              options: [.transitionCrossDissolve],
                              animations: { self.view.isHidden = false },
                              completion: nil)
        }
        
    }
    
    //Change the appearance of the buttons
    func changeButton(emotion: Int){
        var index = 5
        for button in EmotionButtons{
            button.isEnabled = false
            if index == emotion{
                button.isEnabled = true
                button.setImage(UIImage(named: "\(numberToEmotion[index] ?? "medium")Bold"), for: .normal)
            }
            index -= 1
        }
    }
    
    //Get the number of people for a certain emotion and assigns it to an array + displays the percentage
    func getNumberOfPeoplePerEmotion(emotion: Int){
        let database = Firestore.firestore()
        let ref = database.collection("stats").document(date)
        ref.getDocument { (snapchot, error) in
            if error != nil{
                errorDescription = error?.localizedDescription ?? "Please try again"
                self.performSegue(withIdentifier: "errorSegue", sender: self)
            }
            else{
                if let document = snapchot {
                    if document.exists{
                        var total = 0
                        for index in 1...5{
                            if let number = document.data()![numberToEmotion[index]!] as? Int{
                                self.emotionsNumber[numberToEmotion[index]!] = number
                                total += number
                            }
                        }
                        self.emotionsNumber["total"] = total
                        if total != 0{
                            if let currentEmotion = numberToEmotion[emotion] {
                                percentageLikeYou = Double(Int(Double(self.emotionsNumber[currentEmotion]!)/Double(self.emotionsNumber["total"]!)*1000))/10
                                self.PercentageLabel.text = "\(percentageLikeYou)%"
                            }
                            
                            self.PercentageDescriptionLabel.isHidden = false
                            self.PercentageLabel.isHidden = false
                        }
                        
                        UIView.transition(with: self.PercentageLabel,
                                          duration: 0.8,
                                          options: [.transitionFlipFromRight],
                                          animations: nil,
                                          completion: nil)
                        
                    }
                }
            }
        }
    }
    
    //get the number of Emotions in firebase
    func getEmotionNumber() {
        let database = Firestore.firestore()
        database.collection("users").document(id).collection("emotions").getDocuments { (snapchot, error) in
            if error != nil{
                errorDescription = error?.localizedDescription ?? "Please try again"
                self.performSegue(withIdentifier: "errorSegue", sender: self)
            }
            else{
                if let documents = snapchot?.documents {
                   
                    for _ in documents {
                        emotionNumber += 1
                    }
                    getAllData()
                }
            }
        }
        
        
    }
    
    
    //White status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
