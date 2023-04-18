//
//  LoginViewController_New.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 26/09/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCrashlytics


class LoginViewController_New: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!

    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var mobileTappedView: UIView!
    @IBOutlet weak var mobileTappedLbl: UILabel!
    
    @IBOutlet weak var emailTappedView: UIView!
    @IBOutlet weak var emailTappedLbl: UILabel!
    
    @IBOutlet weak var webTappedView: UIView!
    @IBOutlet weak var webTappedLbl: UILabel!
    
    @IBOutlet weak var errorMsg: UILabel!
    
    
    @IBOutlet weak var mobileTxtView: UIView!
    @IBOutlet weak var txtMobileno: UITextField!
    
    @IBOutlet weak var emailTxtView: UIView!
    @IBOutlet weak var txtEmailId: UITextField!
    
    @IBOutlet weak var webTextView: UIView!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var passwordBtn: UIButton!
    
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    
    
    var blueColor = UIColor(red:0/255, green:112/255, blue:223/255, alpha: 1)
    var whiteColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1).cgColor
    
    var isSelected = ""
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var iconClick = true
  
    override func viewDidLoad(){
        
        UserDefaults.standard.set(nil, forKey: "userEmployeeSrnoValue")
        UserDefaults.standard.set(nil, forKey: "userEmployeIdNoValue")
        UserDefaults.standard.set(nil, forKey: "userPersonSrnNoValue")
        
        
        menuButton.isHidden = true
        menuButton.removeFromSuperview()

        menuButton.isHidden = true
        menuButton.removeFromSuperview()

        UserDefaults.standard.setValue("true", forKey: "firstTimeInstall")
        
        getCoreDataDBPath()
        
        //Overlay screens used in enrollment
        UserDefaults.standard.setValue(false, forKey: "dependantOverlay")
        UserDefaults.standard.setValue(false, forKey: "parentalOverlay")
        
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        initialViews()
        self.mobileTappedView.layer.backgroundColor = blueColor.cgColor
        //self.mobileTappedView.layer.cornerRadius = 25
        self.mobileTappedLbl.textColor = UIColor.white
        self.mobileTxtView.isHidden = false
        self.emailTxtView.isHidden = true
        self.webTextView.isHidden = true
        self.mobileBtn.isHidden = false
        isSelected = "mobile"
        addgestures()
        mobilelayoutSettings()
        emaillayoutSettings()
        weblayoutSettings()
        
        
        //for sending to next textfield
        self.txtGroupName.delegate = self
        self.txtUserName.delegate = self
        self.txtPassword.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
         menuButton.isHidden=true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.txtGroupName:
            self.txtUserName.becomeFirstResponder()
        case self.txtUserName:
            self.txtPassword.becomeFirstResponder()
        case self.txtPassword:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden=true
        
        DispatchQueue.main.async()
            {
                
            menuButton.setImage(nil, for: .normal)
            menuButton.setBackgroundImage(nil, for: .normal)
            menuButton.isHidden=true
            menuButton.removeFromSuperview()
            
        }
        
        

        self.navigationController?.isNavigationBarHidden = true
//        m_mobileNumberTxtField.isUserInteractionEnabled=true
//        m_mobileNumberTxtField.becomeFirstResponder()
        
    }
    
    
    @IBAction func hideShowPasswordBtn(_ sender: Any) {
        print("hideShowPasswordBtn Tapped")
        
        if(iconClick == true) {
            txtPassword.isSecureTextEntry = false
            passwordBtn.setImage(UIImage(named:"passwordVisible"), for: .normal)
        } else {
            txtPassword.isSecureTextEntry = true
            passwordBtn.setImage(UIImage(named:"passwordHide"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    
    @IBAction func mobileBtnPressed(_ sender: Any) {
        print("Tapped mobile",txtMobileno.text ?? "")
        
        if txtMobileno.text?.isEmpty ?? true
        {
           
            displayActivityAlert(title: "Enter mobile number")
            
        }
        else
        {
            if (txtMobileno.text?.count == 10)
            {
                print("Tapped mobile count getPostLoginDetailsForMobile")
                UserDefaults.standard.setValue(txtMobileno.text, forKey: "loginMobileNo")
                getPostLoginDetailsForMobile()
//                let url = NSURL(string: "https://portal.mybenefits360.com")
//                let session = URLSession(
//                               configuration: URLSessionConfiguration.ephemeral,
//                               delegate: URLSessionPinningDelegate(),
//                               delegateQueue: nil)
//
//                let task = session.dataTask(with: url as! URL, completionHandler: { (data, response, error) -> Void in
//                    print(error)
//                })
                 
            }
            else
            {
                displayActivityAlert(title: "Please enter valid mobile number")
            }
        }
        
    }
    
 
    @IBAction func emailBtnPressed(_ sender: Any) {
        print("Tapped email",txtEmailId.text ?? "")
        
        if txtEmailId.text?.isEmpty ?? true
        {
           
            displayActivityAlert(title: "Enter E-mail ID")
            
        }
        else
        {
            if isValidEmail(emailStr: txtEmailId.text!) == false {
                shakeTextfield(textField: txtEmailId)
                displayActivityAlert(title: "Please enter valid E-mail ID")
            }
            else
            {
                print("Inside getPostLoginDetailsForMobile")
                UserDefaults.standard.setValue(txtEmailId.text, forKey: "loginEmailID")
                getPostLoginDetailsForEmail()
            }
        }
    }
    
    @IBAction func webBtnPressed(_ sender: Any) {
        print("Tapped web",txtGroupName.text ?? "")
        
        if txtGroupName.text?.isEmpty ?? true
        {
            displayActivityAlert(title: "Please Enter the Group Name")
        }
        else  if txtUserName.text?.isEmpty ?? true
        {
            displayActivityAlert(title: "Please Enter the Username")
        }
        else if txtPassword.text?.isEmpty ?? true
        {
            displayActivityAlert(title: "Please Enter the password")
        }
        else{
            print("Inside getPostLoginDetailsForWeb")
            getPostLoginDetailsForWeb()

        }
        
        
        
    }
    
}

extension LoginViewController_New{
    
    func addgestures(){
           self.mobileTappedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
           self.mobileTappedView.isUserInteractionEnabled = true
            //For Testing
        self.txtMobileno.text = ""//"9004752086"
           
           self.emailTappedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
           self.emailTappedView.isUserInteractionEnabled = true
            //For Testing
        self.txtEmailId.text = ""//"charudatt.revadekar@semantictech.in"
        
           self.webTappedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
           self.webTappedView.isUserInteractionEnabled = true
        self.txtGroupName.text = ""//"NAYASA1"
        self.txtUserName.text = ""//"NAYASA06"
        self.txtPassword.text = ""//"Test@123"
       }
       
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
           let tag = gestureRecognizer.view?.tag
           switch tag! {
           case 1 :
               print("select first view")
               initialViews()
               self.mobileTappedView.layer.backgroundColor = blueColor.cgColor
               self.mobileTappedLbl.textColor = UIColor.white
               
               self.mobileTxtView.isHidden = false
               self.emailTxtView.isHidden = true
               self.webTextView.isHidden = true
               self.mobileBtn.isHidden = false
               self.emailBtn.isHidden = true
               self.webBtn.isHidden = true
               
           case 2 :
               print("select second view")
               initialViews()
               self.emailTappedView.layer.backgroundColor = blueColor.cgColor
               self.emailTappedLbl.textColor = UIColor.white
               
               self.mobileTxtView.isHidden = true
               self.emailTxtView.isHidden = false
               self.webTextView.isHidden = true
               self.mobileBtn.isHidden = true
               self.emailBtn.isHidden = false
               self.webBtn.isHidden = true
               
               
           case 3 :
               print("select third view")
               initialViews()
               self.webTappedView.layer.backgroundColor = blueColor.cgColor
               self.webTappedLbl.textColor = UIColor.white
               
               self.mobileTxtView.isHidden = true
               self.emailTxtView.isHidden = true
               self.webTextView.isHidden = false
               self.mobileBtn.isHidden = true
               self.emailBtn.isHidden = true
               self.webBtn.isHidden = false
               
           default:
               print("default")
           }
       }
    
}

//Set Layout Views
extension LoginViewController_New{
    
    func initialViews(){
        self.errorMsg.text = ""
        self.stackView.layer.borderWidth = 0
        self.stackView.layer.borderColor = UIColor.lightGray.cgColor
        //self.stackView.layer.cornerRadius = 25
        
        
        self.mobileTappedView.layer.backgroundColor = whiteColor
        //self.mobileTappedView.layer.cornerRadius = 25
        self.mobileTappedLbl.textColor = blueColor//UIColor.blue
        self.emailTappedView.layer.backgroundColor = whiteColor
        //self.emailTappedView.layer.cornerRadius = 25
        self.emailTappedLbl.textColor = blueColor//UIColor.blue
        self.webTappedView.layer.backgroundColor = whiteColor
        //self.webTappedView.layer.cornerRadius = 25
        self.webTappedLbl.textColor = blueColor//UIColor.blue
        
        self.mobileTappedView.layer.borderWidth = 1
        self.mobileTappedView.layer.borderColor = blueColor.cgColor
        self.emailTappedView.layer.borderWidth = 1
        self.emailTappedView.layer.borderColor = blueColor.cgColor
        self.webTappedView.layer.borderWidth = 1
        self.webTappedView.layer.borderColor = blueColor.cgColor
        
        self.mobileBtn.isHidden = true
        self.emailBtn.isHidden = true
        self.webBtn.isHidden = true
        
    }
    
    func mobilelayoutSettings()
    {
        txtMobileno.layer.masksToBounds=true
        txtMobileno.delegate=self
        txtMobileno.layer.borderColor=UIColor.lightGray.cgColor
        txtMobileno.layer.borderWidth=1
        txtMobileno.becomeFirstResponder()
        txtMobileno.tintColor=UIColor.black
        txtMobileno.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtMobileno.addTarget(self, action: #selector(mobtxteditingChanged(sender:)), for: .editingChanged)
        txtMobileno.layer.cornerRadius=txtMobileno.frame.size.height/2
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "call"), textField: txtMobileno)
        
        mobileBtn.layer.masksToBounds=true
        if(Device.IS_IPAD)
        {
            
            txtMobileno.layer.cornerRadius=39
        }
        else
        {
            
            txtMobileno.layer.cornerRadius=18
        }
        mobileBtn.layer.cornerRadius=mobileBtn.frame.size.height/2
        mobileBtn.dropShadow()
        
    }
   
    func emaillayoutSettings()
    {
        txtEmailId.layer.masksToBounds=true
        txtEmailId.delegate=self
        txtEmailId.layer.borderColor=UIColor.lightGray.cgColor
        txtEmailId.layer.borderWidth=1
        txtEmailId.becomeFirstResponder()
        txtEmailId.tintColor=UIColor.black
        txtEmailId.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        //txtEmailId.addTarget(self, action: #selector(emailtxteditingChanged(sender:)), for: .editingChanged)
      
        txtEmailId.layer.cornerRadius=txtMobileno.frame.size.height/2
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "emailIcon"), textField: txtEmailId)
        
        emailBtn.layer.masksToBounds=true
        if(Device.IS_IPAD)
        {
            
            txtEmailId.layer.cornerRadius=39
        }
        else
        {
            
            txtEmailId.layer.cornerRadius=18
        }
        emailBtn.layer.cornerRadius=emailBtn.frame.size.height/2
        emailBtn.dropShadow()
    }
    
    func weblayoutSettings()
    {
        //For Group Name
        txtGroupName.layer.masksToBounds=true
        txtGroupName.delegate=self
        txtGroupName.layer.borderColor=UIColor.lightGray.cgColor
        txtGroupName.layer.borderWidth=1
        txtGroupName.becomeFirstResponder()
        txtGroupName.tintColor=UIColor.black
        txtGroupName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtGroupName.layer.cornerRadius=txtMobileno.frame.size.height/2
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "groupIcon"), textField: txtGroupName)
        
        //For UserNmae
        txtUserName.layer.masksToBounds=true
        txtUserName.delegate=self
        txtUserName.layer.borderColor=UIColor.lightGray.cgColor
        txtUserName.layer.borderWidth=1
        txtUserName.becomeFirstResponder()
        txtUserName.tintColor=UIColor.black
        txtUserName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtUserName.layer.cornerRadius=txtMobileno.frame.size.height/2
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "userIcon"), textField: txtUserName)
        
        //For password
        txtPassword.layer.masksToBounds=true
        txtPassword.delegate=self
        txtPassword.layer.borderColor=UIColor.white.cgColor
        txtPassword.layer.borderWidth=0
        txtPassword.becomeFirstResponder()
        txtPassword.tintColor=UIColor.black
        txtPassword.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "passwordIcon"), textField: txtPassword)
        passwordView.layer.cornerRadius = passwordView.frame.size.height/2
        passwordView.layer.borderWidth=1
        passwordView.layer.borderColor=UIColor.lightGray.cgColor
        //txtPassword.layer.cornerRadius=txtMobileno.frame.size.height/2
        //setRightSideImageViewLogin(image:  #imageLiteral(resourceName: "passwordHide"), textField: txtPassword)
        
        
        
        webBtn.layer.masksToBounds=true
        if(Device.IS_IPAD)
        {
            txtGroupName.layer.cornerRadius=39
        }
        else
        {
            txtGroupName.layer.cornerRadius=18
        }
        webBtn.layer.cornerRadius=webBtn.frame.size.height/2
        webBtn.dropShadow()
    }
   
}

//Animation and design textField
extension LoginViewController_New{
    
    func animateTextField(_ textField:UITextField, with up: Bool)
     {
         var movementDistance=0
         let movementDuration=0.3
         if(textField.tag==1)
         {
             if(isFromforeground)
             {
                 movementDistance=90;
             }
             else
             {
                 movementDistance=0;
             }
             
         }
         else
         {
             movementDistance=80;
         }
         
         
         let movement = (up ? -movementDistance : movementDistance);
         
         UIView.beginAnimations("anim", context: nil)
         UIView.setAnimationBeginsFromCurrentState(true)
         UIView.setAnimationDuration(movementDuration)
        // self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
         UIView.commitAnimations()
         
     }
    
    func setLeftSideImageViewLogin(image : UIImage,textField : UITextField)
    {
        let viewPadding = UIView(frame: CGRect(x: 5, y: 0, width: 30 , height: Int(textField.frame.size.height)))
        
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 24 , height: 24))
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        imageView.center = viewPadding.center
        imageView.image  = image
        viewPadding .addSubview(imageView)
        
        textField.leftView = viewPadding
        textField.leftViewMode = .always
    }
    
    func setRightSideImageViewLogin(image : UIImage,textField : UITextField)
    {
        let viewPadding = UIView(frame: CGRect(x: -15, y: 0, width: 30 , height: Int(textField.frame.size.height)))
        
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 24 , height: 24))
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        imageView.center = viewPadding.center
        imageView.image  = image
        viewPadding .addSubview(imageView)
        
        textField.rightView = viewPadding
        textField.rightViewMode = .always
    }
}

//TextFields methods
extension LoginViewController_New{
    
    @objc func textFieldDidChange(_ textfield:UITextField)
    {
        
        animateTextField(textfield, with: false)
        
        if textfield == txtMobileno {
            if txtMobileno.text?.isEmpty ?? true
            {
                shakeTextfield(textField: textfield)
            }
            else
            {
                if (txtMobileno.text!.count > 10)
                {
                    shakeTextfield(textField: textfield)
                }
            }
        }
        else if textfield == txtEmailId {
            if isValidEmail(emailStr: txtEmailId.text!) == false {
                shakeTextfield(textField: txtEmailId)
                
            }
        }
    }
    
    @objc private func mobtxteditingChanged(sender: UITextField) {

            if let text = sender.text, text.count >= 10 {
                sender.text = String(text.dropLast(text.count - 10))
                return
            }
    }
    
   /* @objc private func emailtxteditingChanged(sender: UITextField) {

            if let text = sender.text, text.count < 0 {
                sender.text = String(text.dropLast(text.count - 10))
                return
            }
    }
    */
    
    
}

//Validations for txtfields
extension LoginViewController_New{
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
}

//Server call
extension LoginViewController_New{
    
    func getPostLoginDetailsForMobile()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg:"Please wait...")
            
            
            //let url = URL(string: "https://portal.mybenefits360.com/mb360apiV1/api/Login/RequestOTP")!
            
            
            let url = NSURL(string: WebServiceManager.getSharedInstance().getSendOtpPostUrlPortal() as String)
            var loginMobileNoValue = UserDefaults.standard.value(forKey: "loginMobileNo") as! String
            print("From user Default Mobile values: ",loginMobileNoValue)
            let jsonDict = ["mobileno":"\(loginMobileNoValue)"]
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            print("jsonData: ",jsonData)
            print("jsonDict: ",jsonDict)
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "post"
            request.httpBody = jsonData
            
//            var encryptedUserName = try! AesEncryption.encrypt(m_authUserName_Portal)
//            var encryptedPassword = try! AesEncryption.encrypt(m_authPassword_Portal)
//
//            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
//            print("m_authUserName_Portal ",encryptedUserName)
//            print("m_authPassword_Portal ",encryptedPassword)
//
//            let authData = authString.data(using: String.Encoding.utf8)!
//            let base64AuthString = authData.base64EncodedString()
//
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
           
            
            
            print("Request: ",request)
            print("Request Body: ",request.httpBody)
            
            /*
            let session = URLSession(
                           configuration: URLSessionConfiguration.ephemeral,
                           delegate: URLSessionPinningDelegate(),
                           delegateQueue: nil)
            
            let task = session.dataTask(with: request) { [self] (data, response, error) in
             */
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                if let error = error {
                    print("error:", error)
                    return
                }
                else{
                    if let httpResponse = response as? HTTPURLResponse
                    {
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
                                    let status = obj["OTPStatusInformation"]
                                    
                                    print("Status: ",status)
                                    
                                    DispatchQueue.main.async(execute:
                                                                {
                                        m_loginIDMobileNumber = ""
                                        m_loginIDEmail = ""
                                        m_loginIDWeb = ""
                                        m_loginIDMobileNumber = self.txtMobileno.text!
                                                             
                                        if(status == "3") //|| (status == "1")
                                        {
                                            
                                            let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                            
                                            //sending email in mobileNumber
                                            enterOTPVC.mobileNumber=self.txtMobileno.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                                            
                                        }
                                        else if(status=="2")
                                        {
                                            
                                            self.displayActivityAlert(title: "Mobile number doesn't exist")
                                        }
                                        else if(status=="1")
                                        {
                                            /*
                                            let msg = """
                                                    Your MyBenefits360 services have expired or your mobile number is not updated in our records.
                                                    Kindly call our customer service representative or your HR
                                                    """
                                             */
                                            let msg = "Multiple Mobile number exists"
                                            
                                            self.displayActivityAlert(title: msg)
                                        }
                                        else if(status == "0")
                                        {
                                            self.displayActivityAlert(title: "OTP not generated")
                                        }
                                        else
                                        {
                                            var msg = errorMsg(httpResponse.statusCode)
                                            self.displayActivityAlert(title: msg)
//                                            let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
//
//                                            enterOTPVC.mobileNumber=self.txtEmailId.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
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
                        else{
                            self.hidePleaseWait()
                            
                            print("else executed",httpResponse.statusCode)
                            if httpResponse.statusCode == 429{
                                self.displayActivityAlert(title: "Too many request, please try again later")
                            }
                            else{
                                self.displayActivityAlert(title: m_errorMsg)
                            }
                            
                            //Testing
                            //let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                            
                            //enterOTPVC.mobileNumber=self.txtEmailId.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
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
    
    func getPostLoginDetailsForEmail()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg:"Please wait...")
            
            
            //let url = URL(string: "https://portal.mybenefits360.com/mb360apiV1/api/Login/RequestOTP")!
            
            
            let url = NSURL(string: WebServiceManager.getSharedInstance().getSendOtpPostUrlPortal() as String)
            var loginEmailIDValue = UserDefaults.standard.value(forKey: "loginEmailID") as! String
            print("From user Default Email values: ",loginEmailIDValue)
            let jsonDict = ["officialemailId":"\(loginEmailIDValue)"]
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            print("jsonData: ",jsonData)
            print("jsonDict: ",jsonDict)
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "post"
            request.httpBody = jsonData
            
            request.httpBody = jsonData
            
            var encryptedUserName = try! AesEncryption.encrypt(m_authUserName_Portal)
            var encryptedPassword = try! AesEncryption.encrypt(m_authPassword_Portal)
           
//            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
//            print("m_authUserName_Portal ",encryptedUserName)
//            print("m_authPassword_Portal ",encryptedPassword)
//
//            let authData = authString.data(using: String.Encoding.utf8)!
//
//            let base64AuthString = authData.base64EncodedString()
//
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
           
            
            print("Request: ",request)
            print("Request Body: ",request.httpBody)
            
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                if let error = error {
                    print("error:", error)
                    return
                }
                else{
                    if let httpResponse = response as? HTTPURLResponse
                    {
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
                                    let status = obj["OTPStatusInformation"]
                                    
                                    print("Status: ",status)
                                    
                                    DispatchQueue.main.async(execute:
                                                                {
                                        m_loginIDMobileNumber = ""
                                        m_loginIDEmail = ""
                                        m_loginIDWeb = ""
                                        m_loginIDEmail = self.txtEmailId.text!
                                        //if(status == "3")
                                        if (status == "2")
                                        {
                                            
                                            let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                            
                                            enterOTPVC.mobileNumber=self.txtEmailId.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                                            
                                        }
                                        else if(status=="NO")
                                        {
                                            
                                            self.displayActivityAlert(title: "E-mail Id doesn't exist")
                                        }
                                        else if(status=="1")
                                        {
                                            /*let msg = """
                                                    Your MyBenefits360 services have expired or your mobile number is not updated in our records.
                                                    Kindly call our customer service representative or your HR
                                                    """
                                            */
                                            let msg = "Multiple Official E-mail Id exists"
                                            self.displayActivityAlert(title: msg)
                                        }
                                        else if(status == "0")
                                        {
                                            self.displayActivityAlert(title: "OTP not generated")
                                        }
                                        else
                                        {
                                            let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                            
                                            enterOTPVC.mobileNumber=self.txtMobileno.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
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
                        else{
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed")
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
    
    
    func getPostLoginDetailsForWeb()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg:"Please wait...")
            
            
            //let url = URL(string: "https://portal.mybenefits360.com/mb360apiV1/api/Login/RequestOTP")!
            
            
            let url = NSURL(string: WebServiceManager.getSharedInstance().getSendWebLoginPostUrlPortal() as String)
            
            let jsonDict = ["GroupCode":"\(txtGroupName.text!)",
                            "UserName":"\(txtUserName.text!)",
                            "Password":"\(txtPassword.text!)"]
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            print("jsonData: ",jsonData)
            print("jsonDict: ",jsonDict)
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "post"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
//            var encryptedUserName = try! AesEncryption.encrypt(m_authUserName_Portal)
//            var encryptedPassword = try! AesEncryption.encrypt(m_authPassword_Portal)
//
//            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
//            print("m_authUserName_Portal ",encryptedUserName)
//            print("m_authPassword_Portal ",encryptedPassword)
//
//            let authData = authString.data(using: String.Encoding.utf8)!
//            let base64AuthString = authData.base64EncodedString()
//
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
         
            print("Request: ",request)
            print("Request Body: ",request.httpBody)
            
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                if let error = error {
                    print("error:", error)
                    return
                }
                else{
                    if let httpResponse = response as? HTTPURLResponse
                    {
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
                                    let status = obj["status"]
                                    let message = obj["Message"]
                                    let uniqueID = obj["UniqueID"]
                                    
                                    print("Web Portal \(status) \(message) \(uniqueID)")
                                    
                                    
                                    DispatchQueue.main.async(execute:
                                                                {
                                        m_loginIDMobileNumber = ""
                                        m_loginIDEmail = ""
                                        m_loginIDWeb = ""
                                        m_loginIDWeb = uniqueID ?? "-1"
                                        if message?.uppercased() == "SUCCESS"{
                                            
                                            print("Valid Web Credentials")
                                            if (status == "1")
                                            {
                                                let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                                enterOTPVC.getNewLoadSessionDataFromServer()
                                                navigationController?.pushViewController(enterOTPVC, animated: true)
                                             
                                            }
                                            else{
                                                self.displayActivityAlert(title: "Invalid details")
                                            }
                                        }
                                        else{
                                            self.displayActivityAlert(title: message!)
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
                        else{
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed")
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
    
    
    func getCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        print("Core Data DB Path :: \(path ?? "Not found")")
    }
}

class URLSessionPinningDelegate: NSObject, URLSessionDelegate{
    /*
     func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
     if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
     if let serverTrust = challenge.protectionSpace.serverTrust {
     var secresult = SecTrustResultType.invalid
     let status = SecTrustEvaluate(serverTrust, &secresult)
     if(errSecSuccess == status) {
     // server certificate
     if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
     let serverCertificateData = SecCertificateCopyData(serverCertificate)
     let data = CFDataGetBytePtr(serverCertificateData);
     let size = CFDataGetLength(serverCertificateData);
     let cert1 = NSData(bytes: data, length: size)
     // bundled certificate
     let file_der = Bundle.main.path(forResource: "mybenefits360_com", ofType: "cer")
     if let file = file_der {
     if let cert2 = NSData(contentsOfFile: file) {
     // bundled certificate matches server's actual certificate
     if cert1.isEqual(to: cert2 as Data) {
     completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
     return
     }
     }
     }
     }
     }
     }
     }
     // Certificate validation / Pinning failed
     completionHandler(.cancelAuthenticationChallenge, nil)
     }
     */
    
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        /*
//        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
//            if let serverTrust = challenge.protectionSpace.serverTrust {
//                var secresult = SecTrustResultType.invalid
//                let status = SecTrustEvaluate(serverTrust, &secresult)
//
//
//
//                if (errSecSuccess == status) {
//                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 1) {
//                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
//                        let data = CFDataGetBytePtr(serverCertificateData);
//                        let size = CFDataGetLength(serverCertificateData);
//                        let cert1 = NSData(bytes: data, length: size)
//                        let file_der = Bundle.main.path(forResource: "mybenefits360_com", ofType: ".cer")
//                        print("file_der: ",file_der)
//                        print("cert1: ",cert1)
//                        print("serverTrust: ",serverTrust)
//                        if let file = file_der {
//                            if let cert2 = NSData(contentsOfFile: file) {
//                                print("cert1: ",cert1)
//                                print("cert2: ",cert2)
//                                if cert1.isEqual(to: cert2 as Data) { completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
//                                    return
//                                }
//                                else{
//                                    print("cert1 error")
//                                    print("--------")
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//         // Pinning failed
//         completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
//         */
//
//        //Create a server trust
//
//        guard let serverTrust = challenge.protectionSpace.serverTrust, let certificate =
//                SecTrustGetCertificateAtIndex(serverTrust, 0) else {
//            return
//        }
//        //certificate pinning
//        
//        //SSL Policy for domain check
//        let policy = NSMutableArray()
//        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
//        //Evaluate the certificate
//        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
//        print("serverTrust: ",serverTrust)
//        print("isServerTrusted: ",isServerTrusted)
//        print("certificate: ",certificate)
//        //Local and Remote Certificate Data
//        let remoteCertificateData: NSData = SecCertificateCopyData(certificate)
//        let remoteCert = remoteCertificateData as Data
//        let pathToCertificate = Bundle.main.path(forResource: "STAR_mybenefits360_com", ofType: ".cer")
//        let localCertificateData: NSData = NSData.init(contentsOfFile: pathToCertificate!)!
//        print("remoteCertificateData: ",remoteCertificateData)
//        print("localCertificateData: ",localCertificateData)
//        print("remoteCert: ",remoteCert)
//        //Compare Data of both certificates
//        if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)) {
//            let credential: URLCredential = URLCredential(trust: serverTrust)
//            print("Certification pinning is successfull")
//            completionHandler(.useCredential, credential)
//        } else {
//            //failure happened
//            print("Certification pinning is failed")
//            completionHandler(.cancelAuthenticationChallenge, nil)
//        }
//
//    }
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
    if let serverTrust = challenge.protectionSpace.serverTrust {
    var secresult = SecTrustResultType.invalid
    let status = SecTrustEvaluate(serverTrust, &secresult)
    if (errSecSuccess == status) {
    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
    let serverCertificateData = SecCertificateCopyData(serverCertificate)
    let data = CFDataGetBytePtr(serverCertificateData);
    let size = CFDataGetLength(serverCertificateData);
    let cert1 = NSData(bytes: data, length: size)
    let file_der = Bundle.main.path(forResource: "STAR_mybenefits360_com", ofType: "cer")
    if let file = file_der {
    if let cert2 = NSData(contentsOfFile: file) {
    if cert1.isEqual(to: cert2 as Data) { completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
    return
    }
    }
    }
    }
    }
    }
    }
    // Pinning failed
        
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
         
}
