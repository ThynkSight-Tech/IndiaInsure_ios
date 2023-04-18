//
//  AddNewAddressMD_VC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 15/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit


protocol AddNewAddressForMedicineProtocol {
    func newAddressAdded(modelObj:[AddressModel_MD])
}

//Single class for Add Address and Edit Address record
class AddNewAddressMD_VC: UIViewController,UITextFieldDelegate {
    
    
    var isEdit = 0
    var isKeyboardAppear = false

    //TextFields
    
    @IBOutlet weak var txtFlatStreet: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    
    @IBOutlet weak var txtLandmark: UITextField!
    
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var btnSaveAddress: UIButton!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtEmailId: UITextField!
    
    @IBOutlet weak var backgroundView: UIView!
    
    
    @IBOutlet weak var lblFlatNo: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblLandmark: UILabel!
    @IBOutlet weak var lblPincode: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblEmailId: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var addressModelArray = [AddressModel_MD]()
    var arrayIndex = 0
    var addAddedDelegateObj:AddNewAddressForMedicineProtocol? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundView.layer.cornerRadius = 4.0
        self.view.backgroundColor = Color.backgroundLightGrayShade.value
        self.backgroundView.backgroundColor = UIColor.white
        
        
        if isEdit == 0 {
            self.title = "Add New Address"
            self.btnSaveAddress.setTitle("Save Address", for: .normal)
        }
        else {
            self.title = "Edit Address"
            self.btnSaveAddress.setTitle("Update Address", for: .normal)
        }
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        btnSaveAddress.backgroundColor = Color.buttonBackgroundGreen.value
        btnSaveAddress.makeCicular()
        
        
        
        //Set Bottom Border
        txtFlatStreet.setBottomBorder()
        txtArea.setBottomBorder()
        txtLandmark.setBottomBorder()
        txtPincode.setBottomBorder()
        txtCity.setBottomBorder()
        txtState.setBottomBorder()
        txtMobileNo.setBottomBorder()
        txtEmailId.setBottomBorder()
        
        //Set Label Colors
        setLabelColor(label: lblCity)
        setLabelColor(label: lblState)
        setLabelColor(label: lblFlatNo)
        setLabelColor(label: lblEmailId)
        setLabelColor(label: lblState)
        setLabelColor(label: lblPincode)
        setLabelColor(label: lblLandmark)
        setLabelColor(label: lblLocation)
        setLabelColor(label: lblMobileNo)
        
        if isEdit == 1 {
            showText()
        }
        
        print("In \(self.title ?? "") AddNewAddressMD_VC")
    }
    
    private func showText() {
        let obj = addressModelArray[arrayIndex]
        txtFlatStreet.text = obj.FlatHouse
        txtArea.text = obj.Area
        txtCity.text = obj.City
        txtPincode.text = obj.Pincode
        txtLandmark.text = obj.Landmark
        txtMobileNo.text = obj.Mobile
        txtEmailId.text = obj.EmailId
        txtState.text = obj.State
    }
    
    private func setLabelColor(label:UILabel)
    {
        label.textColor = Color.fontColor.value
    }
    
    
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func saveDidTapped(_ sender: Any) {
        var txtFlatNo = txtFlatStreet.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var txtAreaText = txtArea.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var txtLandMark = txtLandmark.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var pincodeTxt = txtPincode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var cityText = txtCity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var stateText = txtState.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var mobText = txtMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var emailText = txtEmailId.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtFlatNo == "" {
            displayActivityAlert(title: "Please Enter Flat No")
        }
        else if txtAreaText == "" {
            displayActivityAlert(title: "Please Enter Location")
        }
        else if txtLandMark == "" {
            displayActivityAlert(title: "Please Enter Landmark")
        }
        else if pincodeTxt == "" {
            displayActivityAlert(title: "Please Enter Pincode")
        }
        else if pincodeTxt?.count != 6 {
            displayActivityAlert(title: "Please Enter Valid Pincode")
        }
        else if cityText == "" {
            displayActivityAlert(title: "Please Enter City")
        }
        else if stateText == "" {
            displayActivityAlert(title: "Please Enter State")
        }
        else if mobText == "" {
            displayActivityAlert(title: "Please Enter Mobile No")
        }
        else if mobText?.isValidContact == false {
            displayActivityAlert(title: "Please Enter Valid Mobile No")
        }
        else if emailText == "" {
            displayActivityAlert(title: "Please Enter Email Id")
        }
        else if isValidEmail(emailStr: emailText ?? "") == false {
            displayActivityAlert(title: "Please Enter Valid Email Id")
        }
        else {
            //Success
            
            if isEdit == 0 {
                let addModelObj = AddressModel_MD.init(FlatHouse: txtFlatNo, Area: txtAreaText, Landmark: txtLandMark, Pincode: pincodeTxt, City: cityText, State: stateText, EmailId: emailText, Mobile: mobText)
                
                self.addressModelArray.append(addModelObj)
                
                //displayActivityAlert(title: "Address added Successfully")
                if self.addAddedDelegateObj != nil {
                    self.addAddedDelegateObj?.newAddressAdded(modelObj: addressModelArray)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else { //edit
                let addModelObj = AddressModel_MD.init(FlatHouse: txtFlatNo, Area: txtAreaText, Landmark: txtLandMark, Pincode: pincodeTxt, City: cityText, State: stateText, EmailId: emailText, Mobile: mobText)
                
                
                
                //displayActivityAlert(title: "Address added Successfully")
                if self.addAddedDelegateObj != nil {
                    self.addressModelArray[arrayIndex] = addModelObj
                    self.addAddedDelegateObj?.newAddressAdded(modelObj: addressModelArray)
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        
    }
    
    // timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addedAddress), userInfo: nil, repeats: false)
    
    
    
    
    //@objc func addedAddress() {
    //}
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        scrollView.contentInset.bottom = 0
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
            guard let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
       
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
}
