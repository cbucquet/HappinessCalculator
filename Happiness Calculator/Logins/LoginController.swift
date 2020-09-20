//
//  LoginController.swift
//  Happiness Calculator
//
//  Created by Charles on 2/9/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

// *** Global variables ***
var id = "default"

class LoginController: UIViewController {
    
    
    // *** Outlets ***
    @IBOutlet weak var GenerateButtonOutlet: UIButton!
    @IBOutlet weak var LoginButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the Buttons
        GenerateButtonOutlet.layer.cornerRadius = 10
        GenerateButtonOutlet.layer.borderColor = UIColor.white.cgColor
        GenerateButtonOutlet.layer.borderWidth = 1
        GenerateButtonOutlet.setTitle(" Start the calculator ", for: .normal)
        
        LoginButtonOutlet.layer.cornerRadius = 10
        LoginButtonOutlet.layer.borderColor = UIColor.white.cgColor
        LoginButtonOutlet.layer.borderWidth = 1
        LoginButtonOutlet.setTitle(" Login with an existing identifier ", for: .normal)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // *** Button Actions ***
    @IBAction func GenerateButtonAction(_ sender: Any) {
        //Generate id
        id = generateID()
        
        //Save the data
        UserDefaults.standard.set(id, forKey: "id")
        UserDefaults.standard.set(true, forKey: "notFirstTime")
        Firestore.firestore().collection("users").document(id).setData(["DateCreated": date])
        
        performSegue(withIdentifier: "startCalculSegue", sender: self)
    }
    
    @IBAction func LoginButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: self)
        
    }
    
    
    // *** Functions ***
    func generateID() -> String{
        let database = Firestore.firestore()
        let ref = database.collection("users").document()
        let id = ref.documentID
        return id
    }
}
