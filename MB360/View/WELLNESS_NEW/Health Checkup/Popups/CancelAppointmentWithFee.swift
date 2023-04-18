//
//  CancelAppointmentWithFee.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 02/07/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CancelAppointmentWithFee: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblHeaderCancelAppt: UILabel!
    @IBOutlet weak var lblmessage: UILabel!
    @IBOutlet weak var lblBlueLabel: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
    @IBOutlet weak var lblPriceDescription: UILabel!
    
    var appointmentCancelFeeProtocolDelegate : AppointmentPopUpProtocol? = nil
    var selectedAppointmentModel = AppointmentModel()
    var cancellationAmount = "0"
    var refundAmount = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.makeTransparentBackground()

        self.navigationController?.navigationBar.navBarDropShadow()
        
        
        setColors()
        
        if selectedAppointmentModel.CancelationCharge != "-1" {
            cancellationAmount = selectedAppointmentModel.CancelationCharge ?? ""
        }
        
        let cancAmt = getFormattedCurrency(amount: cancellationAmount)
        let stringTempFirst = String(format: "A cancellation fee of %@ inclusive of applicable taxes will be deducted and ", cancAmt)
        
        if let refund = selectedAppointmentModel.RefundAmount {
        refundAmount = refund
        }
        
        let refAmt = getFormattedCurrency(amount: refundAmount)
        
        let stringTempSecond = String(format: "%@ will be refunded back to your account/card within 10-15 working days",refAmt)
        let colorFirst = getColoredText(string_to_color: cancAmt, string_to_color2: "", color:Color.fontColor.value , fullString: stringTempFirst)
        let colorSecond = getColoredText(string_to_color: refAmt, string_to_color2: "", color:Color.fontColor.value , fullString: stringTempSecond)
        
        let attributedStr = NSMutableAttributedString()
        attributedStr.append(colorFirst)
        attributedStr.append(colorSecond)

        
        
        self.lblPriceDescription.attributedText = attributedStr
    
        if let reschCharge = selectedAppointmentModel.RescheduleCharge {
            
            if reschCharge != "-1" {
                let rccharge = getFormattedCurrency(amount: reschCharge)

                let stringTemp1 = String(format: "Alertnatively, you can reschedule your appointment by paying just %@", rccharge)
                
                self.lblBlueLabel.attributedText = getColoredText(string_to_color: rccharge, string_to_color2:"", color:Color.fontColor.value , fullString: stringTemp1)
            }
            else {
                let stringTemp1 = String(format: "Alertnatively, you can reschedule your appointment")
                self.lblBlueLabel.attributedText = getColoredText(string_to_color: reschCharge, string_to_color2:"", color:Color.fontColor.value , fullString: stringTemp1)

            }
        }
        
        print("In CancelAppointmentWithFee")
    }
    
    private func getFormattedCurrency(amount:String) -> String {
        if amount == "" {
            return ""
        }
        
        let myDouble = Double(amount)!
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = ""
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        currencyFormatter.currencySymbol = ""

        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        var priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
        print(priceString)
        priceString = priceString.replacingOccurrences(of: ".00", with: "")
        priceString = priceString.replacingOccurrences(of: " ", with: "")
        
        let formatedString =  String(format: "₹%@",priceString)
        
        return formatedString.removeWhitespace()
    }
    

    
    private func getColoredText(string_to_color:String,string_to_color2:String,color:UIColor,fullString:String) -> NSMutableAttributedString {
        
        
        let range = (fullString as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: fullString)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        
        let range2 = (fullString as NSString).range(of: string_to_color2)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range2)

        
        return attribute
    }
    private func setColors() {
        self.btnYes.dropShadow()
        self.btnYes.backgroundColor = Color.buttonBackgroundGreen.value
        self.lblHeaderCancelAppt.textColor = Color.fontColor.value
        self.btnYes.layer.cornerRadius = self.btnYes.frame.height / 2
        self.btnNo.setTitleColor(Color.fontColor.value, for: .normal)
    }
    
    @IBAction func yesDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {

            if self.appointmentCancelFeeProtocolDelegate != nil {
                self.appointmentCancelFeeProtocolDelegate?.cancelToRescheduleAppointment(selectedAppointment: self.selectedAppointmentModel)
        }
        })
        
    }
    
    @IBAction func noDidTapped(_ sender: Any) {
        if appointmentCancelFeeProtocolDelegate != nil {
            appointmentCancelFeeProtocolDelegate?.cancelAppointment(selectedAppointment: self.selectedAppointmentModel)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCloseDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
