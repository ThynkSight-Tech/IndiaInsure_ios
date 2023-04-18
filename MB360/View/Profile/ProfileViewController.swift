//
//  ProfileViewController.swift
//  MyBenefits
//
//  Created by Semantic on 20/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//URLSession.sharedSession.dataTaskWithURL( NSURL(string:link)!, completionHandler: {


import UIKit
import FirebaseCrashlytics
//import AktivoCoreSDK

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode)
    {
        
        URLSession.shared.dataTask(with: URL(string: link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            })
            
            
        }).resume()
    }
}
class ProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,XMLParserDelegate,UITextFieldDelegate ,UITabBarControllerDelegate,UITabBarDelegate{
    @IBOutlet weak var m_topBarVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_userNameLbl: UILabel!
    
    @IBOutlet weak var m_noInternetView: UIView!
    
    @IBOutlet weak var m_tableView: UITableView!
    @IBOutlet weak var m_postLbl: UILabel!
    @IBOutlet weak var m_userImageView: UIImageView!
    
    var m_isExpanded = Bool()
    var xmlKey = String()
    var highlightclr = ""
    var resultsDictArray: [[String: Any]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    let dictionaryKeys = ["EMPLOYEE_NAME", "EMPLOYEE_DESIGNATION", "EMPLOYEE_DEPARTMENT", "RELATION_WITH_EMPLOYEE","BASE_SUM_INSURED","TOPUP_SUM_INSURED","EMPLOYEE_ID","EMPLOYEE_OFFICIAL_EMAIL_ID","EMPLOYEE_MOBILENO","EMPLOYEE_DATE_OF_BIRTH","EMPLOYEE_GENDER","EMP_PER_ADDR_LINE1","EMP_PER_ADDR_LINE2","EMP_PER_ADDR_LANDMARK","EMP_CITY","EMP_STATE","EMP_PINCODE","EMP_EMERGENCY_CONTACTNO","EMP_PERSONAL_EMAIL_IDS","EMP_EMERGENCY_CONTACT_RELTN"]
    
    var datasource = [ExpandedCellContent]()
    var selectedRowIndex = -1
    var m_employeedict : EMPLOYEE_INFORMATION?
    var m_profilearray : Array<PERSON_INFORMATION> = []
    var m_profileDict : PERSON_INFORMATION?
    
    var profileData : [ProfileDetails] = []
    
    var newProfileArray = [String: Any]()
    var UserPersonalDetailsArray = [String: Any]()
    var UserAddressDetailsArray = [String: Any]()
    var UserOfficialDetailsArray = [String: Any]()
    var UserDocumentsDetails = [Any]()
    var UserProfileImageUrl = ""
    var UserSocialDetailsArray = [String : Any]()
    var UserNomineeDetailsArray = [String : Any]()
    var message = [String: Any]()
    
    let reuseIdentifier = "cell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        m_tableView.register(ProfileDetailsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        m_tableView.register(UINib (nibName: "ProfileDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        
        m_userImageView.layer.masksToBounds=true
        m_userImageView.layer.cornerRadius=m_userImageView.frame.size.height/2
        m_userImageView.layer.borderWidth=1
        m_userImageView.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
        tabBarController?.delegate=self
        
        
        //    self.datasource.append(ExpandedCellContent(otherInfo:self.m_profilearray[0]))
        
        
        
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(tabBarController.selectedIndex==1)
        {
            
        }
    }
    func scrollToTop()
    {
        let indexpath = IndexPath(row: 0, section: 0)
        m_tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        navigationItem.rightBarButtonItem=getRightBarButton()
        navigationController?.navigationBar.isHidden=false
        navigationItem.title="My Profile"
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        
        if highlightclr == "HC" {
            // self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
            self.navigationController?.navigationBar.applyGradient()
            self.navigationController?.navigationBar.navBarDropShadow()
            self.navigationController?.navigationBar.changeFont()
        }else {
            navigationItem.leftBarButtonItem=getBackButton()
            self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        }
        
        navigationController?.navigationBar.dropShadow()
        
        //getProfileDetails()
        getProfileDetailsUrl()
        scrollToTop()
        
        
        
        
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        //        menuButton.backgroundColor = UIColor.white
        //        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        //        menuButton.setImage(UIImage(named:"Home"), for: .normal)
    }
    func getLeftBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func leftButtonClicked()
    {
        
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        //        navigationController?.popViewController(animated: true)
        tabBarController!.selectedIndex = 2
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc override func backButtonClicked()
    {
        print ("backButtonClicked")
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    var m_productCode = String()
    /*  func getProfileDetails()
     {
     if(isConnectedToNet())
     {
     
     
     m_profilearray =  DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:"GMC", relationName: "EMPLOYEE")
     m_profileDict=m_profilearray[0]
     print(m_profileDict)
     m_userNameLbl.text=m_profileDict?.personName
     self.datasource.append(ExpandedCellContent(otherInfo:self.m_profilearray[0]))
     m_employeedict=DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")[0]
     if(m_profilearray.count>0)
     {
     m_tableView.reloadData()
     let deadlineTime = DispatchTime.now() + .seconds(2)
     DispatchQueue.main.asyncAfter(deadline: deadlineTime)
     {
     self.m_noInternetView.isHidden=true
     
     }
     }
     }
     else
     {
     
     m_noInternetView.isHidden=false
     
     
     }
     }
     */
    func getProfileDetailsUrl()
    {
        //        print("m_employeedict: ",m_employeedict)
        //        if (m_employeedict==nil)
        //        {
        //
        //            //            m_employeedict=nil
        //            displayActivityAlert(title: "noDataFound".localized())
        //
        //        }
        //        else
        //        {
        //
        if(isConnectedToNetWithAlert())
        {
            
            
            showPleaseWait(msg: """
Please wait...
Fetching details
""")
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
            m_employeedict = userArray[0]
            var groupchildsrno = String()
            var oegrpbasinfsrno = String()
            var employeesrno = String()
            
            if let childNo = m_employeedict?.groupChildSrNo
            {
                groupchildsrno = String(childNo)
                groupchildsrno = try! AesEncryption.encrypt(groupchildsrno)
            }
            if let oeinfNo = m_employeedict?.oe_group_base_Info_Sr_No
            {
                oegrpbasinfsrno = String(oeinfNo)
                oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
            }
            if let empNo = m_employeedict?.empSrNo
            {
                employeesrno = String(empNo)
                employeesrno = try! AesEncryption.encrypt(employeesrno)
            }
            
            
            let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getProfileDetailsurl(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded, employeesrno: employeesrno.URLEncoded))
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            
            var encryptedUserName = try! AesEncryption.encrypt(m_authUserName_Portal)
            var encryptedPassword = try! AesEncryption.encrypt(m_authPassword_Portal)
            
            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
            print("m_authUserName_Portal ",encryptedUserName)
            print("m_authPassword_Portal ",encryptedPassword)
            
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
            request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            
            print("Profile url:",urlreq)
            let task = URLSession.shared.dataTask(with: request as URLRequest)
            {
                (data, response, error)  -> Void in
                
                
                if error != nil {
                    print("error ",error!)
                    self.hidePleaseWait()
                    self.displayActivityAlert(title: "The request timed out")
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print(httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            do {
                                guard let data = data, error == nil else {
                                    print(error?.localizedDescription ?? "No data")
                                    return
                                }
                                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                
                                self.newProfileArray = json!
                                print("json: ",json)
                                
                                self.resultsDictArray = [json] as? [[String : Any]]
                                
                                print("resultsDictArray: ",self.resultsDictArray)
                                
                                
                                
                                DispatchQueue.main.async
                                {
                                    let status = DatabaseManager.sharedInstance.deleteProfileDetails()
                                    if(status)
                                    {
                                        for profileDict in self.resultsDictArray!
                                        {
                                            DatabaseManager.sharedInstance.saveProfileDetailsPortal(profileDict: profileDict as NSDictionary)
                                        }
                                    }
                                    
                                    var dataBaseProfileData = DatabaseManager.sharedInstance.retrieveProfileDetails()
                                    
                                    self.UserPersonalDetailsArray = self.newProfileArray["UserPersonalDetails"] as! [String : Any]
                                    print("UserPersonalDetailsArray: ",self.UserPersonalDetailsArray)
                                    
                                    self.UserAddressDetailsArray = self.newProfileArray["UserAddressDetails"] as! [String : Any]
                                    print("UserAddressDetailsArray: ",self.UserAddressDetailsArray)
                                    
                                    self.UserOfficialDetailsArray = self.newProfileArray["UserOfficialDetails"] as! [String : Any]
                                    print("UserOfficialDetailsArray: ",self.UserOfficialDetailsArray)
                                    
                                    self.UserProfileImageUrl = self.newProfileArray["UserProfileImageUrl"] as! String
                                    print("UserProfileImageUrl: ",self.UserProfileImageUrl)
                                    
                                    self.UserSocialDetailsArray = self.newProfileArray["UserSocialDetails"] as! [String : Any]
                                    print("UserSocialDetailsArray: ",self.UserSocialDetailsArray)
                                    
                                    self.UserNomineeDetailsArray = self.newProfileArray["UserNomineeDetails"] as? [String : Any] ?? ["" : ""]
                                    print("UserNomineeDetailsArray: ",self.UserNomineeDetailsArray)
                                    
                                    self.message = self.newProfileArray["message"] as! [String : Any]
                                    print("message: ",self.message)
                                    
                                    
                                    self.UserDocumentsDetails = self.newProfileArray["UserDocumentsDetails"] as! [Any]
                                    print("UserDocumentsDetails: ",self.UserDocumentsDetails)
                                    
                                    
                                    self.datasource.append(ExpandedCellContent(otherInfo:dataBaseProfileData))
                                    
                                    
                                    print("datasource: ",self.datasource)
                                    self.m_tableView.reloadData()
                                    self.hidePleaseWait()
                                    
                                    
                                }
                            }
                            catch let JSONError as NSError
                            {
                                //Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                                print(JSONError)
                            }
                        }else if httpResponse.statusCode == 401{
//                            self.hidePleaseWait()
//                            self.alertForLogout()
                            self.getUserTokenGlobal(completion: { (data,error) in
                                self.getProfileDetailsUrl()
                            })
                        }
                        else
                        {
                            self.hidePleaseWait()
                            //                            self.displayActivityAlert(title: m_errorMsg)
                            
                            let array : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:"EMPLOYEE")
                            if(array.count>0)
                            {
                                let personInfo = array[0]
                                if let name = personInfo.personName
                                {
                                    DispatchQueue.main.async{
                                        self.m_userNameLbl.text="Hello, "+name
                                        employeeName = name
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    else
                    {
                        self.displayActivityAlert(title: m_errorMsg)
                        print("Can't cast response to NSHTTPURLResponse")
                    }
                    
                }
                
            }
            task.resume()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("indexPath4: ",indexPath)
        
        let cell : ProfileDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileDetailsTableViewCell
        /*
         if(m_profilearray.count>0)
         {
         m_profileDict = m_profilearray[0]
         if(m_employeedict?.designation?.contains("NOT AVAILABLE"))!
         {
         m_postLbl.text = "NOT AVAILABLE"
         }
         else
         {
         m_postLbl.text = m_employeedict?.designation
         }
         print(m_profileDict)
         if(m_profileDict?.gender=="MALE" || m_profileDict?.gender=="Male")
         {
         m_userImageView.image = UIImage(named: "avatar_male11")
         
         }
         else
         {
         m_userImageView.image = UIImage(named: "avatar_female11")
         }
         
         switch indexPath.row
         {
         case 0:
         cell.m_detilsBackgroundView.isHidden=true
         cell.m_detailsButton.isHidden=true
         cell.m_iconImageview.image=#imageLiteral(resourceName: "email")
         
         var emailId = m_employeedict?.officialEmailID
         emailId = emailId?.replacingOccurrences(of: "\r\n", with: "")
         
         
         if(emailId=="")
         {
         cell.m_titleLbl.text=""
         }
         else
         {
         cell.m_titleLbl.text=emailId
         
         }
         break
         case 1:
         cell.m_detilsBackgroundView.isHidden=true
         cell.m_detailsButton.isHidden=true
         cell.m_iconImageview.image=#imageLiteral(resourceName: "bday")
         cell.m_titleLbl.text=m_profileDict?.dateofBirth
         break
         case 2:
         if(datasource.count>0)
         {
         if(datasource[0].expanded)
         {
         cell.m_detilsBackgroundView.isHidden=false
         }
         else
         {
         cell.m_detilsBackgroundView.isHidden=true
         }
         cell.m_iconImageview.image=#imageLiteral(resourceName: "user2")
         cell.m_titleLbl.text="Personal Information"
         
         
         cell.m_detailsButton.isHidden=false
         cell.m_detailsButton.addTarget(self, action: #selector(detailsButtonClicked), for: .touchUpInside)
         
         cell.m_saveChangesButton.dropShadow()
         cell.m_saveChangesButton.addTarget(self, action: #selector(saveChangesButtonClicked), for: .touchUpInside)
         cell.m_cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
         cell.logOutButton.dropShadow()
         cell.logOutButton.addTarget(self, action: #selector(logOutButtonClicked), for: .touchUpInside)
         }
         break
         default:
         break
         }
         
         cell.selectionStyle=UITableViewCellSelectionStyle.none
         
         cell.m_emailIDTxtField.layer.masksToBounds=true
         cell.m_emailIDTxtField.layer.cornerRadius=20
         cell.m_emailIDTxtField.layer.borderWidth=1
         cell.m_emailIDTxtField.delegate=self
         cell.m_emailIDTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
         
         
         cell.m_mobileNumberTxtField.delegate=self
         cell.m_mobileNumberTxtField.layer.masksToBounds=true
         cell.m_mobileNumberTxtField.layer.cornerRadius=20
         cell.m_mobileNumberTxtField.layer.borderWidth=1
         cell.m_mobileNumberTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
         
         
         cell.m_genderTxtField.delegate=self
         cell.m_genderTxtField.layer.masksToBounds=true
         cell.m_genderTxtField.layer.cornerRadius=20
         cell.m_genderTxtField.layer.borderWidth=1; cell.m_genderTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
         
         
         cell.m_addressTxtField.delegate=self
         cell.m_addressTxtField.layer.masksToBounds=true
         cell.m_addressTxtField.layer.cornerRadius=20
         cell.m_addressTxtField.layer.borderWidth=1; cell.m_addressTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
         
         cell.contactNumberTxtField.delegate=self
         cell.contactNumberTxtField.layer.masksToBounds=true
         cell.contactNumberTxtField.layer.cornerRadius=20
         cell.contactNumberTxtField.layer.borderWidth=1; cell.contactNumberTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
         
         
         cell.m_cancelButton.layer.masksToBounds=true
         cell.m_cancelButton.layer.cornerRadius=20
         cell.m_cancelButton.dropShadow()
         cell.m_saveChangesButton.dropShadow()
         cell.m_saveChangesButton.layer.masksToBounds=true
         cell.logOutButton.layer.masksToBounds=true
         cell.logOutButton.layer.cornerRadius=20
         cell.logOutButton.setBorderToView(color: hexStringToUIColor(hex: "696969"))
         cell.m_saveChangesButton.layer.cornerRadius=cell.m_saveChangesButton.frame.size.height/2
         
         shadowForCell(view: cell.m_backgroundView)
         
         let viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: 7 , height: Int(cell.m_emailIDTxtField.frame.size.height)))
         cell.m_emailIDTxtField.leftView = viewPadding
         cell.m_emailIDTxtField.leftViewMode = .always
         if(m_profileDict?.emailID=="")
         {
         //                cell.m_emailIDTxtField.text="-"
         }
         else
         {
         cell.m_emailIDTxtField.text=m_profileDict?.emailID
         
         }
         let viewPadding1 = UIView(frame: CGRect(x: 0, y: 0, width: 7 , height: Int(cell.m_mobileNumberTxtField.frame.size.height)))
         cell.m_mobileNumberTxtField.leftView = viewPadding1
         cell.m_mobileNumberTxtField.leftViewMode = .always
         if(m_profileDict?.cellPhoneNUmber=="")
         {
         cell.m_mobileNumberTxtField.text="-"
         }
         else
         {
         cell.m_mobileNumberTxtField.text=m_profileDict?.cellPhoneNUmber
         
         
         }
         /*if(m_profileDict?.emergencyContactRelation?.contains("NOT AVAILABLE"))!
          {
          
          }
          else
          {
          cell.m_genderTxtField.text=m_profileDict?.emergencyContactRelation
          let viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: 7 , height: Int(cell.m_genderTxtField.frame.size.height)))
          cell.m_genderTxtField.leftView = viewPadding
          cell.m_genderTxtField.leftViewMode = .always
          
          }*/
         /* if(m_profileDict?.ad?.contains("NOT AVAILABLE"))!
          {
          
          }
          else
          {
          
          cell.m_addressTxtField.text=(m_profileDict?.address1)!+(m_profileDict?.address2)!+(m_profileDict?.city)!
          let viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: 7 , height: Int(cell.m_addressTxtField.frame.size.height)))
          cell.m_addressTxtField.leftView = viewPadding
          cell.m_addressTxtField.leftViewMode = .always
          
          }*/
         
         
         }
         else
         {
         
         }
         */
        if(newProfileArray.count>0)
        {
            
            if let EMPLOYEE_NAME = self.UserPersonalDetailsArray["EMPLOYEE_NAME"] as? String {
                print("EMPLOYEE_NAME1: ",EMPLOYEE_NAME)
                if EMPLOYEE_NAME == ""{
                    self.m_userNameLbl.text = "NOT AVAILABLE"
                }
                else
                {
                    self.m_userNameLbl.text = EMPLOYEE_NAME
                }
            }
            
            if let DESIGNATION = self.UserOfficialDetailsArray["DESIGNATION"] as? String {
                print("DESIGNATION1: ",DESIGNATION)
                if DESIGNATION == "" || DESIGNATION == "-"{
                    m_postLbl.text = "NOT AVAILABLE"
                }
                else
                {
                    m_postLbl.text = DESIGNATION
                }
            }
            
            if let GENDER = self.UserPersonalDetailsArray["GENDER"] as? String {
                print("GENDER: ",GENDER)
                if GENDER.uppercased() == "MALE"{
                    m_userImageView.image = UIImage(named: "avatar_male11")
                }
                else
                {
                    m_userImageView.image = UIImage(named: "avatar_female11")
                }
            }
            
            switch indexPath.row
            {
            case 0:
                cell.m_detilsBackgroundView.isHidden=true
                cell.m_detailsButton.isHidden=true
                cell.m_iconImageview.image = #imageLiteral(resourceName: "email")
                
                var emailId = self.UserPersonalDetailsArray["E_MAIL_ID"] as? String
                
                emailId = emailId?.replacingOccurrences(of: "\r\n", with: "")
                
                
                if(emailId=="")
                {
                    cell.m_titleLbl.text=""
                }
                else
                {
                    cell.m_titleLbl.text=emailId
                    
                }
                break
            case 1:
                cell.m_detilsBackgroundView.isHidden=true
                cell.m_detailsButton.isHidden=true
                cell.m_iconImageview.image = #imageLiteral(resourceName: "bday")
                cell.m_titleLbl.text = self.UserPersonalDetailsArray["DATE_OF_BIRTH"] as? String
                break
                
            case 2:
                if(datasource.count>0)
                {
                    if(datasource[0].expanded)
                    {
                        cell.m_detilsBackgroundView.isHidden=false
                    }
                    else
                    {
                        cell.m_detilsBackgroundView.isHidden=true
                    }
                    cell.m_iconImageview.image=#imageLiteral(resourceName: "user2")
                    cell.m_titleLbl.text="Personal Information"
                    
                    
                    cell.m_detailsButton.isHidden=false
                    cell.m_detailsButton.addTarget(self, action: #selector(detailsButtonClicked), for: .touchUpInside)
                    
                    cell.m_saveChangesButton.dropShadow()
                    cell.m_saveChangesButton.addTarget(self, action: #selector(saveChangesButtonClicked), for: .touchUpInside)
                    cell.m_cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
                    cell.logOutButton.dropShadow()
                    cell.logOutButton.addTarget(self, action: #selector(logOutButtonClicked), for: .touchUpInside)
                }
                break
                
            case 3:
                if(datasource.count>0)
                {
                    if(datasource[0].expanded)
                    {
                        cell.m_detilsBackgroundView.isHidden=false
                    }
                    else
                    {
                        cell.m_detilsBackgroundView.isHidden=true
                    }
                    cell.m_iconImageview.image=#imageLiteral(resourceName: "user2")
                    cell.m_titleLbl.text="Personal Information"
                    
                    
                    cell.m_detailsButton.isHidden=false
                    //cell.m_detailsButton.addTarget(self, action: #selector(detailsButtonClicked2), for: .touchUpInside)
                    
                    cell.m_saveChangesButton.dropShadow()
                    cell.m_saveChangesButton.addTarget(self, action: #selector(saveChangesButtonClicked), for: .touchUpInside)
                    cell.m_cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
                    cell.logOutButton.dropShadow()
                    cell.logOutButton.addTarget(self, action: #selector(logOutButtonClicked), for: .touchUpInside)
                }
                break
            default:
                break
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            
            cell.m_emailIDTxtField.layer.masksToBounds=true
            cell.m_emailIDTxtField.layer.cornerRadius=20
            cell.m_emailIDTxtField.layer.borderWidth=1
            cell.m_emailIDTxtField.delegate=self
            cell.m_emailIDTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
            
          
            
            cell.m_mobileNumberTxtField.delegate=self
            cell.m_mobileNumberTxtField.layer.masksToBounds=true
            cell.m_mobileNumberTxtField.layer.cornerRadius=20
            cell.m_mobileNumberTxtField.layer.borderWidth=1
            cell.m_mobileNumberTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
           
            
            cell.m_genderTxtField.delegate=self
            cell.m_genderTxtField.layer.masksToBounds=true
            cell.m_genderTxtField.layer.cornerRadius=20
            cell.m_genderTxtField.layer.borderWidth=1; cell.m_genderTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
            let viewPaddingGender = UIView(frame: CGRect(x: 0, y: 0, width: 7 , height: Int(cell.m_genderTxtField.frame.size.height)))
            cell.m_genderTxtField.leftView = viewPaddingGender
            cell.m_genderTxtField.leftViewMode = .always
            
            if let GENDER = self.UserPersonalDetailsArray["GENDER"] as? String{
                if GENDER.isEmpty{
                    cell.m_genderTxtField.text = "NOT AVAILABLE"
                }
                else{
                    cell.m_genderTxtField.text = " "+GENDER
                }
            }
            
            cell.m_addressTxtField.delegate=self
            cell.m_addressTxtField.layer.masksToBounds=true
            cell.m_addressTxtField.layer.cornerRadius=20
            cell.m_addressTxtField.layer.borderWidth=1; cell.m_addressTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
            
            let viewPaddingAddress = UIView(frame: CGRect(x: 0, y: 0, width: 7 , height: Int(cell.m_addressTxtField.frame.size.height)))
            cell.m_addressTxtField.leftView = viewPaddingAddress
            cell.m_addressTxtField.leftViewMode = .always
            
            cell.m_addressTxtField.text = "m_addressTxtField"
            var fulladdress = ""
            if let address1 = self.UserAddressDetailsArray["EMP_PER_ADDR_LINE1"] as? String{
                fulladdress = fulladdress+address1
            }
            if let address2 = self.UserAddressDetailsArray["EMP_PER_ADDR_LINE2"] as? String{
                fulladdress = fulladdress+", "+address2
            }
            if let address3 = self.UserAddressDetailsArray["EMP_PER_ADDR_LANDMARK"] as? String{
                fulladdress = fulladdress+", "+address3
            }
            if let address4 = self.UserAddressDetailsArray["EMP_CITY"] as? String{
                fulladdress = fulladdress+", "+address4
            }
            if let address5 = self.UserAddressDetailsArray["EMP_PINCODE"] as? String{
                fulladdress = fulladdress+", "+address5
            }
            if let address6 = self.UserAddressDetailsArray["EMP_STATE"] as? String{
                fulladdress = fulladdress+", "+address6
            }
            cell.m_addressTxtField.text = fulladdress
            
            
            cell.contactNumberTxtField.delegate=self
            cell.contactNumberTxtField.layer.masksToBounds=true
            cell.contactNumberTxtField.layer.cornerRadius=20
            cell.contactNumberTxtField.layer.borderWidth=1; cell.contactNumberTxtField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
            let viewPaddingEmergency = UIView(frame: CGRect(x: 0, y: 0, width: 7 , height: Int(cell.contactNumberTxtField.frame.size.height)))
            cell.contactNumberTxtField.leftView = viewPaddingEmergency
            cell.contactNumberTxtField.leftViewMode = .always
            
            //cell.contactNumberTxtField.text = "contactNumberTxtField"
            
            cell.m_cancelButton.layer.masksToBounds=true
            cell.m_cancelButton.layer.cornerRadius=20
            cell.m_cancelButton.dropShadow()
            cell.m_saveChangesButton.dropShadow()
            cell.m_saveChangesButton.layer.masksToBounds=true
            cell.logOutButton.layer.masksToBounds=true
            cell.logOutButton.layer.cornerRadius=20
            cell.logOutButton.setBorderToView(color: hexStringToUIColor(hex: "696969"))
            cell.m_saveChangesButton.layer.cornerRadius=cell.m_saveChangesButton.frame.size.height/2
            
            shadowForCell(view: cell.m_backgroundView)
            
            let viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: 7 , height: Int(cell.m_emailIDTxtField.frame.size.height)))
            cell.m_emailIDTxtField.leftView = viewPadding
            cell.m_emailIDTxtField.leftViewMode = .always
           
            if let E_MAIL_ID = self.UserPersonalDetailsArray["E_MAIL_ID"] as? String{
                print("E_MAIL_ID: to display",E_MAIL_ID)
                if E_MAIL_ID.isEmpty{
                    cell.m_emailIDTxtField.text = "NOT AVAILABLE"
                }
                else{
                    cell.m_emailIDTxtField.text = E_MAIL_ID
                }
            }
            
            let viewPadding1 = UIView(frame: CGRect(x: 0, y: 0, width: 7 , height: Int(cell.m_mobileNumberTxtField.frame.size.height)))
            cell.m_mobileNumberTxtField.leftView = viewPadding1
            cell.m_mobileNumberTxtField.leftViewMode = .always
            
            if let CELLPHONE_NUMBER = self.UserPersonalDetailsArray["CELLPHONE_NUMBER"] as? String{
                print("CELLPHONE_NUMBER: to display ",CELLPHONE_NUMBER)
                if CELLPHONE_NUMBER.isEmpty{
                    cell.m_mobileNumberTxtField.text = "NOT AVAILABLE"
                }
                else{
                    cell.m_mobileNumberTxtField.text = " "+CELLPHONE_NUMBER
                }
            }
            
        }
        else
        {
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row==2)
        {
            if (datasource.count>0)
            {
                let content = datasource[0]
                content.expanded = !content.expanded
                let cell : ProfileDetailsTableViewCell = m_tableView.cellForRow(at: indexPath) as! ProfileDetailsTableViewCell
                if(datasource.count>0)
                {
                    cell.setContent(data: datasource[0])
                }
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        else
        {
            
            
        }
        //            let cell : ProfileDetailsTableViewCell = tableView.cellForRow(at: indexPath) as! ProfileDetailsTableViewCell
        //            cell.m_detilsBackgroundView.isHidden=false
        //        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        
        
        //        if(m_isExpanded)
        //        {
        //        }
        //        else
        //        {
        //            tableView.reloadData()
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row==2)
        {
            if(datasource.count>0)
            {
                
                if(datasource[0].expanded)
                {
                    return 420
                }
            }
        }
        return 95
    }
    
    
    
    @objc func detailsButtonClicked(sender:UIButton)
    {
        
        
        
        let indexPath = IndexPath(row: 2, section: 0)
        //
        //        let content = datasource[0]
        //        content.expanded = !content.expanded
        //        let cell : ProfileDetailsTableViewCell = m_tableView.cellForRow(at: indexPath) as! ProfileDetailsTableViewCell
        //        cell.setContent(data: datasource[0])
        
        tableView(m_tableView, didSelectRowAt: indexPath)
        
        //        tableView(m_tableView, didSelectRowAt: indexPath)
        //        m_tableView.reloadData()
        //        tableView(m_tableView, heightForRowAt: indexPath)
        //        m_tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
  
    
    @objc func saveChangesButtonClicked()
    {
        
    }
    
    @objc func cancelButtonClicked()
    {
        let indexPath = IndexPath(row:2, section: 0)
        tableView(m_tableView, didSelectRowAt: indexPath)
    }
    @objc func logOutButtonClicked()
    {
        let alertController = UIAlertController(title: "Do you want to logout?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
            
        }
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        {(result : UIAlertAction) -> Void in
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isAlreadylogin")
            
            DispatchQueue.main.async()
            {
                menuButton.isHidden=true
            }
            
            //            Aktivo.invalidateUser(completion: { (error) in
            //                print("Invalidate User...")
            //            })
            
            let loginVC :LoginViewController = LoginViewController()
            
            
            
            self.navigationController?.pushViewController(loginVC, animated: true)
            //        navigationController?.popToViewController(loginVC, animated: true)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if(textField.tag==5)
        {
            view.endEditing(true)
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.becomeFirstResponder()
        
        let viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5 , height: Int(textField.frame.size.height)))
        textField.leftView = viewPadding
        textField.leftViewMode = .always
        
        animateTextField(textField, with: true)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.resignFirstResponder()
        if(textField.tag == 5)
        {
            
            
            view.endEditing(true)
            
        }
        animateTextField(textField, with: false)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField.tag==1 || textField.tag==3)
        {
            let MAX_LENGTH_PHONENUMBER = 10
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        else if(textField.tag==4)
        {
            let MAX_LENGTH_PHONENUMBER = 10
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS)
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    func animateTextField(_ textField:UITextField, with up: Bool)
    {
        var movementDistance=0
        let movementDuration=0.3
        if(textField.tag==0)
        {
            movementDistance=20;
        }
        else if(textField.tag==1)
        {
            movementDistance=20;
        }
        else if(textField.tag==2)
        {
            movementDistance=60;
        }
        else if(textField.tag==3)
        {
            movementDistance=100;
        }
        else if(textField.tag==4)
        {
            movementDistance=120;
        }
        else
        {
            movementDistance=150;
        }
        let movement = (up ? -movementDistance : movementDistance);
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
    }
    
    
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        
        if elementName == xmlKey
        {
            currentDictionary = [String : String]()
        }
        //        else if dictionaryKeys.contains(elementName)
        //        {
        //            self.currentValue = String()
        //        }
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
        }
        else if dictionaryKeys.contains(elementName)
        {
            self.currentDictionary![elementName] = currentValue
            self.currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
        
    }
    
}
