//
//  VerifyMobileNoViewController.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 04/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit


protocol MobileNumberVerifyDelegate {
    func mobileNumberVerified()
}

class VerifyMobileNoViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var termsCheckbox: UIButton!
    
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var lblMobile: UILabel!
    
    //var memberDetailsModel = FamilyDetailsModel()
    var memberDetailsModel = PersonCheckupModel()

    var isTermsAccepted = 0
    var isKeyboardAppear = false
    
    var mobileNumberDelegate : MobileNumberVerifyDelegate? = nil
    
    var isTemp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In VerifyMobileNoViewController")
        self.btnTerms.underline()
        setColor()
        
        self.navigationController?.navigationBar.changeFont()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.txtMobileNumber.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addDoneButtonOnKeyboard()
    }
    
    private func setColor()
    {
        lblMobile.textColor = Color.fontColor.value
        btnTerms.setTitleColor(Color.fontColor.value, for: .normal)
        btnVerify.backgroundColor = Color.buttonBackgroundGreen.value

    }
    
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.tintColor = Color.fontColor.value
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = Color.fontColor.value
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtMobileNumber.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        
//        if isKeyboardAppear {
//            //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y != 0 {
//                    self.view.frame.origin.y += 300
//                }
//           // }
//            isKeyboardAppear = false
//        }
        txtMobileNumber.resignFirstResponder()

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let _ : Int = (txtMobileNumber.text?.count)!
        
        let MAX_LENGTH_PHONENUMBER = 10
        let ACCEPTABLE_NUMBERS = "0123456789"
        let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
        let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
        let strValid = string.rangeOfCharacter(from: numberOnly) == nil
        return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if !isKeyboardAppear {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y == 0{
//                    self.view.frame.origin.y -= 300
//                }
//            }
//            isKeyboardAppear = true
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if isKeyboardAppear {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y != 0 {
//                    self.view.frame.origin.y += 300
//                }
//            }
//            isKeyboardAppear = false
//        }
//    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("Keyboard Show",self.view.frame.origin.y)
           if !isKeyboardAppear {
               if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                   if self.view.frame.origin.y == 0{
                       self.view.frame.origin.y -= keyboardSize.height
                    print("After Show",self.view.frame.origin.y)

                   }
               }
               isKeyboardAppear = true
           }
       }
       
       @objc func keyboardWillHide(notification: NSNotification) {
        print("Keyboard Hide",self.view.frame.origin.y)

           if isKeyboardAppear {
               if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                   if self.view.frame.origin.y < 0{
                       self.view.frame.origin.y = 0
                    print("After Hide",self.view.frame.origin.y)

                   }
               }
               isKeyboardAppear = false
           }
       }
    

    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func termsDidTapped(_ sender: Any) {
        //Show Web Page
        let url = URL(string: "http://mybenefits360.in/wellness/termsOfUse.aspx")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        //if let url = Bundle.main.url(forResource: "gpa_instructions", withExtension: "html")
        //{
            //let request = NSURLRequest(url: url)
            //UIApplication.shared.canOpenURL(url)
           //UIApplication.shared.open(url, options: [:], completionHandler: nil)
       // }

//        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "WellnessOverviewVC") as! WellnessOverviewVC
//        vc.isOverview = false
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .custom
//        self.present(vc, animated: true, completion: nil)
////        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func termsCheckboxTapped(_ sender: Any) {
        if isTermsAccepted == 0 {
            termsCheckbox.setImage(UIImage(named: "checked1"), for: .normal)
            
            isTermsAccepted = 1
        }
        else {
            termsCheckbox.setImage(UIImage(named: "checkbox"), for: .normal)
            
            isTermsAccepted = 0
        }
    }
    
    @IBAction func verifyBtnDidTapped(_ sender: Any) {
        let mobileText = txtMobileNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (mobileText?.isValidContact == false) {
            displayActivityAlert(title: "Please Enter Valid Mobile Number")
        }
            
        else if isTermsAccepted == 0 {
            displayActivityAlert(title: "Please accept Terms of Use")
        }
            
        else {
            //{"PersonSrNo":"1212", "MobileNumber":"12122", "EmailId":"sas@gamil.com"}
            
            if isTemp {
                self.dismiss(animated: true, completion: {
                    self.mobileNumberDelegate?.mobileNumberVerified()
                })

            }
            else {
            let dictionary = ["PersonSrNo":memberDetailsModel.PersonSRNo?.description,"MobileNumber":mobileText,"EmailId":memberDetailsModel.EmailID]
            sendMobileNumberToServer(parameter: dictionary as NSDictionary)
            }
        }
        
    }
    
    //MARK:- Send Mobile Number to server
    private func sendMobileNumberToServer(parameter:NSDictionary) {
        print("Insert Mobile Info")
        
        let url = APIEngine.shared.addMobileNumberURL()
        print(url)
        ServerRequestManager.serverInstance.putDataToServer(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    self.dismiss(animated: true, completion: {
                        
                        self.mobileNumberDelegate?.mobileNumberVerified()
                    })
                    
                }
            }
            else {
                //Failed to send member info
            }
        })
        
    }
}


