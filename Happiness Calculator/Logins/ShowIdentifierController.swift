//
//  ShowIdentifierController.swift
//  Happiness Calculator
//
//  Created by Charles on 2/9/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class ShowIdentifierController: UIViewController {
    // *** Outlets ***
    @IBOutlet weak var IdentifierLabel: UILabel!
    @IBOutlet weak var ContinueButtonOutlet: UIButton!
    @IBOutlet weak var SignOutButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up buttons
        ContinueButtonOutlet.layer.cornerRadius = 10
        ContinueButtonOutlet.layer.borderWidth = 1
        ContinueButtonOutlet.layer.borderColor = UIColor.white.cgColor
        ContinueButtonOutlet.setTitle(" Back ", for: .normal)
        ContinueButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        
        SignOutButtonOutlet.setTitle(" Sign Out ", for: .normal)
        SignOutButtonOutlet.setTitleColor(UIColor.white, for: .normal)
       
        
        // Set the label to the user's id
        IdentifierLabel.text = id
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    // *** Button Actions ***
    @IBAction func ContinueButtonOutlet(_ sender: Any) {
        performSegue(withIdentifier: "continue", sender: self)
    }
    
    @IBAction func SignOutButtonAction(_ sender: Any) {
        id = "STRDC4VI0VHFk0XfinxX"
        UserDefaults.standard.set(id, forKey: "id")
        UserDefaults.standard.set(false, forKey: "notFirstTime")
        performSegue(withIdentifier: "signOutSegue", sender: self)
    }
}
