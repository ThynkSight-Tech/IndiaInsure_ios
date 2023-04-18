//
//  ProfileFitnessTVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 14/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import AktivoCoreSDK
import SlideMenuControllerSwift
import Alamofire

protocol OnboardingProtocol {
    func onboardingCompleted(isComplete:Bool)
}

class LoginFitnessProfile: UITableViewController,UITextFieldDelegate {
    
    //TextFields
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtWakeUpTime: UITextField!
    @IBOutlet weak var txtCigarette: UITextField!
    @IBOutlet weak var txtDrinks: UITextField!
    @IBOutlet weak var txtBedTime: UITextField!
    
    
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var imgFirstName: UIImageView!
    @IBOutlet weak var imgLastName: UIImageView!
    @IBOutlet weak var imgGender: UIImageView!
    @IBOutlet weak var imgPhoneNo: UIImageView!
    @IBOutlet weak var imgDob: UIImageView!
    @IBOutlet weak var imgWakeupTime: UIImageView!
    @IBOutlet weak var imgBedTime: UIImageView!
    @IBOutlet weak var imgWeight: UIImageView!
    
    //Gender Switch
    @IBOutlet weak var genderSwitchView: UIView!
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var viewFemale: UIView!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    
    //Height Switch
    @IBOutlet weak var heightSwitchView: UIView!
    @IBOutlet weak var viewCM: UIView!
    @IBOutlet weak var viewFT: UIView!
    @IBOutlet weak var lblFT: UILabel!
    @IBOutlet weak var lblCM: UILabel!
    @IBOutlet weak var feetView: UIView!
    @IBOutlet weak var txtFeet: UITextField!
    @IBOutlet weak var imgFeet: UIImageView!
    @IBOutlet weak var txtInch: UITextField!
    @IBOutlet weak var imgInch: UIImageView!
    
    //Height Switch
    @IBOutlet weak var weightSwitchView: UIView!
    @IBOutlet weak var viewLBS: UIView!
    @IBOutlet weak var viewKG: UIView!
    @IBOutlet weak var lblLBS: UILabel!
    @IBOutlet weak var lblKG: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    //view for image
    
    @IBOutlet weak var viewForImage: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblChange: UILabel!
    
    //    let wrongImageName = "negativearrrow40x40"
    //  let correctImageName = "positivearrrow20x20"
    
    let wrongImageName = "wrongF"
    let correctImageName = "correctF"
    
    var wrongImage = UIImage()
    var correctImage = UIImage()
    
    let pickerView = ToolbarPickerView()
    let cigratteArray = ["0", "1", "2", "3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20+"]
    
    var datePicker = UIDatePicker()
    
    var weightFlag = 0 //0 for KG, 1 for lbs
    var heightFlag = 0 //0 for feet, 1 for CM
    
    var feetArray = (1...8).map { "\($0)" }
    var weightArray = (30...400).map { "\($0)" }
    var inchArray = (0...11).map { "\($0)" }
    var cmArray = (48...253).map { "\($0)" }
    var lbsArray = (66...662).map { "\($0)" }
    var finalArray = [String]()
    
    var m_profilearray : Array<PERSON_INFORMATION> = []
    var m_profileDict : PERSON_INFORMATION?
    var m_employeedict : EMPLOYEE_INFORMATION?
    
    var delegateOnboarding:OnboardingProtocol? = nil
    var isFromInsurance = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- set Gradient color
        //self.setTableViewBackgroundGradient(sender: self, Color.fitnessBottom.value, Color.fitnessTop.value)
        //self.slideMenuController()?.removeRightGestures()
        self.tabBarController?.tabBar.isHidden = true
        
        self.btnSubmit.layer.cornerRadius = self.btnSubmit.frame.height / 2;
        self.setFitnessBackground()
        self.view.backgroundColor = UIColor.white
        //self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.hideBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])
        
        //let rightBarButton = UIBarButtonItem(title: "Privacy Policy", style: .plain, target:self, action:#selector(moveToPrivacyPolicy))
        //self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        wrongImage = UIImage(named: wrongImageName)!
        correctImage = UIImage(named: correctImageName)!
        
        addDoneButtonOnKeyboard()
        setupSwitchView()
        setupHeightView()
        setupWeightView()
        
        let textfields : [UITextField] = [txtFirstName,txtLastName,txtGender,txtPhoneNo,txtHeight,txtWeight,txtDrinks,txtCigarette,txtInch,txtFeet]
        for textfield in textfields {
            textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        self.txtCigarette.inputView = self.pickerView
        self.txtCigarette.inputAccessoryView = self.pickerView.toolbar
        
        self.txtDrinks.inputView = self.pickerView
        self.txtDrinks.inputAccessoryView = self.pickerView.toolbar
        
        self.txtWeight.inputView = self.pickerView
        self.txtWeight.inputAccessoryView = self.pickerView.toolbar
        
        self.txtFeet.inputView = self.pickerView
        self.txtFeet.inputAccessoryView = self.pickerView.toolbar
        
        self.txtInch.inputView = self.pickerView
        self.txtInch.inputAccessoryView = self.pickerView.toolbar
        
        self.txtHeight.inputView = self.pickerView
        self.txtHeight.inputAccessoryView = self.pickerView.toolbar
        
        
        self.pickerView.dataSource = self as UIPickerViewDataSource
        self.pickerView.delegate = self as UIPickerViewDelegate
        self.pickerView.toolbarDelegate = self as ToolbarPickerViewDelegate
        
        self.pickerView.reloadAllComponents()
        
        
        txtDob.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        txtWakeUpTime.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        txtBedTime.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        
        txtWeight.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        
        
        let kg = Measurement(value: 80, unit: UnitMass.kilograms)
        let lbs = Measurement(value: 100, unit: UnitMass.pounds)
        
        print(kg)
        print(lbs)
        
        let goodUnit = UnitMass.kilograms
        let goodWeight:Measurement = Measurement(value: 80, unit: goodUnit)
        print("Good pounds: ", goodWeight.converted(to: .pounds))
        
        
        
        
        //getProfileDataFromServer()
        //let rightBar = UIBarButtonItem(image: UIImage(named: "menu-1"), style: .done, target: self, action: #selector(menuTapped))
        //self.navigationItem.rightBarButtonItem = rightBar
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        
    }
    
    private func setData() {
        
    }
    
    @objc func backTapped() {
        if isFromInsurance == 1 {
            setupInsurance()
        }
        else {
            setupWellnessTabbar()
        }
        /*
         if self.delegateOnboarding != nil {
         self.delegateOnboarding?.onboardingCompleted(isComplete: false)
         
         }
         self.dismiss(animated: false, completion: nil)
         */
    }
    
    @objc private func menuTapped() {
        // self.slideMenuController()?.openRight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.slideMenuController()?.removeRightGestures()
        getDataFromInsurance()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Update Profile
        // updateProfileAktivo()
    }
    
    @objc private func moveToPrivacyPolicy() {
        let vc = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier: "FitnessPrivacyPolicyVC") as! FitnessPrivacyPolicyVC
        
        // let vc1 = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier: "ConnectWearablesVC") as! ConnectWearablesVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func getDataFromInsurance() {
        
        m_profilearray =  DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:"GMC", relationName: "EMPLOYEE")
        m_profileDict=m_profilearray[0]
        print(m_profileDict)
        let fullName = m_profileDict?.personName
        if let nameArray = fullName?.split(separator: " ") {
            if nameArray.count >= 2 {
                txtFirstName.text = nameArray[0].description
                txtLastName.text = nameArray[1].description
                lblWelcome.text = String(format: "Welcome %@ %@",
                                         nameArray[0].description, nameArray[1].description)
            }
        }
        
        if let dob = m_profileDict?.dateofBirth as? String {
            if dob != "" {
               // let dobStr = dob.getStrDateEnrollment()
                self.txtDob.text = dob.getStrDateFormatyyyyMMdd()
                
            }
        }
        
        if let gender = m_profileDict?.gender as? String {
            if gender != "" {
                if gender.lowercased() == "male" {
                    self.viewMale.isHidden = true
                    self.viewFemale.isHidden = false
                    txtGender.text = "Male"
                }
                else {
                    self.viewMale.isHidden = false
                    self.viewFemale.isHidden = true
                    txtGender.text = "Female"
                }
                
            }
        }
        
        /*txtPhoneNo.text = m_profileDict?.cellPhoneNUmber
         m_employeedict=DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")[0]
         if(m_profilearray.count>0)
         {
         
         
         }
         */
        
    }
    
    //Update Profile Aktivo
    /*
     private func updateProfileAktivo() {
     // let dob = dobDate
     //let bedTime = Date()
     // let wakeTime = Date(timeInterval: 8 * 3600.0, since: bedTime)
     //let dobFormat = Date(timeInterval: -(5 * 365 * 24 * 3600.0), since: dobDate)
     if let userId = UserDefaults.standard.value(forKey: "userAktivoId") as? String {
     
     
     //            let fullName = String(format: "%@ %@", txtFirstName.text!,txtLastName.text!)
     let user = Aktivo.User.init(userID: userId)
     
     let gender = txtGender.text == "Male" ? (Aktivo.Gender.male) : (Aktivo.Gender.female)
     
     let profile = Aktivo.UserProfile(user: user, dateOfBirth: dobDate,
     gender: gender,
     wakeupTime: wakeUpDate,
     bedTime: bedTimeDate)
     
     Aktivo.updateUserProfile(profile, completion: { (success, error) in
     // Handle response here
     })
     } //if let
     }
     */
    
    func setTableViewBackgroundGradient(sender: UITableViewController, _ topColor:UIColor, _ bottomColor:UIColor) {
        
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = sender.tableView.bounds
        let backgroundView = UIView(frame: sender.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        sender.tableView.backgroundView = backgroundView
    }
    
    //MARK:- Gender View
    private func setupSwitchView() {
        //gender View
        self.genderSwitchView.layer.cornerRadius = genderSwitchView.frame.height / 2
        self.viewMale.layer.cornerRadius = self.viewMale.frame.size.width/2
        self.viewFemale.layer.cornerRadius = self.viewFemale.frame.size.width/2
        viewFemale.clipsToBounds = true
        viewMale.clipsToBounds = true
        
        viewFemale.isHidden = false
        viewMale.isHidden = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.genderSwitchView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.genderSwitchView.addGestureRecognizer(swipeLeft)
        
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                self.viewMale.isHidden = true
                self.viewFemale.isHidden = false
                txtGender.text = "Male"
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                self.viewMale.isHidden = false
                self.viewFemale.isHidden = true
                txtGender.text = "Female"
                
            default:
                break
            }
        }
    }
    
    private func setupGenderView(gender:String) {
        if gender == "Male" {
            self.viewMale.isHidden = true
            self.viewFemale.isHidden = false
            txtGender.text = "Male"
        }
        else {
            self.viewMale.isHidden = false
            self.viewFemale.isHidden = true
            txtGender.text = "Female"
        }
    }
    
    
    
    
    //MARK:- Height View
    private func setupHeightView() {
        self.heightSwitchView.layer.cornerRadius = heightSwitchView.frame.height / 2
        self.viewCM.layer.cornerRadius = self.viewCM.frame.size.width/2
        self.viewFT.layer.cornerRadius = self.viewFT.frame.size.width/2
        viewCM.clipsToBounds = true
        viewFT.clipsToBounds = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToHeightGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.heightSwitchView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToHeightGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.heightSwitchView.addGestureRecognizer(swipeLeft)
        
    }
    
    @objc func respondToHeightGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right") //convert to feet
                self.viewFT.isHidden = true
                self.viewCM.isHidden = false
                self.lblCM.isHidden = true
                self.lblFT.isHidden = false
                self.feetView.isHidden = false
                
                self.heightFlag = 1
                txtHeight.isHidden = true
                if txtHeight.text != "" {
                    if let cmHeight = Double(txtHeight.text!) {
                        if cmHeight > 0 {
                            let feet = getFeetFrom(cm: cmHeight)
                            
                            let feetArray = feet.components(separatedBy: ".")
                            if feetArray.count > 1 {
                                let feetStr = feetArray[0]
                                let inchStr = feetArray[1]
                                self.txtFeet.text = feetStr
                                self.txtInch.text = inchStr
                            }
                            else {
                                self.txtFeet.text = feet
                                self.txtInch.text = "0"
                            }
                        }
                    }
                }
                
                
                
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left") //convert to cm
                self.viewFT.isHidden = false
                self.viewCM.isHidden = true
                self.lblCM.isHidden = false
                self.lblFT.isHidden = true
                self.feetView.isHidden = true
                
                self.txtHeight.isHidden = false
                
                heightFlag = 0
                let feetTxt = txtFeet.text!
                let inchText = txtInch.text!
                
                if txtFeet.text != "" {
                    let combinedStr = String(format:"%@.%@",feetTxt,inchText)
                    let feetDouble = Double(feetTxt) ?? 0.0
                    let cmHeight = getCmFrom(feet: feetDouble, inch: Double(inchText) ?? 0.0)
                    
                    self.txtHeight.text = cmHeight
                    
                }
                
                
            default:
                break
            }
        }
    }
    
    //MARK:- Weight View
    private func setupWeightView() {
        self.weightSwitchView.layer.cornerRadius = weightSwitchView.frame.height / 2
        self.viewKG.layer.cornerRadius = self.viewKG.frame.size.width/2
        self.viewLBS.layer.cornerRadius = self.viewLBS.frame.size.width/2
        viewKG.clipsToBounds = true
        viewLBS.clipsToBounds = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToWeightGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.weightSwitchView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToWeightGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.weightSwitchView.addGestureRecognizer(swipeLeft)
        
    }
    @objc func respondToWeightGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right") //convert lbs , show in lbs
                self.viewLBS.isHidden = true
                self.viewKG.isHidden = false
                self.lblKG.isHidden = true
                self.lblLBS.isHidden = false
                
                self.weightFlag = 1
                
                if txtWeight.text != "" {
                    if let kgPound = Double(txtWeight.text!) {
                        if kgPound > 0 {
                            let pounds = getPounds(kg: kgPound)
                            txtWeight.text = pounds
                        }
                    }
                }
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left") //convert kg , show in kg
                self.viewLBS.isHidden = false
                self.viewKG.isHidden = true
                self.lblKG.isHidden = false
                self.lblLBS.isHidden = true
                self.weightFlag = 0
                
                if txtWeight.text != "" {
                    if let lbs = Double(txtWeight.text!) {
                        if lbs > 0 {
                            let kg = getKg(lbs: lbs)
                            txtWeight.text = kg
                        }
                    }
                }
                
            default:
                break
            }
        }
    }
    
    //MARK:- SUBMIT Tapped
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        if validations() {
            //self.setupFitnessTabbar()
            sendOnboardingDataToServer()
        }
        /*
         if self.delegateOnboarding != nil {
         self.delegateOnboarding?.onboardingCompleted()
         //self.navigationController?.popViewController(animated: false)
         self.dismiss(animated: true, completion: nil)
         }
         else {
         self.dismiss(animated: false, completion: nil)
         self.navigationController?.popViewController(animated: false)
         }
         */
    }
    
    //MARK:- Validations
    func validations() -> Bool {
        //        if txtFirstName.text?.trimmingCharacters(in: .whitespaces) == "" {
        //            self.displayActivityAlert(title: "Please enter first name")
        //            return false
        //        }
        //        else if txtLastName.text?.trimmingCharacters(in: .whitespaces) == "" {
        //            self.displayActivityAlert(title: "Please enter last name")
        //            return false
        //        }
        //        else if txtDob.text?.trimmingCharacters(in: .whitespaces) == "" {
        //            self.displayActivityAlert(title: "Please select Date of birth")
        //            return false
        //        }
        if txtBedTime.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.displayActivityAlert(title: "Please select bed time")
            return false
        }
        else if txtWakeUpTime.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.displayActivityAlert(title: "Please select wake-up time")
            return false
        }
            //        else if txtGender.text?.trimmingCharacters(in: .whitespaces) == "" {
            //            self.displayActivityAlert(title: "Please select Gender")
            //            return false
            //        }
        else if (heightFlag == 0) && (txtHeight.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            self.displayActivityAlert(title: "Please enter Height")
            return false
        }
        else if (heightFlag == 1) && (txtFeet.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            self.displayActivityAlert(title: "Please enter Height")
            return false
        }
        else if txtWeight.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.displayActivityAlert(title: "Please enter Weight")
            return false
        }
        
        return true
    }
    
    //MARK:- Text Field Delegate Validation
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txtFirstName {
            if textField.text == "" {
                self.imgFirstName.image = wrongImage
            }
            else {
                self.imgFirstName.image = correctImage
            }
        }
            //last name
        else if textField == txtLastName {
            if textField.text == "" {
                self.imgLastName.image = wrongImage
            }
            else {
                self.imgLastName.image = correctImage
            }
        }
            
            //phone number
        else if textField == txtPhoneNo {
            if textField.text!.count > 13 || textField.text!.count < 10 {
                self.imgPhoneNo.image = wrongImage
            }
            else {
                self.imgPhoneNo.image = correctImage
            }
        }
            //CM
        else if textField == txtHeight {
            let textfieldInt: Double? = Double(textField.text!)
            
            if textField.text == "" {
                self.imgInch.image = wrongImage
            }
            else if textfieldInt! > 250 {
                self.imgInch.image = wrongImage
            }
            else {
                self.imgInch.image = correctImage
            }
        }
            
        else if textField == txtFeet {
            let textfieldInt: Int? = Int(textField.text!)
            
            if textField.text == "" {
                self.imgInch.image = wrongImage
            }
            else if textfieldInt! > 8 {
                self.imgFeet.image = wrongImage
            }
            else {
                self.imgFeet.image = correctImage
            }
        }
            
        else if textField == txtInch {
            
            if textField.text == "" {
                self.imgInch.image = wrongImage
            }
            else if let textfieldInt: Int = Int(textField.text!) {
                
                if textfieldInt > 11 {
                    self.imgInch.image = wrongImage
                }
                else {
                    self.imgInch.image = correctImage
                }
                
                //Check If user enters Feet > 8 and Inch is Greater than 2
                if let txtFeetInt: Int = Int(txtFeet.text!) {
                    if txtFeetInt >= 8 {
                        if textfieldInt > 2 {
                            self.imgInch.image = wrongImage
                        }
                    }
                }
                
                
            }
            else {
                self.imgInch.image = wrongImage
            }
        }
            //Weight
        else if textField == txtWeight {
            
            if textField.text == "" {
                self.imgWeight.image = wrongImage
            }
            else if let textfieldInt: Int = Int(textField.text!) {
                //Add lbs and kg conditions
                if weightFlag == 0 {
                    if textfieldInt > 400 {
                        self.imgWeight.image = wrongImage
                    }
                    else {
                        self.imgWeight.image = correctImage
                    }
                }
                else {
                    if textfieldInt > 882 {
                        self.imgWeight.image = wrongImage
                    }
                    else {
                        self.imgWeight.image = correctImage
                    }
                }
                
                
            }
            else {
                self.imgWeight.image = wrongImage
            }
        }
        
        
    }
    
    
    
    
    //MARK:- TableView Delegate and Datasource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7 {
            return 0
            
        }
        else if indexPath.row == 1 {
            //return 145
            return 70
            
        }
            
        else if indexPath.row == 10 {
            return 90
            
        }
            
        else if indexPath.row == 12 {
            return 0
            
        }
        else {
            return 50
        }
    }
    
    //MARK:- Add Done Button On Keyboard
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = #colorLiteral(red: 0.8858889249, green: 0.6749766178, blue: 0.211310445, alpha: 1)
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        // doneToolbar.tintColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
        
        txtWeight.inputAccessoryView = doneToolbar
        txtHeight.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    
    
    //MARK:- DOB
    @objc func pickUpDate(_ textField : UITextField){
        print("Pickup Date..\(textField)")
        
        //createDatePicker()
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        
        if txtDob.isFirstResponder {
            print("Date")
            self.datePicker.datePickerMode = UIDatePickerMode.date
            //self.datePicker.maximumDate = Date()
            
            if let backdate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) {
                self.datePicker.maximumDate = backdate
            }
            
            txtDob.inputView = self.datePicker
            // self.txtDob.inputAccessoryView = self.datePicker.toolbar
            
        }
        else if txtWakeUpTime.isFirstResponder {
            print("Time")
            self.datePicker.locale = Locale(identifier: "en_GB")
            
            self.datePicker.datePickerMode = UIDatePickerMode.time
            self.datePicker.minuteInterval = 5
            txtWakeUpTime.inputView = self.datePicker
        }
        else if txtBedTime.isFirstResponder {
            print("Time")
            self.datePicker.locale = Locale(identifier: "en_GB")
            
            self.datePicker.datePickerMode = UIDatePickerMode.time
            self.datePicker.minuteInterval = 5
            
            txtBedTime.inputView = self.datePicker
        }
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        if txtDob.isFirstResponder {
            txtDob.inputAccessoryView = toolBar
        }
        else if txtWakeUpTime.isFirstResponder {
            txtWakeUpTime.inputAccessoryView = toolBar
        }
        else if txtBedTime.isFirstResponder {
            txtBedTime.inputAccessoryView = toolBar
            
        }
    }
    /*
     func createDatePicker(){
     print("createDatePicker")
     //format for datepicker display
     if txtDob.isFirstResponder == true {
     datePicker.datePickerMode = .date
     txtDob.inputView = datePicker
     
     }
     else {
     datePicker.datePickerMode = .time
     txtWakeUpTime.inputView = datePicker
     
     }
     
     //assign datepicker to our textfield
     
     //create a toolbar
     let toolbar = UIToolbar()
     toolbar.sizeToFit()
     
     //add a done button on this toolbar
     let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDOBClicked))
     
     toolbar.setItems([doneButton], animated: true)
     if txtDob.isFirstResponder == true {
     txtDob.inputAccessoryView = toolbar
     }
     else if txtWakeUpTime.isFirstResponder == true {
     txtWakeUpTime.inputAccessoryView = toolbar
     }
     else if txtBedTime.isFirstResponder == true {
     txtBedTime.inputAccessoryView = toolbar
     }
     }
     
     @objc func doneDOBClicked(){
     
     //format for displaying the date in our textfield
     
     if txtDob.isFirstResponder == true {
     let dateFormatter = DateFormatter()
     dateFormatter.dateStyle = .medium
     dateFormatter.timeStyle = .none
     txtDob.text = dateFormatter.string(from: datePicker.date)
     self.view.endEditing(true)
     }
     else {
     let dateFormatter = DateFormatter()
     dateFormatter.dateStyle = .none
     dateFormatter.timeStyle = .short
     txtWakeUpTime.text = dateFormatter.string(from: datePicker.date)
     self.view.endEditing(true)
     
     }
     }
     */
    
    var dobDate = Date()
    var wakeUpDate = Date()
    var bedTimeDate = Date()
    
    @objc func doneClick() {
        
        
        if txtDob.isFirstResponder {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .short
            dateFormatter1.timeStyle = .none
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            txtDob.text = dateFormatter1.string(from: datePicker.date)
            dobDate = datePicker.date
            txtDob.resignFirstResponder()
        }
        else if txtWakeUpTime.isFirstResponder {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .none
            dateFormatter1.timeStyle = .short
            dateFormatter1.dateFormat = "HH:mm"
            txtWakeUpTime.text = dateFormatter1.string(from: datePicker.date)
            wakeUpDate = datePicker.date
            txtWakeUpTime.resignFirstResponder()
        }
        else if txtBedTime.isFirstResponder {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .none
            dateFormatter1.timeStyle = .short
            dateFormatter1.dateFormat = "HH:mm"
            
            txtBedTime.text = dateFormatter1.string(from: datePicker.date)
            bedTimeDate = datePicker.date
            txtBedTime.resignFirstResponder()
        }
        else if txtWeight.isFirstResponder {
            
        }
    }
    @objc func cancelClick() {
        //        txtDob.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    /*
     Optional(AktivoCoreSDK.Aktivo.UserProfile(dateOfBirth: Optional(1993-04-28 18:30:00 +0000), gender: Optional(AktivoCoreSDK.Aktivo.Gender.male),
     bedTime: Optional(1999-12-31 19:00:00 +0000),
     wakeTime: Optional(2000-01-01 02:00:00 +0000), user: AktivoCoreSDK.Aktivo.User(userID: "5d2061b0d4b892001b05bc59")))
     
     */
    //MARK:- Get Data From Server
    private func getProfileDataFromServer() {
        self.showFitnessLoader(msg: "", type: 2)
        
        Aktivo.getUserProfile { (response, error) in
            self.hidePleaseWait()
            if error == nil {
                print(response)
                
                if response?.dateOfBirth != nil {
                    self.txtDob.text = response?.dateOfBirth?.getSimpleDate()
                    self.dobDate = response?.dateOfBirth ?? Date()
                }
                
                
                self.txtGender.text = (response?.gender).map { $0.rawValue }
                if self.txtGender.text == "Male" {
                    self.setupGenderView(gender: "Male")
                }
                else {
                    self.setupGenderView(gender: "Female")
                }
                
                // let wakeTime = Date(timeInterval: 8 * 3600.0, since: (response?.wakeTime)!)
                self.txtWakeUpTime.text = response?.wakeTime?.getTime()
                self.txtBedTime.text = response?.bedTime?.getTime()
                self.wakeUpDate = response?.wakeTime ?? Date()
                self.bedTimeDate = response?.bedTime ?? Date()
                
            }
        }
    } //getProfileDataFromServer()
    
    //MARK:- Tabbar setup
    func setupFitnessTabbar()
    {
        
        let tabBarController = UITabBarController()
        
        let tabViewController1 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"CompeteChallengesVC") as! CompeteChallengesVC
        // tabViewController1.isAddMember = 1
        
        let tabViewController2 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"FitnessDashboardVC") as! FitnessDashboardVC
        
        let tabViewController3 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"FitnessDashboardRootVC") as! FitnessDashboardRootVC
        tabViewController3.isFromInsurance = 1
        
        let tabViewController4 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"StatsFitnessVC") as! StatsFitnessVC
        
        let tabViewController5 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"ProfileFitnessTVC") as! ProfileFitnessTVC
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Compete",
            image: UIImage(named: "star20x20"),
            tag: 1)
        
        nav2.tabBarItem = UITabBarItem(
            title: "Rewards",
            image:UIImage(named: "reward20x20") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Stats",
            image:UIImage(named: "stat40x40") ,
            tag:2)
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile-1") ,
            tag:2)
        tabBarController.selectedIndex=2
        
        
        //Set Bar tint color white
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        let colorSelected = UIColor.orange
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
        
        tabBarController.view.backgroundColor = UIColor.white
        
        tabBarController.tabBar.tintColor = UIColor.orange
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        //Set Tab bar border color
        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        tabBarController.tabBar.clipsToBounds = true
        tabBarController.tabBar.isHidden = false
        tabBarController.tabBar.isUserInteractionEnabled = true
        
        //tabBarController.modalTransitionStyle = .crossDissolve
        
        tabBarController.modalPresentationStyle = .fullScreen
        // self.present(tabBarController, animated: true)
        
        
        //Present Home Vc
        
        //Set Slide Menu Controller
        // let homeVCObject = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "homeNavigationDrawer")
        
        SlideMenuOptions.rightViewWidth = 280.0
        SlideMenuOptions.contentViewScale = 1.0
        
        let rightMenu = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier: "FitnessSlidemenuVC") as! FitnessSlidemenuVC
        
        let slideMenuController = SlideMenuController(mainViewController: tabBarController, rightMenuViewController: rightMenu)
        
        slideMenuController.modalPresentationStyle = .fullScreen
        self.present(slideMenuController, animated: true)
        
        
    }
}

extension LoginFitnessProfile: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if txtWeight.isFirstResponder == true {
            if weightFlag == 0 {
                self.finalArray = weightArray
                return weightArray.count
            }
            else {
                self.finalArray = lbsArray
                
                return lbsArray.count
            }
        }
        else if txtHeight.isFirstResponder == true {
            self.finalArray = cmArray
            
            return cmArray.count
        }
        else if txtFeet.isFirstResponder == true {
            if let inch = txtInch.text {
                if (Int(inch) ?? 0) > 3 {
                    feetArray = (2...7).map { "\($0)" }
                }
                else {
                    feetArray = (2...8).map { "\($0)" }
                }
            }
            else {
                feetArray = (2...8).map { "\($0)" }
            }
            self.finalArray = feetArray
            return feetArray.count
        }
        else if txtInch.isFirstResponder == true {
            if let feet = txtFeet.text {
                if feet == "8" {
                    inchArray = (0...3).map { "\($0)" }
                }
                else {
                    inchArray = (0...11).map { "\($0)" }
                }
            }
            else {
                inchArray = (0...11).map { "\($0)" }
            }
            self.finalArray = inchArray
            
            return inchArray.count
        }
        return self.finalArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtWeight.isFirstResponder == true {
            if weightFlag == 0 {
                return weightArray[row]
            }
            else {
                return lbsArray[row]
            }
        }
        else if txtHeight.isFirstResponder == true {
            return cmArray[row]
        }
        else if txtFeet.isFirstResponder == true {
            if row < feetArray.count {
            return feetArray[row]
            }
            return feetArray[0]
        }
        else if txtInch.isFirstResponder == true {
            if row < inchArray.count {
                return inchArray[row]
            }
            return inchArray[0]
            
        }
        return self.finalArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // self.txtCigarette.text = self.cigratteArray[row]
    }
}

extension LoginFitnessProfile: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        //self.pickerView.selectRow(row, inComponent: 0, animated: false)
        
        
        if txtCigarette.isFirstResponder == true {
            
        }
        else if txtWeight.isFirstResponder == true {
            if weightFlag == 0 {
                self.txtWeight.text = String(format: "%@", self.weightArray[row])
            }
            else {
                self.txtWeight.text = String(format: "%@", self.lbsArray[row])
            }
        }
        else if txtHeight.isFirstResponder == true {
            self.txtHeight.text = String(format: "%@", self.cmArray[row])
        }
        else if txtFeet.isFirstResponder == true {
            self.txtFeet.text = String(format: "%@", self.feetArray[row])
        }
        else if txtInch.isFirstResponder == true {
            self.txtInch.text = String(format: "%@", self.inchArray[row])
        }
        
        self.view.endEditing(true)
    }
    
    func didTapCancel() {
        //self.txtCigarette.text = nil
        self.txtCigarette.resignFirstResponder()
        self.txtDrinks.resignFirstResponder()
        self.view.endEditing(true)
    }
}


//MARK:- Measurment
extension LoginFitnessProfile {
    
    private func getPounds(kg:Double) -> String {
        
        
       // let pounds = kg * 2.205
        //let roundedPounds = Int(pounds)
        //return roundedPounds.description
        
        let kg1 = Double(kg)
        var pounds = kg1 * 2.205
        let roundedPounds = pounds.round()
        let intLbs = Int(pounds)
        return intLbs.description

    }
    
    private func getKg(lbs:Double) -> String {
        //let kg = Double(lbs) / 2.205
        //let roundedKg = Int(kg)
        //return roundedKg.description
        
        var kg = Double(lbs) / 2.205
        let roundedKg = kg.round()
        let intKG = Int(kg.rounded())
        return intKG.description

    }
    
    /*
    private func getCmFrom(feet:Double) -> String {
        let cm = feet * 30.48
        // let cmrounded = cm.rounded(toPlaces: 2)
        let cmrounded = Int(cm)
        
        let cmStr = cmrounded.description
        return cmStr
    }
    */
    /*
    private func getFeetFrom(cm:Double) -> String {
        // let feet = cm / 30.48
        //  let feetStr = feet.rounded(toPlaces: 2)
        // return feetStr.description
        
        let feet = cm * 0.0328084
        let feetShow = Int(floor(feet))
        let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
        let inches = Int(floor(feetRest * 12))
        
        return "\(feetShow).\(inches)"
    }
    */
    private func getFeetFrom(cm:Double) -> String {
        //FIRST WORKING
        /*if cm > 0 {
        let feetFinal:Double = Double(Int(floor((cm/2.54)/12)))
        let inchFinal:Double = Double(Int(floor((cm/2.54) - (feetFinal * 12))))
            print("\(Int(feetFinal)).\(Int(inchFinal.rounded()))")
            return "\(Int(feetFinal).description).\(Int(inchFinal.rounded()).description)"
        }
        else {
            return "0.0"
        }*/
        print("cm",cm)
        if cm > 0 {
            
           // cmGlobal = Int(cm)
            
            let realFeet = ((cm*0.393700)/12)
            var feetff = floor(realFeet)
            var inches = ((realFeet - feetff)*12).rounded()
            if inches == 12.0 {
                feetff += 1
                inches = 0
            }
           // if txtFeet
            print("FI=\(Int(feetff)).\(Int(inches))")
            //self.feetGlobal = Int(feetff)
            //self.inchGlobal = Int(inches)
            return "\(Int(feetff).description).\(Int(inches).description)"
        }
        else {
            return "0.0"
        }

    }
    
    private func getCmFrom(feet:Double,inch:Double) -> String {
        print("GET F.I",feet,inch)
        /*
        var feetF = feet * 12.0
        feetF += inch
        print("CM = \(feetF.rounded())")
        
        let cmInch = feetF.rounded() * 2.54
        let cmIrounded = cmInch
        
        let totalCm = cmIrounded
        
        let cmStr = Int(totalCm.rounded())
        return cmStr.description
        */
        
        //ver 1.17 - 2
        if feet > 0 {
        var feetF = feet * 12.0
        feetF += inch
        let totalCm = feetF * 2.54
        let cmStr = Int(totalCm.rounded())
        print(cmStr.description)
        return cmStr.description
            
        }
        else {
            return "0"
        }

    }

}

//MARK:- API Call send Onboarding Data To AKTIVO
extension LoginFitnessProfile {
    func sendOnboardingDataToServer() {
        print("Send Data to Server..")
        //Convert Height in cm
        var heightInCm = "0"
        if heightFlag == 1 {
            //convert in cm
            let feetTxt = txtFeet.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let inchText = txtInch.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if txtFeet.text != "" {
                let combinedStr = String(format:"%@.%@",feetTxt,inchText)
                let feetDouble = Double(feetTxt) ?? 0.0
                let cmHeight = getCmFrom(feet: feetDouble, inch: Double(inchText) ?? 0.0)
                heightInCm = cmHeight
            }
        }
        else {
            heightInCm = txtHeight.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        //Convert weight in KG
        var weightInKg = "0"
        if weightFlag == 0 {
            weightInKg = txtWeight.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        else {
            if txtWeight.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                if let lbs = Double(txtWeight.text!) {
                    if lbs > 0 {
                        let kg = getKg(lbs: lbs)
                        weightInKg = kg
                    }
                }
            }
        } 
        
        var empSrNo = String()
        var groupChildSrNo = String()
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if(userArray.count>0)
        {
            var m_employeedict : EMPLOYEE_INFORMATION?
            m_employeedict=userArray[0]
            if let empSr = m_employeedict?.empIDNo
            {
                empSrNo = String(empSr)
            }
        }
        
        var groupName = ""
        let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
        if groupMasterArray.count > 0 {
            let groupMasterDict = groupMasterArray[0]
            groupName = groupMasterDict.groupName ?? ""
            groupChildSrNo = groupMasterDict.groupCode ?? ""
        }
        
        
        //externalId is groupChildSerialNumber
        // let memberDict = ["externalId" : empSrNo,"height_cm" : heightInCm,"weight_kg":weightInKg,"date_of_birth":txtDob.text!,"sex":txtGender.text!,"bedtime":txtBedTime.text!,"wakeup":txtWakeUpTime.text!,"firstname":txtFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines),"lastname":txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
        
        let memberDict = ["externalId" : empSrNo,"height_cm" : heightInCm,"weight_kg":weightInKg,"date_of_birth":txtDob.text!,"sex":txtGender.text!,"bedtime":txtBedTime.text!,"wakeup":txtWakeUpTime.text!,"firstname":txtFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines),"lastname":txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)]
        
        
        let companyDict = ["externalId":groupChildSrNo,"title": groupName]
        
        let finalDict = ["member":memberDict,"company":companyDict]
        print(finalDict)
        
        let url = "https://api.aktivolabs.com/api/system/onboard"
        print(url)
        
        //create Header
        /*
         Accept: application/vnd.aktivolabs.v11.0.0+json
         Authorization: Bearer a87411e8e294a19d49d9ac47679a636a3aadaffc
         Content-Type: application/json
         */
        
        let token = UserDefaults.standard.value(forKey: "tokenAktivo") as! String
        let tokenType = UserDefaults.standard.value(forKey: "tokenType") as! String
        let tokenStr = String(format: "%@ %@",tokenType,token)
        
        let headers: HTTPHeaders = ["Accept":"application/vnd.aktivolabs.v11.0.0+json","Content-Type":"application/json","Authorization":tokenStr]
        
        
        ServerRequestManager.serverInstance.postOnboardingDataToServerWithHeader(url: url, dictionary: finalDict as NSDictionary, view: self,headerParam: (headers as NSDictionary) as! HTTPHeaders, onComplition: { (response, error) in
            
            if error == nil {
                
                var isNewMember = "0"
                var isNewCompany = "0"
                        if let dataDict = response?["data"].dictionary {
                            
                            if let memberDict = dataDict["member"]?.dictionary {
                                if let memberid = memberDict["_id"]?.stringValue {
                                    UserDefaults.standard.set(memberid, forKey: "MEMBER_ID")
                                }
                                if let userExtId = memberDict["externalId"]?.stringValue {
                                    UserDefaults.standard.set(userExtId, forKey: "MEMBER_EXTID")
                                }
                                if let isNew = memberDict["isNew"]?.bool {
                                    if isNew {
                                        isNewMember = "1"
                                    }
                                    else {
                                        isNewMember = "0"
                                    }
                                }
                                
                            }
                            
                            if let companyDict = dataDict["company"]?.dictionary {
                                if let companyId = companyDict["_id"]?.stringValue {
                                    UserDefaults.standard.set(companyId, forKey: "COMPANY_ID")
                                }
                                
                                if let companyExtId = companyDict["externalId"]?.stringValue {
                                    UserDefaults.standard.set(companyExtId, forKey: "COMPANY_EXTID")
                                }
                                
                                if let isNew = companyDict["isNew"]?.bool {
                                    if isNew {
                                        isNewCompany = "1"
                                    }
                                    else {
                                        isNewCompany = "0"
                                    }
                                }
                            }
                            
                            self.sendOnboardingDataToMyBenefits(isMemberAlreadyOnboarded: isNewMember, isCompanyOnboarded: isNewCompany)
                            
                            /*
                             company": {
                             "_id": "5f4f3c732d6c1e4ef9ef2e7c",
                             "isNew": true,
                             "externalId": "someguidxyz"
                             }
                             
                             */
                        }
                    else {

                        self.displayActivityAlert(title: "Failed to setup Fitness")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.backTapped()
                        }
                }

                }
                else {

                    self.displayActivityAlert(title: "Failed to setup Fitness")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.backTapped()
                    }
            } //error == nil
          
        })
        
        
    }
}

extension LoginFitnessProfile {
    private func setupInsurance()
    {
        
        let tabBarController = UITabBarController()
        let tabViewController1 = ContactDetailsViewController(
            nibName: "ContactDetailsViewController",
            bundle: nil)
        let tabViewController2 = NewDashboardViewController(
            nibName:"NewDashboardViewController",
            bundle: nil)
        let tabViewController3 = NewDashboardViewController(
            nibName: "NewDashboardViewController",
            bundle: nil)
        let tabViewController4 = UtilitiesViewController(
            nibName:"UtilitiesViewController",
            bundle: nil)
        let tabViewController5 = LeftSideViewController(
            nibName:"LeftSideViewController",
            bundle: nil)
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Support",
            image: UIImage(named: "call-1"),
            tag: 1)
        nav2.tabBarItem = UITabBarItem(
            title: "E-Card",
            image:UIImage(named: "ecard1") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Utilities",
            image:UIImage(named: "utilities") ,
            tag:2)
        
        nav5.tabBarItem = UITabBarItem(
            title: "More",
            image:UIImage(named: "menu-1") ,
            tag:2)
        
        
        //Set Bar tint color white
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        let colorSelected = hexStringToUIColor(hex: hightlightColor)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
        
        tabBarController.view.backgroundColor = UIColor.white
        
        tabBarController.tabBar.tintColor = hexStringToUIColor(hex: hightlightColor)
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        
        //menuButton.isHidden = true
        isRemoveFlag = 0
        tabBarController.modalPresentationStyle = .fullScreen
        
        
        navigationController?.present(tabBarController, animated: true, completion: nil)
        tabBarController.selectedIndex=2
        
        
    }
    
    private func setupWellnessTabbar()
    {
        /*
        let tabBarController = UITabBarController()
        
        let tabViewController1 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
        
        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
        
        
        // tabViewController1.isAddMember = 1
        
        //let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"ProfileViewForWellness") as! ProfileViewForWellness
        
        
        
        let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"DashboardRootViewController") as! DashboardRootViewController
        tabViewController3.fromInsurance = 0
        
        //let tabViewController4 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"ProfileViewForWellness") as! ProfileViewForWellness
        
        
        let tabViewController4 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
        
        let tabViewController5 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
        
        
        // let tabViewController5 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"ProfileViewForWellness") as! ProfileViewForWellness
        
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Add Member",
            image: UIImage(named: "adduser"),
            tag: 1)
        
        nav2.tabBarItem = UITabBarItem(
            title: "History",
            image:UIImage(named: "history") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Appointments",
            image:UIImage(named: "appointment") ,
            tag:2)
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile-1") ,
            tag:2)
        tabBarController.selectedIndex=2
        
        //Set Bar tint color white
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        let colorSelected = Color.buttonBackgroundGreen.value
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
        
        tabBarController.view.backgroundColor = UIColor.white
        
        tabBarController.tabBar.tintColor = colorSelected
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        //Set Tab bar border color
        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        tabBarController.tabBar.clipsToBounds = true
        tabBarController.tabBar.isHidden = false
        tabBarController.tabBar.isUserInteractionEnabled = false
        
        //tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
 */
    }
}


//MARK:- API CALL
//MARK:- Send Onboarding data to MB server
extension LoginFitnessProfile {
    
    private func sendOnboardingDataToMyBenefits(isMemberAlreadyOnboarded:String,isCompanyOnboarded:String) {
        
        let memberId = UserDefaults.standard.value(forKey: "MEMBER_ID") as! String
        
        guard let memberExtId = UserDefaults.standard.value(forKey: "MEMBER_EXTID") as? String else {
            return
        }
//        guard let companyExtId = UserDefaults.standard.value(forKey: "COMPANY_EXTID") as? String else {
//            return
//        }
        guard let companyId = UserDefaults.standard.value(forKey: "COMPANY_ID") as? String else {
            return
        }
        
        var empSrNo = ""
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if(userArray.count>0)
        {
            var m_employeedict : EMPLOYEE_INFORMATION?
            m_employeedict=userArray[0]
            if let empSr = m_employeedict?.empSrNo
            {
                empSrNo = String(empSr)
            }
        }
        
        var groupChildSrNo = ""
        var groupName = ""
        let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
        if groupMasterArray.count > 0 {
            let groupMasterDict = groupMasterArray[0]
            groupName = groupMasterDict.groupName ?? ""
            //groupChildSrNo = groupMasterDict.groupChildSrNo.description
            groupChildSrNo = groupMasterDict.groupCode ?? ""
        }
        
        //Convert Height in cm
               var heightInCm = "0"
               if heightFlag == 1 {
                   //convert in cm
                   let feetTxt = txtFeet.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                   let inchText = txtInch.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                   
                   if txtFeet.text != "" {
                       let combinedStr = String(format:"%@.%@",feetTxt,inchText)
                       let feetDouble = Double(feetTxt) ?? 0.0
                       let cmHeight = getCmFrom(feet: feetDouble, inch: Double(inchText) ?? 0.0)
                       heightInCm = cmHeight
                   }
               }
               else {
                   heightInCm = txtHeight.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               }
               
               //Convert weight in KG
               var weightInKg = "0"
               if weightFlag == 0 {
                   weightInKg = txtWeight.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               }
               else {
                   if txtWeight.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                       if let lbs = Double(txtWeight.text!) {
                           if lbs > 0 {
                               let kg = getKg(lbs: lbs)
                               weightInKg = kg
                           }
                       }
                   }
               }
        
        
        //Sample format  --- >
        
        let parameterDict = ["WAKE_UP_TIME":txtWakeUpTime.text!,"BED_TIME":txtBedTime.text!,"WEIGHT":weightInKg,"HEIGHT":heightInCm,"MEMBER_ID":memberId,"MEMBER_EXTERNAL_ID":memberExtId,"MEMBER_ONBOARD":isMemberAlreadyOnboarded,"COMPANY_ID":companyId,"COMPANY_EXT_ID":groupChildSrNo,"COMPANY_ONBOARD":isCompanyOnboarded,"EMPLOYEE_SR_NO":empSrNo]
        print(parameterDict)
        let stringURL = APIEngine.shared.sendOnboardingDataToServerAPI()
        
        
        ServerRequestManager.serverInstance.postDataToServerWithoutLoader(url: stringURL, dictionary: parameterDict as NSDictionary, view: self) { (response, error) in
            print("MB Response..")
            print(response)
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        if self.delegateOnboarding != nil {
                            self.delegateOnboarding?.onboardingCompleted(isComplete: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else {
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                }
            }
            
        }
        
        print(parameterDict)
    }
}

