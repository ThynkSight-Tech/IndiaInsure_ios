//
//  RescheduleApptVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 28/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class RescheduleApptVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblHeaderCancelAppt: UILabel!
    @IBOutlet weak var lblBlueLabel: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
    var rescheduleAmount = "0"
    var selectedAppointmentModel = AppointmentModel()
    var appointmentProtocolDelegate : AppointmentPopUpProtocol? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.makeTransparentBackground()

        self.navigationController?.navigationBar.navBarDropShadow()
        
        if selectedAppointmentModel.RescheduleCharge != "-1" {
            self.rescheduleAmount = selectedAppointmentModel.RescheduleCharge ?? "0"
        }
        setColors()
        print("In RescheduleApptVC")
    }
    
    private func setColors() {
        self.btnYes.dropShadow()
        self.btnYes.backgroundColor = Color.buttonBackgroundGreen.value
        self.lblHeaderCancelAppt.textColor = Color.fontColor.value
        self.btnYes.layer.cornerRadius = self.btnYes.frame.height / 2
        //btnNo.setTitleColor(Color.fontColor.value, for: .normal)
        
        if rescheduleAmount != "0" && rescheduleAmount != "-1" {
        let amountPrice = getFormattedCurrency(amount: rescheduleAmount)
        let stringTemp = String(format: "Reschedule your appointment by paying a nominal rescheduling fee of %@", amountPrice)
            
            self.lblBlueLabel.attributedText = getColoredText(string_to_color: amountPrice, color:Color.fontColor.value , fullString: stringTemp)

        }
        else {
            lblBlueLabel.text = "Alternatively you can reschedule your appointment"
        }
    }
    
    private func getColoredText(string_to_color:String,color:UIColor,fullString:String) -> NSMutableAttributedString {
        
        
        let range = (fullString as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: fullString)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        
        
        return attribute
    }
    
    private func getFormattedCurrency(amount:String) -> String {
        
        if amount == "" {
            return ""
        }
        
        let myDouble = Double(amount)!
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = ""
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        var priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
        print(priceString)
        priceString = priceString.replacingOccurrences(of: ".00", with: "")
        priceString = priceString.replacingOccurrences(of: " ", with: "")
        
        let formatedString =  String(format: "₹%@",priceString)
        
        return formatedString.removeWhitespace()
    }
    
    
    
    //Reschedule
    @IBAction func yesDidTapped(_ sender: Any) {
        
        if appointmentProtocolDelegate != nil {
           appointmentProtocolDelegate?.rescheduleAppointment(selectedAppointment: self.selectedAppointmentModel)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //Cancle tapped
//    @IBAction func noDidTapped(_ sender: Any) {
//
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func btnCloseDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

