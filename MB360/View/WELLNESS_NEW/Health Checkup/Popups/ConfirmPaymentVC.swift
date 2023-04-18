//
//  ConfirmPaymentVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 08/07/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class ConfirmPaymentVC: UIViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblBottomLabel: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var lblPriceLabel: UILabel!

    var yesNoDelegate : YesNoProtocol? = nil
    var summaryModelObject = SummaryModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.makeTransparentBackground()

        viewBorder.layer.cornerRadius = 10.0
    
        if summaryModelObject.Youpay == "0" {
            let tempStr = "Do you wish to confirm your appointment?"
            self.lblPriceLabel.text = tempStr
        }
        else {
            let amtText = summaryModelObject.Youpay ?? ""
            let currencyForm = getFormattedCurrency(amount: amtText)

            let tempStr = String(format: "You will be redirected to our secure payment gateway in order to process your payment of %@ and schedule your Health Checkups. \nDo you wish to continue?", currencyForm)
            let attributedText = handleRuppeeText(customFontString: tempStr, SystemFontString: "₹")
            self.lblPriceLabel.attributedText = attributedText
            //self.lblPriceLabel.text = tempStr
        }
        
        setColor()
        print("In ConfirmPaymentVC")
    }
    
    func handleRuppeeText(customFontString: String, SystemFontString: String) -> NSAttributedString {
        let poppinsFont = UIFont(name: "Poppins-Medium",
                                 size: 14)
        
        let attributedString = NSMutableAttributedString(string: customFontString,
                                                         attributes: [NSAttributedString.Key.font: poppinsFont!])
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: poppinsFont!.pointSize)]
        let range = (customFontString as NSString).range(of: SystemFontString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
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
    
    
    func setColor() {
        self.btnYes.layer.cornerRadius = btnYes.bounds.height / 2
        self.btnNo.layer.cornerRadius = btnNo.bounds.height / 2
        self.btnYes.backgroundColor = Color.buttonBackgroundGreen.value
        self.btnNo.setTitleColor(Color.fontColor.value, for: .normal)
        self.lblHeader.textColor = Color.fontColor.value
        
      
        btnYes.dropShadow()
        btnNo.dropShadow()
        //btnNo.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
       // btnNo.layer.borderWidth = 1.0
        
    }
    
    func addborder() {
//        btnNo.layer.shadowColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 0.25).cgColor
//        btnNo.layer.shadowOffset = CGSize(width: 0, height: 3)
//        btnNo.layer.shadowOpacity = 1.0
//        btnNo.layer.shadowRadius = 10.0
//        btnNo.layer.masksToBounds = false
        
        btnNo.layer.shadowColor = UIColor.black.cgColor
        btnNo.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnNo.layer.masksToBounds = false
        btnNo.layer.shadowRadius = 0.5
        btnNo.layer.shadowOpacity = 0.5
        btnNo.layer.cornerRadius = btnNo.bounds.height / 2
        btnNo.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btnNo.layer.borderWidth = 0.7
        
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
