//
//  ErrorView.swift
//  Happiness Calculator
//
//  Created by Charles on 4/8/19.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit

var errorDescription = "Error"

class ErrorView: UIViewController {
    
    
    
    @IBOutlet weak var TopBar: UIView!
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var OkButtonOutlet: UIButton!
    @IBOutlet weak var ErrorDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OkButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        OkButtonOutlet.layer.cornerRadius = 10
        OkButtonOutlet.backgroundColor = UIColor(red: 71/255, green: 184/255, blue: 77/255, alpha: 1)
        
        PopUpView.layer.cornerRadius = 20
        
        let maskPath = UIBezierPath(roundedRect: TopBar.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 18, height: 18))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        TopBar.layer.mask = shape
        
        
        ErrorDescriptionLabel.text = errorDescription
    }
    
    @IBAction func OkButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
