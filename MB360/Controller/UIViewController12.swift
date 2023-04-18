//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
//import VHUD
// import SVProgressHUD
import MBProgressHUD
import IOSSecuritySuite

var m_productCodeArray : Array<String>=[]
var menuButton = UIButton()
var employeeName = String()
var hightlightColor = "0070d5"      //dark blue color
var gradiantColor2 = "51acff"       //light blue color
var gradiantWhiteColor = "ffffff"  //pure white color
var isFromforeground = Bool()
var m_windowPeriodStatus = Bool()
var getAdminStatus = Bool()
var m_enrollmentLifeEventInfoDict = NSDictionary()

let m_authUserName = "MB360"
let m_authPassword = "$EM@MB360"
let m_authUserName_Portal = "MB360"
let m_authPassword_Portal = "$EM@MB360"
//let m_authUserName_Portal = "nPsnEnXx1s3nmwLKgYWYNMtCE/gJ0gUx5Me6ZDkocydjGo9kB0KvFx620L05C489HtUi5mI6XljZxUvW/b/2EM4LDmlMj24r+Ybju3ZcYVHKA2vVbrB/4uVMF4hBBtpi"
//let m_authPassword_Portal = "qZy+QBOVxQkVpVAo284+ZbOixwuuTwY1NSbYcpJSTHnB1G/0vhY+sSbLHNt1gGsKowkv6mvWcGVfQTvmVkETZiwK/wUY2SDzeGAuBDgs52mRt8mz/5uH0t7vszipVPLS"
var m_loginIDMobileNumber = String()
var m_loginIDEmail = String()
var m_loginIDWeb = String()
var m_loginUserGender = String()
var userEmployeeSrno = String()
var userEmployeIdNo = String()
var userPersonSrnNo = String()

var authToken = String() // used for barer token api calls

let m_errorMsg = "Unable to reach server please try again later."
let err_no_503 = "Service is unavailable"
let err_no_404 = "No Response From Server"
let err_no_0 = "No Response From Server"
let err_no_1000 = "Invalid Request Code"
let err_no_1001 = "No Data Found"
let err_no_1002 = " UndefinedError"
let m_errorMsgFile = "File not found"
var m_serverDate = Date()
var m_isFirstTime = true
var isGPAEmployee = false
var m_spouse = String()
var documentController: UIDocumentInteractionController = UIDocumentInteractionController()
var cornerRadiusForView : CGFloat = 8
var isJailbrokenDevice : Bool = false


extension UIViewController {
    
    
    
//    func displayActivityAlert(title: String)
//    {
//        let pending = UIAlertController(title: title, message: nil, preferredStyle: .alert)
//        
//        present(pending, animated: true, completion: nil)
//        let deadlineTime = DispatchTime.now() + .seconds(2)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
//        {
//            pending.dismiss(animated: true, completion: nil)
//            
//        }
//        
//    }
    
    func displayActivityAlert(title: String)
    {
        DispatchQueue.main.async { () -> Void in

        let pending = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
            self.present(pending, animated: true, completion: nil)
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
        {
            pending.dismiss(animated: true, completion: nil)
            
        }
        }
        
    }
    
    func errorMsg(_ status: Int) -> String{
        var msg = ""
        switch status {
        case 500:
            msg = err_no_503
            break
        case 404:
            msg = err_no_404
            break
        case 1000:
            msg = err_no_1000
            break
        case 1001:
            msg = err_no_1001
            break
        case 1002:
            msg = err_no_1002
            break
        case 0:
            msg = err_no_0
            break
        default:
            msg = m_errorMsg
            break
        }
        
        return msg
    }
    
    func alertForLogout(){
        let alertController = UIAlertController(title: "something went wrong.", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
//            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
//            {
//                (result : UIAlertAction) -> Void in
//                print("Cancel")
//
//            }
        let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {(result : UIAlertAction) -> Void in
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isAlreadylogin")
            
            menuButton.isHidden=true
            menuButton.removeFromSuperview()
            
            
            let loginVC :LoginViewController_New = LoginViewController_New()
            
            UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
            UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
            UserDefaults.standard.set("", forKey: "OrderMasterNo")
            UserDefaults.standard.set("", forKey: "GroupChildSrNo")
            UserDefaults.standard.set("", forKey: "emailid")
            
            UserDefaults.standard.set(nil, forKey: "MEMBER_ID")
            
            //for Added for Terms and codition on 1st time login
//                if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
//                    self.perviousTermsCondtion = "true"
//                }
//                else{
//                    self.perviousTermsCondtion = "false"
//                }
            //To display disclaimer every time
            UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
            UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
            UserDefaults.standard.setValue(nil, forKey: "drinkCount")
            UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")

            UserDefaults.standard.set(false, forKey: "isInsurance")
            UserDefaults.standard.set(false, forKey: "isWellness")
            UserDefaults.standard.set(false, forKey: "isFitness")

            
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

            center.removeAllPendingNotificationRequests()
//                if self.perviousTermsCondtion == "true"{
//                    UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
//                }

            self.navigationController?.pushViewController(loginVC, animated: true)
            //        navigationController?.popToViewController(loginVC, animated: true)
            
        }
        //alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayActivityAlertWithSeconds(title: String,seconds:Int)
    {
        DispatchQueue.main.async { () -> Void in

        let pending = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
            self.present(pending, animated: true, completion: nil)
        let deadlineTime = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
        {
            pending.dismiss(animated: true, completion: nil)
            
        }
        }
        
    }
    
    func handleServerError(httpResponse:HTTPURLResponse)
    {
        var errorMsg:String="Something went wrong, please try again"
        if (httpResponse.statusCode == 400)
        {
            errorMsg="400_error"
        }
        else if(httpResponse.statusCode == 401)
        {
            errorMsg="401_error"
        }
        else if(httpResponse.statusCode == 403)
        {
            errorMsg="403_error"
        }
        else if(httpResponse.statusCode == 404)
        {
            errorMsg="404_error"
        }
        else if(httpResponse.statusCode == 405)
        {
            errorMsg="405_error"
        }
        else if(httpResponse.statusCode == 408)
        {
            errorMsg="408_error"
        }
        else if(httpResponse.statusCode == 500)
        {
            errorMsg="500_error"
        }
        else if(httpResponse.statusCode == -1001)
        {
            errorMsg="-1001_error"
        }
        
        let deadlineTime = DispatchTime.now() + .seconds(0)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
        {
//            ALLoadingView.manager.hideLoadingView(withDelay: 0.0)
            self.displayActivityAlert(title: errorMsg )
        }
    }
   
    func showAlert(message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "DISMISS", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertwithOk(message:String)
       {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel)
           {
               (result : UIAlertAction) -> Void in
               print("Cancel")
           }
           alert.addAction(cancelAction)
           self.present(alert, animated: true, completion: nil)
       }
    
    func showAlertDetails(message:String,title1:String)
    {
        let alert = UIAlertController(title: title1, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "DISMISS", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func isConnectedToNetWithAlert()->Bool
    {
        let status = Reach().connectionStatus()
        var netStatus = true
        switch status
        {
        case .unknown, .offline:
            print("Not connected")
            netStatus = false
            //self.displayActivityAlert(title: "Not connected to internet!")
            break;
        case .online(.wwan),.online(.wiFi):
            netStatus = true
            break
            
            
        }
        return netStatus
    }
    func isConnectedToNet()->Bool
    {
        let status = Reach().connectionStatus()
        var netStatus = true
        switch status
        {
        case .unknown, .offline:
            netStatus = false
            break;
        case .online(.wwan),.online(.wiFi):
            netStatus = true
            break
            
        }
        return netStatus

    }
    func getDocumentDirectory()->String
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentsPath
    }
    func createDirectoryIfNotAvailable(fullPath:String)
    {
        
//        let documentsDirectory = getDocumentDirectory()
//        let fullPath = "\(documentsDirectory)/\(dirName)"
        
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if (!fileManager.fileExists(atPath: fullPath, isDirectory:&isDir))
        {
            do {
                try FileManager.default.createDirectory(atPath: fullPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
            
        }
        
        
        
        
    }
    
    func convertDatetoString(_ date: Date) -> String
    {
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
    }
    
    func convertSelectedStringToDate(dateString:String)->Date
          {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd~MM~yyyy" //Your date format
              dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
              
              if let date = dateFormatter.date(from: dateString)
              {
                  print(date )
                  
                  
                  return date
              }
              return Date()
          }
    
    func getRightBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "notification"), style: .plain, target: self, action: #selector(rightButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func rightButtonClicked()
    {
        print ("rightButtonClicked")

    }
    func getBackButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backButtonClicked)) // action:#selector(Class.MethodName) for swift 3

        
        return button1
    }
    @objc func backButtonClicked()
    {
        print ("backButtonClicked")
        self.tabBarController?.tabBar.isHidden=false
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func getBackButtonHideTabBar()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backButtonClickedHideTabBar)) // action:#selector(Class.MethodName) for swift 3

        
        return button1
    }
    @objc func backButtonClickedHideTabBar()
    {
        print ("backButtonClicked")
        self.tabBarController?.tabBar.isHidden=true
        _ = navigationController?.popViewController(animated: true)
    }
    
    
   
    func showHello()
    {
        
//        SVProgressHUD.show(withStatus: "Authenticating...").
    }
    func isConnectedToMobileDataWithAlert()->String
    {
        let status = Reach().connectionStatus()
        var netStatus = "Yes"
        switch status
        {
        case .unknown, .offline:
            print("Not connected")
            netStatus = "No"
            self.displayActivityAlert(title: "ConectionAlert")
            break;
        case .online(.wwan):
            netStatus = "Data"
            
            break
        case.online(.wiFi):
            netStatus = "WiFi"
            break
            
            
        }
        return netStatus
    }
    
    //MARK:- Add Loader
    func showPleaseWait(msg:String)
    {
        
        
//       GCD.dispatch(type: .async(queue: .main))
//        {
//
//            ALLoadingView.manager.resetToDefaults()
//            ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator, windowMode: .fullscreen)
//            ALLoadingView.manager.messageText=msg
//
//
//        }
        

        
        //        let progresshub = MBProgressHUD.init(for: self.view)
        
        DispatchQueue.main.async {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //hud.label.text = msg
            hud.backgroundColor = UIColor.clear
            hud.bezelView.backgroundColor = UIColor.clear
            hud.bezelView.color = UIColor.clear
            hud.bezelView.style = .solidColor

        }
    }
    
    
    func showPleaseWait1(msg:String)
    {
        
        
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.hide(animated: true, afterDelay: 0.5)
            //hud.label.text = msg
            hud.backgroundColor = UIColor.clear
            hud.bezelView.backgroundColor = UIColor.clear
            hud.bezelView.color = UIColor.clear
            hud.bezelView.style = .solidColor

        }
        
        
     
    }
    func hidePleaseWait1()
    {
        
        DispatchQueue.main.async {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            
        }
      
    }
    
    func hidePleaseWait()
    {
//        GCD.dispatch(type: .async(queue: .main))
//        {
//            ALLoadingView.manager.hideLoadingView(withDelay: 1.0)
//            //            SVProgressHUD.dismiss()
//        }
        
        DispatchQueue.main.async {

            MBProgressHUD.hide(for: self.view, animated: true)


        }
        
    }
    func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
    }
    
    func convertStringToDate(dateString:String)->Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
       if let date = dateFormatter.date(from: dateString)
       {
            print(date )

        
            return date
        }
        return Date()
    }
    
    func convertMMMStringToDate(dateString:String)->Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
       if let date = dateFormatter.date(from: dateString)
       {
            print(date )

        
            return date
        }
        return Date()
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
       if let date1 = dateFormatter.date(from: date)
       {
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return  dateFormatter.string(from: date1)
        
       }
        else
       {
         return date
        }
        
        
    }
    func shadowForCell(view:UIView)
    {
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = hexStringToUIColor(hex: "#969696").cgColor
        
//        view.layer.shouldRasterize = true
        
        view.layer.cornerRadius = cornerRadiusForView//8
    }
    func customShadowPath(view:UIView)
    {
       
        let shadowPath = UIBezierPath()
        // Start at the Top Left Corner
       
        shadowPath.move(to: CGPoint(x: 0.0, y: 0.0))
        
        
        
        // Move to the Top Right Corner
        shadowPath.addLine(to: CGPoint(x: view.frame.size.width, y: 0.0))
        
        // Move to the Bottom Right Corner
        shadowPath.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height))
        
        // This is the extra point in the middle :) Its the secret sauce.
        shadowPath.addLine(to: CGPoint(x: view.bounds.width/2.0, y: view.bounds.height/2.0))
        
        // Move to the Bottom Left Corner
        shadowPath.addLine(to: CGPoint(x: 0.0, y: view.bounds.height))
        
        // Move to the Close the Path
        shadowPath.close()
        
        view.layer.shadowPath = shadowPath.cgPath
        
        view.layer.cornerRadius=cornerRadiusForView//8
        
    }
    func setBottomShadow(view:UIView)
    {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
    
    func setLeftSideImageView(image : UIImage,textField : UITextField)
    {
        let viewPadding = UIView(frame: CGRect(x: 5, y: 0, width: 30 , height: Int(textField.frame.size.height)))
        
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 15 , height: 15))
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        imageView.center = viewPadding.center
        imageView.image  = image
        viewPadding .addSubview(imageView)
        
        textField.leftView = viewPadding
        textField.leftViewMode = .always
        
        
        
        
    }
    
    func shakeTextfield(textField:UIView)
    {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        
        textField.layer.add(animation, forKey: "position")
    }
    
    func checkjailbrokenDevice(){
        if IOSSecuritySuite.amIJailbroken() {
            //print("This device is jailbroken")
            isJailbrokenDevice = true
            self.showalertforJailbreakDevice()
            //self.showAlert(message: "This device is jailbroken")
           
            //return true
        }else{
            isJailbrokenDevice = false
            //return false
        }
    }
    
    func showalertforJailbreakDevice(){
        let alertController = UIAlertController(title: "This device is jailbroken", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
//            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
//            {
//                (result : UIAlertAction) -> Void in
//                print("Cancel")
//
//            }
        let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {(result : UIAlertAction) -> Void in
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isAlreadylogin")

            menuButton.isHidden=true
            menuButton.removeFromSuperview()


            let loginVC :LoginViewController_New = LoginViewController_New()

            UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
            UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
            UserDefaults.standard.set("", forKey: "OrderMasterNo")
            UserDefaults.standard.set("", forKey: "GroupChildSrNo")
            UserDefaults.standard.set("", forKey: "emailid")

            UserDefaults.standard.set(nil, forKey: "MEMBER_ID")

            //for Added for Terms and codition on 1st time login
//                if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
//                    self.perviousTermsCondtion = "true"
//                }
//                else{
//                    self.perviousTermsCondtion = "false"
//                }
            //To display disclaimer every time
            UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
            UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
            UserDefaults.standard.setValue(nil, forKey: "drinkCount")
            UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")

            UserDefaults.standard.set(false, forKey: "isInsurance")
            UserDefaults.standard.set(false, forKey: "isWellness")
            UserDefaults.standard.set(false, forKey: "isFitness")


            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

            center.removeAllPendingNotificationRequests()
//                if self.perviousTermsCondtion == "true"{
//                    UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
//                }

            self.navigationController?.pushViewController(loginVC, animated: true)
            //        navigationController?.popToViewController(loginVC, animated: true)
            UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                   to: UIApplication.shared, for: nil)
            
        }
        //alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUserTokenGlobal(completion: @escaping (_ data: String, _ error: String)->()){
        
        var employeeSrno = String()
        var personSrnNo = String()
        var employeIdNo = String()
        var empSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String
        var empIDno = UserDefaults.standard.value(forKey: "userEmployeIdNoValue") as? String
        var perSrno = UserDefaults.standard.value(forKey: "userPersonSrnNoValue") as? String
       
        
        if empSrno != nil{
            employeeSrno = empSrno ?? ""
            print("employeeSrno: ",employeeSrno)
            employeeSrno = try! AesEncryption.encrypt(employeeSrno)
        }
        if empIDno != nil{
            employeIdNo = empIDno ?? ""
            print("employeIdNo: ",employeIdNo)
            employeIdNo = try! AesEncryption.encrypt(employeIdNo)
        }
        
        if perSrno != nil{
            personSrnNo = perSrno ?? ""
            print("personSrnNo: ",personSrnNo)
            personSrnNo = try! AesEncryption.encrypt(personSrnNo)
        }
        
        
        let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
        let urlEncodedemployeeSrno = employeeSrno.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print("urlEncodedemployeeSrno: ",urlEncodedemployeeSrno)
        
        let urlEncodedpersonSrnNo = personSrnNo.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print("urlEncodedpersonSrnNo: ",urlEncodedpersonSrnNo)
        
        let urlEncodedemployeIdNo = employeIdNo.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print("urlEncodedemployeIdNo: ",urlEncodedemployeIdNo)
        
        
        
        let urlreq = NSURL(string: WebServiceManager.sharedInstance.getRefreshUserToken(employeeSrno: urlEncodedemployeeSrno!, personSrnNo: urlEncodedpersonSrnNo!, employeIdNo: urlEncodedemployeIdNo!))
        
        print("1000 getUserToken : \(urlreq)")
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = urlreq as URL?
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let datatask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, httpUrlResponse, error ) in
//            guard let dataResponse = data,
//                  error == nil else {
//                print(error?.localizedDescription ?? "Response Error")
//                return }
            if error == nil{
                print(String(data: data!, encoding: .utf8)!)
                let resp = httpUrlResponse as! HTTPURLResponse
                let status = resp.statusCode
                print(status)
                switch status{
                case 200:
                    do {
                        guard let data = data else { return }
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
                        print("jsonResponse: ", json)
                        
                        if let token = json["Authtoken"]
                        {
                            print("Token:  ",token)
                            if token.isEmpty{
                                print("Something went wrong!!!")
                            }
                            else{
                                authToken = token
                            }
                            completion(authToken,"")
                        }
                    } catch {
                        print("error:", error)
                        //self.hidePleaseWait()
                        //Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                    }
                    
                    break
                default:
                    completion(authToken,"error")
                    break
                }
            }else{
                completion("",error!.localizedDescription)
            }
        })
        datatask.resume()
        
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [self] (data, response, error) in
//            if let error = error {
//                print("error:", error)
//                return
//            }
//            else{
//                if let httpResponse = response as? HTTPURLResponse
//                {
//                    if httpResponse.statusCode == 200
//                    {
//                        do {
//                            guard let data = data else { return }
//                            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
//                            print("jsonResponse: ", json)
//
//                            if let token = json["Authtoken"]
//                            {
//                                print("Token:  ",token)
//                                if token.isEmpty{
//                                    print("Something went wrong!!!")
//                                }
//                                else{
//                                    authToken = token
//                                }
//                            }
//                        } catch {
//                            print("error:", error)
//                            //self.hidePleaseWait()
//                            //Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
//                        }
//                    }
//                    else if httpResponse.statusCode == 401{
//
//                        //self.hidePleaseWait()
//                        //self.displayActivityAlert(title: m_errorMsg)
//                        print("else 401 executed with \(httpResponse.statusCode)")
//                        //self.navigationController?.showAlert(message: "Some error occured.Please try again later")
//
//                        DispatchQueue.main.async{
//                            self.alertForLogout()
//                        }
//                    }
//                    else{
//                        print("else executed with \(httpResponse.statusCode)")
//                    }
//                }
//                else {
//                    print("Can't cast response to NSHTTPURLResponse")
//                    //                        self.displayActivityAlert(title: m_errorMsg)
//                    //                        self.hidePleaseWait()
//                }
//            }
//        }
////        if empSrno == nil && empIDno == nil && perSrno == nil{
////            print("Empty value: empSrno: ",empSrno,"empIDno: ",empIDno,"perSrno: ",perSrno)
////        }
////        else{
//            print("empSrno: ",empSrno,"empIDno: ",empIDno,"perSrno: ",perSrno)
//            task.resume()
        //}
    }
    
    

}





