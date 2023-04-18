//
//  LeftSideViewController.swift
//  MyBenefits
//
//  Created by Semantic on 22/01/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var m_profileImageView: UIImageView!
    var perviousTermsCondtion = ""
    @IBAction func logOutButtonClicked(_ sender: Any)
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
            if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
                self.perviousTermsCondtion = "true"
            }
            else{
                self.perviousTermsCondtion = "false"
            }
            //To display disclaimer every time
            UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
            UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
            UserDefaults.standard.setValue(nil, forKey: "drinkCount")
            UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")

            UserDefaults.standard.set(false, forKey: "isInsurance")
            UserDefaults.standard.set(false, forKey: "isWellness")
            UserDefaults.standard.set(false, forKey: "isFitness")
            UserDefaults.standard.set(nil, forKey: "userEmployeeSrnoValue")
            UserDefaults.standard.set(nil, forKey: "userEmployeIdNoValue")
            UserDefaults.standard.set(nil, forKey: "userPersonSrnNoValue")
            authToken = ""

            
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

            center.removeAllPendingNotificationRequests()
            if self.perviousTermsCondtion == "true"{
                UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            }

            self.navigationController?.pushViewController(loginVC, animated: true)
            //        navigationController?.popToViewController(loginVC, animated: true)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    @IBOutlet weak var m_tableView: UITableView!
    @IBOutlet weak var m_designationLbl: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    @IBOutlet weak var m_appVersion: UILabel!
    
    var titleArray = ["My Coverages","My Claims","Intimate Claim","Network Hospitals","My Queries","Policy Features","Claim Procedures"]
  
    let imageArray = [#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyClaims"),#imageLiteral(resourceName: "IntimateClaim-1"),#imageLiteral(resourceName: "NetworkHospital-1"),#imageLiteral(resourceName: "faq-2"),#imageLiteral(resourceName: "PolicyFeature"),#imageLiteral(resourceName: "ClaimProcedure-1")]
    var m_personArray : [PERSON_INFORMATION]?
    var m_productCode = String()
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        m_tableView.register(LeftSideTableViewCell.self, forCellReuseIdentifier: "cell")
        m_tableView.register(UINib (nibName: "LeftSideTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.singleLine
        m_tableView.separatorColor=hexStringToUIColor(hex: "EAEAEA")
        
        // Product Code "" to "GMC" 14 Oct
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_personArray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
        
        if((m_personArray?.count)!>0)
        {
            let profileDict = m_personArray![0]
            if(profileDict.gender=="MALE" || profileDict.gender=="Male" || profileDict.gender=="male")
            {
                m_profileImageView.image = UIImage(named: "avatar_male11")
                
            }
            else
            {
                m_profileImageView.image = UIImage(named: "avatar_female11")
            }
        }
        if(userArray.count>0)
        {
            let dict = userArray[0]
            if let designation = dict.designation
            {
                m_designationLbl.text=designation
            }
        }
        m_nameLbl.text=employeeName
        m_profileImageView.layer.masksToBounds=true
        m_profileImageView.layer.cornerRadius=m_profileImageView.frame.height/2
        m_profileImageView.layer.borderWidth=1
        m_profileImageView.layer.borderColor=UIColor.lightGray.cgColor
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        print("appVersion: ",appVersion)
        m_appVersion.text = appVersion
        
        
    }
    @IBAction func viewProfileButtonClicked(_ sender: Any)
    {
        let profile : ProfileViewController = ProfileViewController()
        navigationController?.pushViewController(profile, animated: true)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        menuButton.isHidden=false
//        menuButton.backgroundColor = UIColor.white
//        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
//        menuButton.setImage(UIImage(named:"Home"), for: .normal)
        navigationItem.title="My Profile"
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backButtonClicked1))
        navigationItem.leftBarButtonItem = button1
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
//        navigationController?.popViewController(animated: true)
        tabBarController!.selectedIndex = 2
    }
    @objc func backButtonClicked1()
    {
        tabBarController!.selectedIndex = 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : LeftSideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeftSideTableViewCell
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        
        
        cell.m_titleLbl.text=titleArray[indexPath.row]
        cell.m_imageView.image=imageArray[indexPath.row]
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
       
        switch indexPath.row
        {
        case 0:
            let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
            navigationController?.pushViewController(myCoverages, animated: true)
//            let backItem = UIBarButtonItem()
//            backItem.title = ""
//            navigationItem.backBarButtonItem = backItem
          
            
            return
        case 1:
            let myClaims:MyClaimsViewController = MyClaimsViewController()
            navigationController?.pushViewController(myClaims, animated: true)
            
            return
        case 2:
            /*let intimation : MyIntimationViewController = MyIntimationViewController()
            navigationController?.pushViewController(intimation, animated: true)*/
            
           // showAlert(message: "Claim intimation clause not applicable for your policy")
            
            if let groupCode = UserDefaults.standard.value(forKey: "groupCodeString") as? String,groupCode != "" {
                if groupCode.uppercased() == "TCL" {
                    showAlert(message: "Claim intimation clause not applicable for your policy")
                }
                else {
                    let intimation : MyIntimationViewController = MyIntimationViewController()
                    navigationController?.pushViewController(intimation, animated: true)
                }
            }
            
            return
        case 3:
            let networkHospitals : NetworkHospitalsViewController = NetworkHospitalsViewController()
            navigationController?.pushViewController(networkHospitals, animated: true)
            
            
            return
       
        case 4:
            /*let myQueries : MyQueriesViewController = MyQueriesViewController()
            navigationController?.pushViewController(myQueries, animated: true)*/
            //showAlert(message: "Employee Queries not activated for your policy ")
            
            if let groupCode = UserDefaults.standard.value(forKey: "groupCodeString") as? String,groupCode != "" {
                if groupCode.uppercased() == "TCL" {
                    showAlert(message: "Employee Queries not activated for your policy ")
                }
                else {
                    let myQueries : MyQueriesViewController = MyQueriesViewController()
                    navigationController?.pushViewController(myQueries, animated: true)
                }
            }
            
            return
        case 5:
            let policyFeatures : PolicyFeaturesViewController = PolicyFeaturesViewController()
           navigationController?.pushViewController(policyFeatures, animated: true)
            
            return
            
        case 6:
            let claimProcedure : ClaimProcedureViewController = ClaimProcedureViewController()
            navigationController?.pushViewController(claimProcedure, animated: true)
            return
      
        case 7:
            
            break
            
        case 8:
            let FAQVC : FAQViewController = FAQViewController()
            navigationController?.pushViewController(FAQVC, animated: true)
            return
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 60
    }
    
   
    func setTabbar()
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
        let tabViewController5 = ProfileViewController(
            nibName:"ProfileViewController",
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
            title: "Profile",
            image:UIImage(named: "profile") ,
            tag:2)
        
        let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
        let leftSideMenuNav = UINavigationController(rootViewController: tabBarController)
        
        
//        leftSideMenuNav.pushViewController(myCoverages, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
