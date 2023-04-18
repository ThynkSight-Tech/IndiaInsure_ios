//
//  InstructionsMedicineVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 11/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class InstructionsMedicineVC: UIViewController {

    //Top View Outlets
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnThird: UIButton!
    
    @IBOutlet weak var viewOuterBorder: UIView!
    @IBOutlet weak var viewFirstBackground: UIView!
    @IBOutlet weak var viewSecondBackground: UIView!
    @IBOutlet weak var viewThirdBackground: UIView!
    
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backgroundWebView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnScheduleNow: UIButton!
    var textHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var textViewOutlet: UITextView!
    var modelObject = TermsAndConditionModel()
    var selectedIndex = 0
    var tabString = "first"

    
    
    override func viewDidLoad() {
        print("\(navigationItem.title ?? "medicine delivery") InstructionsMedicineVC")
        menuButton.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        menuButton.removeFromSuperview()
        super.viewDidLoad()
        
        if self.tabString == "first" {
            setHtml(fileName: "dentalOverview")
        } else  if self.tabString == "second" {
            setHtml(fileName: "dentalHowToOrder")
        } else  if self.tabString == "third" {
            setHtml(fileName: "dentalChecklist")
        }
        
        self.setBottomShadowOn(view: backgroundWebView)
        
        self.navigationController?.navigationBar.changeFont()
        
            let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        //textViewOutlet.delegate = self
        setColor()
        setData()
        
        //getDataFromServer()
        
        

    }
    
    private func setColor() {
        self.btnScheduleNow.backgroundColor = Color.buttonBackgroundGreen.value
        btnScheduleNow.layer.cornerRadius = btnScheduleNow.frame.size.height/2
        btnScheduleNow.layer.masksToBounds = true
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Schedule Now Button Tapped
    @IBAction func scheduleNowDidTapped(_ sender: Any) {
        setupMedicineTabbar()
    }
    
    private func setBottomShadowOn(view:UIView)
    {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = 10
    }
    
    //set initial data
    private func setData() {
        self.title = "Medicine Delivery"
        
        // self.btnScheduleNow.layer.masksToBounds=true
        self.btnScheduleNow.dropShadow()
        self.btnScheduleNow.layer.cornerRadius = btnScheduleNow.frame.size.height / 2
        
        //self.btnScheduleNow.plainView.setGradientBackgroundNew(colorTop: hexStringToUIColor(hex: "40e0d0"), colorBottom:hexStringToUIColor(hex: "3ed9b0"))
        
        self.navigationController?.navigationBar.applyGradient()
        
        viewOuterBorder.layer.cornerRadius = viewOuterBorder.frame.size.height / 2
        viewOuterBorder.clipsToBounds = true
        //viewOuterBorder.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        //viewOuterBorder.layer.borderWidth = 0.5
        
        
        self.viewFirstBackground.layer.cornerRadius = viewFirstBackground.frame.size.height / 2
        self.viewSecondBackground.layer.cornerRadius = viewSecondBackground.frame.size.height / 2
        self.viewThirdBackground.layer.cornerRadius = viewThirdBackground.frame.size.height / 2
        self.viewFirstBackground.layer.masksToBounds = true
        self.viewSecondBackground.layer.masksToBounds = true
        self.viewThirdBackground.layer.masksToBounds = true
        
        //set Default zero selected
        btnFirst.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnSecond.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnThird.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.btnFirst.setTitleColor(UIColor.white, for: .normal)
        self.btnSecond.setTitleColor(UIColor.lightGray, for: .normal)
        self.btnThird.setTitleColor(UIColor.lightGray, for: .normal)
        
        btnThird.setBackgroundImage(UIImage(named: ""), for: .normal)
        btnFirst.backgroundColor = Color.buttonBackgroundGreen.value
        
        // btnFirst.setBackgroundImage(UIImage(named: "tabterm"), for: .normal)
        btnSecond.setBackgroundImage(UIImage(named: ""), for: .normal)
    }
    
    
    @IBAction func tabViewButtonDidTapped(_ sender: UIButton) {
        
        print(sender.tag)
        self.selectedIndex = sender.tag
        
        
        switch sender.tag {
        case 0:
            btnFirst.backgroundColor = Color.buttonBackgroundGreen.value
            btnSecond.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            btnThird.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.btnFirst.setTitleColor(UIColor.white, for: .normal)
            self.btnSecond.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnThird.setTitleColor(UIColor.lightGray, for: .normal)
            //self.webView.loadHTMLString(convertHtmlCss(htmlText: self.modelObject.companyOverview ?? ""), baseURL: nil)
            btnThird.setBackgroundImage(UIImage(named: ""), for: .normal)
            //btnFirst.setBackgroundImage(UIImage(named: "tabterm"), for: .normal)
            btnSecond.setBackgroundImage(UIImage(named: ""), for: .normal)
            
            setHtml(fileName: "dentalOverview")
            
        case 1:
            btnSecond.backgroundColor = Color.buttonBackgroundGreen.value
            btnFirst.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            btnThird.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.btnFirst.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnSecond.setTitleColor(UIColor.white, for: .normal)
            self.btnThird.setTitleColor(UIColor.lightGray, for: .normal)
            //self.webView.loadHTMLString(convertHtmlCss(htmlText: self.modelObject.preTestPolicy ?? ""), baseURL: nil)
            //self.webViewHeight.constant = self.webView.scrollView.contentSize.height
            btnThird.setBackgroundImage(UIImage(named: ""), for: .normal)
            btnFirst.setBackgroundImage(UIImage(named: ""), for: .normal)
            //btnSecond.setBackgroundImage(UIImage(named: "tabterm"), for: .normal)
            
            setHtml(fileName: "dentalHowToOrder")
            
        case 2:
            btnThird.backgroundColor = Color.buttonBackgroundGreen.value
            btnFirst.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            btnSecond.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            btnFirst.setImage(UIImage(named: "tab"), for: .normal)
            
            self.btnFirst.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnSecond.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnThird.setTitleColor(UIColor.white, for: .normal)
            //self.webView.loadHTMLString(convertHtmlCss(htmlText: self.modelObject.refCanPolicy ?? ""), baseURL: nil)
            //self.webViewHeight.constant = self.webView.scrollView.contentSize.height
            //btnThird.setBackgroundImage(UIImage(named: "tabterm"), for: .normal)
            btnFirst.setBackgroundImage(UIImage(named: ""), for: .normal)
            btnSecond.setBackgroundImage(UIImage(named: ""), for: .normal)
            
            setHtml(fileName: "dentalChecklist")

        default:
            break
        }
        
        
        self.webView.layoutIfNeeded()
        self.backgroundWebView.layoutIfNeeded()
        
    }
    
    
    func setHtml(fileName:String) {
        
                if let url = Bundle.main.url(forResource: fileName, withExtension: "html")
                {
                    let request = NSURLRequest(url: url)
                    webView.loadRequest(request as URLRequest)
                }
               // self.webView.loadHTMLString(aktivoScore, baseURL: nil)
        
        }
        
    private func getDataFromServer() {
        
        var m_employeedict : EMPLOYEE_INFORMATION?
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_employeedict=userArray[0]
        
        //var employeesrno = String()
        var groupChildSrNo = String()
        
        
        //        if let empNo = m_employeedict?.empSrNo
        //        {
        //            employeesrno = String(empNo)
        //        }
        if let groupChlNo = m_employeedict?.groupChildSrNo
        {
            groupChildSrNo=String(groupChlNo)
        }
        
        print(groupChildSrNo)
        
        
        guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") else {
            return
        }
        
        print("groupSrNo: ",groupSrNo)
        
        let url = APIEngine.shared.getBasicInfoURL(externalGroupSrNo: groupSrNo as! String, agent: "ios")
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    
                    let refString = response?["RefCanPolicy"].string
                    
                    var second =   "<div class=\"main-container\">"
                    second = second + refString! + "</div>"
                    
                    var  preString = response?["PreTestPolicy"].string
                    
                    preString = preString?.replacingOccurrences(of: "pretests", with: "main-container")
                    
                    self.modelObject = TermsAndConditionModel.init(companyOverview: response?["CompanyOverview"].string, preTestPolicy: preString, refundPolicy: response?["RefundPolicy"].string, refCanPolicy: second)
                    
                    
                    
                    let bundlePath = Bundle.main.bundlePath
                    let bundleUrl = URL(fileURLWithPath: bundlePath)
                    
                    self.webView.loadHTMLString(self.convertHtmlCss(htmlText: self.modelObject.companyOverview ?? ""), baseURL: bundleUrl)
                    
                    
                }
            }
        }
    }
    private func convertHtmlCss(htmlText:String) -> String {
        
        print(htmlText)
        let cssText = "<style> .main-container { text-align: justify; font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);color:#696969;}ul.pretests { padding-left: 0px; }ul.pretests li{ color:#696969; line-height: 1;font-size : 13px;font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf); text-align: justify; margin: 0 10px 10px; }.main-container .text-center {text-align: center;}.main-container ul { padding-left:20px; }span.clearfix { color:#696969; font-size:13px; font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);}.h1 {font-size: 24px;}.main-container h2.sbold {font-size: larger;}.sbold { font-weight: 400!important; }.main-container h2,.text-primary,.text-info { color: #0096d6; }.h1, .h2, .h3, h1, h2, h3 {margin-top: 20px;margin-bottom: 10px; }</style>"
        
        
        let finalString = String(format: "%@%@", htmlText,cssText)
        
        print("Converted Text =\(finalString) ")
        return finalString
}
    
    //MARK:- Tabbar setup
    func setupMedicineTabbar()
    {
        
        let tabBarController = UITabBarController()
        
        let tabViewController1 = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"FamilyMemberListMD_VC") as! FamilyMemberListMD_VC
        tabViewController1.isAddMember = 1
        
        let tabViewController2 = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"MedicineHistoryMD_VC") as! MedicineHistoryMD_VC
        
        let tabViewController3 = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"FamilyMemberListMD_VC") as! FamilyMemberListMD_VC

        //let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"FamilyDetailsViewController") as! FamilyDetailsViewController

        
        let tabViewController4 = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"OngoingOrderMD_VC") as! OngoingOrderMD_VC
        
        let tabViewController5 = ProfileViewForWellness(
            nibName:"ProfileViewForWellness",
            bundle: nil)
        
        
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
            title: "Ongoing",
            image:UIImage(named: "appointment") ,
            tag:2)
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile-1") ,
            tag:2)
        tabBarController.selectedIndex=2
        
        //Set Bar tint color white
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
        
        //    tabBarController.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        //  tabBarController.tabBar.selectedItem?.badgeColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
        
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
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
    
    
}

