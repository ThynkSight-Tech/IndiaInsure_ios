//
//  EnterRemarksVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 14/09/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol RemarkSavedProtocol {
    func remarkSaved(remarkStr:String)
}

class EnterRemarksVC: UIViewController {

    @IBOutlet weak var lblRemarks: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnSchedule: UIButton!
    
    var delegateObject : RemarkSavedProtocol? = nil
    var remarkText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.txtView.layer.cornerRadius = 10.0
        self.txtView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.txtView.layer.borderWidth = 1.0
        self.txtView.text = remarkText
        btnSchedule.makeHHCButton()
        
        print("In \(navigationItem.title ?? "") EnterRemarksVC")
    }
    
    @IBAction func btnScheduleTapped(_ sender: UIButton) {
        if txtView.text.trimmingCharacters(in: .whitespaces) != "" {
            if delegateObject != nil {
                delegateObject?.remarkSaved(remarkStr: txtView.text!)
            }
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.displayActivityAlert(title: "Please enter remarks.")
        }
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
