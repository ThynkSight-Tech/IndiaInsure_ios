//
//  ScheduleAppointmentAlert.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 08/07/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import Shimmer

protocol YesNoProtocol {
    func yesTapped()
    func noTapped()
}

class ScheduleAppointmentAlert: UIViewController {

    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblBottomLabel: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    //@IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var shimmerBackView: FBShimmeringView!
    
    var yesNoDelegate : YesNoProtocol? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.makeTransparentBackground()
        print("In ScheduleAppointmentAlert")
        shimmerBackView.isShimmering = true
       // viewBorder.layer.cornerRadius = 10.0
        setColor()
    }
    
    func setColor() {
        self.btnYes.layer.cornerRadius = btnYes.bounds.height / 2
        self.btnYes.backgroundColor = Color.buttonBackgroundGreen.value
        self.btnNo.setTitleColor(Color.fontColor.value, for: .normal)
        lblHeader.textColor = Color.fontColor.value
        //btnNo.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        //btnNo.layer.borderWidth = 0.5
        btnYes.dropShadow()

       btnNo.dropShadow()
        
    }
    
    @IBAction func yesTapped(_ sender: Any) {
        if yesNoDelegate != nil {
            self.dismiss(animated: true) {
                self.yesNoDelegate?.yesTapped()
            }
        }
        else {
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func noTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
