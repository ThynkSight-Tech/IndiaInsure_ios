//
//  EnterAddressVC_HHC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 22/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit


protocol MobileEmailVerifyProtocol {
    func isMobileEmailVerified(isSuccess:Bool,selectedPersonObj:FamilyDetailsModelHHC)
}

class EnterAddressVC_HHC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    var isKeyboardAppear = false
    
    @IBOutlet weak var txtFlatNo: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtArea: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLandmark: SkyFloatingLabelTextField!
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPincode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!

    
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var termsCheckbox: UIButton!
    
    
    var isTermsAccepted = 0
    
    var selectedCityObject = CityListModel()
    var selectedNursingType : NursingType?
    var personDetailsDict = FamilyDetailsModelHHC()
    var delegateObject : MobileEmailVerifyProtocol? = nil
    
    var cityArray = [String]()
    var stateArray = [String]()
    let pickerView = ToolbarPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        print("in enter address : EnterAddressVC_HHC")
        //btnSave.makeHHCCircularButton()
        btnSave.makeHHCButton()
        //btnSave.disabledButton()

        middleView.layer.cornerRadius = 10.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        txtFlatNo.returnKeyType = UIReturnKeyType.done
        txtArea.returnKeyType = UIReturnKeyType.done
        txtLandmark.returnKeyType = UIReturnKeyType.done
        txtMobileNo.returnKeyType = UIReturnKeyType.done
        txtPincode.returnKeyType = UIReturnKeyType.done
        txtCity.returnKeyType = UIReturnKeyType.done
        txtState.returnKeyType = UIReturnKeyType.done
        txtEmail.returnKeyType = UIReturnKeyType.done

        btnTerms.setTitleColor(Color.buttonBackgroundGreen.value, for: .normal)
        
        addTextfieldListener()
        addDoneButtonOnKeyboard()
        
        self.cityArray = StateCityCollection.sharedInstance.getAllCities()
        self.stateArray = StateCityCollection.sharedInstance.getAllStates()

        self.txtState.inputView = self.pickerView
        self.txtState.inputAccessoryView = self.pickerView.toolbar
        self.txtCity.inputView = self.pickerView
        self.txtCity.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self as UIPickerViewDataSource
        self.pickerView.delegate = self as UIPickerViewDelegate
        self.pickerView.toolbarDelegate = self as ToolbarPickerViewDelegate
        
        self.pickerView.reloadAllComponents()

        print(cityArray)
    }

    //MARK:- Add Done Button On Keyboard
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = Color.buttonBackgroundGreen.value
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        // doneToolbar.tintColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
        
        txtMobileNo.inputAccessoryView = doneToolbar
        txtPincode.inputAccessoryView = doneToolbar
        //txtFlatNo.inputAccessoryView = doneToolbar
        //txtArea.inputAccessoryView = doneToolbar
        //txtLandmark.inputAccessoryView = doneToolbar
        //txtState.inputAccessoryView = doneToolbar

    }
    
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    

    @IBAction func termsOfUseTapped(_ sender: UIButton) {
       /* let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "WellnessOverviewVC") as! WellnessOverviewVC
        vc.isOverview = false
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        navigationController?.pushViewController(vc, animated: true)
       // self.present(vc, animated: true, completion: nil)
*/
        let url = URL(string: "https://portal.mybenefits360.com/termsOfUse.html")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)

    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    @IBAction func saveTapped(_ sender: UIButton) {
//        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "SelectOptionsVC_WN") as! SelectOptionsVC_WN
//        vc.selectedCityObject = self.selectedCityObject
//        //vc.memberInfoObj = obj
//        vc.selectedPersonObj = personDetailsDict
//        vc.selectedNursingType = self.selectedNursingType

        //self.navigationController?.pushViewController(vc, animated: true)
        
//        if delegateObject != nil {
//            self.dismiss(animated: true, completion: nil)
//            delegateObject?.isMobileEmailVerified(isSuccess: true, selectedPersonObj: personDetailsDict)
//        }
        
         validations()
        

    }
    
    func addTextfieldListener() {
        [txtFlatNo, txtArea, txtCity, txtState, txtPincode, txtMobileNo, txtEmail, txtLandmark].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }

    @objc func editingChanged(_ textField: UITextField) {
//        guard
//            let flatNo = txtFlatNo.text, !flatNo.isEmpty,
//            let area = txtArea.text, !area.isEmpty,
//            let landmark = txtLandmark.text, !landmark.isEmpty,
//            let state = txtState.text, !state.isEmpty,
//            let city = txtCity.text, !city.isEmpty,
//            let pincode = txtPincode.text, !pincode.isEmpty,
//            let email = txtEmail.text, !email.isEmpty,
//            let mobile = txtMobileNo.text, !mobile.isEmpty
//
//            else {
//                btnSave.disabledButton()
//                return
//        }
//
//        validations()
    }
    
    func validations()  {
        
        if txtMobileNo.text!.isEmpty {
            txtMobileNo.errorMessage = "Enter Mobile Number"
            txtMobileNo.becomeFirstResponder()
            [txtFlatNo, txtArea, txtCity, txtState, txtPincode,txtLandmark, txtEmail].forEach({ $0?.errorMessage = ""})

        }
        else if txtMobileNo.text!.count != 10 {
            txtMobileNo.errorMessage = "Enter 10 Digit Mobile Number"
            txtMobileNo.becomeFirstResponder()
            [txtFlatNo, txtArea, txtCity, txtState, txtPincode,txtLandmark, txtEmail].forEach({ $0?.errorMessage = ""})
        }
        else if txtEmail.text!.isEmpty {
            txtEmail.errorMessage = "Enter E-mail ID"
            txtEmail.becomeFirstResponder()
            
            [txtFlatNo, txtArea, txtCity, txtState, txtPincode,txtLandmark, txtMobileNo ].forEach({ $0?.errorMessage = ""})

        }
        else if !(isValidEmail(emailStr: txtEmail.text!))
        {
            txtEmail.errorMessage = "Enter valid E-Mail ID"
            txtEmail.becomeFirstResponder()
            [txtFlatNo, txtArea, txtCity, txtState, txtPincode,txtLandmark, txtMobileNo ].forEach({ $0?.errorMessage = ""})
        }
        else if txtFlatNo.text!.isEmpty {
            txtFlatNo.errorMessage = "Enter Flat/House No. Street"
            txtFlatNo.becomeFirstResponder()
            [txtEmail, txtArea, txtCity, txtState, txtPincode,txtLandmark, txtMobileNo].forEach({ $0?.errorMessage = ""})

        }
        else if txtArea.text!.isEmpty {
            txtArea.errorMessage = "Enter Area/Locality"
            txtArea.becomeFirstResponder()
            [txtEmail, txtFlatNo, txtCity, txtState, txtPincode,txtLandmark, txtMobileNo].forEach({ $0?.errorMessage = ""})
        }
        else if txtLandmark.text!.isEmpty {
            txtLandmark.errorMessage = "Enter Landmark"
            txtLandmark.becomeFirstResponder()
            [txtEmail, txtFlatNo, txtCity, txtState, txtPincode,txtArea, txtMobileNo].forEach({ $0?.errorMessage = ""})
        }
        else if txtState.text!.isEmpty {
            txtState.errorMessage = "Enter State"
            txtState.becomeFirstResponder()
            [txtEmail, txtFlatNo, txtCity, txtPincode,txtArea, txtMobileNo, txtLandmark].forEach({ $0?.errorMessage = ""})

        }
        else if txtCity.text!.isEmpty {
            txtCity.errorMessage = "Enter City"
            txtCity.becomeFirstResponder()
            [txtEmail, txtFlatNo, txtLandmark, txtPincode,txtArea, txtMobileNo, txtState].forEach({ $0?.errorMessage = ""})

        }
        else if txtPincode.text!.isEmpty {
            txtPincode.errorMessage = "Enter Pincode"
            txtPincode.becomeFirstResponder()
            
            [txtEmail, txtFlatNo, txtCity, txtLandmark,txtArea, txtMobileNo, txtState].forEach({ $0?.errorMessage = ""})
        }
        else if txtPincode.text!.count != 6 {
            txtPincode.errorMessage = "Enter 6 Digit Pincode"
            txtPincode.becomeFirstResponder()
            [txtFlatNo, txtArea, txtCity, txtState, txtMobileNo,txtLandmark, txtEmail].forEach({ $0?.errorMessage = ""})
        }
            
        else if isTermsAccepted == 0 {
            [txtEmail, txtFlatNo, txtLandmark, txtCity, txtPincode,txtArea, txtMobileNo, txtState].forEach({ $0?.errorMessage = ""})

            self.displayActivityAlert(title: "Please accept Terms of Use")
        }
        else {
            if let personSr = personDetailsDict.ExtPersonSRNo {
            let url = APIEngine.shared.sendMobileAddressEmailHHC_API(LINE1: txtFlatNo.text!, LINE2: txtArea.text!, LANDMARK: txtLandmark.text!, CITY: txtCity.text!, STATE: txtState.text!, PINCODE: txtPincode.text!, MobileNumber: txtMobileNo.text!, EmailId: txtEmail.text!, WellSerSrno:self.getServiceId(), PersonSrNo:personSr)
            self.sendAddressDataToServer(url: url)
            }
        }
        
        

    }
    
    func isValidEmail(emailStr:String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          
          let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailPred.evaluate(with: emailStr)
      }
    
    private func getServiceId() -> String {
        /*
         10                NURSING ATTENDANT=
         11                LONG TERM NURSING=
         12                SHORT TERM NURSING
         13                DOCTOR SERVICES
         14                PHYSIOTHERAPY
         15                DIABETESE MANAGEMENT
         16                ELDER CARE
         17                POST NATAL CARE
         */
        switch selectedNursingType {
        case .trainedAttendants:
            return "10"
            
        case .longTerm:
            return "11"
            
        case .shortTerm:
            return "12"
            
        case .doctorServices:
            return "13"
            
        case .physiotherapy:
            return "14"
            
        case .diabetesManagement:
            return "15"
            
        case .postNatelCare:
            return "16"
            
        case .elderCare:
            return "17"
            
        default:
            return ""
            break
        }
        
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtCity {
            self.cityArray = StateCityCollection.sharedInstance.getAllCitiesFrom(state: txtState.text!)
        }
    }


    @objc func keyboardWillShow(notification: NSNotification) {
        if txtCity.isEditing || txtPincode.isEditing || txtState.isEditing || txtLandmark.isEditing {
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
        else {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y < 0{
                    self.view.frame.origin.y = 0
                 print("After Hide",self.view.frame.origin.y)

                }
            }
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
    
}

extension EnterAddressVC_HHC {
    
    private func sendAddressDataToServer(url:String) {
    print(url)
        print("Send Address Info")
        
    ServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: NSDictionary(), view: self, onComplition: { (response, error) in
            
            if let msgDict = response?["message"].dictionary
            {
                guard let status = msgDict["Status"]?.bool else {
                    return
                }
                
                if status == true {
                   // let msg = msgDict["Message"]?.stringValue
                 // self.displayActivityAlert(title: msg ?? "")
                    
                    if self.delegateObject != nil {
                        self.dismiss(animated: true, completion: nil)
                        var address = String(format: "%@,%@,%@,%@,%@",self.txtFlatNo.text ?? "",self.txtArea.text ?? "", self.txtLandmark.text ?? "",self.txtPincode.text ?? "",self.txtCity.text ?? "",self.txtState.text ?? "")
                        
                        self.delegateObject?.isMobileEmailVerified(isSuccess: true, selectedPersonObj: self.personDetailsDict)
                    }

                }
                else {
                    //Failed to send member info
                    //if let msg = msgDict["Message"]?.stringValue {
                        self.displayActivityAlert(title: m_errorMsg )
                    //}
                }
            }
        })
    }
}


extension EnterAddressVC_HHC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if txtState.isFirstResponder == true {
           return stateArray.count
        }
        return self.cityArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtState.isFirstResponder == true {
            return stateArray[row]
        }
        else {
            return cityArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // self.txtCigarette.text = self.cigratteArray[row]
    }
}

extension EnterAddressVC_HHC: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
      
        if txtState.isFirstResponder == true {
            self.txtState.text = String(format: "%@", self.stateArray[row])
            self.txtCity.text = ""
            self.cityArray = StateCityCollection.sharedInstance.getAllCitiesFrom(state: txtState.text!)
        }
        else {
            self.txtCity.text = String(format: "%@", self.cityArray[row])
           // if txtState.text == "" {
            let stateName = StateCityCollection.sharedInstance.getStateNameFrom(selectedCity: txtCity.text!)
                self.txtState.text = stateName
            //}
        }
        
        self.view.endEditing(true)
    }
    
    func didTapCancel() {
        self.view.endEditing(true)
    }
}
