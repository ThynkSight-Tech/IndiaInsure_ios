//
//  CancelAppointmentVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 28/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CancelAppointmentVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblHeaderCancelAppt: UILabel!
    @IBOutlet weak var lblmessage: UILabel!
    @IBOutlet weak var lblBlueLabel: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
    var appointmentCancelProtocolDelegate : AppointmentPopUpProtocol? = nil
    var selectedAppointmentModel = AppointmentModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.navBarDropShadow()
        self.view.makeTransparentBackground()
        setColors()
        print("In CancelAppointmentVC")
    }
    
    private func setColors() {
        self.btnYes.dropShadow()
        self.btnYes.backgroundColor = Color.buttonBackgroundGreen.value
        self.lblHeaderCancelAppt.textColor = Color.fontColor.value
        self.btnYes.layer.cornerRadius = self.btnYes.frame.height / 2
        self.btnNo.setTitleColor(Color.fontColor.value, for: .normal)
        
     
        
    }

    @IBAction func yesDidTapped(_ sender: Any) { //I want to reschedule
        
        if appointmentCancelProtocolDelegate != nil {
            appointmentCancelProtocolDelegate?.cancelToRescheduleAppointment(selectedAppointment: self.selectedAppointmentModel)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func noDidTapped(_ sender: Any) { //I want to cancel
        
        if appointmentCancelProtocolDelegate != nil {
            appointmentCancelProtocolDelegate?.cancelAppointment(selectedAppointment: self.selectedAppointmentModel)
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func btnCloseDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
