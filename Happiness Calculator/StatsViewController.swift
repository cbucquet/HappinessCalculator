//
//  StatsViewController.swift
//  Happiness Calculator
//
//  Created by Charles on 2/20/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

var firstTimeLoad = true
var numberToDay = [1: "Sunday", 2: "Monday", 3: "Tuesday", 4: "Wednesday", 5: "Thursday", 6: "Friday", 7: "Saturday"]

var statsName = ["All time average", "Monday's Average", "Tomorrow's Average", "Last 7 days", "Last 30 days", "Today's World average", "Percentage Like You", "Best Day"]
var statsValue = ["N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A"]
var statsValueStart = ["0", "0", "0", "0", "0", "0", "0"]
let animationDuration = 1.5
var animationStartDate = Date()
var displaylink = CADisplayLink()
var statsNumberToImageName = [1.0: "sad",  1.5: "sadMiddle", 2.0: "mediumSad", 2.5: "medumSadMiddle", 3.0: "medium", 3.5: "mediumMiddle", 4.0: "mediumHappy", 4.5: "mediumHappyMiddle", 5.0: "happy"]


var isFaces = false

class StatsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var animationFinished = false
    
    @IBOutlet weak var switchButtonOutlet: UIButton!
    @IBOutlet weak var statsCollectionView: UICollectionView!
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = currentColor
        statsCollectionView.backgroundColor = currentColor
        
        
       
        //Set Up Button
        backButtonOutlet.layer.cornerRadius = 10
        backButtonOutlet.layer.borderWidth = 1
        backButtonOutlet.layer.borderColor = UIColor.white.cgColor
        
        statsCollectionView.isScrollEnabled = false
    
        
        if firstTimeLoad == true {
            getAllData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                self.statsCollectionView.reloadData()
                animationStartDate = Date()
                var countOfNonInt = 0
                for stat in statsValue {
                    if Double(stat) == nil{
                        countOfNonInt += 1
                    }
                }
                if countOfNonInt <= 6{
                    displaylink = CADisplayLink(target: self, selector: #selector(self.handleAnimation))
                    displaylink.add(to: .main, forMode: .default)
                }
                else{
                    for index in 0...statsValueStart.count-1{
                        statsValueStart[index] = statsValue[index]
                    }
                    
                    self.statsCollectionView.isScrollEnabled = true
                }
            }
            firstTimeLoad = false
        }
        else{
            self.statsCollectionView.reloadData()
            animationStartDate = Date()
            var countOfNonInt = 0
            for stat in statsValue {
                if Double(stat) == nil{
                    countOfNonInt += 1
                }
            }
            if countOfNonInt <= 6{
                displaylink = CADisplayLink(target: self, selector: #selector(self.handleAnimation))
                displaylink.add(to: .main, forMode: .default)
            }
            else{
                for index in 0...statsValueStart.count-1{
                    statsValueStart[index] = statsValue[index]
                }
                
                self.statsCollectionView.isScrollEnabled = true
            }
            
        }
        
        
        
        
        
    }
    @IBAction func switchButtonAction(_ sender: Any) {
        isFaces = !isFaces
        if isFaces{
            self.switchButtonOutlet.setTitle("Switch to numbers", for: .normal)
        }
        else{
            self.switchButtonOutlet.setTitle("Switch to faces", for: .normal)
        }
        statsCollectionView.reloadData()

    }
    
    
    
    
    @objc func handleAnimation(){
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        
        
        if elapsedTime > animationDuration{
            for index in 0...statsValueStart.count-1{
                statsValueStart[index] = statsValue[index]
            }
            animationFinished = true
            displaylink.invalidate()
            
            self.statsCollectionView.isScrollEnabled = true
            
            statsCollectionView.reloadData()
        }
        else{
            let percentage = elapsedTime/animationDuration
            for index in 0...statsValueStart.count-1{
                statsValueStart[index] = "\(((Double(statsValue[index]) ?? 0) * 10 * percentage).rounded()/10)"
            }
           
            
            //statsValueStart[6] = String(statsValue[6].prefix(Int(percentage*Double(statsValue[6].count))))
        }
        statsCollectionView.reloadData()
    }
    
    //Collection View Functions
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        
        if indexPath.row == 0 || indexPath.row == 7{
             cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as UICollectionViewCell
        }
        (cell.viewWithTag(1) as! UILabel).text = statsName[indexPath.row]
        (cell.viewWithTag(1) as! UILabel).textColor = currentColor
    
        
            
        if indexPath.row >= 7{
            (cell.viewWithTag(2) as! UILabel).text = statsValue[indexPath.row]
            
            (cell.viewWithTag(2) as! UILabel).isHidden = false
            (cell.viewWithTag(3) as! UIImageView).isHidden = true
        }
        else{
            
            
            if isFaces == false || statsValue[indexPath.row] == "N/A" || indexPath.row == 6{
                if animationFinished {
                    (cell.viewWithTag(2) as! UILabel).text = statsValue[indexPath.row]
                }
                else{
                    (cell.viewWithTag(2) as! UILabel).text = statsValueStart[indexPath.row]
                }
                (cell.viewWithTag(2) as! UILabel).isHidden = false
                (cell.viewWithTag(3) as! UIImageView).isHidden = true
                
               
            }
            else{
                let imageNumber = (((Double(statsValue[indexPath.row]) ?? 3)*2).rounded())/2
                (cell.viewWithTag(3) as! UIImageView).image = UIImage(named: statsNumberToImageName[imageNumber] ?? "medium")!.withRenderingMode(.alwaysTemplate)
                (cell.viewWithTag(3) as! UIImageView).tintColor = currentColor
                (cell.viewWithTag(2) as! UILabel).isHidden = true
                (cell.viewWithTag(3) as! UIImageView).isHidden = false
            }
            
            if indexPath.row == 6{
                (cell.viewWithTag(2) as! UILabel).text = "\((cell.viewWithTag(2) as! UILabel).text!)%"
                if Double(statsValue[indexPath.row]) == 0.0{
                    (cell.viewWithTag(2) as! UILabel).text = "N/A"
                }
                
                (cell.viewWithTag(2) as! UILabel).isHidden = false
                (cell.viewWithTag(3) as! UIImageView).isHidden = true
            }
        }
        (cell.viewWithTag(2) as! UILabel).textColor = currentColor
        
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statsName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || indexPath.row == 7 {
            let leftAndRightPaddings: CGFloat = 30.0
            let numberOfItemsPerRow: CGFloat = 1.0
            
            let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
            return CGSize(width: width, height: 80)
        }
        else{
            let leftAndRightPaddings: CGFloat = 60.0
            let numberOfItemsPerRow: CGFloat = 2.0
            
            let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
            
            return CGSize(width: width, height: width)
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statsCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}



//Functions
func getAllData(){
    getDayAverage(specificDay: day, statNumber: 1)
    if day == 7{
        getDayAverage(specificDay: 1, statNumber: 2)
        
    }
    else{
        getDayAverage(specificDay: day+1, statNumber: 2)
    }
    getBestDay(statNumber: 7)
    getLastDaysAverage(days: 7, statNumber: 3)
    getLastDaysAverage(days: 30, statNumber: 4)
    //getLastDaysAverage(days: 100, statNumber: 6)
    getLikeYou(statNumber: 6)
    getLastDaysAverage(days: -1, statNumber: 0)
    getPeopleAverage(statNumber: 5)
    firstTimeLoad = false
    
}
func getPeopleAverage(statNumber: Int){
    var average = 0.0
    var total = 0.0
    let database = Firestore.firestore()
    database.collection("stats").document(date).getDocument { (snapchot, error) in
        if error != nil{
        }
        else{
            if let document = snapchot{
                if document.exists {
                    if let data = document.data() {
                        for value in data {
                            average += Double((value.value as? Int ?? 0)*(numberToEmotion.allKeys(forValue: value.key).first ?? 0))
                            total += Double((value.value as? Int ?? 0))
                        }
                        statsValue[statNumber] = "\(((average/total)*100).rounded()/100)"
                    }
                }
            }
        }
    }
}
func getDayAverage(specificDay: Int, statNumber: Int){
    var dayAverage = [Int]()
    
    let database = Firestore.firestore()
    database.collection("users").document(id).collection("emotions").whereField("day", isEqualTo: specificDay).getDocuments { (snapchot, error) in
        if error != nil{
        }
        else{
            if let snapchotDocs = snapchot{
                if snapchotDocs.documents.count > 0{
                    for doc in snapchotDocs.documents {
                        dayAverage.append(doc.data()["emotion"] as! Int)
                    }
                }
            }
        }
        statsValue[statNumber] = "\(dayAverage.average)"
        statsName[statNumber] = "\(numberToDay[specificDay]!)'s average"
    }
}

func getBestDay(statNumber: Int){
    var dayAverages = [[Int]]()
    if emotionNumber >= 7{
        for dayNumber in 1...7{
            dayAverages.append([])
            let database = Firestore.firestore()
            database.collection("users").document(id).collection("emotions").whereField("day", isEqualTo: dayNumber).getDocuments { (snapchot, error) in
                if error != nil{
                }
                else{
                    if let snapchotDocs = snapchot{
                        if snapchotDocs.documents.count > 0{
                            for doc in snapchotDocs.documents {
                                dayAverages[dayNumber-1].append(doc.data()["emotion"] as! Int)
                            }
                        }
                        var currentBestAverage = 0.0
                        var currentBestAverageDay = 0
                        
                        if dayAverages.count > 0{
                            for index in 0...dayAverages.count-1{
                                if dayAverages[index].average > currentBestAverage{
                                    currentBestAverage = dayAverages[index].average
                                    currentBestAverageDay = index+1
                                }
                                
                            }
                            statsValue[statNumber] = "\(numberToDay[currentBestAverageDay] ?? "Sunday")"
                        }
                    }
                }
            }
        }
        
    }
    else{
       print("It's because of emotion number")
    }
    
    
}


func getLastDaysAverage(days: Int, statNumber: Int){
    let database = Firestore.firestore()
    let reference = database.collection("users").document(id)
    var emotions: [Int] = []
    
    if days == -1 && emotionNumber>0{
        reference.collection("emotions").getDocuments { (snapchot, error) in
            if error != nil{
            }
            else{
                if let snapDocs = snapchot{
                    if !snapDocs.isEmpty {
                        for doc in snapDocs.documents{
                            emotions.append(doc.data()["emotion"] as? Int ?? 3)
                        }
                    }
                }
            }
    
            if emotions.isEmpty != true{
                statsValue[statNumber] = "\(emotions.average)"
            }
        }
    }
    


    else if emotionNumber>0 {
        let daysToCheck = getDaysBefore(goBack: days)
        
        for day in daysToCheck {
            var realDay = day
            if day.count <= 7{
                realDay = "0\(day)"
            }
            
            reference.collection("emotions").document(realDay).getDocument { (snapchot, error) in
                if error != nil{
                }
                else{
                    if let snapDoc = snapchot{
                        if snapDoc.exists {
                            emotions.append(snapDoc.data()!["emotion"] as? Int ?? 3)
                        }
                            
                    }
                }
                if emotions.isEmpty != true{
                    statsValue[statNumber] = "\(emotions.average)"
                   
                }
                
            }
            
        }
    }
    
    
}
func getLikeYou(statNumber: Int) {
    statsValue[statNumber] = "\(percentageLikeYou)"
}


func getDaysBefore(goBack: Int) -> [String]{
    var returnArray = [String]()
    
    if Int(String(date.prefix(2)))! > goBack{
        for i in 0...goBack-1 {
            returnArray.append(String(Int(date)! - i*1000000))
        }
    }
    else{
        
        let newReferenceDateWithoutDay = String(Int(date)! - 10000)
        let newReferenceDate = Int("31\(newReferenceDateWithoutDay.suffix(6))")!
        
        for i in 0...Int(String(date.prefix(2)))! - 1 {
            returnArray.append(String(Int(date)! - i*1000000))
        }
        if Int(String(date.prefix(2)))! + 31 > goBack {
            
            
            for i in goBack-Int(String(date.prefix(2)))!...31 {
                returnArray.append(String(newReferenceDate - i*1000000))
            }
        }
       
        print(returnArray)
    }
    
    
    return returnArray
}



extension Collection where Element: Numeric {
    /// Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : ((Double(total)/Double(count))*10).rounded()/10
    }
}
extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}



