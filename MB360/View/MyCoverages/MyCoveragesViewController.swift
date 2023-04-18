//
//  MyCoveragesViewController.swift
//  MyBenefits
//
//  Created by Semantic on 12/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class MyCoveragesViewController: UIViewController,XMLParserDelegate, NewPoicySelectedDelegate{
  
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var m_topBarTopVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_stackView: UIStackView!
    
    @IBOutlet weak var GTLShadowView: UIView!
    @IBOutlet weak var GPAShadowView: UIView!
    @IBOutlet weak var m_shadowView: UIView!
    @IBOutlet weak var m_topBarView: UIView!
    
    
    @IBOutlet weak var m_topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_GMCTab: UIButton!
    @IBOutlet weak var GPATab: UIButton!
    @IBOutlet weak var GTLTab: UIButton!
    @IBOutlet weak var GMCLine: UILabel!
    @IBOutlet weak var GPALine: UILabel!
    @IBOutlet weak var GTLLine: UILabel!
    @IBOutlet weak var m_tableView: UITableView!
    
    @IBOutlet weak var errorPageView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var PolicylblView: UIView!
    @IBOutlet weak var policyNamelbl: UILabel!
    @IBOutlet weak var policyButtonView: UIView!
    @IBOutlet weak var policyButtonLbl: UILabel!
    
    
    
    var errorState = 0
    var selectedPolicyStatus = 0
    var topupValues = "0"
    
    let reuseIdentifier = "cell1"
    let dictionaryKeys = ["BENEFICIARY_NAME", "AGE", "DATE_OF_BIRTH", "RELATION_WITH_EMPLOYEE","BASE_SUM_INSURED","TOPUP_SUM_INSURED","EMPLOYEE_ID","GROUPNAME","SI_TABLED","SI_TABLEB","SI_TABLEC","SI_TABLEA","OTHER_SUM_INSURED","PERMNT_PAR_DISAB_SUM_INSURED","PERMNT_TOT_DISAB_SUM_INSURED","TERMINAL_ILLNESS_SUM_INSURED","ACC_DEATH_BENEFIT_SUM_INSURED","CRITICAL_ILLNESS_SUM_INSURED","TOTAL_SI"]
    
    
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var personDetailsDict : PERSON_INFORMATION?
    var personDetailsArray = Array<PERSON_INFORMATION>()
    var sortedPersonDetailsArray = Array<PERSON_INFORMATION>()
    //var m_productCode = String()
    var m_gender = String()
    var relation = String()
    var m_isTopupAvailable = Bool()
    var m_employeedict : EMPLOYEE_INFORMATION?
    let menuController = UIMenuController.shared
    var m_policyDetailsArray = Array<OE_GROUP_BASIC_INFORMATION>()
    var datasource = [ExpandedCoveragesCellContent]()
    var selectedRowIndex = -1
    var isFromSideBar = Bool()
    var m_employeeDict : EMPLOYEE_INFORMATION?
    
    var selectedPolicyValue = ""
    var m_productCode = String()
    var policyDetailArray: [[String: String]]?
    var empolyeeDetailArray: [[String : Any]]?
    var stringDict = [String: String]()
    
    
    var selectedIndexPosition = -1
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupFontsUI()
        //Top bar hide buttons
        m_GMCTab.isHidden=true
        GPATab.isHidden=true
        GTLTab.isHidden=true
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        
        print("MyCoverages Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
       
        
        m_noInternetView.isHidden=true
        m_tableView.register(PolicyDetailsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib = UINib (nibName: "PolicyDetailsTableViewCell", bundle: nil)
        m_tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        m_tableView.register(SumInsuredTableViewCell.self, forCellReuseIdentifier: "cell")
        m_tableView.register(UINib (nibName: "SumInsuredTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        m_tableView.register(EmployeeFamilyDetailsTableViewCell.self, forCellReuseIdentifier: "Cell")
        m_tableView.register(UINib (nibName: "EmployeeDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        m_tableView.tableFooterView=UIView()
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        
        self.m_tableView.estimatedRowHeight = 320.0;
        self.m_tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.m_tableView.setNeedsLayout()
        self.m_tableView.layoutIfNeeded()
        errorPageView.isHidden = true
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        print("m_productCode: ",m_productCode)
        
        /*
        if m_productCode == "GMC"{
            GMCTabSeleted()
        }
        else if m_productCode == "GPA"{
            GPATabSelect()
        }
        else if m_productCode == "GTL"{
            GTLTabSelect()
        }
        */
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
            GPATabSelect()
        }
        else if m_productCode == "GTL"{
            GTLTabSelect()
        }
        
        setData()
        addTarget()
        
    }
    
    func setupFontsUI(){
        
        m_GMCTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        
        GPATab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        
        GTLTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        
        policyNamelbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        policyNamelbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        policyButtonLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        policyButtonLbl.textColor = FontsConstant.shared.app_WhiteColor
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        self.tabBarController?.tabBar.isHidden=false
        m_topBarView.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        PolicylblView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
        //navigationItem.rightBarButtonItem=getRightBarButton()
        //policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        
    }
    func setData()
    {
        
        navigationController?.isNavigationBarHidden=false
        navigationItem.title="link2Name".localized()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        navigationItem.leftBarButtonItem = getBackButton()
        
        
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        //        menuButton.backgroundColor = UIColor.white
        //        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        //        menuButton.setImage(UIImage(named:"Home"), for: .normal)
        
        
        if let adminSettingsDict = UserDefaults.standard.value(forKey: "AdminSettingsDic")as? NSDictionary
        {
            //            m_isTopupAvailable = adminSettingsDict.value(forKey: "IS_TOPUP_OPTION_AVAILABLE") as! String
        }
        // setTopbarProducts()
        
    }
   
    
    func getLeftBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    
    func setTopbarProducts()
    {
        
        if(m_productCodeArray.count==1)
        {
            if(m_productCodeArray.contains("GMC"))
            {
                GMCTabSeleted()
                m_GMCTab.isUserInteractionEnabled=false
                GPATab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=false
                
                GPATab.setTitleColor(UIColor.white, for: .normal)
                GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GPA"))
            {
                GPATabSelect()
                m_GMCTab.isUserInteractionEnabled=false
                GPATab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=false
                
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
                GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GTL"))
            {
                GTLTabSelect()
                GPATab.isUserInteractionEnabled=false
                m_GMCTab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=false
                
                GPATab.setTitleColor(UIColor.white, for: .normal)
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
            }
        }
        else if(m_productCodeArray.count==2)
        {
            m_topBarView.isHidden=false
            if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GPA"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                GPATab.isUserInteractionEnabled=true
                GTLTab.isUserInteractionEnabled=false
                m_GMCTab.isHidden=false
                GPATab.isHidden=false
                GTLTab.isHidden=true
                GMCTabSeleted()
                
            }
            else if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                GPATab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=false
                GPATab.isHidden=true
                GTLTab.isHidden=false
                GMCTabSeleted()
            }
            else if(m_productCodeArray.contains("GPA") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=false
                GPATab.isUserInteractionEnabled=true
                GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=true
                GPATab.isHidden=false
                GTLTab.isHidden=false
                GPATabSelect()
                
            }
            else
            {
                getEnrollmentDetails()
                m_topBarHeightConstraint.constant=0
                m_topBarTopVerticalConstraint.constant=0
                m_topBarView.isHidden=true
            }
        }
        else
        {
            GMCTabSeleted()
        }
    }
    @objc func leftButtonClicked()
    {
        
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        //        tabBarController!.selectedIndex = 2
    }
    @objc override func backButtonClicked()
    {
        
        self.tabBarController?.tabBar.isHidden=false
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    func GMCTabSeleted()
    {
        m_productCode="GMC"
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
        
        self.errorState = 0
        m_GMCTab.setTitle("GHI", for: .normal)
        m_shadowView.dropShadow()
        GTLShadowView.layer.masksToBounds=true
        GPAShadowView.layer.masksToBounds=true
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//m_GMCTab.frame.size.height/2
        //m_GMCTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        GMCLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        GPALine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        GPATab.layer.borderColor=UIColor.white.cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        GTLTab.layer.borderColor=UIColor.white.cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        
        GPATab.layer.borderWidth = 2
        GTLTab.layer.borderWidth = 2
        
        GPATab.layer.cornerRadius = cornerRadiusForView//8
        GTLTab.layer.cornerRadius = cornerRadiusForView//8
        m_shadowView.layer.cornerRadius = cornerRadiusForView//8
        
        GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        //getEnrollmentDetails()
        getPolicyCoveragesDetails_Data()
    }
   
    func getEnrollmentDetails()
    {
        if(isConnectedToNet())
        {
            
            print("m_productCode: ",m_productCode)
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            
            if(userArray.count>0)
            {
                m_employeedict = userArray[0]
                print("m_employeedict: ",m_employeedict)
                //  getCovragesDetails()
                //                    getenrollmentUrl(employeedict: m_employeedict)
                
                
            }
            
            //not getting emp policy details values for GPA,GTL from loadSession
            getFinalCovragesDetails()
            
        }
        else
        {
            
            m_noInternetView.isHidden=false
            
            
            
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime)
            {
                self.m_noInternetView.isHidden=true
                //self.getCovragesDetails()
                self.getFinalCovragesDetails()
                
            }
            
           
        }
    }
   
    func getFinalCovragesDetails()
    {
        personDetailsArray=[]
        let defaultPolcy = m_employeedict?.oe_group_base_Info_Sr_No
        let selectedValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as? String ?? "0"
        
        let selectedPolicy = Int64(selectedValue)
        
        print("selectedPolicyValue: ",defaultPolcy)
        print("selectedPolicyValue1: ",selectedPolicy)
        
        if selectedPolicy == 0{
            //If policy is not selected or 1st time login
            m_policyDetailsArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetailsEmpSr(oegrpBasicInfo: defaultPolcy!)
            
        }else{
            m_policyDetailsArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetailsEmpSr(oegrpBasicInfo: selectedPolicy!)
        }
        
        print(m_policyDetailsArray,personDetailsArray)
        
        
        
        sortedPersonDetailsArray=DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:m_productCode,relationName:"EMPLOYEE")
        
        print(sortedPersonDetailsArray)
        
        //replace this "retrieveEmployeePersonDetails" With This "retrieveEmployeePersonDependants" Methods
        
        let empSrNo = DatabaseManager.sharedInstance.getSelectedEmpSrNo()
        
        //        let arrayofSon = DatabaseManager.sharedInstance.retrieveEmployeeDependantsFrom(empSrNo: empSrNo,productCode: m_productCode, relationName: "SON")
        
        if m_spouse.lowercased() == "wife" {
            let array = DatabaseManager.sharedInstance.retrieveEmployeeDependantsFrom(empSrNo: empSrNo,productCode: m_productCode, relationName: "WIFE")
            
            if(array.count>0)
            {
                personDetailsArray.append(array[0])
            }
        }
        else {
            let array = DatabaseManager.sharedInstance.retrieveEmployeeDependantsFrom(empSrNo: empSrNo,productCode: m_productCode, relationName: "HUSBAND")
            
            if(array.count>0)
            {
                personDetailsArray.append(array[0])
            }
            
        }
        
        
        let arrayofSon = DatabaseManager.sharedInstance.retrieveEmployeeDependantsFrom(empSrNo: empSrNo,productCode: m_productCode, relationName: "SON")
        
        if(arrayofSon.count>0)
        {
            
            if(arrayofSon.count==2)
            {
                personDetailsArray.append(arrayofSon[0])
                personDetailsArray.append(arrayofSon[1])
            }
            else if(arrayofSon.count==3)
            {
                personDetailsArray.append(arrayofSon[0])
                personDetailsArray.append(arrayofSon[1])
                personDetailsArray.append(arrayofSon[2])
            }
            else
            {
                personDetailsArray.append(arrayofSon[0])
            }
        }
        
        
        let arrayofDaughter = DatabaseManager.sharedInstance.retrieveEmployeeDependantsFrom(empSrNo: empSrNo,productCode: m_productCode, relationName: "DAUGHTER")
        
        //DatabaseManager.sharedInstance.retrieveEmployeePersonDependants(productCode: m_productCode, relationName: "DAUGHTER")
        if(arrayofDaughter.count>0)
        {
            if(arrayofDaughter.count==2)
            {
                personDetailsArray.append(arrayofDaughter[0])
                personDetailsArray.append(arrayofDaughter[1])
            }
            else if(arrayofDaughter.count==3)
            {
                personDetailsArray.append(arrayofDaughter[0])
                personDetailsArray.append(arrayofDaughter[1])
                personDetailsArray.append(arrayofDaughter[2])
            }
            else
            {
                personDetailsArray.append(arrayofDaughter[0])
            }
        }
        
        let fatherarray = DatabaseManager.sharedInstance.retrieveEmployeeDependantsFrom(empSrNo: empSrNo,productCode: m_productCode, relationName: "FATHER")
        
        //DatabaseManager.sharedInstance.retrieveEmployeePersonDependants(productCode: m_productCode, relationName: "FATHER")
        if(fatherarray.count>0)
        {
            personDetailsArray.append(fatherarray[0])
        }
        let motherarray = DatabaseManager.sharedInstance.retrieveEmployeeDependantsFrom(empSrNo: empSrNo,productCode: m_productCode, relationName: "MOTHER")
        
        
        // DatabaseManager.sharedInstance.retrieveEmployeePersonDependants(productCode:  m_productCode, relationName: "MOTHER")
        if(motherarray.count>0)
        {
            personDetailsArray.append(motherarray[0])
        }
        let fatherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeeDependantsFrom(empSrNo: empSrNo,productCode: m_productCode, relationName: "FATHER-IN-LAW")
        
        // DatabaseManager.sharedInstance.retrieveEmployeePersonDependants(productCode:  m_productCode, relationName: "FATHER-IN-LAW")
        if(fatherInLawarray.count>0)
        {
            personDetailsArray.append(fatherInLawarray[0])
        }
        let motherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeeDependantsFrom(empSrNo: empSrNo,productCode: m_productCode, relationName: "MOTHER-IN-LAW")
        
        //DatabaseManager.sharedInstance.retrieveEmployeePersonDependants(productCode:  m_productCode, relationName: "MOTHER-IN-LAW")
        if(motherInLawarray.count>0)
        {
            personDetailsArray.append(motherInLawarray[0])
        }
        
        
        if sortedPersonDetailsArray.count > 0 {
            personDetailsArray.insert(sortedPersonDetailsArray[0], at: 0)
            
            print(personDetailsArray)
        }
        m_tableView.reloadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func GMCTabSelected(_ sender: Any)
    {
        selectedPolicyStatus = 1
        selectedIndexPosition = 0
        GMCTabSeleted()
    }
    
    @IBAction func GPATabSelected(_ sender: Any)
    {
        selectedPolicyStatus = 1
        selectedIndexPosition = 0
        GPATabSelect()
        
    }
    @IBAction func GTLTabSelected(_ sender: Any)
    {
        selectedPolicyStatus = 1
        selectedIndexPosition = 0
        GTLTabSelect()
    }
    func GPATabSelect()
    {
        m_productCode = "GPA"
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        print("selectedIndexPosition: ",selectedIndexPosition)
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
        
        self.errorState = 0
        GPATab.setTitle("GPA", for: .normal)
        GPAShadowView.dropShadow()
        m_shadowView.layer.masksToBounds = true
        GTLShadowView.layer.masksToBounds=true
        
        
        GPATab.layer.masksToBounds=true
        GPATab.layer.cornerRadius = cornerRadiusForView//GPATab.frame.size.height/2
        //GPATab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        GPATab.layer.borderWidth=0
        GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        GPALine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        GPATab.setTitleColor(UIColor.white, for: .normal)
        
        GMCLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        GTLTab.layer.borderColor=UIColor.white.cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        
        m_GMCTab.layer.borderWidth = 2
        GTLTab.layer.borderWidth = 2
        
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        GTLTab.layer.cornerRadius = cornerRadiusForView//8
        
        GPAShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        
        
        getPolicyCoveragesDetails_Data()
        //getEnrollmentDetails()
        //personDetailsArray=[]
        //personDetailsArray.insert(sortedPersonDetailsArray[0], at: 0)
        //print(personDetailsArray)
        //scrollToTop()
        m_tableView.reloadData()
        
    }
    func scrollToTop()
    {
        let indexpath = IndexPath(row: 0, section: 0)
        m_tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
    }
    func GTLTabSelect()
    {
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
        print("policyDataArray:: ",policyDataArray)

        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        self.errorState = 0
        GTLTab.setTitle("GTL", for: .normal)
        GTLShadowView.dropShadow()
        GPAShadowView.layer.masksToBounds=true
        m_shadowView.layer.masksToBounds=true
        GTLTab.layer.masksToBounds=true
        GTLTab.layer.cornerRadius = cornerRadiusForView//GTLTab.frame.size.height/2
        //GTLTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        GTLTab.layer.borderWidth=0
        GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        GTLLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        GTLTab.setTitleColor(UIColor.white, for: .normal)
        
        GMCLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        GPALine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        GPATab.layer.borderColor=UIColor.white.cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        
        GPATab.layer.borderWidth = 2
        m_GMCTab.layer.borderWidth = 2
        
        GPATab.layer.cornerRadius = cornerRadiusForView//8
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        GTLShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        
        getPolicyCoveragesDetails_Data()
        //getEnrollmentDetails()
        //personDetailsArray=[]
        //personDetailsArray.insert(sortedPersonDetailsArray[0], at: 0)
        //scrollToTop()
        m_tableView.reloadData()
        
    }
    
    //MARK:- GHI TopUp
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
                print("MyCoverages url:",url)
                
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
                            print("Started parsing Top Up...")
                            print(data)
                            
                            if let jsonResult = data as? NSDictionary
                            {
                                print("Admin Data Found")
                                if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                    if let status = msgDict.value(forKey: "Status") as? Bool {
                                        
                                        if status == true
                                        {
                                            print(jsonResult)
                                            
                                            
                                            UserDefaults.standard.set(false, forKey:"gmcPolicy")
                                            UserDefaults.standard.set(false, forKey:"gpaPolicy")
                                            UserDefaults.standard.set(false, forKey:"gtlPolicy")
                                            
                                            
                                            //                                                if let IsEnrollmentSaved = jsonResult.value(forKey: "IsEnrollmentSaved") as? Int {
                                            //                                                    UserDefaults.standard.set(String(IsEnrollmentSaved), forKey: "IsEnrollmentSaved")
                                            //                                                    if IsEnrollmentSaved == 1 {
                                            //                                                        self.m_enrollmentStatus = true
                                            //                                                    }
                                            //                                                    else {
                                            //                                                        self.m_enrollmentStatus = false
                                            //                                                    }
                                            //
                                            //
                                            //                                                }
                                            //
                                            //                                                if let IsWindowPeriodOpen = jsonResult.value(forKey: "IsWindowPeriodOpen") as? Int {
                                            //                                                    UserDefaults.standard.set(String(IsWindowPeriodOpen), forKey: "IsWindowPeriodOpen")
                                            //                                                    if IsWindowPeriodOpen == 1 {
                                            //                                                        self.isWindowPeriodOpen = true
                                            //                                                        m_windowPeriodStatus = true
                                            //                                                    }
                                            //                                                    else {
                                            //                                                        self.isWindowPeriodOpen = false
                                            //                                                        m_windowPeriodStatus = false
                                            //                                                    }
                                            //                                                }
                                            
                                            if let ExtGroupSrNo = jsonResult.value(forKey: "ExtGroupSrNo") as? Int {
                                                UserDefaults.standard.set(String(ExtGroupSrNo), forKey: "ExtGroupSrNoEnrollment")
                                            }
                                            
                                            
                                            //SumInsuredData
                                            if let tempDict = jsonResult.value(forKey: "SumInsuredData") as? NSDictionary {
                                                if let dictMainTopUp = tempDict.value(forKey: "Enroll_Topup_Options") as? NSDictionary {
                                                    
                                                    var gmcTopUp = false
                                                    var gpaTopUp = false
                                                    var gtlTopUp = false
                                                    
                                                    UserDefaults.standard.set("0", forKey:"ghiSelectedTopup")
                                                    UserDefaults.standard.set("0", forKey:"gpaSelectedTopup")
                                                    UserDefaults.standard.set("0", forKey:"gtlSelectedTopup")
                                                    
                                                    
                                                    if let topUpApplicabilityDict = dictMainTopUp.value(forKey: "TopupApplicability_data") as? NSDictionary {
                                                        if let gmc = topUpApplicabilityDict.value(forKey: "GMCTopup") as? String {
                                                            if gmc == "YES" {
                                                                gmcTopUp = true
                                                                UserDefaults.standard.set(true, forKey:"gmcPolicy")
                                                                
                                                            }
                                                        }
                                                        
                                                        if let gpa = topUpApplicabilityDict.value(forKey: "GPATopup") as? String {
                                                            if gpa == "YES" {
                                                                gpaTopUp = true
                                                                UserDefaults.standard.set(true, forKey:"gpaPolicy")
                                                                
                                                            }
                                                        }
                                                        
                                                        if let gtl = topUpApplicabilityDict.value(forKey: "GTLTopup") as? String {
                                                            if gtl == "YES" {
                                                                gtlTopUp = true
                                                                UserDefaults.standard.set(true, forKey:"gtlPolicy")
                                                                
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                    if let topUPEnrollDict = dictMainTopUp.value(forKey: "TopupSumInsured_Cls_data") as? NSDictionary
                                                    {
                                                        if gmcTopUp == true {
                                                            if let gmcTopUpArray = topUPEnrollDict.value(forKey: "GMCTopupOptions_data") as? [NSDictionary] {
                                                                for gmcOuter in gmcTopUpArray {
                                                                    let baseGmc = gmcOuter.value(forKey: "BASE_SI") as? String
                                                                    print("BASE_SI====\(baseGmc)")
                                                                    UserDefaults.standard.set(baseGmc, forKey: "baseGmc")
                                                                    
                                                                    if let topUpGMCArray = gmcOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                                    {
                                                                        //DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GMC")
                                                                        for topUpObjDict in topUpGMCArray {
                                                                            let userDict = ["productCode":"GMC","BaseSumInsured":baseGmc,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                            
                                                                            if let isOpted = topUpObjDict.value(forKey: "Opted") as? String {
                                                                                if isOpted == "YES" {
                                                                                    UserDefaults.standard.set(topUpObjDict.value(forKey: "TSumInsured"), forKey: "ghiSelectedTopup")
                                                                                }
                                                                            }
                                                                            //  DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict as NSDictionary)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        if gpaTopUp == true {
                                                            if let gpaTopUpArray = topUPEnrollDict.value(forKey: "GPATopupOptions_data") as? [NSDictionary] {
                                                                for gpaOuter in gpaTopUpArray {
                                                                    let baseGpa = gpaOuter.value(forKey: "BASE_SI") as? String
                                                                    print("BASE_SI====\(baseGpa)")
                                                                    
                                                                    if let topUpGPAArray = gpaOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                                    {
                                                                        // DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GPA")
                                                                        
                                                                        for topUpObjDict in topUpGPAArray {
                                                                            let userDict1 = ["productCode":"GPA","BaseSumInsured":baseGpa,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                            
                                                                            if let isOpted = topUpObjDict.value(forKey: "Opted") as? String {
                                                                                if isOpted == "YES" {
                                                                                    UserDefaults.standard.set(topUpObjDict.value(forKey: "TSumInsured"), forKey: "gpaSelectedTopup")
                                                                                }
                                                                            }
                                                                            //  DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict1 as NSDictionary)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        
                                                        if gtlTopUp == true {
                                                            if let gtlTopUpArray = topUPEnrollDict.value(forKey: "GTLTopupOptions_data") as? [NSDictionary] {
                                                                for gtlOuter in gtlTopUpArray {
                                                                    let baseGtl = gtlOuter.value(forKey: "BASE_SI") as? String
                                                                    print("BASE_SI====\(baseGtl)")
                                                                    
                                                                    if let topUpGTLArray = gtlOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                                    {
                                                                        //  DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GTL")
                                                                        for topUpObjDict in topUpGTLArray {
                                                                            let userDict2 = ["productCode":"GTL","BaseSumInsured":baseGtl,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                            if let isOpted = topUpObjDict.value(forKey: "Opted") as? String {
                                                                                if isOpted == "YES" {
                                                                                    UserDefaults.standard.set(topUpObjDict.value(forKey: "TSumInsured"), forKey: "gtlSelectedTopup")
                                                                                }
                                                                            }
                                                                            //   DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict2 as NSDictionary)
                                                                            
                                                                            
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }//topUPEnrollDict
                                                    
                                                    
                                                    
                                                    self.m_tableView.reloadData()
                                                    // let indexset = IndexSet(integer: 1)
                                                }
                                                //self.tableView.reloadSections([1], with: .none)
                                            }
                                            else {
                                                //No Data found
                                            }
                                        }//status
                                    }//msgDict
                                }//jsonResult
                            }
                        }
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
            }//userArray
        }
    }
    
    
    func getPolicyCoveragesDetails_Data(){
        if(isConnectedToNetWithAlert())
        {
            let array = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            if(array.count>0)
            {
                m_employeedict=array[0]
                if (m_employeedict==nil)
                {
                    displayActivityAlert(title: "noDataFound".localized())
                    
                }
                else
                {
                    
                    showPleaseWait(msg: "Please wait...")
                    
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    var productType = String()
                    var employeesrno = String()
                    
                    if let childNo = m_employeedict?.groupChildSrNo
                    {
                        groupchildsrno = String(childNo)
                        groupchildsrno = try! AesEncryption.encrypt(groupchildsrno)
                    }
                    print("selectedIndexPosition: ",selectedIndexPosition)
                    if selectedIndexPosition == 0{
                        if let oeinfNo = m_employeedict?.oe_group_base_Info_Sr_No
                        {
                            oegrpbasinfsrno = String(oeinfNo)
                            oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                        }
                    }else{
                        oegrpbasinfsrno = selectedPolicyValue
                        oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                    }
                    
                    if let empNo = m_employeedict?.empSrNo
                    {
                        employeesrno = String(empNo)
                        employeesrno = try! AesEncryption.encrypt(employeesrno)
                    }
                    
                    let product = "GMC"
                    productType = m_productCode
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getPolicyCoveragesDetailsPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded, productType: productType, employeeSrNo: employeesrno.URLEncoded))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
                    request.httpMethod = "GET"
                    
                    let session = URLSession(configuration: .default)
                    var encryptedUserName = try! AesEncryption.encrypt(m_authUserName_Portal)
                    var encryptedPassword = try! AesEncryption.encrypt(m_authPassword_Portal)
                    let authString = String(format: "%@:%@", encryptedUserName, encryptedPassword)
                    let authData = authString.data(using: String.Encoding.utf8)!
                    let base64AuthString = authData.base64EncodedString()
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                    request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                    
                    
                    print("getPolicyCoveragesDetails_Data url: ",urlreq)
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        guard let data = data, error == nil else {
                            print(error?.localizedDescription ?? "No data")
                            return
                        }
                        
                        if let httpresponse = response as? HTTPURLResponse
                        {
                            if httpresponse.statusCode == 200{
                                do{
                                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                    
                                    print("JSON: ",json)
                                    
                                    if let data = json?["Coverages_Data"] as? [Any] {
                                        
                                        self.empolyeeDetailArray = json?["Coverages_Data"] as? [[String : Any]]
                                        
                                        print("empolyeeDetailArray : ",self.empolyeeDetailArray)
                                        if self.empolyeeDetailArray?.count ?? 0 > 0
                                        {
                                            for item in data {
                                                if let object = item as? [String: Any] {
                                                    
                                                    // EMPLOYEE_IDENTIFICATION_NO
                                                    let EMPLOYEE_IDENTIFICATION_NO = object["EMPLOYEE_IDENTIFICATION_NO"] as? String ?? "0"
                                                    print("EMPLOYEE_IDENTIFICATION_NO: \(EMPLOYEE_IDENTIFICATION_NO)")
                                                    
                                                    // PERSON_NAME
                                                    let PERSON_NAME = object["PERSON_NAME"] as? String ?? ""
                                                    print("PERSON_NAME: \(PERSON_NAME)")
                                                    
                                                    // GENDER
                                                    let GENDER = object["GENDER"] as? String ?? ""
                                                    print("GENDER: \(GENDER)")
                                                    
                                                    // DATE_OF_BIRTH
                                                    let DATE_OF_BIRTH = object["DATE_OF_BIRTH"] as? String ?? "0"
                                                    print("DATE_OF_BIRTH: \(DATE_OF_BIRTH)")
                                                    
                                                    // AGE
                                                    let AGE = object["AGE"] as? String ?? "0"
                                                    print("AGE: \(AGE)")
                                                    
                                                    // SORT_ORDER
                                                    let SORT_ORDER = object["SORT_ORDER"] as? String ?? "0"
                                                    print("SORT_ORDER: \(SORT_ORDER)")
                                                    
                                                    // RELATION
                                                    let RELATION = object["RELATION"] as? String ?? "0"
                                                    print("RELATION: \(RELATION)")
                                                    
                                                    // BASE_SUM_INSURED
                                                    let BASE_SUM_INSURED = object["BASE_SUM_INSURED"] as? String ?? "0"
                                                    print("BASE_SUM_INSURED: \(BASE_SUM_INSURED)")
                                                    
                                                    // TOP_UP_FLAG
                                                    let TOP_UP_FLAG = object["TOP_UP_FLAG"]
                                                    print("TOP_UP_FLAG: \(TOP_UP_FLAG)")
                                                    
                                                    // TOP_UP_BASE_SUM_INSURED
                                                    let TOP_UP_BASE_SUM_INSURED = object["TOP_UP_BASE_SUM_INSURED"] as? String ?? "0"
                                                    
                                                    if RELATION.uppercased() == "EMPLOYEE"{
                                                        self.topupValues = TOP_UP_BASE_SUM_INSURED
                                                        print("topupValues : ",self.topupValues)
                                                    }
                                                    print("TOP_UP_BASE_SUM_INSURED: \(TOP_UP_BASE_SUM_INSURED)")
                                                }
                                            }
                                        }
                                        else{
                                            self.displayActivityAlert(title: "No Data Found for Policy Coverages Details")
                                        }
                                    }
                                    else{
                                        self.errorState = 1
                                        print("Error Occured : errorstate ",self.errorState)
                                    }
                                    
                                    DispatchQueue.main.async
                                    {
                                        print("empolyeeDetailArray Count : ",self.empolyeeDetailArray?.count)
                                        
                                        if self.errorState == 0{
                                            
                                            self.errorPageView.isHidden = true
                                            self.errorImage.isHidden = true
                                            self.errorLbl.isHidden = true
                                            self.getCoveragePolicy_Data(PolicyNumber: self.m_productCode)
                                            self.m_tableView.reloadData()
                                        }
                                        else{
                                            
                                            self.errorPageView.isHidden = false
                                            self.errorImage.isHidden = false
                                            self.errorLbl.isHidden = false
                                            
                                        }
                                        self.hidePleaseWait()
                                        
                                    }
                                }catch{
                                    
                                }
                            }else if httpresponse.statusCode == 401{
                                self.getUserTokenGlobal(completion: { (data,error) in
                                    self.getPolicyCoveragesDetails_Data()
                                })
                            }else{
                                self.hidePleaseWait()
                                self.errorPageView.isHidden = false
                                self.errorImage.isHidden = false
                                self.errorLbl.isHidden = false
                            }
                        }
                        
                                          }
                    
                    task.resume()
                    
                }
            }else{
                self.hidePleaseWait()
                self.errorPageView.isHidden = false
                self.errorImage.isHidden = false
                self.errorLbl.isHidden = false
            }
        }
    }
   
    func getCoveragePolicy_Data(PolicyNumber: String){
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
                    
                    if let childNo = m_employeedict?.groupChildSrNo
                    {
                        groupchildsrno = String(childNo)
                        groupchildsrno = try! AesEncryption.encrypt(groupchildsrno)
                    }
                    if selectedIndexPosition == 0{
                        if let oeinfNo = m_employeedict?.oe_group_base_Info_Sr_No
                        {
                            oegrpbasinfsrno = String(oeinfNo)
                            oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                        }
                    }else{
                        oegrpbasinfsrno = selectedPolicyValue
                        oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                    }
                    
                    print("oegrp",oegrpbasinfsrno)
                    print("grp",groupchildsrno)
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getCoveragePolicyDataPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
                    request.httpMethod = "GET"
                    
                    let session = URLSession(configuration: .default)
                    var encryptedUserName = try! AesEncryption.encrypt(m_authUserName_Portal)
                    var encryptedPassword = try! AesEncryption.encrypt(m_authPassword_Portal)
                    let authString = String(format: "%@:%@", encryptedUserName, encryptedPassword)
                    let authData = authString.data(using: String.Encoding.utf8)!
                    let base64AuthString = authData.base64EncodedString()
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                   // request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                    request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                    
                    
                    print("getCoveragePolicy_Data url: ",urlreq)
                    
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        guard let data = data, error == nil else {
                            print("Error: ",error?.localizedDescription ?? "No data")
                            return
                        }
                        
                        if let httpresponse = response as? HTTPURLResponse
                        {
                            if httpresponse.statusCode == 200{
                                do{
                                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                    
                                    if let data = json?["CoveragePolicy_Data"] as? [Any] {
                                        
                                        self.policyDetailArray?.removeAll()
                                        self.policyDetailArray = json?["CoveragePolicy_Data"] as? [[String : String]]
                                        
                                        
                                        print("policyDetailArray : ",self.policyDetailArray)
                                        
                                        for item in data {
                                            if let object = item as? [String: Any] {
                                                
                                                // GROUPNAME
                                                let GROUPNAME = object["GROUPNAME"] as? String ?? ""
                                                print("GROUPNAME: \(GROUPNAME)")
                                                
                                                // POLICY_NUMBER
                                                let POLICY_NUMBER = object["POLICY_NUMBER"] as? String ?? ""
                                                print("POLICY_NUMBER: \(POLICY_NUMBER)")
                                                
                                                // POLICY_COMMENCEMENT_DATE
                                                let POLICY_COMMENCEMENT_DATE = object["POLICY_COMMENCEMENT_DATE"] as? String ?? ""
                                                print("POLICY_COMMENCEMENT_DATE: \(POLICY_COMMENCEMENT_DATE)")
                                                
                                                // POLICY_VALID_UPTO
                                                let POLICY_VALID_UPTO = object["POLICY_VALID_UPTO"] as? String ?? ""
                                                print("POLICY_VALID_UPTO: \(POLICY_VALID_UPTO)")
                                                
                                                // PRODUCT_CODE
                                                let PRODUCT_CODE = object["PRODUCT_CODE"] as? String ?? ""
                                                print("PRODUCT_CODE: \(PRODUCT_CODE)")
                                                
                                                // TPA_NAME
                                                let TPA_NAME = object["TPA_NAME"] as? String ?? ""
                                                print("TPA_NAME: \(TPA_NAME)")
                                                
                                                // BROKER_NAME
                                                let BROKER_NAME = object["BROKER_NAME"] as? String ?? ""
                                                print("BROKER_NAME: \(BROKER_NAME)")
                                                
                                                // INSURANCE_CO_NAME
                                                let INSURANCE_CO_NAME = object["INSURANCE_CO_NAME"] as? String ?? ""
                                                print("INSURANCE_CO_NAME: \(INSURANCE_CO_NAME)")
                                            }
                                        }
                                    }else{
                                        self.errorState = 1
                                        print("Some Error occured errorState ",self.errorState)
                                    }
                                    
                                    DispatchQueue.main.async
                                    {
                                        print("policyDetailArray Count : ",self.policyDetailArray?.count)
                                        
                                        if self.errorState == 0{
                                            self.errorPageView.isHidden = true
                                            self.errorImage.isHidden = true
                                            self.errorLbl.isHidden = true
                                            self.m_tableView.reloadData()
                                        }
                                        else{
                                            self.errorPageView.isHidden = false
                                            self.errorImage.isHidden = false
                                            self.errorLbl.isHidden = false
                                        }
                                        self.hidePleaseWait()
                                    }
                                    
                                }catch{
                                    
                                }
                            }else if httpresponse.statusCode == 401{
//                                self.hidePleaseWait()
//                                self.alertForLogout()
                                self.getUserTokenGlobal(completion: { (data,error) in
                                    self.getCoveragePolicy_Data(PolicyNumber: self.m_productCode)
                                })
                                
                                
                            }else{
                                self.hidePleaseWait()
                                self.errorPageView.isHidden = false
                                self.errorImage.isHidden = false
                                self.errorLbl.isHidden = false
                            }
                        }
                        
                      
                        
                    }
                    task.resume()
                }
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
        
        getPolicyCoveragesDetails_Data()
    }
}

extension MyCoveragesViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("Countss: ",self.policyDetailArray?.count)
        print("Countss: ",self.empolyeeDetailArray?.count)
        
        // if self.policyDetailArray?.count != nil && self.empolyeeDetailArray?.count != nil{
        if section == 0{
            if self.policyDetailArray?.count == nil{
                return 0
            }
            else{
                print("Countss: ",self.policyDetailArray?.count)
                return 1
            }
        }
        else if section == 1{
            return 1
        }
        else{
            if self.empolyeeDetailArray?.count == nil{
                return 0
            }
            else{
                print("Countss: ",self.empolyeeDetailArray?.count)
                return self.empolyeeDetailArray!.count
            }
        }
    }
    
    private func tableView(_ tableView: UITableView, willDisplay cell: PolicyDetailsTableViewCell, forRowAt indexPath: IndexPath)
    {
        if(indexPath.section==2)
        {
            TipInCellAnimator.animate(cell: cell)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.section==0)
        {
            return UITableViewAutomaticDimension
        }
        else if(indexPath.section==1)
        {
            return 125
        }
        else if(indexPath.section==2)
        {
            return UITableViewAutomaticDimension
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.section==1)
        {
            if (datasource.count>0)
            {
                
                /*  if selectedRowIndex == indexPath.row
                 {
                 selectedRowIndex = -1
                 let content = datasource[indexPath.row]
                 content.expanded = !content.expanded
                 }
                 else
                 {
                 if self.selectedRowIndex != -1
                 {
                 let content = datasource[selectedRowIndex]
                 content.expanded = !content.expanded
                 tableView.reloadData()
                 
                 
                 }
                 selectedRowIndex = indexPath.row
                 let content = datasource[indexPath.row]
                 content.expanded = !content.expanded
                 
                 }
                 
                 tableView.reloadRows(at: [indexPath], with: .automatic)
                 if(indexPath.row==personDetailsArray.count-1 || indexPath.row==personDetailsArray.count-2)
                 {
                 m_tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                 }*/
                
                
                let content = datasource[indexPath.row]
                content.expanded = !content.expanded
                let cell : EmployeeFamilyDetailsTableViewCell = m_tableView.cellForRow(at: indexPath) as! EmployeeFamilyDetailsTableViewCell
                if(datasource.count>0)
                {
                    cell.setContent(data: datasource[indexPath.row])
                }
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                //                tableView.reloadData()
                m_tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.section==0)
        {
            let cell : PolicyDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! PolicyDetailsTableViewCell
            cell.m_headerView.layer.masksToBounds=true
            cell.m_headerView.layer.cornerRadius=cornerRadiusForView//8
            cell.m_headerView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
            shadowForCell(view: cell.m_backgroundView)
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            
            cell.m_headerTitleLbl.text="policyDetailTitle".localized()
            cell.m_policyLbl.text="policy".localized()
            cell.m_brokerLbl.text="broker".localized()
            cell.m_insurerLbl.text="insurer".localized()
            cell.m_tpaLbl.text="tpa".localized()
            
            if(self.policyDetailArray?.count != nil)
            {
                for item in self.policyDetailArray as! [[String : String]]{
                    
                    if let object = item as? [String: String] {
                        print("object: ",object)
                        // GROUPNAME
                        let GROUPNAME = object["GROUPNAME"] as? String ?? ""
                        print("GROUPNAME: \(GROUPNAME)")
                        
                        // POLICY_NUMBER
                        let POLICY_NUMBER = object["POLICY_NUMBER"] as? String ?? ""
                        print("POLICY_NUMBER: \(POLICY_NUMBER)")
                        if POLICY_NUMBER.uppercased() == "NOT AVAILABLE"{
                            cell.m_groupNameLbl.text="-"
                        }
                        else{
                            cell.m_groupNameLbl.text=POLICY_NUMBER
                        }
                        
                        
                        // POLICY_COMMENCEMENT_DATE
                        let POLICY_COMMENCEMENT_DATE = object["POLICY_COMMENCEMENT_DATE"] as? String ?? ""
                        print("POLICY_COMMENCEMENT_DATE: \(POLICY_COMMENCEMENT_DATE)")
                        
                        // POLICY_VALID_UPTO
                        let POLICY_VALID_UPTO = object["POLICY_VALID_UPTO"] as? String ?? ""
                        print("POLICY_VALID_UPTO: \(POLICY_VALID_UPTO)")
                        if POLICY_VALID_UPTO.uppercased() == "NOT AVAILABLE"{
                            cell.m_polocyDateLbl.text="-"
                        }
                        else{
                            cell.m_polocyDateLbl.text="["+POLICY_COMMENCEMENT_DATE+" To "+POLICY_VALID_UPTO+"]"
                        }
                        
                        
                        
                        // PRODUCT_CODE
                        let PRODUCT_CODE = object["PRODUCT_CODE"] as? String ?? ""
                        print("PRODUCT_CODE: \(PRODUCT_CODE)")
                        
                        // BROKER_NAME
                        let BROKER_NAME = object["BROKER_NAME"] as? String ?? ""
                        print("BROKER_NAME: \(BROKER_NAME)")
                        if BROKER_NAME.uppercased() == "NOT AVAILABLE"{
                            cell.m_brokerNameLbl.text="-"
                        }
                        else{
                            cell.m_brokerNameLbl.text=BROKER_NAME as? String
                        }
                        
                        
                        // TPA_NAME
                        let TPA_NAME = object["TPA_NAME"] as? String ?? ""
                        print("TPA_NAME: \(TPA_NAME)")
                        if TPA_NAME.uppercased() == "NOT AVAILABLE"{
                            cell.m_tpaNameLbl.text="-"
                        }
                        else{
                            cell.m_tpaNameLbl.text=TPA_NAME
                        }
                        
                        // INSURANCE_CO_NAME
                        let INSURANCE_CO_NAME = object["INSURANCE_CO_NAME"] as? String ?? ""
                        print("INSURANCE_CO_NAME: \(INSURANCE_CO_NAME)")
                        if INSURANCE_CO_NAME.uppercased() == "NOT AVAILABLE"{
                            cell.m_insurerNameLbl.text="-"
                        }
                        else{
                            cell.m_insurerNameLbl.text=INSURANCE_CO_NAME
                        }
                        
                        
                    }
                    
                }
                
                
                //                cell.m_bottomVerticalConstraint.constant=63.5
            }
            else
            {
                cell.m_tpaNameLbl.isHidden=true
                cell.m_tpaTitleLbl.isHidden=true
                cell.m_groupNameLbl.text = "-"
                cell.m_polocyDateLbl.text = "-"
                cell.m_insurerNameLbl.text = "-"
                cell.m_brokerNameLbl.text = "-"
                cell.m_tpaNameLbl.text = "-"
                //                cell.m_bottomVerticalConstraint.constant=10
                
            }
            /*
             if(m_productCode=="GMC")
             {
             cell.m_tpaNameLbl.isHidden=false
             cell.m_tpaTitleLbl.isHidden=false
             
             cell.m_tpaTopConstraint.constant=5
             cell.m_tpavalueBottomConstraint.constant=15
             }
             else
             {
             print(cell.m_tpavalueBottomConstraint.constant,cell.m_tpaTopConstraint.constant)
             
             cell.m_tpaTopConstraint.constant = 0
             cell.m_tpavalueBottomConstraint.constant = 15
             cell.m_tpaNameLbl.text=""
             cell.m_tpaLbl.text=""
             
             print(cell.m_tpavalueBottomConstraint.constant,cell.m_tpaTopConstraint.constant)
             cell.m_tpaNameLbl.isHidden=true
             cell.m_tpaTitleLbl.isHidden=true
             }
             
             cell.m_insurerNameLbl.text=cell.m_insurerNameLbl.text?.uppercased()
             cell.m_tpaNameLbl.text=cell.m_tpaNameLbl.text?.uppercased()
             cell.m_brokerNameLbl.text=cell.m_brokerNameLbl.text?.uppercased()
             */
            return cell
        }
        else if(indexPath.section==1) //Base And TopUp cell
        {
            let cell : SumInsuredTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SumInsuredTableViewCell
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            shadowForCell(view: cell.sumInsuredView)
            
            cell.sumInsuredTitleView.layer.masksToBounds=true
            cell.sumInsuredTitleView.layer.cornerRadius=8
            cell.sumInsuredTitleView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
            cell.sumInsuredStackView.layer.masksToBounds=true
            cell.sumInsuredStackView.layer.cornerRadius=cornerRadiusForView//8
            cell.bsiView.layer.masksToBounds=true
            cell.bsiView.layer.cornerRadius=cornerRadiusForView//8
            //            cell.totalSiiew.layer.masksToBounds=true
            //            cell.totalSiiew.layer.cornerRadius=8
            
            print("m_productCode: : ",m_productCode)
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            
            if(userArray.count>0)
            {
                m_employeedict = userArray[0]
                if( m_employeedict?.topupoptedflag=="1")
                {
                    m_isTopupAvailable = true
                }
                else
                {
                    //   m_isTopupAvailable = false
                    m_isTopupAvailable = true //changed By Pranit on 2nd APRIL 2020
                    
                }
                
                
                
                var topUpSelectedAmount = "0"
                if m_productCode == "GMC" {
                    if let amount = UserDefaults.standard.value(forKey: "ghiSelectedTopup") as? String {
                        topUpSelectedAmount = amount
                    }
                }
                else if m_productCode == "GPA" {
                    if let amount = UserDefaults.standard.value(forKey: "gpaSelectedTopup") as? String {
                        topUpSelectedAmount = amount
                    }
                }
                else { //GTL
                    if let amount = UserDefaults.standard.value(forKey: "gtlSelectedTopup") as? String {
                        topUpSelectedAmount = amount
                    }
                }
                
                var bsiAmount = NSString()
                //For Base Sum Insured
                if let bsi = m_employeedict?.baseSumInsured
                {
                    bsiAmount = bsi.replacingOccurrences(of: "Rs.", with: "", options: NSString.CompareOptions.literal, range: nil) as NSString
                    let bsi = (bsiAmount as String).currencyInputFormatting()
                    cell.bsiLbl.text=bsi
                }
                //Old Logic
                /*
                if(!m_isTopupAvailable)
                {
                    //                cell.totalLbl.isHidden=true
                    cell.topupLbl.isHidden=true
                    cell.topupTitleLbl.isHidden=true
                    //                cell.totalTitleLbl.isHidden=tru
                }
                else
                {
                    
                    //                cell.totalLbl.isHidden=false
                    //                cell.totalTitleLbl.isHidden=false
                    
                    //commented If condition by pranit 2nd April 2020
                    //  if let tsi = m_employeedict?.topupSumInsured
                    
                    if topUpSelectedAmount != "0"
                    {
                        cell.topupLbl.isHidden=false
                        cell.topupTitleLbl.isHidden=false
                        
                        var tsiAmount : NSString = topUpSelectedAmount.replacingOccurrences(of: "Rs.", with: "", options: NSString.CompareOptions.literal, range: nil) as NSString
                        tsiAmount = topUpSelectedAmount.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil) as NSString
                        cell.topupLbl.text=(tsiAmount as String).currencyInputFormatting()
                        //                    cell.topupLbl.text=(tsiAmount as String) as String
                        
                        
                        /*
                         let totalTsi = tsiAmount.integerValue
                         let totalBsi = bsiAmount.integerValue
                         let totalSi = totalBsi+totalTsi
                         
                         
                         let numberFormatter = NumberFormatter()
                         numberFormatter.numberStyle = NumberFormatter.Style.decimal
                         if let formattedNumber = numberFormatter.string(from: NSNumber(value:totalSi))
                         {
                         //                        cell.totalLbl.text="Rs."+formattedNumber
                         }
                         */
                    }
                    else {
                        cell.topupLbl.isHidden=true
                        cell.topupTitleLbl.isHidden=true
                        
                    }
                }
                 */
                //For TOP_UP_BASE_SUM_INSURED
                print("topupValues : ",self.topupValues)
                var tsiAmount : NSString = self.topupValues.replacingOccurrences(of: "Rs.", with: "", options: NSString.CompareOptions.literal, range: nil) as NSString
                tsiAmount = self.topupValues.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil) as NSString
                print("tsiAmount: ",tsiAmount)
                if tsiAmount == "-1"{
                    cell.topupLbl.text = "-"
                }
                else if tsiAmount == "0"{
                    cell.topupLbl.text = tsiAmount as String
                }
                else{
                    cell.topupLbl.text=(tsiAmount as String).currencyInputFormatting()
                    //cell.topupLbl.text = self.topupValues
                }
            }
            else
            {
                cell.bsiLbl.text="0"
                cell.topupLbl.text="0"
            }
            return cell
            
        }
        else
        {
            let cell : EmployeeDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! EmployeeDetailsTableViewCell
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            shadowForCell(view: cell.empDetailsView)
            cell.employeeDetailsTitleView.layer.masksToBounds=true
            cell.employeeDetailsTitleView.layer.cornerRadius=cornerRadiusForView//8
            cell.employeeDetailsTitleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            print(empolyeeDetailArray?.count)
            /*
             if(empolyeeDetailArray?.count>0)
             {
             personDetailsDict=personDetailsArray[indexPath.row]
             
             let relation=personDetailsDict?.relationname
             m_gender=(personDetailsDict?.gender) ?? ""
             
             cell.relationLbl.text=relation
             switch relation
             {
             case "EMPLOYEE" :
             
             if(m_gender=="MALE" || m_gender=="Male")
             {
             cell.personImageView.image=UIImage(named: "Male")
             }
             else
             {
             cell.personImageView.image=UIImage(named: "women")
             }
             break
             case "SPOUSE" :
             
             
             if(m_gender=="MALE" || m_gender=="Male")
             {
             cell.personImageView.image=UIImage(named: "Male")
             }
             else
             {
             cell.personImageView.image=UIImage(named: "women")
             }
             break
             
             case "WIFE","wife","Wife" :
             cell.personImageView.image=UIImage(named: "women")
             
             case "HUSBAND","husband","Husband" :
             cell.personImageView.image=UIImage(named: "Male")
             
             case "PARTNER" :
             
             
             if(m_gender=="MALE" || m_gender=="Male")
             {
             cell.personImageView.image=UIImage(named: "Male")
             }
             else if m_gender.uppercased() == "FEMALE"
             {
             cell.personImageView.image=UIImage(named: "women")
             }
             else {
             cell.personImageView.image = UIImage(named: "othericon")
             }
             case "SON" :
             
             cell.personImageView.image=#imageLiteral(resourceName: "son")
             break
             
             case "DAUGHTER" :
             
             cell.personImageView.image=#imageLiteral(resourceName: "daughter")
             break
             
             case "FATHER" :
             
             cell.personImageView.image=#imageLiteral(resourceName: "Male")
             break
             
             case "MOTHER" :
             
             cell.personImageView.image=#imageLiteral(resourceName: "women")
             break
             
             case "FATHER-IN-LAW":
             
             cell.personImageView.image=#imageLiteral(resourceName: "Male")
             break
             
             case "MOTHER-IN-LAW" :
             
             cell.personImageView.image=#imageLiteral(resourceName: "women")
             break
             
             default :
             break
             
             }
             
             
             cell.empNameLbl.text=personDetailsDict?.personName
             cell.dobLbl.text=convertDateFormater(personDetailsDict?.dateofBirth ?? "")
             cell.ageLbl.text=String((personDetailsDict?.age)!)
             
             
             
             
             }
             */
            
            
            if(self.empolyeeDetailArray?.count != nil)
            {
                var dataArray = self.empolyeeDetailArray!
                var dob = ""
                var age = ""
                var name = ""
                for index in 0..<dataArray.count {
                    if indexPath.row == index{
                        name = dataArray[index]["PERSON_NAME"] as! String
                        m_gender = dataArray[index]["GENDER"] as! String
                        dob = dataArray[index]["DATE_OF_BIRTH"] as! String
                        age = dataArray[index]["AGE"] as! String
                        relation = dataArray[index]["RELATION"] as! String
                        
                        cell.empNameLbl.text = name
                        cell.relationLbl.text = relation
                        cell.dobLbl.text = dob
                        cell.ageLbl.text = age
                    }
                }
                
                
                switch relation
                {
                case "EMPLOYEE" :
                    
                    if(m_gender=="MALE" || m_gender=="Male")
                    {
                        cell.personImageView.image=UIImage(named: "Male")
                    }
                    else
                    {
                        cell.personImageView.image=UIImage(named: "women")
                    }
                    break
                case "SPOUSE" :
                    
                    
                    if(m_gender=="MALE" || m_gender=="Male")
                    {
                        cell.personImageView.image=UIImage(named: "Male")
                    }
                    else
                    {
                        cell.personImageView.image=UIImage(named: "women")
                    }
                    break
                    
                case "WIFE","wife","Wife" :
                    cell.personImageView.image=UIImage(named: "women")
                    
                case "HUSBAND","husband","Husband" :
                    cell.personImageView.image=UIImage(named: "Male")
                    
                case "PARTNER" :
                    
                    
                    if(m_gender=="MALE" || m_gender=="Male")
                    {
                        cell.personImageView.image=UIImage(named: "Male")
                    }
                    else if m_gender.uppercased() == "FEMALE"
                    {
                        cell.personImageView.image=UIImage(named: "women")
                    }
                    else {
                        cell.personImageView.image = UIImage(named: "othericon")
                    }
                case "SON" :
                    
                    cell.personImageView.image=#imageLiteral(resourceName: "son")
                    break
                    
                case "DAUGHTER" :
                    
                    cell.personImageView.image=#imageLiteral(resourceName: "daughter")
                    break
                    
                case "FATHER" :
                    
                    cell.personImageView.image=#imageLiteral(resourceName: "Male")
                    break
                    
                case "MOTHER" :
                    
                    cell.personImageView.image=#imageLiteral(resourceName: "women")
                    break
                    
                case "FATHER-IN-LAW":
                    
                    cell.personImageView.image=#imageLiteral(resourceName: "Male")
                    break
                    
                case "MOTHER-IN-LAW" :
                    
                    cell.personImageView.image=#imageLiteral(resourceName: "women")
                    break
                    
                default :
                    break
                    
                }
            }
            return cell
        }
        
    }
    
}
