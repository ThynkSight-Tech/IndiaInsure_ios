//
//  extensions.swift
//  MyBenefits360
//
//  Created by home on 08/12/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation


extension UIView {
    func myCustomAnimation() {
        print("CS Animation....")
//        self.alpha = 0
//        self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
//        UIView.animate(withDuration: 0.7) {
//            self.alpha = 1
//            self.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
//        }
        
       // self.layer.contents = #imageLiteral(resourceName: "").cgImage
       // self.backgroundColor = UIColor.clear
        
        //        UIView.transition(with: self,
        //                          duration: 0.5,
        //                          options: [.transitionFlipFromTop],
        //                          animations: {
        //
        //                            self.isHidden = true
        //        },
        //                          completion: {(void) in
        //                            self.isHidden = false
        //
        //                            })
        
    }
    
    func dropShadow(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 3)
        layer.shadowRadius = 3
        
        layer.cornerRadius = frame.size.height/2
        
    }
    
    
    
    func setBorderToView(color : UIColor)
    {
        layer.masksToBounds=true
        layer.cornerRadius=frame.size.height/2
        layer.borderColor=color.cgColor
        layer.borderWidth=1
    }
    
    func setBorderToViewSelectPolicy(color : UIColor)
    {
        layer.masksToBounds=true
        layer.cornerRadius=cornerRadiusForView//8
        layer.borderColor=color.cgColor
        layer.borderWidth=1
    }
    
    func ShadowForView(scale: Bool = true)
    {
        
        
        let shadowSize : CGFloat = 3.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: frame.size.width + shadowSize,
                                                   height: frame.size.height + shadowSize))
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.cornerRadius=cornerRadiusForView//8
        
    }
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.65, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}


extension UITextField {

    @available(iOS 13.4, *)
    func addInputViewDatePicker(_ selectedDate : Date,_ maxDate : Date,target: Any, selector: Selector) {

   let screenWidth = UIScreen.main.bounds.width

   //Add DatePicker as inputView
   let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
   datePicker.datePickerMode = .date

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }else{
            datePicker.preferredDatePickerStyle = .automatic
        }
        
        datePicker.maximumDate = maxDate//Calendar.current.date(byAdding: .year, value: 1, to: Date())
        datePicker.minimumDate = selectedDate
        
   self.inputView = datePicker

   //Add Tool Bar as input AccessoryView
   let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
   let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
   let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
   let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
   toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

   self.inputAccessoryView = toolBar
}

  @objc func cancelPressed() {
    self.resignFirstResponder()
  }
}

extension Data
{
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding)
        {
            append(data)
        }
    }
}




