//
//  MotionPermissionsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 17/12/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import CoreMotion

class MotionPermissionsVC: UIViewController {

    @IBOutlet weak var btnSettings: UIButton!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSettings.makeCicular()
        
        let label1 = attributedText(withString: "Tap 'Open Settings'.", boldString: "'Open Settings'", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
        self.lbl1.attributedText = label1

        let label2 = attributedText(withString: "Turn on 'Motion & Fitness'.", boldString: "'Motion & Fitness'", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
        self.lbl2.attributedText = label2

        let label3 = attributedText(withString: "and tap on MyBenefits360 on the top left corner.", boldString: "MyBenefits360", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
        self.lbl3.attributedText = label3

    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.hidePleaseWait()

       // triggerActivityPermissionRequest()
    }
    

    @IBAction func btnSettingsTapped(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }

    }
    
    
    func triggerActivityPermissionRequest() {
        let manager = CMMotionActivityManager()
        let today = Date()
        
        manager.queryActivityStarting(from: today, to: today, to: OperationQueue.main, withHandler: { (activities: [CMMotionActivity]?, error: Error?) -> () in
            if error != nil {
                let errorCode = (error! as NSError).code
                if errorCode == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                    
                    print("MOTION Not Authorized")
                    
                }
                else if errorCode == Int(CMErrorMotionActivityNotEntitled.rawValue) {
                    
                    print("MOTION Not Entitled")
                    
                }
                else if errorCode == Int(CMErrorMotionActivityNotEntitled.rawValue) {
                    
                    print("MOTION Not Available")
                    
                }
                
            }
                
            else {
                print("MOTION Authorized")
                self.dismiss(animated: true, completion: nil)
            }
            manager.stopActivityUpdates()
        })
    }

    
    


func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
    //let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
    
    let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font:  UIFont(name: "Poppins-SemiBold", size: font.pointSize)!]

   
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute, range: range)
    return attributedString
}


}
