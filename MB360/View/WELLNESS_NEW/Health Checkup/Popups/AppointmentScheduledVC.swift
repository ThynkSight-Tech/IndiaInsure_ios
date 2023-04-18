//
//  AppointmentScheduledVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 15/07/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit



class AppointmentScheduledVC: UIViewController {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    var responseMsg = ""

    var appointmentOkDelegate:AppointmentConfirmedProtocol? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.navBarDropShadow()
        self.view.makeTransparentBackground()
        
        if responseMsg != ""{
            lblHeader.text = responseMsg
            lblHeader.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h15))
        }
        else{
            
            lblHeader.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h13))
        }
        btnOk.dropShadow()
        btnOk.layer.cornerRadius = btnOk.frame.height / 2
        print("In AppointmentScheduledVC")
        setColors()
    }
    
    private func setColors() {
        self.btnOk.backgroundColor = Color.buttonBackgroundGreen.value
        //self.lblHeader.textColor = Color.fontColor.value
        
        self.btnOk.layer.cornerRadius = self.btnOk.frame.height / 2
    }
    
    @IBAction func btnCloseDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOkDidTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.appointmentOkDelegate?.okTapped()
        }
    }

}
