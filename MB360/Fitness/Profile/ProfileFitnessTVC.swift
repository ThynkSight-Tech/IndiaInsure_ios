//
//  ProfileFitnessTVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 14/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import AktivoCoreSDK


class ProfileFitnessTVC: UITableViewController,UITextFieldDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:- set Gradient color
        //self.setTableViewBackgroundGradient(sender: self, Color.fitnessBottom.value, Color.fitnessTop.value)
        //self.slideMenuController()?.removeRightGestures()

        self.setFitnessBackground()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Profile"
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
        
        
        self.pickerView.dataSource = self as UIPickerViewDataSource
        self.pickerView.delegate = self as UIPickerViewDelegate
        self.pickerView.toolbarDelegate = self as ToolbarPickerViewDelegate
        
        self.txtWeight.inputView = self.pickerView
        self.txtWeight.inputAccessoryView = self.pickerView.toolbar
        
        self.txtFeet.inputView = self.pickerView
        self.txtFeet.inputAccessoryView = self.pickerView.toolbar
        
        self.txtInch.inputView = self.pickerView
        self.txtInch.inputAccessoryView = self.pickerView.toolbar
        
        self.txtHeight.inputView = self.pickerView
        self.txtHeight.inputAccessoryView = self.pickerView.toolbar

        
        self.pickerView.reloadAllComponents()
        
        
        txtDob.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        txtWakeUpTime.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        txtBedTime.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        
        txtWakeUpTime.returnKeyType = UIReturnKeyType.done
        txtBedTime.returnKeyType = UIReturnKeyType.done

        
        
        let kg = Measurement(value: 80, unit: UnitMass.kilograms)
        let lbs = Measurement(value: 100, unit: UnitMass.pounds)
        
        print(kg)
        print(lbs)
        
        let goodUnit = UnitMass.kilograms
        let goodWeight:Measurement = Measurement(value: 80, unit: goodUnit)
        print("Good pounds: ", goodWeight.converted(to: .pounds))
        
        
        
        
        getProfileDataFromServer()
     let rightBar = UIBarButtonItem(image: UIImage(named: "menu-1"), style: .done, target: self, action: #selector(menuTapped))
               self.navigationItem.rightBarButtonItem = rightBar
               
        btnSubmit.layer.cornerRadius = 6.0
           }
           
           @objc private func menuTapped() {
               self.slideMenuController()?.openRight()
           }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.slideMenuController()?.removeRightGestures()
        setViewForKG()
        getDataFromInsurance()
        getMemberIdFromMBServer()

        if let cigarette = UserDefaults.standard.value(forKey: "cigaretteCount") as? String {
            if cigarette == "1" {
                self.txtCigarette.text = String(format: "%@", cigarette)
            }
            else {
                self.txtCigarette.text = String(format: "%@", cigarette)

            }
        }
        
        if let drinks = UserDefaults.standard.value(forKey: "drinkCount") as? String {
            if drinks == "1" {
                self.txtDrinks.text = String(format: "%@", drinks)
            }
            else {
                self.txtDrinks.text = String(format: "%@", drinks)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Update Profile
        
    }
    
    //MARK:- Submit Tapped
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
    updateProfileAktivo()
    sendOnboardingDataToMyBenefits(isMemberAlreadyOnboarded: "0", isCompanyOnboarded: "0")

        UserDefaults.standard.set(txtCigarette.text!, forKey: "cigaretteCount")
        UserDefaults.standard.set(txtDrinks.text!, forKey: "drinkCount")

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
            }
        }
        
        if let dob = m_profileDict?.dateofBirth {
            if dob != "" {
                let dobStr = dob.getStrDateEnrollment()
                self.txtDob.text = dobStr
            }
        }
        
        txtPhoneNo.text = m_profileDict?.cellPhoneNUmber
        m_employeedict=DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")[0]
        if(m_profilearray.count>0)
        {
            
            
        }
        
    }
    
    //Update Profile Aktivo
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
        
        self.genderSwitchView.isUserInteractionEnabled = false
        self.viewFemale.isUserInteractionEnabled = false
        self.viewFemale.isUserInteractionEnabled = false
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
                self.txtHeight.isHidden = true

                self.heightFlag = 1
                
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
                
                let feetTxt = txtFeet.text!
                let inchText = txtInch.text ?? "0"
                
                if txtFeet.text != "" {
                    //let combinedStr = String(format:"%@.%@",feetTxt,inchText)
                    let feetDouble = Double(feetTxt) ?? 0.0
                    let cmHeight = getCmFrom(feet: feetDouble,inch: Double(inchText) ?? 0.0)
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
    
    func setViewForKG() {
        self.viewLBS.isHidden = false
        self.viewKG.isHidden = true
        self.lblKG.isHidden = false
        self.lblLBS.isHidden = true
        self.weightFlag = 0
    }
    
    @objc func respondToWeightGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right") //convert lbs
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
                print("Swiped left") //convert kg
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
        if indexPath.row == 0 {
            //return 145
            return 0

        }
        else if indexPath.row == 10 {
            return 90
            
        }
            
        else if indexPath.row == 11 || indexPath.row == 12 {
            return 90
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
        txtPhoneNo.inputAccessoryView = doneToolbar
        txtFirstName.inputAccessoryView = doneToolbar
        txtLastName.inputAccessoryView = doneToolbar
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
            self.datePicker.maximumDate = Date()
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
            self.datePicker.minuteInterval = 5
            self.datePicker.datePickerMode = UIDatePickerMode.time
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
    }
    @objc func cancelClick() {
        //        txtDob.resignFirstResponder()
        self.view.endEditing(true)
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
                    //self.txtDob.text = response?.dateOfBirth?.getSimpleDate().getStrDateFitnessProfile()

                    //self.dobDate = response?.dateOfBirth ?? Date()
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
    
    
}

extension ProfileFitnessTVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    else if txtCigarette.isFirstResponder == true {
        
        self.finalArray = cigratteArray
    }

    else if txtDrinks.isFirstResponder == true {
        
        self.finalArray = cigratteArray
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
           
           return feetArray[row]
       }
       else if txtInch.isFirstResponder == true {
           
           return inchArray[row]
       }
       else if txtCigarette.isFirstResponder == true {
        
        return cigratteArray[row]
       }
       else if txtDrinks.isFirstResponder == true {
        
        return cigratteArray[row]
    }
       return self.finalArray[row]
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // self.txtCigarette.text = self.cigratteArray[row]
   }

}

extension ProfileFitnessTVC: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        
        
        if txtCigarette.isFirstResponder == true {
            if self.cigratteArray[row] == "1" {
                self.txtCigarette.text = String(format: "%@ Cigarette", self.cigratteArray[row])
            }
            else {
                self.txtCigarette.text = String(format: "%@ Cigarettes", self.cigratteArray[row])

            }

            self.txtCigarette.resignFirstResponder()
        }
        else if txtDrinks.isFirstResponder == true {
            if self.cigratteArray[row] == "1" {
                self.txtDrinks.text = String(format: "%@ Drink", self.cigratteArray[row])
            }
            else {
                self.txtDrinks.text = String(format: "%@ Drinks", self.cigratteArray[row])
            }

            self.txtDrinks.resignFirstResponder()
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
       // self.txtCigarette.resignFirstResponder()
       // self.txtDrinks.resignFirstResponder()
        self.view.endEditing(true)

    }
}


//MARK:- Measurment
extension ProfileFitnessTVC {
    
    
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
    
    //version 1.15
   /* private func getCmFrom(feet:Double) -> String {
        let cm = feet * 30.48
        // let cmrounded = cm.rounded(toPlaces: 2)
        let cmrounded = Int(cm)
        
        let cmStr = cmrounded.description
        return cmStr
    }*/
        private func getCmFrom(feet:Double,inch:Double) -> String {
            print("get Cm =",feet,inch)
           /* var feetF = feet * 12.0
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
                
            return cmStr.description
            }
            else {
                return "0"
            }


        }
    
    
    //version 1.15
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
            print("Get feet",cm)
            //FIRST WORKING
            /*if cm > 0 {
            let feetFinal:Double = Double(Int(floor((cm/2.54)/12)))
            let inchFinal:Double = Double(Int(floor((cm/2.54) - (feetFinal * 12))))
                print("\(Int(feetFinal)).\(Int(inchFinal.rounded()))")
                return "\(Int(feetFinal).description).\(Int(inchFinal.rounded()).description)"
            }
            else {
                return "0.0"
            }
            */
            //version 1.17
            
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
                print("\(Int(feetff)).\(Int(inches))")
                //self.feetGlobal = Int(feetff)
                //self.inchGlobal = Int(inches)
                return "\(Int(feetff).description).\(Int(inches).description)"
            }
            else {
                return "0.0"
            }
        }


}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}

extension ProfileFitnessTVC {
func getMemberIdFromMBServer() {
    let empID = DatabaseManager.sharedInstance.getSelectedEmpSrNo1()
    if empID != "" {
        let url = APIEngine.shared.getFitnessUserInfo(strEmpSrno:empID)
        
        print(url)
        
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        if let memberInfoArray = response?["UserMemberIdInfo"].array {
                            var memberID = ""
                            for arrDict in memberInfoArray {
                                let memberid = arrDict["MEMBER_ID"].stringValue
                                memberID = memberid
                                UserDefaults.standard.set(memberid, forKey: "MEMBER_ID")
                                
                                let memberExid = arrDict["MEMBER_EXTERNAL_ID"].stringValue
                                UserDefaults.standard.set(memberExid, forKey: "MEMBER_EXTID")

                            }
      
                        }
                        
                        if let companyInfoArray = response?["UserCompIdInfo"].array {
                            for arrDict in companyInfoArray {
                                let companyId = arrDict["COMPANY_ID"].stringValue
                                UserDefaults.standard.set(companyId, forKey: "COMPANY_ID")
                                
                                //COMPANY_EXT_ID
                                let companyExId = arrDict["COMPANY_EXT_ID"].stringValue
                                UserDefaults.standard.set(companyExId, forKey: "COMPANY_EXTID")

                            }
                        }
                        
                        if let memberPhyArray = response?["UserPhysicalInfo"].array {
                            for arrDict in memberPhyArray {
                                let wakeup = arrDict["WAKE_UP_TIME"].stringValue
                                let BED_TIME = arrDict["BED_TIME"].stringValue
                                let WEIGHT = arrDict["WEIGHT"].stringValue
                                let HEIGHT = arrDict["HEIGHT"].stringValue
                                
                                self.txtHeight.text = HEIGHT
                                self.txtWeight.text = WEIGHT
                                self.txtWakeUpTime.text = wakeup
                                self.txtBedTime.text = BED_TIME
                            }
                            
                        }
                        
                    }
                    else {
                        //self.displayActivityAlert(title: m_errorMsg )
                    }
                }
            }//msgDic
        }
    }
}
}


//MARK:- Send Onboarding data to server
extension ProfileFitnessTVC {
    
    private func sendOnboardingDataToMyBenefits(isMemberAlreadyOnboarded:String,isCompanyOnboarded:String) {
        
        let memberId = UserDefaults.standard.value(forKey: "MEMBER_ID") as! String
        
        guard let memberExtId = UserDefaults.standard.value(forKey: "MEMBER_EXTID") as? String else {
            return
        }
        guard let companyExtId = UserDefaults.standard.value(forKey: "COMPANY_EXTID") as? String else {
            return
        }
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
            groupChildSrNo = groupMasterDict.groupChildSrNo.description
        }
        
        
        //Sample format  --- >
        //Convert Height in cm
        var heightInCm = "0"
        if heightFlag == 1 {
            //convert in cm
            let feetTxt = txtFeet.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let inchText = txtInch.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if txtFeet.text != "" {
               // let combinedStr = String(format:"%@.%@",feetTxt,inchText)
                let feetDouble = Double(feetTxt) ?? 0.0
                let cmHeight = getCmFrom(feet:feetDouble,inch: Double(inchText) ?? 0.0)

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

        let parameterDict = ["WAKE_UP_TIME":txtWakeUpTime.text!,"BED_TIME":txtBedTime.text!,"WEIGHT":weightInKg,"HEIGHT":heightInCm,"MEMBER_ID":memberId,"MEMBER_EXTERNAL_ID":memberExtId,"MEMBER_ONBOARD":"0","COMPANY_ID":companyId,"COMPANY_EXT_ID":companyExtId,"COMPANY_ONBOARD":"0","EMPLOYEE_SR_NO":empSrNo]
        print(parameterDict)
        let stringURL = APIEngine.shared.sendOnboardingDataToServerAPI()
        
        
        ServerRequestManager.serverInstance.postDataToServerWithLoader(url: stringURL, dictionary: parameterDict as NSDictionary, view: self) { (response, error) in
            print("MB Response..")
            print(response)
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                    self.displayActivityAlert(title: "Profile details updated successfully")
                    }
                    else {
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                }
            }
            else {
                self.displayActivityAlert(title: m_errorMsg)
            }
            
        }
        
        print(parameterDict)
    }
}

/*
class ProfileFitnessTVC: UITableViewController,UITextFieldDelegate {
    
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
    
    
    var m_profilearray : Array<PERSON_INFORMATION> = []
    var m_profileDict : PERSON_INFORMATION?
    var m_employeedict : EMPLOYEE_INFORMATION?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:- set Gradient color
        //self.setTableViewBackgroundGradient(sender: self, Color.fitnessBottom.value, Color.fitnessTop.value)
        //self.slideMenuController()?.removeRightGestures()

        self.setFitnessBackground()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Profile"
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
        
        
        self.pickerView.dataSource = self as UIPickerViewDataSource
        self.pickerView.delegate = self as UIPickerViewDelegate
        self.pickerView.toolbarDelegate = self as ToolbarPickerViewDelegate
        
        self.pickerView.reloadAllComponents()
        
        
        txtDob.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        txtWakeUpTime.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        txtBedTime.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        
        txtWakeUpTime.returnKeyType = UIReturnKeyType.done
        txtBedTime.returnKeyType = UIReturnKeyType.done

        
        
        let kg = Measurement(value: 80, unit: UnitMass.kilograms)
        let lbs = Measurement(value: 100, unit: UnitMass.pounds)
        
        print(kg)
        print(lbs)
        
        let goodUnit = UnitMass.kilograms
        let goodWeight:Measurement = Measurement(value: 80, unit: goodUnit)
        print("Good pounds: ", goodWeight.converted(to: .pounds))
        
        
        
        
        getProfileDataFromServer()
     let rightBar = UIBarButtonItem(image: UIImage(named: "menu-1"), style: .done, target: self, action: #selector(menuTapped))
               self.navigationItem.rightBarButtonItem = rightBar
               
        getMemberIdFromMBServer()
           }
           
           @objc private func menuTapped() {
               self.slideMenuController()?.openRight()
           }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.slideMenuController()?.removeRightGestures()
        getDataFromInsurance()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Update Profile
        updateProfileAktivo()
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
            }
        }
        
        
        txtPhoneNo.text = m_profileDict?.cellPhoneNUmber
        m_employeedict=DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")[0]
        if(m_profilearray.count>0)
        {
            
            
        }
        
    }
    
    //Update Profile Aktivo
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
                self.txtHeight.isHidden = true

                self.heightFlag = 1
                
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
                
                let feetTxt = txtFeet.text!
                let inchText = txtInch.text!
                
                if txtFeet.text != "" {
                    let combinedStr = String(format:"%@.%@",feetTxt,inchText)
                    let feetDouble = Double(combinedStr) ?? 0.0
                    let cmHeight = getCmFrom(feet: feetDouble)
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
                print("Swiped right") //convert lbs
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
                print("Swiped left") //convert kg
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
        if indexPath.row == 0 {
            //return 145
            return 0

        }
        else if indexPath.row == 10 {
            return 90
            
        }
            
        else if indexPath.row == 11 {
            return 90
            
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
        txtPhoneNo.inputAccessoryView = doneToolbar
        txtFirstName.inputAccessoryView = doneToolbar
        txtLastName.inputAccessoryView = doneToolbar
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
            self.datePicker.maximumDate = Date()
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
            self.datePicker.minuteInterval = 5
            self.datePicker.datePickerMode = UIDatePickerMode.time
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
    }
    @objc func cancelClick() {
        //        txtDob.resignFirstResponder()
        self.view.endEditing(true)
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
                    //self.txtDob.text = response?.dateOfBirth?.getSimpleDate()
                    self.txtDob.text = response?.dateOfBirth?.getSimpleDate().getStrDateFitnessProfile()

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
    
    
}

extension ProfileFitnessTVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.cigratteArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.cigratteArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // self.txtCigarette.text = self.cigratteArray[row]
    }
}

extension ProfileFitnessTVC: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        
        
        if txtCigarette.isFirstResponder == true {
            if self.cigratteArray[row] == "1" {
                self.txtCigarette.text = String(format: "%@ Cigarette", self.cigratteArray[row])
                
            }
            else {
                self.txtCigarette.text = String(format: "%@ Cigarettes", self.cigratteArray[row])
            }
            self.txtCigarette.resignFirstResponder()
        }
        else {
            if self.cigratteArray[row] == "1" {
                self.txtDrinks.text = String(format: "%@ Drink", self.cigratteArray[row])
                
            }
            else {
                self.txtDrinks.text = String(format: "%@ Drinks", self.cigratteArray[row])
            }
            self.txtDrinks.resignFirstResponder()
        }
        
        
    }
    
    func didTapCancel() {
        //self.txtCigarette.text = nil
        self.txtCigarette.resignFirstResponder()
        self.txtDrinks.resignFirstResponder()
    }
}


//MARK:- Measurment
extension ProfileFitnessTVC {
    
    private func getPounds(kg:Double) -> String {
        // let goodUnit = UnitMass.kilograms
        //  var goodWeight:Measurement = Measurement(value: 110.0, unit: goodUnit)
        //var pounds = goodWeight.converted(to: .pounds)
        
        //return pounds.description
        
        let pounds = kg * 2.205
        let roundedPounds = pounds.rounded(toPlaces: 2)
        return roundedPounds.description
    }
    
    private func getKg(lbs:Double) -> String {
        let kg = Double(lbs) / 2.205
        let roundedKg = kg.rounded(toPlaces: 2)
        return roundedKg.description
    }
    
    private func getCmFrom(feet:Double) -> String {
        let cm = feet * 30.48
        let cmrounded = cm.rounded(toPlaces: 2)
        let cmStr = cmrounded.description
        return cmStr
    }
    
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
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}

extension ProfileFitnessTVC {
func getMemberIdFromMBServer() {
    let empID = DatabaseManager.sharedInstance.getSelectedEmpSrNo()
    if empID != "" {
        let url = APIEngine.shared.getFitnessUserInfo(strEmpSrno:empID)
        
        print(url)
        
        ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        if let memberInfoArray = response?["UserMemberIdInfo"].array {
                            var memberID = ""
                            for arrDict in memberInfoArray {
                                let memberid = arrDict["MEMBER_ID"].stringValue
                                memberID = memberid
                                UserDefaults.standard.set(memberid, forKey: "MEMBER_ID")
                            }
      
                        }
                        
                        if let memberPhyArray = response?["UserPhysicalInfo"].array {
                            for arrDict in memberPhyArray {
                                let wakeup = arrDict["WAKE_UP_TIME"].stringValue
                                let BED_TIME = arrDict["BED_TIME"].stringValue
                                let WEIGHT = arrDict["WEIGHT"].stringValue
                                let HEIGHT = arrDict["HEIGHT"].stringValue
                                
                                self.txtHeight.text = HEIGHT
                                self.txtWeight.text = WEIGHT
                                self.txtWakeUpTime.text = wakeup
                                self.txtBedTime.text = BED_TIME
                            }
                            
                        }
                        
                    }
                    else {
                        //self.displayActivityAlert(title: m_errorMsg )
                    }
                }
            }//msgDic
        }
    }
}
}
*/
