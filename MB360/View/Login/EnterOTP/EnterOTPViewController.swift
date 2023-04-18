//
//  EnterOTPViewController.swift
//  MyBenefits
//
//  Created by Semantic on 07/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import AEXML
import IOSSecuritySuite

class EnterOTPViewController: UIViewController,UITextFieldDelegate,XMLParserDelegate,UITabBarDelegate {
    @IBOutlet weak var m_goButton: UIButton!
    
    @IBOutlet weak var m_textField4: UITextField!
    @IBOutlet weak var m_textField3: UITextField!
    @IBOutlet weak var m_textField1: UITextField!
    @IBOutlet weak var m_textField2: UITextField!
    
    @IBOutlet weak var tf1Lbl: UIView!
    
    @IBOutlet weak var tf2Lbl: UIView!
    
    @IBOutlet weak var tf3Lbl: UIView!
    
    @IBOutlet weak var tf4Lbl: UIView!
    @IBOutlet weak var m_mobileNumberTextField: UITextField!
    
    
    @IBOutlet weak var hideView: UIView!
    
    var mobileNumber = String()
    
    var m_productCode = String()
    var xmlKey = String()
    var indexNumber = Int()
    

    
    var xmlKeysArray = ["GroupInformation","BrokerInformation","GroupProducts","GroupPolicies","GroupPoliciesEmployees","GroupPoliciesEmployeesDependants"]
    
    
  // var xmlKeysArray  = ["GroupAdminBasicSettings","GroupRelations","GroupWindowPeriodInformation","EnrollmentLifeEventInfo","EnrollmentTopUpOptions","EnrollmentMiscInformation","GroupInformation","BrokerInformation","GroupProducts","GroupPolicies","GroupPoliciesEmployees","GroupPoliciesEmployeesDependants"]
    
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var policiesDictArray: [[String: String]]?
    var dependantsDictArray: [[String: String]]?
    var policyEmpDictArray : [[String: String]]?
    var brokerDictArray : [[String: String]]?
    var currentValue = String()
    
    //OLD
   // var dictionaryKeys = ["OTPValidatedInformation","GROUPCHILDSRNO","GROUPCODE","GROUPNAME","GroupInformation","GroupGMCPolicies","GMCEmployee","GPAEmployee","GTLEmployee","tpa_code","tpa_name","ins_co_code","ins_co_name", "oe_gr_bas_inf_sr_no" ,"policy_number","ins_co_name","policy_commencement_date","policy_validupto_date","PRODUCTCODE","active","employee_id","oe_grp_bas_inf_sr_no","EMPLOYEENAME","GENDER","employee_sr_no","groupchildsrno","BROKERNAME","date_of_joining","official_e_mail_id","department","grade","designation","person_sr_no","employee_sr_no","age","date_of_birth","cellphone_no","person_name","gender","relationname","relationid","policy1","policy2","policy3","policy4","policy5","policy6","policy7","policy8","policy9","policy10","ProductCode","GMC","GPA","GTL","Dependant1","Dependant2","Dependant3","Dependant4","Dependant5","Dependant6","Dependant7","Dependant8","BROKER_NAME","BROKER_CODE","base_suminsured","topup_suminsured","date_of_datainsert","topup_si_pk","topup_si_opted_flag","topup_si_opted","topup_si_premium"]
    
    //New
    var dictionaryKeys = ["OTPValidatedInformation","GROUPCHILDSRNO","GROUPCODE","GROUPNAME","GroupInformation","GroupGMCPolicies","GMCEmployee","GPAEmployee","GTLEmployee","tpa_code","tpa_name","ins_co_code","ins_co_name", "oe_gr_bas_inf_sr_no" ,"policy_number","ins_co_name","policy_commencement_date","policy_validupto_date","PRODUCTCODE","active","employee_id","oe_grp_bas_inf_sr_no","EMPLOYEENAME","GENDER","employee_sr_no","groupchildsrno","BROKERNAME","date_of_joining","official_e_mail_id","department","grade","designation","person_sr_no","employee_sr_no","age","date_of_birth","cellphone_no","person_name","gender","relationname","relationid","policy1","policy2","policy3","policy4","policy5","policy6","policy7","policy8","policy9","policy10","ProductCode","GMC","GPA","GTL","Dependant1","Dependant2","Dependant3","Dependant4","Dependant5","Dependant6","Dependant7","Dependant8","BROKER_NAME","BROKER_CODE","base_suminsured","topup_suminsured","date_of_datainsert","topup_si_pk","topup_si_opted_flag","topup_si_opted","topup_si_premium","WINDOW_PERIOD_ACTIVE","PARENTAL_PREMIUM", "CROSS_COMBINATION_ALLOWED", "PAR_POL_INCLD_IN_MAIN_POLICY", "LIFE_EVENT_DOM","LIFE_EVENT_CHILDDOB","SON_MAXAGE","DAUGHTER_MAXAGE","PARENTS_MAXAGE","LIFE_EVENT_DOM_VALDTN_MSG","LIFE_EVENT_CHILDDOB_VALDTN_MSG","SON_MAXAGE_VALDTN_MSG","DAUGHTER_MAXAGE_VALDTN_MSG","PARENTS_MAXAGE_VALDTN_MSG","IS_TOPUP_OPTION_AVAILABLE","TOPUP_OPTIONS","TOPUP_PREMIUMS","ENRL_CNRFM_ALLOWED_FREQ","ENRL_CNRFM_MESSAGE","WINDOW_PERIOD_END_DATE","WINDOW_PERIOD_ACTIVE_TILL_MESSAGE","TOTAL_POLICY_FAMILY_COUNT","RELATION_COVERED_IN_FAMILY","RELATION_ID_COVERED_IN_FAMILY","MAIN_POLICY_FAMILY_COUNT","PARENTAL_POLICY_FAMIL_COUNT","IS_ENROLLMENT_CONFIRMED","EMPLOYEE_EDITABLE_FIELDS","TOPUP_OPT_TOTAL_DAYS_LAPSED","EMPLOYEE_RELATION", "EMPLOYEE_RELATION_ID", "EMPLOYEE_NAME", "EMPLOYEE_DOB","EMPLOYEE_AGE","EMPLOYEE_GENDER","PERSON_SR_NO","OFFICIAL_EMAIL_ID","PERSONAL_EMAIL_ID","CELLPHONE_NO","BASE_SUM_INSURED","TOPUP_SUM_INSURED","EMPLOYEE_IDENTIFICATION_NO","EMPLOYEE_GRADE","EMPLOYEE_DEPARTMENT","EMPLOYEE_DESIGNATION","EMPLOYEE_DOJ","EMP_TOPUP_OPTED","EMP_TOPUP_SI","EMP_TOPUP_PREMIUM","EMP_TOPUP_PREM_DEDTN_MESSAGE","EMP_TOPUP_OPTD_SR_NO","PERSON_SR_NO","DEPENDANT_RELATION","DEPENDANT_RELATION_ID","DEPENDANT_NAME","DEPENDANT_DOB","DEPENDANT_AGE","EcardInformation","IsEnrollmentDoneThroughMyBenefits","EnrollmentType","PolicyDefinition","Description","DependantCount","IncludedRelations","relation","Relation","RelationName","RelationID","MinAge","MaxAge","OpenEnrollmentWindowPeriodInformation","WindowPeriodForNewJoinee","Duration","StartDate","EndDate","WindowPeriodDurationForOptingParentalCoverage","NTimesEnrollmentCanBeConfirmed","NoOfTimesEnrollmentActuallyConfirmed","Childbirth","Marriage","Dependant1","Dependant2","Dependant3","Dependant4","Dependant5","Dependant6","Dependant7","Dependant8","ServerDate","TopupApplicability","GMCTopup","GPATopup","GTLTopup","TopupSumInsured","GMCTopupOptions","GPATopupOptions","GTLTopupOptions","BaseSumInsured","TopSumInsureds","TopupSumInsured","TSumInsured","TSumInsuredPremium","GPATopupOptions","GTLTopupOptions","date_of_datainsert","Hospitals","HospitalName","HospitalAddress","HospitalContactNo","HospitalLevelOfCare","TopupSumInsuredVal","V_COUNT"]
    
    //Added By Pranit - 28 Jan
    var m_userDict : EMPLOYEE_INFORMATION?
    var m_employeedict : EMPLOYEE_INFORMATION?
    var isJailbrokenDevice : Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if IOSSecuritySuite.amIJailbroken() {
            //print("This device is jailbroken")
            isJailbrokenDevice = true
            //self.showAlert(message: "This device is jailbroken")
        } else {
            //print("This device is not jailbroken")
            isJailbrokenDevice = false
        }
        if m_loginIDWeb.isEmpty{
          var groupChildSrNo = String()
          let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0){
                
                m_employeeDict=userArray[0]
                
                if let groupChlNo = m_employeeDict?.groupChildSrNo{
                    groupChildSrNo=String(groupChlNo)
                    print("groupChildSrNo : \(groupChildSrNo)")
                }
            }
        
        m_textField1.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        m_textField2.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        m_textField3.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        m_textField4.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
            print("Data in OTP page: ",m_loginIDMobileNumber," : ",m_loginIDEmail," Token: ",authToken)
        
        if !m_loginIDMobileNumber.isEmpty && m_loginIDMobileNumber.isPhoneNumber{
            m_mobileNumberTextField.text = "+91 "+m_loginIDMobileNumber
            print("m_loginIDMobileNumber")
        }
        
        if !m_loginIDEmail.isEmpty && !m_loginIDEmail.isPhoneNumber{
            m_mobileNumberTextField.text = m_loginIDEmail
            print("m_loginIDEmail")
        }
        
        m_mobileNumberTextField.isUserInteractionEnabled=false
        
        m_goButton.layer.masksToBounds=true
        if(Device.IS_IPAD)
        {
            m_goButton.layer.cornerRadius=39
        }
        else
        {
            m_goButton.layer.cornerRadius=23
        }
        m_goButton.layer.cornerRadius=23
        m_goButton.dropShadow()
        
        m_textField1.becomeFirstResponder()
        hideView.isHidden = true
        }
        else{
            hideView.isHidden = false
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        menuButton.isHidden=true
        DispatchQueue.main.async()
            {
                menuButton.isHidden=true
            }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        menuButton.isHidden=true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editButtonClicked(_ sender: Any)
    {
//        m_mobileNumberTextField.isUserInteractionEnabled=true
//        m_mobileNumberTextField .becomeFirstResponder()
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(_ textfield:UITextField)
    {
        if (textfield.text?.isEmpty)!
        {
            if (textfield.tag==4)
            {
                m_textField3.becomeFirstResponder()
            }
            else if (textfield.tag==3)
            {
                m_textField2.becomeFirstResponder()
            }
            else if (textfield.tag==2)
            {
                m_textField1.becomeFirstResponder()
            }
            
            
        }
        else
        {
            if (textfield.tag==0)
            {
                
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField==m_mobileNumberTextField)
        {
            let _ : Int = (m_mobileNumberTextField.text?.count)!
            
            let MAX_LENGTH_PHONENUMBER = 10
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
           
           
        }
        else
        {
           
            
            guard let text = textField.text else { return true }
            
            
            let newLength = text.utf16.count + string.utf16.count - range.length
            
            if(newLength>1)
            {
                NSLog("check: %@", string)
                
                gotoNextTextField(textField,with: string as NSString)
                
            }
            else
            {
                switch textField.tag
                {
                    
                case 1:
                    textField.textColor=UIColor.black
                    tf1Lbl.backgroundColor=UIColor.black
                    break
                    
                case 2:
                    textField.textColor=UIColor.black
                    tf2Lbl.backgroundColor=UIColor.black
                    break
                    
                case 3:
                    textField.textColor=UIColor.black
                    tf3Lbl.backgroundColor=UIColor.black
                    break
                    
                case 4:
                    textField.textColor=UIColor.black
                    tf4Lbl.backgroundColor=UIColor.black
                    
                    
                    break
                
                default: break
                    
                }
                
            }
            
           
            return newLength <= 1 // Bool
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        animateTextField(textField, with: true)
        if(textField.tag==4)
        {
           // if(tf4Lbl.text?.count==1)
          //  {
            //    view.endEditing(true)
          //  }
        }
        
        //        if(textField == m_mobileNumberTextField)
        //        {
        //            if (m_mobileNumberTextField.text?.isEmpty)!
        //            {
        //
        //            }
        //            else
        //            {
        //                m_mobileNumberTextField.text=""
        //            }
        //
        //        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateTextField(textField, with: false)
        if(textField == m_mobileNumberTextField)
        {
            checkMobileNumber()
        }
        else if(textField.tag==4 && !(textField.text==""))
        {
            m_textField4.textColor=hexStringToUIColor(hex: hightlightColor)
            tf4Lbl.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            print("m_textField4: ",m_textField4.text)
            
            if m_textField4.text != ""{
                self.goButtonClicked(self)
            }
        }
    }
    
    func checkMobileNumber()
    {
        if m_mobileNumberTextField.text?.isEmpty ?? true
        {
            
            displayActivityAlert(title: "Enter mobile number")
            
            
            
            
        }
        else
        {
            if (m_mobileNumberTextField.text?.count == 10)
            {
                m_mobileNumberTextField.isUserInteractionEnabled=false
                mobileNumber=m_mobileNumberTextField.text!
             //   self.sendOTP()
                getPostLoginDetails()
            }
            else
            {
                displayActivityAlert(title: "Please enter valid mobile number")
            }
        }
        
    }
    
    func sendOTP()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: "Please wait...")
            let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getSendOtpUrl(mobileNumber: mobileNumber))
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "GET"
            
            
            
            let task = URLSession.shared.dataTask(with: urlreq! as URL)
            { (data, response, error) in
                
                if data == nil
                {
                    
                    return
                }
                self.xmlKey = "SendOTP"
                let parser = XMLParser(data: data!)
                parser.delegate = self as? XMLParserDelegate
                parser.parse()
                print(self.resultsDictArray ?? "")
                if((self.resultsDictArray?.count)!>0)
                {
                for obj in self.resultsDictArray!
                {
                    let status = obj["OTPStatus"]
                    
                    DispatchQueue.main.async(execute:
                        {
                            if(status == "1")
                            {
                                self.displayActivityAlert(title: "OTP sent to your Mobile Number")
                                
                            }
                            else if(status == "0")
                            {
                                self.displayActivityAlert(title: "OTP not generated")
                                //let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                //enterOTPVC.mobileNumber=self.m_mobileNumberTxtField.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                            }
                            self.hidePleaseWait()
                    })
                }
                    
                }
                else
                {
                    DispatchQueue.main.async(execute:
                        {
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: "OTP not generated")
                        })
                    
                }
                
                
                
            }
            task.resume()
        }
        
        
    }
    
        func getPostLoginDetails()
        {
            if(isConnectedToNetWithAlert())
            {
                showPleaseWait(msg:"Please wait...")
                
               
                
                let string="<DataRequest><mobileno>\(mobileNumber)</mobileno></DataRequest>"
                let uploadData = string.data(using: .utf8)
                
                let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getSendOtpPostUrl() as String)
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?
                request.httpMethod = "POST"
                request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
                request.httpBody=uploadData
                let session = URLSession(configuration: .default)
                
            
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    if error != nil {
                        print("error ",error!)
                        self.hidePleaseWait()
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if httpResponse.statusCode == 200
                            {
                                do {
                                    self.xmlKey = "DocumentElement"
                                    let parser = XMLParser(data: data!)
                                    parser.delegate = self as? XMLParserDelegate
                                    parser.parse()
                                    print(self.resultsDictArray ?? "")
                                    for obj in self.resultsDictArray!
                                    {
                                        let status = obj["OTPStatusInformation"]
                                        if(status == "3")
                                        {
                                            self.displayActivityAlert(title: "OTP sent to your Mobile Number")

                                            
                                        }
                                        else {
                                            self.displayActivityAlert(title: "OTP sent to your Mobile Number")

                                        }
                                        DispatchQueue.main.async(execute:
                                            {
                                              
                                                self.hidePleaseWait()
                                        })
                                    }
                                    
                                }
                                catch let JSONError as NSError
                                {
                                    print(JSONError)
                                    self.hidePleaseWait()
                                   Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                }
                            }
                            else
                            {
                                self.hidePleaseWait()
                                self.displayActivityAlert(title: m_errorMsg)
                                print("else executed getPostLoginDetails")
                            }
                            
                        } else {
                            print("Can't cast response to NSHTTPURLResponse")
                            self.displayActivityAlert(title: m_errorMsg)
                            self.hidePleaseWait()
                            
                        }
                        
                    }
                }
                
                task.resume()
                
                
            }
        }
    func getTextFromTextFields() -> String
    {
        let concatString:String = m_textField1.text!+m_textField2.text!+m_textField3.text!+m_textField4.text!
        //        print(concatString)
        return concatString
    }
    
    
    
    func ValidateOtp()
    {
        
        if (isConnectedToNetWithAlert())
        {
//            showPleaseWait()
            
            
//            getLoginDetails()
            getPostValidateOTP()
            
            
           
        }
        
        
        
    }


    
    //MARK:- Send FCM Token To Server
     func sendFCMTokenToServer() {
        if(isConnectedToNetWithAlert())
        {
            print("send FCM Token To Server...")
            showPleaseWait(msg: "Please wait...")
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            
            if userArray.count > 0 {
                m_employeedict=userArray[0]
                var employeesrno = String()
                if let empNo = m_employeedict?.empSrNo {
                    employeesrno = String(empNo)
                }
            
            //<DataRequest><employeesrno>1009424</employeesrno><firebaseID>95PIA4PDykyLImCxFha08qG6Cc5IL2j8X5mAES3R</firebaseID></DataRequest>
            let token = UserDefaults.standard.value(forKey: "token") as? String
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().saveFirebaseIdUrl() as String)
            print(urlreq)
            let yourXML = AEXMLDocument()
            
            let dataRequest = yourXML.addChild(name: "DataRequest")
            dataRequest.addChild(name: "employeesrno", value: employeesrno)
            dataRequest.addChild(name: "firebaseID", value:token)
            print(yourXML.xml)
            print(urlreq)
            let uploadData = yourXML.xml.data(using: .utf8)
            
            print(dataRequest)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            request.httpBody=uploadData
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if error != nil {
                    print("error ",error!)
                    self.hidePleaseWait()
                   // self.displayActivityAlert(title: "The request timed out")
                }
                else
                {
                    print(response as? HTTPURLResponse)
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            do {
                                self.xmlKey = "DocumentElement"
                                let parser = XMLParser(data: data!)
                                parser.delegate = self as? XMLParserDelegate
                                parser.parse()
                                print(self.resultsDictArray ?? "")
                                for obj in self.resultsDictArray!
                                {
                                    let status = obj["FireBaseIDStatusInformation"]
                                    DispatchQueue.main.async(execute:
                                        {
                                            if(status == "1")
                                            {
                                                //self.displayActivityAlert(title: "Successfully send fcmId")
                                                print("Successfully send fcmId")
                                            }
                                            else if(status == "0")
                                            {
                                               // self.displayActivityAlert(title: "Failed to send FCM Id")
                                                print("Failed to send fcmId")

                                            }
                                            else
                                            {
                                                print("Failed to send FCMFCM")

                                            }
                                            self.hidePleaseWait()
                                    })
                                }
                                
                            }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                                self.hidePleaseWait()
                            }
                        }
                        else
                        {
                            self.hidePleaseWait()
                            //self.handleServerError(httpResponse: httpResponse)
                            print("else executed3")
                            print(httpResponse.statusCode)

                        }
                        
                    } else {
                        print("Can't cast response to NSHTTPURLResponse")
                        
                        self.hidePleaseWait()
                        
                    }
                    
                }
            }
            
            task.resume()
            
            }
        }
    }
    
    
   // MARK:- moveToEnrollment
    func moveToEnrollment() {
        print("MOVE TO ENROLLMENT...")
        
        if loadSession == true {//&& adminSettings == true {
            loadSession = false
            adminSettings = false
            
            let data : Bool = (UserDefaults.standard.value(forKey: "isEnrollmentThroughtMB") as? Bool)!
            print("data ",data)
            
            if let isEnrollmentThroughMB = UserDefaults.standard.value(forKey: "isEnrollmentThroughtMB") as? Bool {
                print("isEnrollmentThroughMB: ",isEnrollmentThroughMB)
                
                if isEnrollmentThroughMB == false{
                    
                    //Uncomment after API working
                    getGHITopUpOptionsFromServer()
                    
                    //comment later
                    //navigateToEnroll ment()

                }
                else {
                    m_windowPeriodStatus = false
                      var groupChildSrNo = String()
                       let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                         if(userArray.count>0){
                             m_employeeDict=userArray[0]
                         }
                             if(userArray.count>0){
                                 if let groupChlNo = m_employeeDict?.groupChildSrNo{
                                     groupChildSrNo=String(groupChlNo)
                                     print("groupChildSrNo : \(groupChildSrNo)")
                                 }
                            }
                       if groupChildSrNo == "1221" {
                          self.navigateToEnrollment()
                       }else{
                           self.setupTabbar(userDict: NSDictionary())
                       }
                }
            }
        }
        else {
            //self.getAdminSettingsValuesFromPostUrl()
            // self.getAdminSettingsJSON()
        }
        
    }
    
    func navigateToEnrollment() {
        
       
        
        if(m_windowPeriodStatus)//true
         {
                 if(m_enrollmentStatus)//wp- open & enrollment confirmed
                 {
                 setupTabbar(userDict: NSDictionary())
                    
                 }
                 else
                 {
                    
                    
                    UserDefaults.standard.set(true, forKey: "isFlexFirstTime")
                    UserDefaults.standard.set(true, forKey: "isFromLogin")
                    let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"EnrollmentNavigationController") as! EnrollmentNavigationController
                    flexIntroVC.modalPresentationStyle = .fullScreen
                    flexIntroVC.isFromLogin = true
                    self.navigationController?.present(flexIntroVC, animated: false, completion: nil)
                    
                    
                 }
         }
         else{
                setupTabbar(userDict: NSDictionary())
         }
    }

    
    var relationsDictArray: [[String: String]]?
    var GMCbaseSumInsuredDictArray : [[String: String]]?
    var GPAbaseSumInsuredDictArray : [[String: String]]?
    var GTLbaseSumInsuredDictArray : [[String: String]]?
    var GMCTopupSumInsuredDictArray : [[String: String]]?
    var GPATopupSumInsuredDictArray : [[String: String]]?
    var GTLTopupSumInsuredDictArray : [[String: String]]?

    var adminSettings = false
    var loadSession = false
    
    //MARK:- Main Admin Settings
    func getAdminSettingsValuesFromPostUrl()
    {
        print("Get Admin Settings")
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: "Please wait...")

            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getAdminSettingsValuesPostUrl() as String)
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
                if m_employeedict?.officialEmailID != nil {
                    UserDefaults.standard.set(m_employeedict?.officialEmailID, forKey: "emailid")
                }
                var oe_group_base_Info_Sr_No = String()
                var groupChildSrNo = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                
                let string="<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><oegrpbasinfsrno>\(oe_group_base_Info_Sr_No)</oegrpbasinfsrno></DataRequest>"
                let uploadData = string.data(using: .utf8)
                
                print(string)
                print(urlreq)
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "POST"
                request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
                //            request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.httpBody=uploadData
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    print(response)
                    
                    if error != nil {
                        print("error ",error!)
                        self.hidePleaseWait()
                        self.displayActivityAlert(title: "The request timed out")
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if httpResponse.statusCode == 200
                            {
                                do {
                                    print("....200....")
                                    
                                    self.xmlKey = "GroupAdminBasicSettings"
                                    
                                    let parser = XMLParser(data: data!)
                                    parser.delegate = self as? XMLParserDelegate
                                    parser.parse()
                                    print(self.resultsDictArray?.count)
                                    
                                    DispatchQueue.main.async(execute:
                                        {
                                            self.hidePleaseWait()
                                            print("AS.. queue..")
                                            //                                let status = DatabaseManager.sharedInstance.deleteEmployeeDetails(productCode: self.m_productCode)
                                            if (((self.resultsDictArray?.count)!)>0)
                                            {
                                                var userDict = NSDictionary()
                                                
                                                for i in 0..<self.resultsDictArray!.count
                                                {
                                                    userDict = self.resultsDictArray![i] as NSDictionary
                                                    print(userDict)
                                                    if(i==0)
                                                    {
                                                        UserDefaults.standard.set(userDict, forKey: "EnrollmentGroupAdminBasicSettings")
                                                        
                                                    }
                                                    else if(i==1)
                                                    {
                                                        let status = DatabaseManager.sharedInstance.deleteEnrollmentGroupRelationsDetails()
                                                        for i in 0..<self.relationsDictArray!.count
                                                        {
                                                            userDict = self.relationsDictArray![i] as NSDictionary; DatabaseManager.sharedInstance.saveEnrollmentGroupRelatoionsDetails(contactDict: userDict)
                                                        }
                                                    }
                                                    else if(i==3)
                                                    {
                                                        UserDefaults.standard.set(userDict, forKey: "EnrollmentLifeEventInfo")
                                                    }
                                                    else if(i==4)
                                                    {
                                                        UserDefaults.standard.set(userDict, forKey: "EnrollmentTopUpOptions")
                                                        print(self.GMCbaseSumInsuredDictArray,self.GPAbaseSumInsuredDictArray,self.GTLbaseSumInsuredDictArray)
                                                        
                                                        
                                                        for i in 0..<self.GMCTopupSumInsuredDictArray!.count
                                                        {
                                                            
                                                            let bsiDict :NSDictionary = self.GMCTopupSumInsuredDictArray![i] as NSDictionary
                                                            let userDict = ["productCode":"GMC","BaseSumInsured":bsiDict.value(forKey: "BaseSumInsured"),"TSumInsured":bsiDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":bsiDict.value(forKey: "TSumInsuredPremium")]
                                                            DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict as NSDictionary)
                                                        }
                                                        for i in 0..<self.GPATopupSumInsuredDictArray!.count
                                                        {
                                                            
                                                            let bsiDict :NSDictionary = self.GPATopupSumInsuredDictArray![i] as NSDictionary
                                                            let userDict = ["productCode":"GPA","BaseSumInsured":bsiDict.value(forKey: "BaseSumInsured"),"TSumInsured":bsiDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":bsiDict.value(forKey: "TSumInsuredPremium")]
                                                            DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict as NSDictionary)
                                                        }
                                                        for i in 0..<self.GTLTopupSumInsuredDictArray!.count
                                                        {
                                                            
                                                            let bsiDict :NSDictionary = self.GTLTopupSumInsuredDictArray![i] as NSDictionary
                                                            let userDict = ["productCode":"GTL","BaseSumInsured":bsiDict.value(forKey: "BaseSumInsured"),"TSumInsured":bsiDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":bsiDict.value(forKey: "TSumInsuredPremium")]
                                                            DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict as NSDictionary)
                                                        }
                                                    }
                                                    else if(i==5)
                                                    {
                                                        UserDefaults.standard.set(userDict, forKey: "EnrollmentMiscInformation")
                                                    }
                                                    
                                                    print(userDict)
                                                }
                                                
                                                //self.CheckEnrollmentStatus()
                                                //                                            self.setEnrollmentData()
                                                self.adminSettings = true
                                                //self.moveToEnrollment()

                                            }
                                            else
                                            {
                                                self.displayActivityAlert(title: "Data not found")
                                            }
                                           // self.getClaims()
                                           // self.getAllQueries()
                                           // self.getHospitalsCount()
                                            
                                            
                                            
                                            
                                    })
                                    
                                }
                                catch let JSONError as NSError
                                {
                                    print(JSONError)
                                    self.hidePleaseWait()
                                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                }
                            }
                            else
                            {
                                print("....400....")

                                self.hidePleaseWait()
                               // self.getClaims()
                               // self.getAllQueries()
                               // self.getHospitalsCount()
                                
                                self.displayActivityAlert(title: m_errorMsg)
                                print("else executed2")
                            }
                            
                        }
                        else
                        {
                            print("....500....")

                            print("Can't cast response to NSHTTPURLResponse")
                            self.displayActivityAlert(title: m_errorMsg)
                            self.hidePleaseWait()
                            
                        }
                        
                    }
                }
                
                task.resume()
            }
            
            
        }
        else {
           // hideRefreshLoader()
        }
    }
    
    
    //MARK:- Load Session
    func getLoadSessionValuesFromPostUrl()
    {
        if(isConnectedToNetWithAlert())
        {
            
            print("LoadSession.....")
            let uploadDic:NSDictionary=["mobileno":m_mobileNumberTextField.text!]
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getAppSessionValuesPostUrl() as String)
           
            
            let string="<DataRequest><mobileno>\(m_mobileNumberTextField.text!)</mobileno></DataRequest>"
            let uploadData = string.data(using: .utf8)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            request.httpBody=uploadData
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if error != nil {
                    print("error ",error!)
                    self.hidePleaseWait()
                    self.displayActivityAlert(title: m_errorMsg)
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            do {
                                
                                self.xmlKey = "GroupInformation"
                                let parser = XMLParser(data: data!)
                                parser.delegate = self as? XMLParserDelegate
                                parser.parse()
                                print(self.resultsDictArray ?? "")
                                print(self.policiesDictArray)
                                DispatchQueue.main.async(execute:
                                    {
                                if ((self.resultsDictArray?.count)!>0)
                                {
                                    var userDict = NSDictionary()
                                    for i in 0..<self.resultsDictArray!.count
                                    {
                                        userDict = self.resultsDictArray![i] as NSDictionary
                                        
                                        switch i
                                        {
                                        case 0 :
                                            let status = DatabaseManager.sharedInstance.deleteGroupChildMasterDetails(productCode: "");
                                            if(status)
                                            {
                                                DatabaseManager.sharedInstance.saveGroupChildMasterDetails(groupDetailsDict: userDict)
                                                print("userDict daya: ",userDict)
                                            }
                                            break
                                        case 1:
                                            print(userDict)
                                            if let brokerName = userDict.value(forKey: "BROKER_NAME")
                                            {
                                                let name: String = brokerName as! String
                                                UserDefaults.standard.set(name, forKey: "BrokerName")
                                            }
                                            break
                                        case 2:
                                            m_productCodeArray.removeAll()
                                            UserDefaults.standard.setValue(m_productCodeArray, forKey: "ProductsArray")

                                            
                                            let gmc : String = (userDict.value(forKey: "GMC")) as! String
                                            let gpa : String = (userDict.value(forKey: "GPA")) as! String
                                            let gtl : String = (userDict.value(forKey: "GTL")) as! String
                                            if(gmc=="1")
                                            {
                                                m_productCodeArray.append("GMC")
                                            }
                                            if(gpa=="1")
                                            {
                                                m_productCodeArray.append("GPA")
                                            }
                                            if(gtl=="1")
                                            {
                                                m_productCodeArray.append("GTL")
                                            }
                                            UserDefaults.standard.setValue(m_productCodeArray, forKey: "ProductsArray")
                                            m_productCodeArray=UserDefaults.standard.value(forKey: "ProductsArray") as! Array<String>
                                            
                                            break
                                            
                                        case 3 :
                                           let status = DatabaseManager.sharedInstance.deleteGroupBasicInfoDetails(productCode: "")
                                           if(status)
                                           {
                                            for i in 0..<self.policiesDictArray!.count
                                            {
                                                 userDict = self.policiesDictArray![i] as NSDictionary
                                                DatabaseManager.sharedInstance.saveGroupBasicInfoDetails(groupDetailsDict: userDict)
                                            }
                                           }
                                            break
                                        case 4 :
                                           let status = DatabaseManager.sharedInstance.deleteEmployeeDetails(productCode: "")
                                           if(status)
                                           {
                                            var code = "GMC"
                                            for i in 0..<self.policyEmpDictArray!.count
                                            {
                                                 userDict = self.policyEmpDictArray![i] as NSDictionary
                                                DatabaseManager.sharedInstance.saveEmployeeDetails(enrollmentDetailsDict: userDict,productCode:code)
                                                if(code=="GPA")
                                                {
                                                    code="GTL"
                                                }
                                                else
                                                {
                                                    code="GPA"
                                                }
                                            }
                                           }
                                            break
                                        case 5 :
                                            let status = DatabaseManager.sharedInstance.deletePersonDetails(personSrNo: "")
                                            print(self.dependantsDictArray)
                                            if(status)
                                            {
                                                for i in 0..<self.dependantsDictArray!.count
                                                {
                                                    userDict = self.dependantsDictArray![i] as NSDictionary; DatabaseManager.sharedInstance.savePersonDetails(personDetailsDict: userDict)
                                                }
                                            }
                                            break
                                       
                                        default :
                                            break
                                            
                                        }
                                        
                                        print(userDict)
                                    }
                                    
                                    //self.setupTabbar(userDict:userDict)
                                    self.loadSession = true

                                    let defaults = UserDefaults.standard
                                    defaults.set(true, forKey: "isAlreadylogin")
                                    self.moveToEnrollment()

                                }
                                else
                                {
                                    self.displayActivityAlert(title: "Data not found")
                                }
                                })
                                
                            }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                self.hidePleaseWait()
                            }
                            

                        }
                        else
                        {
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed getLoadSessionValuesFromPostUrl")
                        }
                        
                    } else {
                        print("Can't cast response to NSHTTPURLResponse")
                        self.displayActivityAlert(title: m_errorMsg)
                        self.hidePleaseWait()
                        
                    }
                    
                }
            }

            task.resume()
            
            
        }
    }
    
    
    func setupTabbar(userDict:NSDictionary)
    {

    print("Tab Bar Setup - TCL2")
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
        
        
       
        
               
       navigationController?.pushViewController(tabBarController, animated: true)
       tabBarController.selectedIndex=2
     
    
    }
    
    //MARK:- Parse
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
        policiesDictArray = []
        dependantsDictArray = []
        policyEmpDictArray = []
        
        //For Admin Settings
        relationsDictArray = []
        GTLTopupSumInsuredDictArray = []
        GPATopupSumInsuredDictArray = []
        GMCTopupSumInsuredDictArray = []
        GMCbaseSumInsuredDictArray = []
        GPAbaseSumInsuredDictArray = []
        GTLbaseSumInsuredDictArray = []
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        print(xmlKey, "==", elementName)
        
        if elementName == xmlKey
        {
            currentDictionary = [String : String]()
            
            
        }
        else if dictionaryKeys.contains(elementName)
        {
            self.currentValue = String()
        }
        
        
        
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        self.currentValue += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == xmlKey
        {
            resultsDictArray?.append(currentDictionary!)
            self.currentDictionary = [:]
            if(xmlKeysArray.contains(xmlKey))
            {
                indexNumber=indexNumber+1
                if(xmlKeysArray.count>indexNumber)
                {
                    xmlKey=xmlKeysArray[indexNumber]
                }
            }
            
            
            
        }
        else if dictionaryKeys.contains(elementName)
        {
            if(elementName=="policy1"||elementName=="policy2"||elementName=="policy3"||elementName=="policy4"||elementName=="policy5" || elementName=="policy6"||elementName=="policy7"||elementName=="policy8"||elementName=="policy9"||elementName=="policy10")
            {
                    policiesDictArray?.append(currentDictionary!)
            }
            else if(elementName=="Dependant1"||elementName=="Dependant2"||elementName=="Dependant3"||elementName=="Dependant4"||elementName=="Dependant5"||elementName=="Dependant6"||elementName=="Dependant7"||elementName=="Dependant8")
            {
                dependantsDictArray?.append(currentDictionary!)
            }
            else if(elementName=="GMCEmployee"||elementName=="GPAEmployee"||elementName=="GTLEmployee")
            {
                policyEmpDictArray?.append(currentDictionary!)
            
            }
                
                
                //Admin Settings - start
                else if(elementName=="GPATopupOptions")
                           {
                               print(m_productCode)
                               GPAbaseSumInsuredDictArray?.append(currentDictionary!)
                               if(m_productCode=="GMC")
                               {
                                   GPATopupSumInsuredDictArray?.append(currentDictionary!)
                               }
                               m_productCode="GPA"
                               
                           }
                           else if(elementName=="GTLTopupOptions")
                           {
                               print(m_productCode)
                               GTLbaseSumInsuredDictArray?.append(currentDictionary!)
                               if(m_productCode=="")
                               {
                                   GTLTopupSumInsuredDictArray?.append(currentDictionary!)
                               }
                               m_productCode="GTL"
                               
                           }
                           else if(elementName=="TopupSumInsuredVal")
                           {
                               
                               if(m_productCode=="GMC")
                               {
                                   GMCTopupSumInsuredDictArray?.append(currentDictionary!)
                                   
                               }
                               else if(m_productCode=="GPA")
                               {
                                   GPATopupSumInsuredDictArray?.append(currentDictionary!)
                               }
                               else if(m_productCode=="GTL")
                               {
                                   GTLTopupSumInsuredDictArray?.append(currentDictionary!)
                               }
                               
                           }
              
                
                //end
            else
            {
                self.currentDictionary![elementName] = currentValue
                self.currentValue = ""
            }
            
        }
        
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
        
    }
    
    
    func gotoNextTextField(_ textField:UITextField, with string:NSString)
    {
        
        if (textField.tag==1)
        {
            m_textField1.textColor=hexStringToUIColor(hex: hightlightColor)
            tf1Lbl.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            m_textField2.becomeFirstResponder()
            if (m_textField2.text?.isEmpty)!
            {
                m_textField2.text=string as String;
            }
            
        }
        else if(textField.tag==2)
        {
            m_textField2.textColor=hexStringToUIColor(hex: hightlightColor)
            tf2Lbl.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            m_textField3.becomeFirstResponder()
            if (m_textField3.text?.isEmpty)!
            {
                m_textField3.text=string as String;
            }
            //            m_tf3.text=string as String;
        }
        else if(textField.tag==3)
        {
            m_textField3.textColor=hexStringToUIColor(hex: hightlightColor)
            tf3Lbl.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            m_textField4.becomeFirstResponder()
            if (m_textField4.text?.isEmpty)!
            {
                m_textField4.text=string as String;
                m_textField4.resignFirstResponder()
            }
           
            //            m_tf4.text=string as String;
        }
        else if(textField.tag==4)
        {
            m_textField4.textColor=hexStringToUIColor(hex: hightlightColor)
            tf4Lbl.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            textField.resignFirstResponder()
        }
        
    }
    func gotoPreviousTextField(_ textField:UITextField)
    {
        
        if (textField.tag==1)
        {
            
        }
        else if(textField.tag==2)
        {
            m_textField1.becomeFirstResponder()
        }
        else if(textField.tag==3)
        {
            m_textField2.becomeFirstResponder()
        }
        else if(textField.tag==4)
        {
            m_textField3.becomeFirstResponder()
        }
        
    }
    func animateTextField(_ textField:UITextField, with up: Bool)
    {
        
        if(UIDevice.current.orientation.isLandscape)
        {
            let movementDistance=50
            let movementDuration=0.3
            
            let movement = (up ? -movementDistance : movementDistance);
            
            UIView.beginAnimations("anim", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration)
            self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
            UIView.commitAnimations()
            
        }
        
    }
    
    @IBAction func resendOtpButtonClicked(_ sender: Any)
    {
        //checkMobileNumber()
        let loginVc  = LoginViewController_New()
        if m_mobileNumberTextField.text!.contains("@"){
            loginVc.getPostLoginDetailsForEmail()
        }
        else if (m_loginIDMobileNumber.count == 10){
            loginVc.getPostLoginDetailsForMobile()
        }
        else
        {
            displayActivityAlert(title: "Please enter valid details")
            
        }
    }
    
    @IBOutlet weak var resendOTPButtonClicked: UIButton!
    @IBAction func goButtonClicked(_ sender: Any)
    {
//        if isJailbrokenDevice{
//            //self.showAlert(message: "This device is jailbroken")
//            let alertController = UIAlertController(title: "This device is jailbroken", message: "", preferredStyle: UIAlertControllerStyle.alert)
//
////            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
////            {
////                (result : UIAlertAction) -> Void in
////                print("Cancel")
////
////            }
//            let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
//            {(result : UIAlertAction) -> Void in
//
//                let defaults = UserDefaults.standard
//                defaults.set(false, forKey: "isAlreadylogin")
//
//                menuButton.isHidden=true
//                menuButton.removeFromSuperview()
//
//
//                let loginVC :LoginViewController_New = LoginViewController_New()
//
//                UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
//                UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
//                UserDefaults.standard.set("", forKey: "OrderMasterNo")
//                UserDefaults.standard.set("", forKey: "GroupChildSrNo")
//                UserDefaults.standard.set("", forKey: "emailid")
//
//                UserDefaults.standard.set(nil, forKey: "MEMBER_ID")
//
//                //for Added for Terms and codition on 1st time login
////                if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
////                    self.perviousTermsCondtion = "true"
////                }
////                else{
////                    self.perviousTermsCondtion = "false"
////                }
//                //To display disclaimer every time
//                UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
//                UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
//                UserDefaults.standard.setValue(nil, forKey: "drinkCount")
//                UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")
//
//                UserDefaults.standard.set(false, forKey: "isInsurance")
//                UserDefaults.standard.set(false, forKey: "isWellness")
//                UserDefaults.standard.set(false, forKey: "isFitness")
//
//
//                let center = UNUserNotificationCenter.current()
//                center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
//                center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])
//
//                center.removeAllPendingNotificationRequests()
////                if self.perviousTermsCondtion == "true"{
////                    UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
////                }
//
//                self.navigationController?.pushViewController(loginVC, animated: true)
//
//                UIControl().sendAction(#selector(NSXPCConnection.suspend),
//                                       to: UIApplication.shared, for: nil)
//
//
//            }
//            //alertController.addAction(cancelAction)
//            alertController.addAction(yesAction)
//
//            self.present(alertController, animated: true, completion: nil)
//        }else{
            
            if m_mobileNumberTextField.text?.isEmpty ?? true
            {
                displayActivityAlert(title: "Please enter Mobile Number")
                
            }
            else
            {
                if m_mobileNumberTextField.text!.contains("@"){
                    
                    let otpLength = getTextFromTextFields().characters.count
                    if (otpLength == 4)
                    {
                        self.ValidateOtp()
                    }
                    else if m_textField1.text?.isEmpty ?? true || m_textField2.text?.isEmpty ?? true || m_textField3.text?.isEmpty ?? true || m_textField4.text?.isEmpty ?? true
                    {
                        shakeTextfield(textField: m_textField1)
                        shakeTextfield(textField: m_textField2)
                        shakeTextfield(textField: m_textField3)
                        shakeTextfield(textField: m_textField4)
                    }
                    else
                    {
                        displayActivityAlert(title: "Please enter valid OTP")
                        
                    }
                    
                }
                else if (m_loginIDMobileNumber.count == 10)
                {
                    
                    let otpLength = getTextFromTextFields().characters.count
                    if (otpLength == 4)
                    {
                        self.ValidateOtp()
                    }
                    else if m_textField1.text?.isEmpty ?? true || m_textField2.text?.isEmpty ?? true || m_textField3.text?.isEmpty ?? true || m_textField4.text?.isEmpty ?? true
                    {
                        shakeTextfield(textField: m_textField1)
                        shakeTextfield(textField: m_textField2)
                        shakeTextfield(textField: m_textField3)
                        shakeTextfield(textField: m_textField4)
                    }
                    else
                    {
                        displayActivityAlert(title: "Please enter valid OTP")
                        
                    }
                }
                else
                {
                    displayActivityAlert(title: "Enter valid details")
                }
            }
        //}
    }
    
    //MARK:- GHI TopUp
    var m_enrollmentStatus = false
    var isWindowPeriodOpen = false
    var m_employeeDict : EMPLOYEE_INFORMATION?

        func getGHITopUpOptionsFromServer()
        {
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeeDict=userArray[0]
            }
            
            
            if(isConnectedToNetWithAlert())
            {
                
                if(userArray.count>0)
                {
                    
                    
                    var oe_group_base_Info_Sr_No = String()
                    var groupChildSrNo = String()
                    var empSrNo = String()
                    var empIDNo = String()
                    
                    if let empNo = m_employeeDict?.oe_group_base_Info_Sr_No
                    {
                        oe_group_base_Info_Sr_No = String(empNo)
                    }
                    if let groupChlNo = m_employeeDict?.groupChildSrNo
                    {
                        groupChildSrNo=String(groupChlNo)
                    }
                    if let empsrno = m_employeeDict?.empSrNo
                    {
                        empSrNo=String(empsrno)
                    }
                    if let empidno = m_employeeDict?.empIDNo
                    {
                        empIDNo=String(empidno)
                    }
                    
                    
                    
                    let url = APIEngine.shared.getNewTopUpOptionsJsonURL(grpchildsrno: groupChildSrNo, oegrpbasinfosrno:oe_group_base_Info_Sr_No , employeesrno: empSrNo, empIdenetificationNo: empIDNo)
                    
                    let urlreq = NSURL(string : url)
                    
                    //self.showPleaseWait(msg: "")
                    print(url)
                    
                        let dict = ["":""]

                        EnrollmentServerRequestManager.serverInstance.postDictionaryDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in

                            
                        if error != nil
                        {
                            print("error ",error!)
                            //self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                        }
                        else
                        {
                            // self.hidePleaseWait()
                            print("found Admin Setting....")
                            
                            do {
                                print("Started parsing Top Up... 1516")
                                print(data)
                                
                                
                                if let jsonResult = data as? NSDictionary
                                {
                                    print("Admin Data Found",jsonResult)
                                    if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                        if let status = msgDict.value(forKey: "Status") as? Bool {
                                            
                                            if status == true
                                            {
                                                print(jsonResult)
                                                
                                                if let IsEnrollmentSaved = jsonResult.value(forKey: "IsEnrollmentSaved") as? Int {
                                                    UserDefaults.standard.set(String(IsEnrollmentSaved), forKey: "IsEnrollmentSaved")
                                                    if IsEnrollmentSaved == 1 {
                                                        self.m_enrollmentStatus = true
                                                    }
                                                    else {
                                                        self.m_enrollmentStatus = false
                                                    }

                                                    
                                                }
                                                
                                                if let IsWindowPeriodOpen = jsonResult.value(forKey: "IsWindowPeriodOpen") as? Int {
                                                    UserDefaults.standard.set(String(IsWindowPeriodOpen), forKey: "IsWindowPeriodOpen")
                                                    if IsWindowPeriodOpen == 1 {
                                                        self.isWindowPeriodOpen = true
                                                        m_windowPeriodStatus = true
                                                    }
                                                    else {
                                                        self.isWindowPeriodOpen = false
                                                        m_windowPeriodStatus = false
                                                    }
                                                }
                                                
                                                if let ExtGroupSrNo = jsonResult.value(forKey: "ExtGroupSrNo") as? Int {
                                                    UserDefaults.standard.set(String(ExtGroupSrNo), forKey: "ExtGroupSrNoEnrollment")
                                                }
                                                
                                                var groupChildSrNo = String()
                                                let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                                                  if(userArray.count>0){
                                                    self.m_employeeDict=userArray[0]
                                                  }
                                                      if(userArray.count>0){
                                                        if let groupChlNo = self.m_employeeDict?.groupChildSrNo{
                                                              groupChildSrNo=String(groupChlNo)
                                                              print("groupChildSrNo : \(groupChildSrNo)")
                                                          }
                                                     }
                                                if groupChildSrNo == "1221" {
                                                   self.navigateToEnrollment()
                                                }else{
                                                    self.setupTabbar(userDict: NSDictionary())
                                                    
                                                }
                                                
                                                
                                                
                                               // let indexset = IndexSet(integer: 1)
                                                }
                                            else {
                                                //add here
                                                self.setupTabbar(userDict: NSDictionary())

                                            }
                                                //self.tableView.reloadSections([1], with: .none)
                                            }
                                            else {
                                                //No Data found
                                            }
                                        }//status
                                    }//msgDict
                                }//jsonResult
                          
                                
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                            }
                        }//else
                    }//server call
                }//userArray
            }
    }
    
    
    func getPostValidateOTP(){
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg:"Please wait...")
            
            
            let url = NSURL(string: WebServiceManager.getSharedInstance().getValidateOtpPostUrlPortal() as String)
            
            var jsonDict : [String : String] = [:]
            if !m_loginIDMobileNumber.isEmpty{
                jsonDict = ["mobileno":"\(m_loginIDMobileNumber)",
                            "enteredotp":"\(getTextFromTextFields())"]
            }
            else if !m_loginIDEmail.isEmpty{
                jsonDict = ["officialemailId":"\(m_mobileNumberTextField.text!)",
                            "enteredotp":"\(getTextFromTextFields())"]
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            print("jsonData: ",jsonData)
            print("jsonDict: ",jsonDict)
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "post"
           // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            var encryptedUserName = try! AesEncryption.encrypt(m_authUserName_Portal)
            var encryptedPassword = try! AesEncryption.encrypt(m_authPassword_Portal)
           
            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
            print("m_authUserName_Portal ",encryptedUserName)
            print("m_authPassword_Portal ",encryptedPassword)
            
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
            
            print("Request: ",request)
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                if let error = error {
                    print("error:", error)
                    return
                }
                else{
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print(httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            do {
                                guard let data = data else { return }
                                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
                                print("jsonResponse: ", json)
                                self.resultsDictArray = [json]
                                
                                print("resultsDictArray: ",self.resultsDictArray)
                                
                                let jsonData = try JSONSerialization.data(withJSONObject: json)
                                
                                // Convert to a string and print
                                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                                    print("Converted json:",JSONString)
                                }
                                
                                for obj in self.resultsDictArray!
                                {
                                    let otpValidatedInformation = obj["OTPValidatedInformation"]
                                    let status = obj["status"]
                                    
                                    print("Status: ",status," : ",otpValidatedInformation)
                                    
                                    DispatchQueue.main.async(execute:
                                                                {
                                        if(otpValidatedInformation == "1")
                                        {
                                            //self.getNewLoadSessionDataFromServer()
                                            
                                            //Authentication Token
                                            let AuthToken = obj["AuthToken"] as! String
                                            if AuthToken.isEmpty{
                                                navigationController?.popViewController(animated: true)
                                            }
                                            else{
                                                authToken = AuthToken
                                                 print("authToken: ",authToken)
                                                 self.getNewLoadSessionDataFromServerNew()
                                            }
                                        }
                                        else if(otpValidatedInformation == "0")
                                        {
                                            self.displayActivityAlert(title: "Enterd  OTP is incorrect")
                                        }
                                        else
                                        {
                                            self.displayActivityAlert(title: "Your MyBenefits360 services have expired or your mobile number is not updated in our records.Kindly call our customer service representative or your HR")
                                        }
                                        self.hidePleaseWait()
                                    })
                                }
                            } catch {
                                print("error:", error)
                                self.hidePleaseWait()
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            }
                        }
                        else if httpResponse.statusCode == 429{
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: "Too many request, please try again later")
                        }else if httpResponse.statusCode == 401{
                            self.hidePleaseWait()
                            self.alertForLogout()
                        }
                        else{
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed getPostValidateOTP")
                        }
                    }
                    else {
                        print("Can't cast response to NSHTTPURLResponse")
                        self.displayActivityAlert(title: m_errorMsg)
                        self.hidePleaseWait()
                    }
                }
            }
            task.resume()
        }
    }
    
    /*    func getPostValidateOTP()
        {
            if(isConnectedToNetWithAlert())
            {
                showPleaseWait(msg: "Please wait...")
                
                
                let uploadDic:NSDictionary=["mobileno":m_mobileNumberTextField.text!,"enteredotp":getTextFromTextFields()]
                
                
                let string="<DataRequest><mobileno>\(m_mobileNumberTextField.text!)</mobileno><enteredotp>\(getTextFromTextFields())</enteredotp></DataRequest>"
                let uploadData = string.data(using: .utf8)
                
                let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getValidateOtpPostUrl() as String)
                
                print(urlreq)
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "POST"
                request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
                request.httpBody=uploadData
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    if error != nil {
                        print("error ",error!)
                        self.hidePleaseWait()
                        self.displayActivityAlert(title: "The request timed out")
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if httpResponse.statusCode == 200
                            {
                                do {
                                    self.xmlKey = "DocumentElement"
                                    let parser = XMLParser(data: data!)
                                    parser.delegate = self as? XMLParserDelegate
                                    parser.parse()
                                    print(self.resultsDictArray ?? "")
                                    for obj in self.resultsDictArray!
                                    {
                                        let status = obj["OTPValidatedInformation"]
                                        
                                        DispatchQueue.main.async(execute:
                                            {
                                                if(status == "1") //|| status == nil || status == "null"
                                                {
                                                    //MARK:- Call Load Session
                                                    //Commented by Pranit old xml version
                                                   // self.getLoadSessionValuesFromPostUrl()
                                                    
                                                    
                                                    self.getNewLoadSessionDataFromServer()
                                                    

                                                   /* let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .default)
                                                    anotherQueue.async {
                                                        //self.getAdminSettingsValuesFromPostUrl()
                                                        
                                                        self.getAdminSettingsJSON()
                                                    }
                                                    */
                                                    //Added  By Pranit - 28th Jan
    //                                                let status=UserDefaults.standard.object(forKey: "isAlreadylogin") as? Bool
    //                                                       if(status==false||status==nil)
    //                                                       {
    //                                                        self.getDataSettings()
    //                                                       }
                                                    
                                                    
                                                }
                                                else if(status == "0")
                                                {
                                                    self.displayActivityAlert(title: "Enterd  OTP is incorrect")
    //                                                self.getAppSessionValuesFromPostUrl()
                                                    
                                                    
                                                }
                                                else
                                                {
    //                                                self.getAppSessionValuesFromPostUrl()
                                                    self.displayActivityAlert(title: "Your MyBenefits360 services have expired or your mobile number is not updated in our records.Kindly call our customer service representative or your HR")
                                                }
                                                self.hidePleaseWait()
                                        })
                                    }
                                    
                                }
                                catch let JSONError as NSError
                                {
                                    print(JSONError)
                                    self.hidePleaseWait()
                                }
                            }
                            else
                            {
                                self.hidePleaseWait()
                                self.handleServerError(httpResponse: httpResponse)
                                print("else executed")
                            }
                            
                        } else {
                            print("Can't cast response to NSHTTPURLResponse")
                            
                            self.hidePleaseWait()
                            
                        }
                        
                    }
                }
                
                task.resume()
                
                
            }
        }
    */
}

