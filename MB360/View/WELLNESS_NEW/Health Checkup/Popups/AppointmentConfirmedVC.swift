//
//  AppointmentConfirmedVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 27/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

protocol AppointmentConfirmedProtocol {
    func okTapped()
}

class AppointmentConfirmedVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    
    @IBOutlet weak var lblPaymentId: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var btnOk: UIButton!
    
    var confirmAppointmentDelegate:AppointmentConfirmedProtocol? = nil
    
    var orderNo = ""
    var amount = ""
    var paymentId = ""
    
    var isPaymentDone = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.navBarDropShadow()
        self.view.makeTransparentBackground()

        if isPaymentDone == 0 {
            self.lblAmount.isHidden = true
        }
        
        btnOk.dropShadow()
        btnOk.layer.cornerRadius = btnOk.frame.height / 2
        
        self.lblOrderNumber.text = orderNo
        self.lblPaymentId.text = paymentId
        
        let currencyForm = getFormattedCurrency(amount: amount)
        self.lblAmount.text = currencyForm

        setColors()
        
        print("In AppointmentConfirmedVC")
    }
    
    private func setColors() {
        self.btnOk.backgroundColor = Color.buttonBackgroundGreen.value
        self.lblHeader.textColor = Color.fontColor.value
        
        self.btnOk.layer.cornerRadius = self.btnOk.frame.height / 2
    }
    
    @IBAction func btnCloseDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnOkDidTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.confirmAppointmentDelegate?.okTapped()
        }
      //  self.dismiss(animated: true, completion: nil)
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
    
}
