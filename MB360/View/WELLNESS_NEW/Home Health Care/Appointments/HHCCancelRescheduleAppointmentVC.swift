//
//  HHCCancelRescheduleAppointmentVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 07/11/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class HHCCancelRescheduleAppointmentVC: UIViewController {

        
        @IBOutlet weak var lblHeader: UILabel!
        @IBOutlet weak var btnNo: UIButton!
        @IBOutlet weak var imgView: UIImageView!
        @IBOutlet weak var lblBottomLabel: UILabel!
        @IBOutlet weak var btnYes: UIButton!
        @IBOutlet weak var btnClose: UIButton!
        //@IBOutlet weak var viewBorder: UIView!
        
        var yesNoDelegate : HHCCancelAppointmentPopUpProtocol? = nil        
        var selectedAppointmentModel = AppointmentHHCModel()
        var isReschedule = false

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.view.makeTransparentBackground()

            if isReschedule {
                lblHeader.text = "Reschedule Appointment!"
                lblBottomLabel.text = "Are you sure you want to reschedule appointment"
            }
            else {
                lblHeader.text = "Cancel Appointment!"
                lblBottomLabel.text = "Are you sure you want to cancel appointment"
            }
            print("\(lblHeader.text) HHCCancelRescheduleAppointmentVC")
           // viewBorder.layer.cornerRadius = 10.0
            setColor()
        }
        
        func setColor() {
            self.btnYes.layer.cornerRadius = btnYes.bounds.height / 2
            self.btnYes.backgroundColor = Color.buttonBackgroundGreen.value
            //made chnage testing2.0
            self.btnNo.setTitleColor(Color.buttonBackgroundGreen.value, for: .normal)
            lblHeader.textColor = Color.buttonBackgroundGreen.value
//            self.btnNo.setTitleColor(Color.fontColor.value, for: .normal)
//            lblHeader.textColor = Color.fontColor.value
            btnYes.dropShadow()
            btnNo.dropShadow()
            
        }
        
        @IBAction func yesTapped(_ sender: Any) {
            if isReschedule {
                if yesNoDelegate != nil {
                    yesNoDelegate?.cancelToRescheduleAppointmentHHC(selectedAppointment: self.selectedAppointmentModel)
                }
                self.dismiss(animated: true, completion: nil)
            }
            else {
                if yesNoDelegate != nil {
                    yesNoDelegate?.cancelAppointmentHHC(selectedAppointment: self.selectedAppointmentModel)
                }
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
