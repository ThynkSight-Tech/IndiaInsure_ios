//
//  SearchPincodeForMD_VC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 11/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

protocol MoveToMedicineDelegate {
    func moveToMedicineSection()
}

class SearchPincodeForMD_VC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var lblInfoMsg: UILabel!
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var centerView: UIView!
    
    var medicineDelegateObj : MoveToMedicineDelegate? = nil
    
    var isKeyboardAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.centerView.layer.cornerRadius = 2.0
        self.viewSearch.backgroundColor = Color.buttonBackgroundGreen.value
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchTapped(_:)))
        viewSearch.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addDoneButtonOnKeyboard()

        print("In \(self.title ?? "") SearchPincodeForMD_VC")
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
        
        txtPincode.inputAccessoryView = doneToolbar
    }

    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Search Tapped
    @objc private func searchTapped(_ sender: UITapGestureRecognizer)
    {
        
        if let pincodeStr = txtPincode.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            if pincodeStr.count == 0 {
                self.displayActivityAlert(title: "Please Enter Pincode")
            }
            else if pincodeStr.count != 6 {
                self.displayActivityAlert(title: "Please Enter valid Pincode")
            }
            else {
                //API Call to check farmacy available or not
               //serverCall()
                self.moveToMedicine()

            }
        }
        
    }
    
    private func moveToMedicine() {
        self.dismiss(animated: true) {
            if self.medicineDelegateObj != nil {
                self.medicineDelegateObj?.moveToMedicineSection()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        guard !s.isEmpty else { return true }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        return numberFormatter.number(from: s)?.intValue != nil
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= 80
                }
            }
            isKeyboardAppear = true
        }
    }
    @objc func doneButtonAction(){
        txtPincode.resignFirstResponder()
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += 80
                }
            }
            isKeyboardAppear = false
        }
    }
    
    
    private func serverCall() {
        
        let url = APIEngine.shared.checkPincodeURL(pincode: self.txtPincode.text!)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            
            if let status = response?["Status"].bool
                {
                    if status == true {
                        if let status = response?["IsServiceable"].bool
                        {
                            if status == true {
                                //Move To Next
                                self.moveToMedicine()
                            }
                            else {
                                self.displayActivityAlert(title: "Service not available in your area")
                            }
                        }
                    }
                    else {
                        //Relations record not found
                        self.displayActivityAlert(title: "Something went wrong.")
                    }
                }
          
        }
    }
}
