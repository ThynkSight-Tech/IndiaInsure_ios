//
//  DisclaimerViewController.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 15/11/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

protocol DesDelegate {
    func refreshData()
    func denyDisclaimer()
}

class DisclaimerViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnUnderstand: UIButton!
    
    
    @IBOutlet weak var botom: UIView!
    @IBOutlet weak var outerView: UIView!
    var delegate:DesDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.outerView.layer.cornerRadius = cornerRadiusForView//8.0
        btnUnderstand.layer.cornerRadius = 10.0
        
        botom.clipsToBounds = true
        outerView.clipsToBounds = true
        
    }
    
    @IBAction func backTapper(_ sender: Any) {
        UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")

        if delegate != nil {
            self.dismiss(animated: true, completion: nil)
            delegate?.denyDisclaimer()
        }
    }
    
    @IBAction func understandTapper(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: "isFitnessFirstTime")

        if delegate != nil {
            delegate?.refreshData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
