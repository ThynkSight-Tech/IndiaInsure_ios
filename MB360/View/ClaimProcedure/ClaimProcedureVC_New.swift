//
//  ClaimProcedureVC_New.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 18/10/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation
import UIKit
class ExpandedCaimProcedureNew
{
    var title : String?
    //    var otherInfo : Intimations?
    var expanded : Bool
    
    init(title:String)
    {
        self.title = title
        //        self.otherInfo = otherInfo
        self.expanded = false
    }
}


class ClaimProcedureVC_New: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate, NewPoicySelectedDelegate {
    
    @IBOutlet weak var topLbl: UILabel!
    
    //Policy Types
    @IBOutlet weak var m_topBarView: UIView!
    @IBOutlet weak var m_shadowView: UIView!
    @IBOutlet weak var m_GMCTab: UIButton!
    
    @IBOutlet weak var m_GPAshadowView: UIView!
    @IBOutlet weak var GPATab: UIButton!
    
    @IBOutlet weak var m_GTLShadowView: UIView!
    @IBOutlet weak var GTLTab: UIButton!
    
    @IBOutlet weak var m_segmentView: UIView!
    
    @IBOutlet weak var m_indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var m_reimbursmentButton: UIButton!
    @IBOutlet weak var m_cashlessButton: UIButton!
    @IBOutlet weak var m_tableView: UITableView!
    
    @IBOutlet weak var m_ttleView: UIView!
    @IBOutlet weak var m_titleLbl: UILabel!
    @IBOutlet weak var m_titleViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainGPAGTLView: UIView!
    @IBOutlet weak var policyNameheaderView: UIView!
    @IBOutlet weak var policyNameheaderlbl: UILabel!
    @IBOutlet weak var policyHeaderBoaderView: UIView!
    @IBOutlet weak var policyHeaderImg: UIImageView!
    @IBOutlet weak var m_webView: UIWebView!
    
    @IBOutlet weak var policyValueView: UIView!
    @IBOutlet weak var leftBorderView: UIView!
    @IBOutlet weak var backGroundColorView: UIView!
    @IBOutlet weak var valueLbl: UILabel!
    
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_webViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_segmentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_cashlessButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_reimbursmentButtonHeightConstraint: NSLayoutConstraint!
    
    //Dropdown Bar
    @IBOutlet weak var PolicylblView: UIView!
    @IBOutlet weak var policyNamelbl: UILabel!
    @IBOutlet weak var policyButtonView: UIView!
    @IBOutlet weak var policyButtonLbl: UILabel!
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var m_errorImageview: UIImageView!
    
    @IBOutlet weak var noInternetHeaderLbl: UILabel!
    @IBOutlet weak var noInternetDescLbl: UILabel!
    
    var selectedIndexPosition = -1
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    var selectedPolicyValue = ""
    
    
    let reuseIdentifier = "cell"
    var m_productCode = String()
    var selectedRowIndex = -1
    var datasource = [ExpandedCaimProcedureNew]()
    var isFromSideBar = Bool()
    
    var m_employeedict : EMPLOYEE_INFORMATION?
    var resultsDictArray: [[String: String]]? // the whole array of dictionaries
    var instructArray: [[String : String]]?
    var emergencyArray: [[String : String]]?
    var claimProcTextPathArray : [[String : String]]?
    
    var layoutVisibleArray = [String]()
    var imagefilename = ""
    var imageFilePath = ""
    var imageFinalPath = ""
    
    var stepsfilename = ""
    var stepsFilePath = ""
    var stepsFinalPath = ""
    var stepsData = ""
    
    var claimProcfilename = ""
    var claimProcFilePath = ""
    var claimProcFinalPath = ""
    var claimProcData = ""
    
    var allemergencyNo = ""
    
   
    var gpaStepData = ""
    var blueColor = UIColor(red:0/255, green:112/255, blue:223/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFontUI()
        
        //Top bar hide buttons
        m_GMCTab.isHidden=true
        GPATab.isHidden=true
        GTLTab.isHidden=true
        m_GMCTab.layer.borderWidth = 2
        GPATab.layer.borderWidth = 2
        GTLTab.layer.borderWidth = 2
        
        m_GMCTab.layer.cornerRadius = cornerRadiusForView
        GPATab.layer.cornerRadius = cornerRadiusForView
        GTLTab.layer.cornerRadius = cornerRadiusForView
        
        self.addTarget()
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
                
        print("Claim Procedure Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
        
        
        m_tableView.register(GMCTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib = UINib (nibName: "GMCTableViewCell", bundle: nil)
        m_tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        m_tableView.register(StepsCell.nib(), forCellReuseIdentifier: StepsCell.identifer)
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        
        
        //    self.m_tableView.estimatedRowHeight = 60;
        //    self.m_tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.m_tableView.setNeedsLayout()
        self.m_tableView.layoutIfNeeded()
        
        //m_topBarView.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        PolicylblView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
        m_segmentView.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
        m_segmentView.layer.borderWidth=1
        
        //Top Bar Policy Hide Show
        m_productCodeArray=UserDefaults.standard.value(forKey: "ProductsArray") as! Array<String>
        print("m_productCodeArray: ",m_productCodeArray)
        
        print("Active Policy: ",m_productCodeArray)
        
        if(m_productCodeArray.contains("GMC")){
            print("GMC present")
            m_GMCTab.isHidden = false
        }
        if(m_productCodeArray.contains("GPA")){
            print("GPA present")
            GPATab.isHidden = false
        }
        if(m_productCodeArray.contains("GTL")){
            print("GTL present")
            GTLTab.isHidden = false
        }
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        print("m_productCode: ",m_productCode)
        
        if m_productCode == "GMC"{
            GMCTabSeleted()
        }
        else if m_productCode == "GPA"{
            GPATabSelected()
        }
        else if m_productCode == "GTL"{
            GTLTabSelected()
        }
        
        setData()
        
        m_indicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        navigationController?.navigationBar.isHidden=false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }
    
    func setupFontUI(){
        m_GMCTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GMCTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        GPATab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        GPATab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        GTLTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        GTLTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        
        topLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        topLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        m_cashlessButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_cashlessButton.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_reimbursmentButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_reimbursmentButton.titleLabel?.textColor = FontsConstant.shared.app_FontBlackColor
        
        policyNameheaderlbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h17))
        policyNameheaderlbl.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        valueLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        valueLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_titleLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h17))
        m_titleLbl.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        policyNamelbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        policyNamelbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        policyButtonLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        policyButtonLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        
    }
    
    func setData()
    {
        self.navigationItem.title="Claim Procedures"
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBackButton()
        //navigationItem.rightBarButtonItem=getRightBarButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        datasource.append(ExpandedCaimProcedureNew(title: "cashless"))
        datasource.append(ExpandedCaimProcedureNew(title: "reimbursement"))
        
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
        //setTopbarProducts()
    }
    
    func setTopbarProducts()
    {
        print("m_productCodeArray: ",m_productCodeArray)
        if(m_productCodeArray.count==1)
        {
            if(m_productCodeArray.contains("GMC"))
            {
                getGetClaimProcLayoutInfo(LayoutOfClaim: "CASHLESS")
                m_GMCTab.isUserInteractionEnabled=false
                GPATab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=false
                
                GPATab.setTitleColor(UIColor.white, for: .normal)
                GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GPA"))
            {
                m_GMCTab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=false
                GPATab.isUserInteractionEnabled=false
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
                GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GTL"))
            {
                GPATab.isUserInteractionEnabled=false
                m_GMCTab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=false
                GPATab.setTitleColor(UIColor.white, for: .normal)
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
            }
        }
        else if(m_productCodeArray.count==2)
        {
            
            if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GPA"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                GPATab.isUserInteractionEnabled=true
                GTLTab.isUserInteractionEnabled=false
                m_GMCTab.isHidden=false
                GPATab.isHidden=false
                GTLTab.isHidden=true
                
            }
            else if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                GPATab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=false
                GPATab.isHidden=true
                GTLTab.isHidden=false
            }
            else if(m_productCodeArray.contains("GPA") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=false
                GPATab.isUserInteractionEnabled=true
                GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=true
                GPATab.isHidden=false
                GTLTab.isHidden=false
                
            }
        }
        else
        {
            //m_GMCTab.sendActions(for: .touchUpInside)
            //GMCTabSeleted()
            
            if m_productCode == "GMC"{
                GMCTabSeleted()
            }
            else if m_productCode == "GPA"{
                GPATabSelected()
            }
            else if m_productCode == "GTL"{
                GTLTabSelected()
            }
        }
    }
    
    
    
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        //        tabBarController!.selectedIndex = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cashlessButtonClicked(_ sender: Any)
    {
        self.layoutVisibleArray.removeAll()
        selectedRowIndex = 0
        m_reimbursmentButton.backgroundColor=UIColor.white
        m_reimbursmentButton.setTitleColor(UIColor.black, for: .normal)
        m_cashlessButton.setTitleColor(UIColor.white, for: .normal)
       // m_cashlessButton.backgroundColor =
        m_cashlessButton.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)//blueColor//hexStringToUIColor(hex: hightlightColor)
        m_reimbursmentButton.setBackgroundImage(nil, for: .normal)
        getGetClaimProcLayoutInfo(LayoutOfClaim: "CASHLESS")
        //getLoadClaimProcImagePathData(LayoutOfClaim: "CASHLESS")
        m_tableView.reloadData()
        //scrollToTop()
    }
    @IBAction func reimbursmentButtonClicked(_ sender: Any)
    {
        
        self.layoutVisibleArray.removeAll()
        selectedRowIndex = 1
        m_cashlessButton.backgroundColor=UIColor.white
        m_cashlessButton.setTitleColor(UIColor.black, for: .normal)
        m_reimbursmentButton.setTitleColor(UIColor.white, for: .normal)
        m_reimbursmentButton.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_cashlessButton.setBackgroundImage(nil, for: .normal)
        //blueColor//hexStringToUIColor(hex: hightlightColor)
        //m_reimbursmentButton.setImage(UIImage(named: "add bg"), for: .normal)
        getGetClaimProcLayoutInfo(LayoutOfClaim: "REIMBURSEMENT")
        //getLoadClaimProcImagePathData(LayoutOfClaim: "REIMBURSEMENT")
        m_tableView.reloadData()
        //scrollToTop()
    }
    
    func GMCTabSeleted(){
        m_productCode = "GMC"
        
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        
        m_cashlessButton.isHidden = false
        m_reimbursmentButton.isHidden = false
        
        m_segmentViewHeightConstraint.constant = 50
        m_cashlessButtonHeightConstraint.constant = 40
        m_reimbursmentButtonHeightConstraint.constant = 40
        m_segmentView.frame.size.height = 50
      
        m_webView.loadHTMLString("", baseURL: nil)
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius=cornerRadiusForView//m_GMCTab.frame.size.height/2
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        
        GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        GPATab.layer.borderColor=UIColor.white.cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        GTLTab.layer.borderColor=UIColor.white.cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        
        
        //m_cashlessButtonHeightConstraint.constant = 40
        //m_reimbursmentButtonHeightConstraint.constant = 40
        //Cashless and Reimbursement Button
        m_segmentView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
        m_cashlessButton.layer.cornerRadius = cornerRadiusForView//m_cashlessButton.frame.size.height/2
        m_reimbursmentButton.layer.cornerRadius = cornerRadiusForView//m_reimbursmentButton.frame.size.height/2
        
        
        print("m_segmentView Height: ",m_segmentView.layer.frame.height)
        print("m_cashlessButton Height: ",m_cashlessButton.layer.frame.height)
        print("m_reimbursmentButton Height: ",m_reimbursmentButton.layer.frame.height)
        
        mainGPAGTLView.isHidden = true
        m_webView.isHidden = true
        policyNameheaderView.isHidden = true
        policyHeaderBoaderView.isHidden = true
        m_cashlessButton.sendActions(for: .touchUpInside)
        GPATab.layer.borderWidth = 2
        GTLTab.layer.borderWidth = 2
        
        GPATab.layer.cornerRadius = cornerRadiusForView//8
        GTLTab.layer.cornerRadius = cornerRadiusForView//8
        m_shadowView.layer.cornerRadius = cornerRadiusForView//8
        
        GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
    }
    
   
    func GPATabSelected(){
        /*
         m_productCode = "GPA"
         m_webView.loadHTMLString("", baseURL: nil)
         m_tableView.isHidden = true
         GPATab.layer.masksToBounds=true
         GPATab.layer.cornerRadius=GPATab.frame.size.height/2
         GPATab.layer.borderWidth=0
         GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
         GPATab.setTitleColor(UIColor.white, for: .normal)
         
         m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
         GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
         
         m_GMCTab.layer.borderColor=UIColor.white.cgColor
         m_GMCTab.setBackgroundImage(nil, for: .normal)
         GTLTab.layer.borderColor=UIColor.white.cgColor
         GTLTab.setBackgroundImage(nil, for: .normal)
         
         mainGPAGTLView.isHidden = false
         m_webView.isHidden = false
         m_webView.layer.cornerRadius = 5
         policyNameheaderlbl.text = "GROUP PERSONAL ACCIDENT PROCEDURE STEPS"
         policyNameheaderView.isHidden = false
         policyHeaderBoaderView.isHidden = false
         shadowForCell(view: mainGPAGTLView)
         getClaimProcInstructionInfoData(LayoutOfClaim: "NOT%20AVAILABLE")
         */
        m_productCode = "GPA"
        
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
            
            print("Claim Procedure Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
            
            
            m_segmentViewHeightConstraint.constant = 0
            // m_cashlessButtonHeightConstraint.constant = 0
            // m_reimbursmentButtonHeightConstraint.constant = 0
            m_cashlessButton.isHidden = true
            m_reimbursmentButton.isHidden = true
            
            m_webView.loadHTMLString("", baseURL: nil)
            m_tableView.isHidden = false
            GPATab.layer.masksToBounds=true
            GPATab.layer.cornerRadius=cornerRadiusForView//GPATab.frame.size.height/2
            GPATab.layer.borderWidth=0
            GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
            GPATab.setTitleColor(UIColor.white, for: .normal)
            
            m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
            GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
            
            m_GMCTab.layer.borderColor=UIColor.white.cgColor
            m_GMCTab.setBackgroundImage(nil, for: .normal)
            GTLTab.layer.borderColor=UIColor.white.cgColor
            GTLTab.setBackgroundImage(nil, for: .normal)
            mainGPAGTLView.isHidden = true
            m_webView.isHidden = true
            policyNameheaderView.isHidden = true
            policyHeaderBoaderView.isHidden = true
            m_GMCTab.layer.borderWidth = 2
            GTLTab.layer.borderWidth = 2
            
            m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
            GTLTab.layer.cornerRadius = cornerRadiusForView//8
            m_GPAshadowView.layer.cornerRadius = cornerRadiusForView//8
            
            m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
            m_GMCTab.setBackgroundImage(nil, for: .normal)
            GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
            GTLTab.setBackgroundImage(nil, for: .normal)
            getGetClaimProcLayoutInfo(LayoutOfClaim: "NOT%20AVAILABLE")
            //getClaimProcInstructionInfoData(LayoutOfClaim: "NOT%20AVAILABLE")
       
    }
    
    func GTLTabSelected(){

        /*
        m_productCode = "GTL"
        m_webView.loadHTMLString("", baseURL: nil)
        m_tableView.isHidden = true
        GTLTab.layer.masksToBounds=true
        GTLTab.layer.cornerRadius=GTLTab.frame.size.height/2
        
        GTLTab.layer.borderWidth=0
        GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        GTLTab.setTitleColor(UIColor.white, for: .normal)
        
        GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        GPATab.layer.borderColor=UIColor.white.cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        
        
        mainGPAGTLView.isHidden = false
        m_webView.isHidden = false
        m_webView.layer.cornerRadius = 5
        policyNameheaderView.isHidden = false
        policyHeaderBoaderView.isHidden = false
        shadowForCell(view: mainGPAGTLView)
        policyNameheaderlbl.text = "GROUP TERM LIFE PROCEDURE STEPS"
        
        getClaimProcInstructionInfoData(LayoutOfClaim: "NOT%20AVAILABLE")
 */
        
        m_productCode = "GTL"
        
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        m_segmentViewHeightConstraint.constant = 0
       // m_cashlessButtonHeightConstraint.constant = 0
       // m_reimbursmentButtonHeightConstraint.constant = 0
        m_cashlessButton.isHidden = true
        m_reimbursmentButton.isHidden = true
        
        m_webView.loadHTMLString("", baseURL: nil)
        m_tableView.isHidden = false
        GTLTab.layer.masksToBounds=true
        GTLTab.layer.cornerRadius=cornerRadiusForView//GTLTab.frame.size.height/2
        
        GTLTab.layer.borderWidth=0
        GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        GTLTab.setTitleColor(UIColor.white, for: .normal)
        
        GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        GPATab.layer.borderColor=UIColor.white.cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        
        mainGPAGTLView.isHidden = true
        m_webView.isHidden = true
        policyNameheaderView.isHidden = true
        policyHeaderBoaderView.isHidden = true
        getGetClaimProcLayoutInfo(LayoutOfClaim: "NOT%20AVAILABLE")
        GPATab.layer.borderWidth = 2
        m_GMCTab.layer.borderWidth = 2
        
        GPATab.layer.cornerRadius = cornerRadiusForView//8
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        m_GTLShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        
        //getClaimProcInstructionInfoData(LayoutOfClaim: "NOT%20AVAILABLE")
 
    }
    
    @IBAction func GMCTabSelected(_ sender: Any) {
        
        selectedRowIndex = -1
        selectedIndexPosition = 0
        GMCTabSeleted()
        //m_cashlessButton.sendActions(for: .touchUpInside)
        m_tableView.isHidden = false
    }
    
    @IBAction func GPATabSelected(_ sender: Any) {
        
        selectedRowIndex = -1
        selectedIndexPosition = 0
        GPATabSelected()
    }
    
    @IBAction func GTLTabSelected(_ sender: Any) {
        
        selectedRowIndex = -1
        selectedIndexPosition = 0
        GTLTabSelected()
    }
    
    func scrollToTop()
    {
        let indexpath = IndexPath(row: 0, section: 0)
        m_tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
    }
    
    
    
    //Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Count for ",self.layoutVisibleArray.count)
        if m_productCode == "GMC"{
            return self.layoutVisibleArray.count
        }else{
            return self.layoutVisibleArray.count + 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var maxCellIndex : Int = self.layoutVisibleArray.count - 1
        
        //
         if m_productCode == "GMC"{
             maxCellIndex = self.layoutVisibleArray.count - 1
         }else{
             maxCellIndex = self.layoutVisibleArray.count
         }
        print("maxCellIndex: ",maxCellIndex)
        print("cellForRowAt : ",self.layoutVisibleArray.count)
       
        if indexPath.row == 0{
            //LAYOUT_PART 1
            //ImageView Cell
            let cell : GMCTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GMCTableViewCell
            
            if(selectedRowIndex==0)
            {
                cell.mainimageView.image = UIImage(named: "claimnotfound")
                cell.mainimageView?.contentMode = .scaleAspectFit
                print("imageFinalPath for Cashless: ",imageFinalPath)
                var imageUrl = URL(string: imageFinalPath)
                cell.mainimageView.sd_setImage(with: imageUrl, completed: nil)
            }
            else
            {
                
                cell.mainimageView.image = UIImage(named: "claimnotfound")
                cell.mainimageView?.contentMode = .scaleAspectFit
                print("imageFinalPath for REIMBURSEMENT: ",imageFinalPath)
                var imageUrl = URL(string: imageFinalPath)
                cell.mainimageView.sd_setImage(with: imageUrl, completed: nil) 
            }
            shadowForCell(view: cell.mainView)
            return cell
        }
        else if indexPath.row == 1{
            //LAYOUT_PART 2
            //Instruction Cell
            let cell = m_tableView.dequeueReusableCell(withIdentifier: StepsCell.identifer, for: indexPath) as! StepsCell
            cell.configure(with: "ContactDetails")
            
            cell.icon?.image = UIImage(named: "ClaimProcedureHeader")
            if m_productCode == "GMC"{
                if selectedRowIndex == 0{
                    cell.headerLbl?.text = "CASHLESS PROCEDURE STEPS"
                }else{
                    cell.headerLbl?.text = "REIMBURSEMENT PROCEDURE STEPS"
                }
            }
            else if m_productCode == "GPA"{
                cell.headerLbl?.text = "GROUP PERSONAL ACCIDENT CLAIM PROCEDURE STEPS"
            }
            else if m_productCode == "GTL"{
                cell.headerLbl?.text = "GROUP TERM LIFE CLAIM PROCEDURE STEPS"
            }
            cell.bottomIcon.heightAnchor.constraint(equalToConstant: 0).isActive = true
            cell.bottomIcon.widthAnchor.constraint(equalToConstant: 0).isActive = true
            
            if self.stepsData.isEmpty{
                cell.stepsLbl?.text = " No steps found"
                cell.stepsLbl?.backgroundColor = Color.Error_BgColor.value
                
                cell.stepsLbl?.textColor = FontsConstant.shared.app_ErrorColor
                let screenSize: CGRect = UIScreen.main.bounds
                let myView = UIView(frame: CGRect(x: 15, y: 40, width: 5, height: 20))
                myView.backgroundColor = Color.Error_ViewBgColor.value
                cell.mainView.addSubview(myView)
            }
            else{
                
                let stepsWithOutSpaces = String(self.stepsData.filter { !"\n\t\r".contains($0) })
                cell.stepsLbl?.text = stepsWithOutSpaces
                print("HtmlToString data in cell 1: ",stepsWithOutSpaces)
                cell.stepsLbl?.backgroundColor = UIColor.white
                
                cell.stepsLbl?.textColor = FontsConstant.shared.app_FontBlackColor
                let screenSize: CGRect = UIScreen.main.bounds
                let myView = UIView(frame: CGRect(x: 15, y: 40, width: 5, height: 20))
                myView.backgroundColor = UIColor.white
                cell.mainView.addSubview(myView)
            }
            shadowForCell(view: cell.mainView)
            return cell
        }
        else if indexPath.row == 2{
            //LAYOUT_PART 3
            //additional instructions Cell
            let cell = m_tableView.dequeueReusableCell(withIdentifier: StepsCell.identifer, for: indexPath) as! StepsCell
            cell.configure(with: "ContactDetails")
            
            cell.icon?.image = UIImage(named: "ClaimProcedureHeader")
            cell.headerLbl?.text = "ADDITIONAL INSTRUCTIONS STEPS"
            
            cell.bottomIcon.heightAnchor.constraint(equalToConstant: 0).isActive = true
            cell.bottomIcon.widthAnchor.constraint(equalToConstant: 0).isActive = true
            
            if self.claimProcData.isEmpty{
                cell.stepsLbl?.text = " No instructions found"
                cell.stepsLbl?.backgroundColor = Color.Error_BgColor.value
                
                cell.stepsLbl?.textColor = FontsConstant.shared.app_ErrorColor
                let screenSize: CGRect = UIScreen.main.bounds
                let myView = UIView(frame: CGRect(x: 15, y: 40, width: 5, height: 20))
                myView.backgroundColor = Color.Error_ViewBgColor.value
                cell.mainView.addSubview(myView)
            }
            else{
                
                let stepsWithOutSpaces = String(self.claimProcData.filter { !"\n\t\r".contains($0) })
                cell.stepsLbl?.text = stepsWithOutSpaces
                print("ADDITIONAL HtmlToString data: ",stepsWithOutSpaces)
                
                cell.stepsLbl?.backgroundColor = UIColor.white
                
                cell.stepsLbl?.textColor = FontsConstant.shared.app_FontBlackColor
                let screenSize: CGRect = UIScreen.main.bounds
                let myView = UIView(frame: CGRect(x: 15, y: 40, width: 5, height: 20))
                myView.backgroundColor = UIColor.clear
                cell.mainView.addSubview(myView)
            }
            
            shadowForCell(view: cell.mainView)
            return cell
        }
        else if indexPath.row == maxCellIndex{
            //LAYOUT_PART 5
            //EmergencyContactNo Cell
            let cell = m_tableView.dequeueReusableCell(withIdentifier: StepsCell.identifer, for: indexPath) as! StepsCell
            cell.configure(with: "ContactDetails")
            
            if self.allemergencyNo.isEmpty{
                cell.mainView.frame.size.height = 0
                cell.stepsLbl?.text = " Not available"
                cell.stepsLbl?.backgroundColor = Color.Error_BgColor.value
                
                cell.stepsLbl?.textColor = FontsConstant.shared.app_ErrorColor
                let screenSize: CGRect = UIScreen.main.bounds
                let myView = UIView(frame: CGRect(x: 15, y: 40, width: 5, height: 20))
                myView.backgroundColor = Color.Error_ViewBgColor.value
                cell.mainView.addSubview(myView)
            }
            else{
                cell.icon?.image = UIImage(named: "ClaimProcedureHeadPhone")
                cell.headerLbl?.text = "HELPLINE NO'S"
                
                cell.bottomIcon?.image = UIImage(named: "ClaimProcedurePhone")
                cell.stepsLbl?.text = self.allemergencyNo
                cell.stepsLbl?.backgroundColor = UIColor.white
                cell.stepsLbl?.textColor = FontsConstant.shared.app_FontBlackColor
                let screenSize: CGRect = UIScreen.main.bounds
                let myView = UIView(frame: CGRect(x: 15, y: 40, width: 5, height: 20))
                myView.backgroundColor = UIColor.white
                cell.mainView.addSubview(myView)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(callButton(sender:)))
                // Gesture recognizer Label
                cell.stepsLbl?.isUserInteractionEnabled = true
                cell.stepsLbl?.addGestureRecognizer(tap)
            }
            shadowForCell(view: cell.mainView)
            return cell
            
        }
        else{
            //LAYOUT_PART 4
            //DOWNLOAD Forms
            let cell = m_tableView.dequeueReusableCell(withIdentifier: StepsCell.identifer, for: indexPath) as! StepsCell
            cell.configure(with: "ContactDetails")
            
            cell.icon?.image = UIImage(named: "ClaimProcedureHeader")
            cell.headerLbl?.text = "DOWNLOAD FORMS"
            
            cell.bottomIcon.heightAnchor.constraint(equalToConstant: 0).isActive = true
            cell.bottomIcon.widthAnchor.constraint(equalToConstant: 0).isActive = true
            
            if self.claimProcData.isEmpty{
                cell.stepsLbl?.text = " No Download forms are available"
                cell.stepsLbl?.backgroundColor = Color.Error_BgColor.value
                
                cell.stepsLbl?.textColor = FontsConstant.shared.app_ErrorColor
                let screenSize: CGRect = UIScreen.main.bounds
                let myView = UIView(frame: CGRect(x: 15, y: 40, width: 5, height: 20))
                myView.backgroundColor = Color.Error_ViewBgColor.value
                cell.mainView.addSubview(myView)
            }
            else{
                
                let stepsWithOutSpaces = String(self.claimProcData.filter { !"\n\t\r".contains($0) })
                cell.stepsLbl?.text = "File Name"
                cell.bottomIcon?.image = UIImage(named: "pdf")
                cell.stepsLbl?.backgroundColor = UIColor.white
                
                
                print("File Name: ",stepsWithOutSpaces)
                
                cell.stepsLbl?.backgroundColor = UIColor.white
                
                cell.stepsLbl?.textColor = FontsConstant.shared.app_FontBlackColor
                let screenSize: CGRect = UIScreen.main.bounds
                let myView = UIView(frame: CGRect(x: 15, y: 40, width: 5, height: 20))
                myView.backgroundColor = UIColor.clear
                cell.mainView.addSubview(myView)
            }
            
            shadowForCell(view: cell.mainView)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Seelcted \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0{
            if m_productCode == "GMC"
            {
                if(selectedRowIndex==0)
                {
                    if(Device.IS_IPAD)
                    {
                        return 1000
                    }
                    else if(Device.IS_IPHONE_6)
                    {
                        return 735
                    }
                    else if(Device.IS_IPHONE_6P)
                    {
                        return 800
                    }
                    else if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
                    {
                        return 615
                    }
                    else if(Device.IS_IPHONE_X)
                    {
                        return 735
                    }
                    else if(Device.IS_IPHONE_XsMax)
                    {
                        print("450")
                        return 450
                    }
                    else
                    {
                        print("735")
                        return 400
                    }
                    
                    
                }
                else
                {
                    if(Device.IS_IPAD)
                    {
                        return 1000
                    }
                    else if(Device.IS_IPHONE_6)
                    {
                        return 820
                    }
                    else if(Device.IS_IPHONE_6P)
                    {
                        return 890
                    }
                    else if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
                    {
                        return 690
                    }
                    else if(Device.IS_IPHONE_X)
                    {
                        return 820
                    }
                    else if(Device.IS_IPHONE_XsMax)
                    {
                        return 450
                    }
                    else
                    {
                        return 400
                    }
                }
            }else{
                return 0
            }
        }
        else{
            //return 700
            return UITableViewAutomaticDimension
        }
    }
    
    @IBAction func callButton(sender: AnyObject) {
        print("In side callButton")
        var number = self.allemergencyNo.replacingOccurrences(of:" ", with: "", options: NSString.CompareOptions.literal, range: nil)
        number = number.replacingOccurrences(of:"+91", with: "", options: NSString.CompareOptions.literal, range: nil)
        print(number ?? "1234567890")
        if let url = URL(string: "tel://"+number), UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(url)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
    }
}


//API CALL
extension ClaimProcedureVC_New{
    
    //Layout call
    func getGetClaimProcLayoutInfo(LayoutOfClaim: String){
        if(isConnectedToNetWithAlert())
        {
            let array = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            
            if(array.count>0)
            {
                m_employeedict=array[0]
                if (m_employeedict==nil)
                {
                    
                    //            m_employeedict=nil
                    displayActivityAlert(title: "noDataFound".localized())
                    
                }
                else
                {
                    
                    showPleaseWait(msg: "Please wait...")
                    
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    var employeesrno = String()
                    
                    if let childNo = m_employeedict?.groupChildSrNo
                    {
                        groupchildsrno = String(childNo)
                        groupchildsrno = try! AesEncryption.encrypt(groupchildsrno)
                    }
                    
                    if let empNo = m_employeedict?.empSrNo
                    {
                        employeesrno = String(empNo)
                        employeesrno = try! AesEncryption.encrypt(employeesrno)
                    }
                    
                    if selectedIndexPosition == 0{
                        if let oegrp = m_employeedict?.oe_group_base_Info_Sr_No
                        {
                            oegrpbasinfsrno = String(oegrp)
                            oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                        }
                    }else{
                        oegrpbasinfsrno = selectedPolicyValue
                        oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                    }
                    
                    print("m_productCode : ",m_productCode," : groupchildsrno: ",groupchildsrno," : employeesrno: ",employeesrno," : oegrpbasinfsrno: ",oegrpbasinfsrno)
                  
                    
                    //Testing Values
                    //oegrpbasinfsrno = "1047"
                    //let product = "GMC"
                    
                    let product = m_productCode
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getClaimProcLayoutInfoPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded, product: product, layoutOfClaim: LayoutOfClaim))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
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
                    
                    
                    print("GetClaimProcLayoutInfo url: ",urlreq)
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        guard let data = data, error == nil else {
                            print(error?.localizedDescription ?? "No data")
                            return
                        }
                        
                        if let httpresponse = response as? HTTPURLResponse
                        {
                            if httpresponse.statusCode == 200{
                                do{
                                    DispatchQueue.main.async {
                                        self.m_noInternetView.isHidden = true
                                    }
                                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                    if let data = json?["ClaimProcLayoutInfo"] as? [Any] {
                                        
                                        self.resultsDictArray = json?["ClaimProcLayoutInfo"] as! [[String : String]]
                                        self.layoutVisibleArray.removeAll()
                                        
                                        print("resultsDictArray : ",self.resultsDictArray)
                                        if self.resultsDictArray?.count ?? 0 > 0
                                        {
                                            
                                            for item in data {
                                                if let object = item as? [String: Any] {
                                                    
                                                    // CLM_PROC_LAYOUT_INF_SR_NO
                                                    let CLM_PROC_LAYOUT_INF_SR_NO = object["CLM_PROC_LAYOUT_INF_SR_NO"] as? String ?? "0"
                                                    print("CLM_PROC_LAYOUT_INF_SR_NO: \(CLM_PROC_LAYOUT_INF_SR_NO)")
                                                    
                                                    // LAYOUT_PART
                                                    let LAYOUT_PART = object["LAYOUT_PART"] as? String ?? ""
                                                    print("LAYOUT_PART: \(LAYOUT_PART)")
                                                    
                                                    // LAYOUT_PART_VISIBILITY
                                                    let LAYOUT_PART_VISIBILITY = object["LAYOUT_PART_VISIBILITY"] as? String ?? ""
                                                    print("LAYOUT_PART_VISIBILITY: \(LAYOUT_PART_VISIBILITY)")
                                                    
                                                    // LAYOUT_OF_PRODUCT
                                                    let LAYOUT_OF_PRODUCT = object["LAYOUT_OF_PRODUCT"] as? String ?? "0"
                                                    print("LAYOUT_OF_PRODUCT: \(LAYOUT_OF_PRODUCT)")
                                                    
                                                    // LAYOUT_OF_CLAIM_PROC
                                                    let LAYOUT_OF_CLAIM_PROC = object["LAYOUT_OF_CLAIM_PROC"] as? String ?? "0"
                                                    print("LAYOUT_OF_CLAIM_PROC: \(LAYOUT_OF_CLAIM_PROC)")
                                                    
                                                    
                                                    // GROUPCHILDSRNO
                                                    let GROUPCHILDSRNO = object["GROUPCHILDSRNO"] as? String ?? "0"
                                                    print("GROUPCHILDSRNO: \(GROUPCHILDSRNO)")
                                                    
                                                    
                                                    // OE_GRP_BAS_INF_SR_NO
                                                    let OE_GRP_BAS_INF_SR_NO = object["OE_GRP_BAS_INF_SR_NO"] as? String ?? "0"
                                                    print("OE_GRP_BAS_INF_SR_NO: \(OE_GRP_BAS_INF_SR_NO)")
                                                    
                                                    if LAYOUT_PART_VISIBILITY == "1"{
                                                        self.layoutVisibleArray.append(LAYOUT_PART)
                                                        print("layoutVisibleArray:: ",self.layoutVisibleArray)
                                                    }
                                                    
                                                    let dic : NSDictionary = item as! NSDictionary
                                                    // self.datasource.append(ExpandedCell(title: dic.value(forKey: "Faq_Question") as! String, answer:dic.value(forKey: "Faq_Ans") as! String))
                                                    // self.resultsDictArray = item as? [[String : String]]
                                                    
                                                }
                                                print("datasource : ",self.datasource)
                                                
                                            }
                                        }
                                        else{
                                            // self.displayActivityAlert(title: "No Data Found")
                                        }
                                        print("datasource count : ",self.datasource.count)
                                        print("resultsDictArray: ",self.resultsDictArray?.count)
                                        print("layoutVisibleArray: ",self.layoutVisibleArray.count)
                                    }
                                    DispatchQueue.main.async
                                    {
                                        
                                        self.getLoadClaimProcImagePathData(LayoutOfClaim: LayoutOfClaim)
                                        self.getClaimProcInstructionInfoData(LayoutOfClaim: LayoutOfClaim)
                                        //self.m_tableView.reloadData()
                                        self.hidePleaseWait()
                                        //self.scrollToTop()
                                    }
                                    
                                }catch{
                                    
                                }
                            }else if httpresponse.statusCode == 401{
//                                self.hidePleaseWait()
//                                self.alertForLogout()
                                if self.m_productCode == "GMC"{
                                    if self.selectedRowIndex == 0{
                                        self.getUserTokenGlobal(completion: { (data,error) in
                                            self.getGetClaimProcLayoutInfo(LayoutOfClaim: "CASHLESS")
                                        })
                                    }else{
                                        self.getUserTokenGlobal(completion: { (data,error) in
                                            self.getGetClaimProcLayoutInfo(LayoutOfClaim: "REIMBURSEMENT")
                                        })
                                    }
                                    
                                }else if self.m_productCode == "GPA"{
                                    self.getUserTokenGlobal(completion: { (data,error) in
                                        self.getGetClaimProcLayoutInfo(LayoutOfClaim: "NOT%20AVAILABLE")
                                    })
                                }else{
                                    self.getUserTokenGlobal(completion: { (data,error) in
                                        self.getGetClaimProcLayoutInfo(LayoutOfClaim: "NOT%20AVAILABLE")
                                    })
                                }
                            }else{
//                                var msg = self.errorMsg(httpresponse.statusCode)
//                                self.showAlert(message: msg)
                                self.m_noInternetView.isHidden=false
                                self.m_tableView.isHidden=true
                                self.m_errorImageview.image=UIImage(named: "nodocuments")
                                self.noInternetHeaderLbl.text="Nothing to show"
                                self.noInternetDescLbl.text=""
                                
                            }
                        }
                        
                        
                    }
                    
                    task.resume()
                }
            }else{
                
                self.m_noInternetView.isHidden=false
                self.m_tableView.isHidden=true
                self.m_errorImageview.image=UIImage(named: "nodocuments")
                self.noInternetHeaderLbl.text="Nothing to show"
                self.noInternetDescLbl.text=""
            }
        }
    }
    
    
    
    //Image call
    func getLoadClaimProcImagePathData(LayoutOfClaim: String){
        if(isConnectedToNetWithAlert())
        {
            let array = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            if(array.count>0)
            {
                m_employeedict=array[0]
                if (m_employeedict==nil)
                {
                    
                    //            m_employeedict=nil
                    displayActivityAlert(title: "noDataFound".localized())
                    
                }
                else
                {
                    
                    showPleaseWait(msg: "Please wait...")
                    
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    var employeesrno = String()
                    
                    var groupchildsrnoDec = String()
                    var oegrpbasinfsrnoDec = String()
                    var employeesrnoDec = String()
                    
                    if let childNo = m_employeedict?.groupChildSrNo
                    {
                        groupchildsrnoDec = String(childNo)
                        groupchildsrno = try! AesEncryption.encrypt(groupchildsrnoDec)
                    }
                    
                    if let empNo = m_employeedict?.empSrNo
                    {
                        employeesrnoDec = String(empNo)
                        employeesrno = try! AesEncryption.encrypt(employeesrnoDec)
                    }
                    
                    if selectedIndexPosition == 0{
                        if let oegrp = m_employeedict?.oe_group_base_Info_Sr_No
                        {
                            oegrpbasinfsrnoDec = String(oegrp)
                            oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrnoDec)
                        }
                    }else{
                        oegrpbasinfsrnoDec = selectedPolicyValue
                        oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrnoDec)
                    }
                    
                    print("m_productCode : ",m_productCode," : groupchildsrno: ",groupchildsrno," : employeesrno: ",employeesrno," : oegrpbasinfsrno: ",oegrpbasinfsrno)
                  
                    
                    //Testing Values
                    //oegrpbasinfsrno = "1047"
                    //let product = "GMC"
                    
                    let product = m_productCode
                    
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getLoadClaimProcImagePathPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded, product: product, layoutOfClaim: LayoutOfClaim))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
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
                   // request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                    request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                    
                    
                    print("getLoadClaimProcImagePathData url: ",urlreq)
                    
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        guard let data = data, error == nil else {
                            print("Error: ",error?.localizedDescription ?? "No data")
                            return
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        
                        if let data = json?["ClaimProcPart1ImagePath"] as? [Any] {
                            
                            self.resultsDictArray = json?["ClaimProcPart1ImagePath"] as! [[String : String]]
                            
                            
                            print("resultsDictArray : ",self.resultsDictArray)
                            
                            for item in data {
                                if let object = item as? [String: Any] {
                                    
                                    // CLM_PROC_P1_IMG_PATH
                                    let CLM_PROC_P1_IMG_PATH = object["CLM_PROC_P1_IMG_PATH"] as? String ?? "0"
                                    print("CLM_PROC_P1_IMG_PATH: \(CLM_PROC_P1_IMG_PATH)")
                                    self.imagefilename = CLM_PROC_P1_IMG_PATH
                                    self.imageFilePath =  WebServiceManager.getSharedInstance().getImageFilePathPortal(groupchildsrno: groupchildsrnoDec, oegrpbasinfsrno: oegrpbasinfsrnoDec, product: product, layoutOfClaim: LayoutOfClaim)
                                    
                                    self.imageFinalPath = self.imageFilePath+self.imagefilename
                                }
                            }
                        }
                        DispatchQueue.main.async
                        {
                            
                            print("getLoadClaimProcImagePathDataTableView",self.imageFinalPath)
                            self.m_tableView.reloadData()
                            self.hidePleaseWait()
                            //self.scrollToTop()
                        }
                        
                    }
                    task.resume()
                }
            }
        }
    }
    
    //steps call
    func getClaimProcInstructionInfoData(LayoutOfClaim: String){
        if(isConnectedToNetWithAlert())
        {
            let array = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            if(array.count>0)
            {
                m_employeedict=array[0]
                if (m_employeedict==nil)
                {
                    
                    //            m_employeedict=nil
                    displayActivityAlert(title: "noDataFound".localized())
                    
                }
                else
                {
                    
                    showPleaseWait(msg: "Please wait...")
                    
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    var employeesrno = String()
                    
                    if let childNo = m_employeedict?.groupChildSrNo
                    {
                        groupchildsrno = String(childNo)
                        groupchildsrno = try! AesEncryption.encrypt(groupchildsrno)
                    }
                    
                    if let empNo = m_employeedict?.empSrNo
                    {
                        employeesrno = String(empNo)
                        employeesrno = try! AesEncryption.encrypt(employeesrno)
                    }
                   
                    if selectedIndexPosition == 0{
                        if let oegrp = m_employeedict?.oe_group_base_Info_Sr_No
                        {
                            oegrpbasinfsrno = String(oegrp)
                            oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                        }
                    }else{
                        oegrpbasinfsrno = selectedPolicyValue
                        oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                    }
                    
                    print("m_productCode : ",m_productCode," : groupchildsrno: ",groupchildsrno," : employeesrno: ",employeesrno," : oegrpbasinfsrno: ",oegrpbasinfsrno)
                  
                    //Testing Values
                    //oegrpbasinfsrno = "1047"
                    //let product = "GMC"
                    
                    let product = m_productCode
                    
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getClaimProcInstructionInfoPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded, product: product, layoutOfClaim: LayoutOfClaim))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
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
                    
                    
                    print("GetClaimProcInstructionInfoData url: ",urlreq)
                    
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        guard let data = data, error == nil else {
                            print("Error: ",error?.localizedDescription ?? "No data")
                            return
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        
                        if let data = json?["ClaimProcInstructionInfo"] as? [Any] {
                            
                            self.instructArray = json?["ClaimProcInstructionInfo"] as! [[String : String]]
                            
                            
                            print("instructArray : ",self.instructArray)
                            
                            for item in data {
                                if let object = item as? [String: Any] {
                                    
                                    // DEF_INST_TEXT_FROM_FILE_PATH
                                    let DEF_INST_TEXT_FROM_FILE_PATH = object["DEF_INST_TEXT_FROM_FILE_PATH"] as? String ?? "0"
                                    print("DEF_INST_TEXT_FROM_FILE_PATH: \(DEF_INST_TEXT_FROM_FILE_PATH)")
                                    self.stepsfilename = DEF_INST_TEXT_FROM_FILE_PATH
                                    
                                    self.stepsFilePath = WebServiceManager.getSharedInstance().getStepsFilePathPortal(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, product: product, layoutOfClaim: LayoutOfClaim)
                                    
                                    self.stepsFinalPath = self.stepsFilePath+self.stepsfilename
                                    
                                }
                            }
                        }
                        DispatchQueue.main.async
                        {
                            
                            self.getStepsFileHTMLData(LayoutOfClaim: LayoutOfClaim)
                            self.getEmergencyContactNoData()
                            self.getClaimProcTextPathData(LayoutOfClaim: LayoutOfClaim)
                            self.m_tableView.reloadData()
                            self.hidePleaseWait()
                            //self.scrollToTop()
                        }
                        
                    }
                    task.resume()
                }
            }
        }
    }
    
    func getStepsFileHTMLData(LayoutOfClaim: String){
        if(isConnectedToNetWithAlert())
        {
            let myURLString = self.stepsFinalPath
            print("stepsFinalPath url: ",stepsFinalPath)
            guard let myURL = URL(string: myURLString) else {
                print("Error: \(myURLString) doesn't seem to be a valid URL")
                return
            }
            
            do {
                let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
                self.stepsData = myHTMLString.htmlToString
                
                print("Steps data: ",self.stepsData)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    //ADDITIONAL INSTRUCTION
    func getClaimProcTextPathData(LayoutOfClaim: String){
        if(isConnectedToNetWithAlert())
        {
            let array = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            if(array.count>0)
            {
                m_employeedict=array[0]
                if (m_employeedict==nil)
                {
                    
                    //            m_employeedict=nil
                    displayActivityAlert(title: "noDataFound".localized())
                    
                }
                else
                {
                    
                    showPleaseWait(msg: "Please wait...")
                    
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    var employeesrno = String()
                    
                    if let childNo = m_employeedict?.groupChildSrNo
                    {
                        groupchildsrno = String(childNo)
                        groupchildsrno = try! AesEncryption.encrypt(groupchildsrno)
                    }
                   
                    if let empNo = m_employeedict?.empSrNo
                    {
                        employeesrno = String(empNo)
                        employeesrno = try! AesEncryption.encrypt(employeesrno)
                    }
                   
                    if selectedIndexPosition == 0{
                        if let oegrp = m_employeedict?.oe_group_base_Info_Sr_No
                        {
                            oegrpbasinfsrno = String(oegrp)
                            oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                        }
                    }else{
                        oegrpbasinfsrno = selectedPolicyValue
                        oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                    }
                    
                    print("m_productCode : ",m_productCode," : groupchildsrno: ",groupchildsrno," : employeesrno: ",employeesrno," : oegrpbasinfsrno: ",oegrpbasinfsrno)
                  
                    //Testing Values
                    //oegrpbasinfsrno = "1047"
                    //let product = "GMC"
                    
                    let product = m_productCode
                    
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getClaimProcTextPathPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded, product: product, layoutOfClaim: LayoutOfClaim))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
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
                    
                    
                    print("getClaimProcTextPathData url: ",urlreq)
                    
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        guard let data = data, error == nil else {
                            print("Error: ",error?.localizedDescription ?? "No data")
                            return
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        
                        if let data = json?["ClaimProcTextPath"] as? [Any] {
                            
                            self.claimProcTextPathArray = json?["ClaimProcTextPath"] as! [[String : String]]
                            
                            
                            print("claimProcTextPathArray : ",self.claimProcTextPathArray)
                            
                            for item in data {
                                if let object = item as? [String: Any] {
                                    
                                    // CLM_PROC_P1_WYSIWYG_TEXT_PATH
                                    let CLM_PROC_P1_WYSIWYG_TEXT_PATH = object["CLM_PROC_P1_WYSIWYG_TEXT_PATH"] as? String ?? "0"
                                    print("CLM_PROC_P1_WYSIWYG_TEXT_PATH: \(CLM_PROC_P1_WYSIWYG_TEXT_PATH)")
                                    self.claimProcfilename = CLM_PROC_P1_WYSIWYG_TEXT_PATH
                                    
                                    self.claimProcFilePath =   WebServiceManager.getSharedInstance().getClaimProcFilePathPortal(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, product: product, layoutOfClaim: LayoutOfClaim)
                                    
                                    self.claimProcFinalPath = self.claimProcFilePath+self.claimProcfilename
                                }
                            }
                        }
                        DispatchQueue.main.async
                        {
                            self.getClaimProcFileHTMLData(LayoutOfClaim: LayoutOfClaim)
                            self.m_tableView.reloadData()
                            self.hidePleaseWait()
                            //self.scrollToTop()
                        }
                        
                    }
                    task.resume()
                }
            }
        }
    }
    
    //ADDITION INSTRUCTIONS
    func getClaimProcFileHTMLData(LayoutOfClaim: String){
        if(isConnectedToNetWithAlert())
        {
            let myURLString = self.claimProcFinalPath
            print("claimProcFinalPath url: ",claimProcFinalPath)
            guard let myURL = URL(string: myURLString) else {
                print("Error: \(myURLString) doesn't seem to be a valid URL")
                return
            }
            
            do {
                let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
                self.claimProcData = myHTMLString.htmlToString
                print("claimProcData data: ",self.claimProcData)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    //Emergency ContactNo
    func getEmergencyContactNoData(){
        if(isConnectedToNetWithAlert())
        {
            
            let groupInfoArray  =  DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "GMC")
            
            let groupDict = groupInfoArray[0]
            if(groupInfoArray.count>0)
            {
                let tpaCode = groupDict.tpa_Code!
                
                print("TPACODE IS: ",tpaCode)
                
                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEmergencyContactNoPortal(TpaCode: tpaCode))
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?
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
                
                print("getEmergencyContactNoData url: ",urlreq)
                
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error: ",error?.localizedDescription ?? "No data")
                        return
                    }
                    
                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    
                    if let data = json?["EmergencyContactNo"] as? [Any] {
                        
                        self.emergencyArray = json?["EmergencyContactNo"] as! [[String : String]]
                        
                        
                        print("emergencyArray : ",self.emergencyArray)
                        
                        for item in data {
                            if let object = item as? [String: Any] {
                                
                                // CLM_PROC_P1_IMG_PATH
                                let CONTACT_NUMBER = object["CONTACT_NUMBER"] as? String ?? "0"
                                print("CONTACT_NUMBER: \(CONTACT_NUMBER)")
                                self.allemergencyNo = CONTACT_NUMBER
                            }
                        }
                    }
                    DispatchQueue.main.async
                    {
                        self.m_tableView.reloadData()
                        self.hidePleaseWait()
                        //self.scrollToTop()
                    }
                    
                }
                task.resume()
                
            }
        }
    }
    
    func addTarget()
    {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.selectPolicyName (_:)))
        self.PolicylblView.addGestureRecognizer(gesture)
        
    }
    
    @objc func selectPolicyName(_ sender:UITapGestureRecognizer)
    {
        print("selectPolicyName 1029")
        
        let policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        print("policyDataArray: ",policyDataArray)
        
        if policyDataArray.count > 0 {
            let vc  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"SelectPolicyOptionsVC") as! SelectPolicyOptionsVC
            //vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            vc.policyDelegateObj = self
            vc.policyCount = policyDataArray.count
            UserDefaults.standard.set(true, forKey: "isPolicyChanged")
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func policyChangedDelegateMethod() {
        print("Called policyChangedDelegateMethod")
        
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        print("selectedIndexPosition is : ",selectedIndexPosition)
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
            
        }
        
        if m_productCode == "GMC"{
            GMCTabSeleted()
        }
        else if m_productCode == "GPA"{
            GPATabSelected()
        }
        else if m_productCode == "GTL"{
            GTLTabSelected()
        }
    }
}



