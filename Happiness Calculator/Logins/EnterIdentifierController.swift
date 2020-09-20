//
//  EnterIdentifierController.swift
//  Happiness Calculator
//
//  Created by Charles on 2/10/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class EnterIdentifierController: UIViewController {
    // *** Outlets ***
    @IBOutlet weak var IdentifierTextField: UITextField!
    @IBOutlet weak var ContinueButtonOutlet: UIButton!
    @IBOutlet weak var SwitchButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up buttons
        ContinueButtonOutlet.layer.cornerRadius = 10
        ContinueButtonOutlet.layer.borderWidth = 1
        ContinueButtonOutlet.layer.borderColor = UIColor.white.cgColor
        ContinueButtonOutlet.setTitle(" Continue ", for: .normal)
        ContinueButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        
        SwitchButtonOutlet.setTitleColor(UIColor.white, for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        IdentifierTextField.resignFirstResponder()
    }
    
    // *** Actions ***
    @IBAction func IdentifierHide(_ sender: Any) {
        self.view.endEditing(true)
        IdentifierTextField.resignFirstResponder()
    }
    
    @IBAction func ContinueButtonAction(_ sender: Any) {
        if let identifier = IdentifierTextField.text{
            if identifier != ""{
                let database = Firestore.firestore()
                let ref = database.collection("users").document(identifier)
            
                ref.getDocument { (document, error) in
                    if error != nil{
                        errorDescription = error?.localizedDescription ?? "Please try again"
                        self.performSegue(withIdentifier: "errorSegue", sender: self)
                    }
                    
                    else{
                        if let document = document{
                            if document.exists{
                                id = identifier
                                UserDefaults.standard.set(id, forKey: "id")
                                UserDefaults.standard.set(true, forKey: "notFirstTime")
                                self.performSegue(withIdentifier: "continue", sender: self)
                            }
                            else{
                                errorDescription = "The Account could not be found. Please try again. Make sure no extra spaces were added."
                                self.performSegue(withIdentifier: "errorSegue", sender: self)
                            }
                        }
                        else{
                            errorDescription = "The Account could not be found. Please try again. Make sure no extra spaces were added."
                            self.performSegue(withIdentifier: "errorSegue", sender: self)
                        }
                    }
                }
            }
            else{
                errorDescription = "Please enter an identifier."
                self.performSegue(withIdentifier: "errorSegue", sender: self)
            }
            
        }
        else{
            errorDescription = "Please enter an identifier."
            self.performSegue(withIdentifier: "errorSegue", sender: self)
        }
    }
}
