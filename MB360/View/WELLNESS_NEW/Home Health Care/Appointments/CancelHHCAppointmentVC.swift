//
//  CancelNursingAppointmentVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 05/11/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol HHCCancelAppointmentPopUpProtocol {
    func cancelToRescheduleAppointmentHHC(selectedAppointment:AppointmentHHCModel)
    func cancelAppointmentHHC(selectedAppointment:AppointmentHHCModel)
}

class CancelHHCAppointmentVC: UIViewController {

       @IBOutlet weak var imgView: UIImageView!
       @IBOutlet weak var lblHeaderCancelAppt: UILabel!
       @IBOutlet weak var lblmessage: UILabel!
       @IBOutlet weak var lblBlueLabel: UILabel!
       @IBOutlet weak var btnNo: UIButton!
       @IBOutlet weak var btnYes: UIButton!
       
       var appointmentCancelProtocolDelegate : HHCCancelAppointmentPopUpProtocol? = nil
       var selectedAppointmentModel = AppointmentHHCModel()

       override func viewDidLoad() {
           super.viewDidLoad()
           print("In CancelHHCAppointmentVC")

           self.navigationController?.navigationBar.navBarDropShadow()
           self.view.makeTransparentBackground()
            setColors()
        
       }
       
       private func setColors() {
           self.btnYes.dropShadow()
           self.btnYes.backgroundColor = Color.buttonBackgroundGreen.value
           self.lblHeaderCancelAppt.textColor = Color.fontColor.value
           self.btnYes.layer.cornerRadius = self.btnYes.frame.height / 2
           self.btnNo.setTitleColor(Color.redFont.value, for: .normal)
           
       }

       @IBAction func yesDidTapped(_ sender: Any) { //I want to reschedule
           
           if appointmentCancelProtocolDelegate != nil {
               appointmentCancelProtocolDelegate?.cancelToRescheduleAppointmentHHC(selectedAppointment:self.selectedAppointmentModel)
           }
           self.dismiss(animated: true, completion: nil)
           
       }
       
       @IBAction func noDidTapped(_ sender: Any) { //I want to cancel
           
           if appointmentCancelProtocolDelegate != nil {
               appointmentCancelProtocolDelegate?.cancelAppointmentHHC(selectedAppointment:self.selectedAppointmentModel)
           }
           self.dismiss(animated: true, completion: nil)
       }
       
       @IBAction func btnCloseDidTapped(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
       }
       
   }

