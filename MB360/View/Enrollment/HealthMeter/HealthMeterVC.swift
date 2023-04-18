//
//  HealthMeterVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 19/12/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import WebKit

class HealthMeterVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    
    let contentRules = """
[
  {
    "trigger": {
      "url-filter": ".*"
    },
    "action": {
      "type": "css-display-none",
      "selector": ".wrapper.welcome-screen .header"
    }
  }

]
"""
    @IBOutlet weak var btnSkip: UIButton!
   // @IBOutlet weak var webBackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSkip.makeCicular()
        btnSkip.layer.masksToBounds = true
        
        self.navigationItem.title="Health Risk Analysis"
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBtn()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()

        print("VDL")
        
        self.showPleaseWait(msg: "")
        
        let webconfig = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), configuration: webconfig)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if(userArray.count>0)
        {
            m_employeeDict=userArray[0]
            var employeesrno = ""
            var groupChildSrNo = ""
            var oegrpbasinfsrno = ""
            
            if let empNo = m_employeeDict?.empSrNo
            {
                employeesrno = String(empNo)
            }
            if let groupChlNo = m_employeeDict?.groupChildSrNo
            {
                groupChildSrNo=String(groupChlNo)
            }
            if let oergNo = m_employeeDict?.oe_group_base_Info_Sr_No
            {
                oegrpbasinfsrno=String(oergNo)
            }
            
            //http://www.mybenefits360.in/mb360api/api/HealthCheckup/GetHCPackageDepInfo?EmpSrNo=3706&GroupChildSrNo=1206&OeGrpBasInfSrNo=644&ExtGrpsrNo=3
            
            
            //https://www.myhealthmeter.com/https/ehra/webservice.php?function=register&full_name=Akshay Pawar&member_age=25&member_gender=male&employee_id=1234&company_id=1
            
            
            let array : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
            
            var name = ""
            var age = "25"
            var gender = "male"
            if(array.count>0)
            {
                let personInfo = array[0]
                
                
                if let name1 = personInfo.personName
                {
                   name = name1
                    
                }
                
                let age1 = personInfo.age
                    age = String(age1)
                
                
                if let gender1 = personInfo.gender {
                    gender = gender1
                }
                
            }
            
            let url1 = String(format: "https://www.myhealthmeter.com/https/ehra/webservice.php?function=register&full_name=%@&member_age=%@&member_gender=%@&employee_id=%@&company_id=%@",name,age,gender,employeesrno,"1")
            getFamilyDetailsFromServer(url: url1)
        }
        
        
        
    }
    var m_employeeDict : EMPLOYEE_INFORMATION?

    @IBAction func skipTapped(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }
   
    func webViewDidFinishLoad(webView : UIWebView) {
        print("finish")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!)
    {
        self.hidePleaseWait()
        print("---Hitted URL--->") // here you are getting URL
        //self.webBackView = self.webView

        self.view = self.webView
//        btnSkip.frame = CGRect(x: 15, y: self.view.frame.height - 60, width: self.view.frame.width - 15, height: 40)
//        self.view.addSubview(btnSkip)
//        self.view.layoutIfNeeded()
//        self.view.layoutSubviews()
        
        let button:UIButton = UIButton(frame:CGRect( x: 15, y: self.view.frame.height - 60, width: self.view.frame.width - 30, height: 40))
        button.backgroundColor = .black
        button.setTitle("SKIP", for: .normal)
        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.clear

        button.setBackgroundImage(UIImage(named: "base nav"), for: .normal)
        button.makeCicular()
        button.layer.masksToBounds = true
        self.view.addSubview(button)

    }
    
    @objc func buttonClicked() {
               print("Button Clicked")
        setupFitnessTabbar()
    }
    
    /*
    override func loadView() {
        super.loadView()
        
        self.navigationItem.title="Health Meter"
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBtn()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        navigationController?.navigationBar.isHidden=false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        let webconfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webconfig)
        webView.uiDelegate = self
        let link = URL(string:"https://goo.gl/oYFfvT")!

        
        let request = URLRequest(url: URL(string: "https://goo.gl/oYFfvT")!)
        if #available(iOS 11.0, *) {
            WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "ContentBlockingRules", encodedContentRuleList: contentRules) { rulesList, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let rulesList = rulesList else { return }
                let config = self.webView.configuration
                config.userContentController.add(rulesList)
                self.webView.load(request)
                
                self.view = self.webView
                
            }
        } else {
            // Fallback on earlier versions
            let link = URL(string:"https://goo.gl/oYFfvT")!
            webView.load(URLRequest(url: link))
            self.view = self.webView
        }
        
    }
    */
    func getBtn() -> UIBarButtonItem {
    let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backClicked))
    
    return button1
}
    
@objc func backClicked()
{
    print ("backButtonClicked")
    navigationController?.popViewController(animated: true)
  //  self.dismiss(animated: true, completion: nil)
}

    //MARK:- Get Data From Server
    private func getFamilyDetailsFromServer(url:String) {
        
       
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["data"].dictionary
            {
                
                if let status = messageDictionary["token"]?.string
                {
                    
                    let stringURL = String(format: "https://www.myhealthmeter.com/https/ehra/webservice.php?token=%@", status)
                    
                    
                    let urlwithPercentEscapes = stringURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                    
                    print(urlwithPercentEscapes)
                    
                    
                    let request = URLRequest(url: URL(string: urlwithPercentEscapes!)!)
                            if #available(iOS 11.0, *) {
                                WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "ContentBlockingRules", encodedContentRuleList: self.contentRules) { rulesList, error in
                                    if let error = error {
                                        print(error)
                                        return
                                    }
                                    guard let rulesList = rulesList else { return }
                                    let config = self.webView.configuration
                                    config.userContentController.add(rulesList)
                                    self.webView.load(request)
                                    
                                    
                                }
                            } else {
                                // Fallback on earlier versions
                    //            let link = URL(string:"https://goo.gl/oYFfvT")!
                    //            webView.load(URLRequest(url: link))
                    //            self.view = self.webView
                            }
                            

                    
                }
            }//msgDic
        }
    }
    
    
        //MARK:- Tabbar setup
        func setupFitnessTabbar()
        {
            
            setupInsurance()
//                    let tabBarController = UITabBarController()
//            
//                    let tabViewController1 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"CompeteChallengesVC") as! CompeteChallengesVC
//                    // tabViewController1.isAddMember = 1
//            
//                    let tabViewController2 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"FitnessDashboardVC") as! FitnessDashboardVC
//            
//                    let tabViewController3 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"FitnessDashboardRootVC") as! FitnessDashboardRootVC
//                    tabViewController3.isFromInsurance = 11
//            
//                    let tabViewController4 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"StatsFitnessVC") as! StatsFitnessVC
//            
//                    let tabViewController5 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"ProfileFitnessTVC") as! ProfileFitnessTVC
//            
//                    let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
//                    let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
//                    let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
//                    let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
//                    let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
//            
//                    let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
//            
//                    tabBarController.viewControllers = controllers as? [UIViewController]
//            
//                    nav1.tabBarItem = UITabBarItem(
//                        title: "Compete",
//                        image: UIImage(named: "star20x20"),
//                        tag: 1)
//            
//                    nav2.tabBarItem = UITabBarItem(
//                        title: "Rewards",
//                        image:UIImage(named: "reward20x20") ,
//                        tag:2)
//                    nav3.tabBarItem = UITabBarItem(
//                        title: "",
//                        image: UIImage(named: ""),
//                        tag: 1)
//                    nav4.tabBarItem = UITabBarItem(
//                        title: "Stats",
//                        image:UIImage(named: "stat40x40") ,
//                        tag:2)
//                    nav5.tabBarItem = UITabBarItem(
//                        title: "Profile",
//                        image:UIImage(named: "profile-1") ,
//                        tag:2)
//                    tabBarController.selectedIndex=2
//            
//            
//                    //Set Bar tint color white
//                    tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
//            
//                    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
//            
//                    let colorSelected = UIColor.orange
//                    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
//            
//                    tabBarController.view.backgroundColor = UIColor.white
//            
//                    tabBarController.tabBar.tintColor = UIColor.orange
//                    tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
//            
//                    //Set Tab bar border color
//                    //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
//                    tabBarController.tabBar.layer.borderWidth = 0.5
//                    tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
//                    tabBarController.tabBar.clipsToBounds = true
//                    tabBarController.tabBar.isHidden = false
//                    tabBarController.tabBar.isUserInteractionEnabled = true
//            
//                    //tabBarController.modalTransitionStyle = .crossDissolve
//            
//            tabBarController.modalPresentationStyle = .fullScreen
//
//                    self.present(tabBarController, animated: true)
        }
    
    //MARK:- Move To Insurance
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
    
        isRemoveFlag = 0
        tabBarController.modalPresentationStyle = .fullScreen

    navigationController?.present(tabBarController, animated: true, completion: nil)
    tabBarController.selectedIndex=2
    
    
    }
    }





/*
class HealthMeterVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://goo.gl/oYFfvT")
        let requestObj = URLRequest(url: url! as URL)
        
        
        webView.loadRequest(URLRequest(url: URL(string: "https://goo.gl/oYFfvT")!))
        
        self.navigationItem.title="Health Meter"
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()

        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }
}
*/

