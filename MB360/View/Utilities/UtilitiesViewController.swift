//
//  UtilitiesViewController.swift
//  MyBenefits
//
//  Created by Semantic on 20/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FirebaseCrashlytics

class UtilitiesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate,UIDocumentInteractionControllerDelegate, NewPoicySelectedDelegate {
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var m_topbarView: UIView!
    @IBOutlet weak var m_tableView: UITableView!
    @IBOutlet weak var m_GTLTabLine: UILabel!
    @IBOutlet weak var m_GTLTab: UIButton!
    @IBOutlet weak var m_GPATabLine: UILabel!
    @IBOutlet weak var m_GPATab: UIButton!
    
    @IBOutlet weak var GTLShadowView: UIView!
    @IBOutlet weak var GMCShadowView: UIView!
    @IBOutlet weak var GPAShadowView: UIView!
    @IBOutlet weak var m_topbarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_GMCTab: UIButton!
    @IBOutlet weak var m_stackView: UIStackView!
    
    @IBOutlet weak var m_GMCTabLine: UILabel!
    
    @IBOutlet weak var m_errorImageview: UIImageView!
    @IBOutlet weak var m_errorDescriptionLbl: UILabel!
    @IBOutlet weak var m_errorMsgLbl: UILabel!
    
    @IBOutlet weak var m_topbarTopVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_tabbarView: UIView!
    
    
    @IBOutlet weak var PolicylblView: UIView!
    @IBOutlet weak var policyNamelbl: UILabel!
    @IBOutlet weak var policyButtonView: UIView!
    @IBOutlet weak var policyButtonLbl: UILabel!
    
    
    var selectedIndexPosition = -1
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    var selectedPolicyValue = ""
    
    var reuseIdentifier = "cell"
    var m_productCode = String()
    
    
    
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?
    var currentDictionary: [String: String]? 
    var currentValue = String()
    let dictionaryKeys = ["Utilities1","UtilitiesDisplayName", "UtilitiesFileType", "UtilitiesLink","Utilities2","Utilities3","Utilities4","Utilities5","Utilities6","Utilities7","Utilities8","Utilities9","Utilities10","Utilities11","Utilities12"]
    var utilitiesDictArray: [[String: String]]?
    var isFromSideBar = Bool()
    var utilitiesArray = Array<UtilitiesDetails>()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupFontsUI()
        //Top bar hide buttons
        m_GMCTab.isHidden=true
        m_GPATab.isHidden=true
        m_GTLTab.isHidden=true
        
        addTarget()
        m_tableView.register(UtilitiesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        m_tableView.register(UINib (nibName: "UtilitiesTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        setData()
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
                
        print("Utilities Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
        
        
     
        
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
            m_GPATab.isHidden = false
        }
        if(m_productCodeArray.contains("GTL")){
            print("GTL present")
            m_GTLTab.isHidden = false
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
        
        
        navigationItem.leftBarButtonItem = getBackButton()
      
    }

    
    func setupFontsUI(){
        
        m_GMCTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GMCTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GPATab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GPATab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GTLTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GTLTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
         
        m_errorMsgLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h17))
        m_errorMsgLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_errorDescriptionLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        m_errorDescriptionLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        policyNamelbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        policyNamelbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        policyButtonLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        policyButtonLbl.textColor = FontsConstant.shared.app_WhiteColor
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        PolicylblView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
        
        self.tabBarController?.tabBar.isHidden=false
        navigationController?.navigationBar.isHidden=false
        navigationItem.title="link9Name".localized()
        //navigationItem.rightBarButtonItem=getRightBarButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
        m_tabbarView.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        
        navigationItem.leftBarButtonItem = getBackButton()
        //navigationItem.leftBarButtonItem = nil
        
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc override func backButtonClicked()
    {
        print ("backButtonClicked")
        tabBarController!.selectedIndex = 2
    }
    
    func GMCTabSeleted()
    {
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
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
        
        
        GMCShadowView.dropShadow()
        GPAShadowView.layer.masksToBounds=true
        GTLShadowView.layer.masksToBounds=true
        
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius=8//m_GMCTab.frame.size.height/2
        //        m_GMCTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_GMCTabLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        m_GPATabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GTLTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GPATab.layer.borderWidth = 2
        m_GTLTab.layer.borderWidth = 2
        
       
        m_GPATab.layer.cornerRadius = cornerRadiusForView//8
        m_GTLTab.layer.cornerRadius = cornerRadiusForView//8
        GMCShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        
         //getUtilitiesDetails()
        getUtilitiesDetailsPortal()
        
    }
  
    func setData()
    {
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
    
        m_productCode="GMC"
        m_GPATabLine.backgroundColor=UIColor.lightGray
        m_GTLTabLine.backgroundColor=UIColor.lightGray
        m_GPATab.setTitleColor(UIColor.lightGray, for: .normal)
        m_GTLTab.setTitleColor(UIColor.lightGray, for: .normal)
        
    
        
    }
    func setTopbarProducts()
    {
        
        if(m_productCodeArray.count==1)
        {
            if(m_productCodeArray.contains("GMC"))
            {
                GMCTabSeleted()
                m_GMCTab.isUserInteractionEnabled=false
                m_GPATab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                
                m_GPATab.setTitleColor(UIColor.white, for: .normal)
                m_GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GPA"))
            {
                GPATabSelect()
                m_GMCTab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                 m_GPATab.isUserInteractionEnabled=false
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
                m_GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GTL"))
            {
                GTLTabSelect()
                m_GPATab.isUserInteractionEnabled=false
                m_GMCTab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                m_GPATab.setTitleColor(UIColor.white, for: .normal)
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
            }
        }
        else if(m_productCodeArray.count==2)
        {
            
            if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GPA"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                m_GPATab.isUserInteractionEnabled=true
                m_GTLTab.isUserInteractionEnabled=false
                m_GMCTab.isHidden=false
                m_GPATab.isHidden=false
                m_GTLTab.isHidden=true
                GMCTabSeleted()
                
            }
            else if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                m_GPATab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=false
                m_GPATab.isHidden=true
                m_GTLTab.isHidden=false
                GMCTabSeleted()
            }
            else if(m_productCodeArray.contains("GPA") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=false
                m_GPATab.isUserInteractionEnabled=true
                m_GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=true
                m_GPATab.isHidden=false
                m_GTLTab.isHidden=false
                GPATabSelect()
                
            }
            else
            {
                
            }
        }
        else
        {
            
            m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
            selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
                    
            print("Contact Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
            
            if m_productCode == "GMC"{
                GMCTabSeleted()
            }
            else if m_productCode == "GPA"{
                GPATabSelect()
            }
            else if m_productCode == "GTL"{
                GTLTabSelect()
            }
        }
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if((utilitiesArray) != nil)
        {
            return (utilitiesArray.count)
        }
        else
        {
            return 0
        }
       
    }
    
    private func tableView(tableView: UITableView, willDisplayMyCell myCell: UtilitiesTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        TipInCellAnimator.animate(cell: myCell)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : UtilitiesTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UtilitiesTableViewCell
        
    
        print("utilitiesDictArray cellfor row count: ",self.utilitiesDictArray?.count)
        
//        if let dict : NSDictionary? = (utilitiesDictArray?[indexPath.row] as! NSDictionary)
//        {
//            cell.m_fileNameLbl.text = dict?.value(forKey: "DOWNLOAD_DISPLAY_NAME") as? String
//
//
//            let type :String = dict?.value(forKey: "FILE_TYPE") as! String
//            print(type)
//            if (type == ".XLSX" || type == "XLS" || type=="XLSX")
//            {
//                cell.m_iconImageView.image = UIImage(named: "excel")
//            }
//            else if(type == ".PDF" || type == "PDF")
//            {
//                cell.m_iconImageView.image = UIImage(named: "pdf-1")
//            }
//            else if(type == ".DOC" || type == "DOC")
//            {
//                cell.m_iconImageView.image = UIImage(named: "word")
//            }
//            else if(type == ".jpeg" || type == ".jpg" || type == ".gif" || type == ".png" || type == ".bmp"){
//                cell.m_iconImageView.image = UIImage(named: "img")
//            }
//            else
//            {
//                cell.m_iconImageView.image = UIImage(named: "claimnotfound")
//            }
//            cell.utilitiesButtonClicked.tag=indexPath.row
//            cell.utilitiesButtonClicked.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
//        }
        if let dict:UtilitiesDetails = utilitiesArray[indexPath.row] as? UtilitiesDetails
        {
            print(dict)
            cell.m_fileNameLbl.text = dict.download_display_name ?? ""//dict?.value(forKey: "DOWNLOAD_DISPLAY_NAME") as? String


            let type :String = dict.file_type as? String ?? ""//dict?.value(forKey: "FILE_TYPE") as! String
            print(type)
            if (type == ".XLSX" || type == "XLS" || type=="XLSX")
            {
                cell.m_iconImageView.image = UIImage(named: "excel")
            }
            else if(type == ".PDF" || type == "PDF")
            {
                cell.m_iconImageView.image = UIImage(named: "pdf-1")
            }
            else if(type == ".DOC" || type == "DOC")
            {
                cell.m_iconImageView.image = UIImage(named: "word")
            }
            else if(type == ".jpeg" || type == ".jpg"){
                cell.m_iconImageView.image = UIImage(named: "jpg")
            }
            else if(type == ".png" || type == ".bmp"){
                cell.m_iconImageView.image = UIImage(named: "png")
            }
            else
            {
                cell.m_iconImageView.image = UIImage(named: "img") //default image
            }
            cell.utilitiesButtonClicked.tag=indexPath.row
            cell.utilitiesButtonClicked.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        }
        shadowForCell(view: cell.m_backgroundView)
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        
        
        return cell
    }
    @objc func downloadButtonClicked(sender:UIButton)
    {
        let indexpath = IndexPath(row:sender.tag,section:0)
        tableView(m_tableView, didSelectRowAt: indexpath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
        //if let dict : NSDictionary = utilitiesDictArray?[indexPath.row] as? NSDictionary
        if let dict:UtilitiesDetails = utilitiesArray[indexPath.row] as? UtilitiesDetails
        {
            print("dict:",dict)
            if let fileName = dict.value(forKey: "file_path")
            {
                showPleaseWait(msg: "Please wait...")

                let newBaseurlPortal = WebServiceManager.getSharedInstance().downloadBaseUrlPortal
                let url = newBaseurlPortal.appending(fileName as! String)
                        
                        if let stringUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        {
                            let urlStr : NSString = stringUrl as NSString
                        
                        if let searchURL : NSURL = NSURL(string: urlStr as String)
                        {
                            
                            print("Utilities searchURL: ",searchURL)
                            let request = URLRequest(url: searchURL as URL)
                            let session = URLSession(configuration: URLSessionConfiguration.default)
                            
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
                                            do
                                            {
                                                
                                                let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                                                
                                                if var fileName = searchURL.lastPathComponent
                                                {
                                                    fileName=fileName.replacingOccurrences(of: "_GMC", with: "")
                                                    if(self.m_productCode=="GMC"){
                                                        fileName="GHI_"+fileName
                                                    }
                                                    else if(self.m_productCode=="GPA"){
                                                        fileName="GPA_"+fileName
                                                    }
                                                    else{
                                                        fileName="GTL_"+fileName
                                                    }
                                                    
                                                    let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                                                    let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
                                                    if let data = data{
                                                        
                                                        if(destinationUrl != nil)
                                                        {
                                                            try data.write(to: destinationUrl!, options: .atomic)
                                                            try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                                        }
                                                    }
                                                    else{
                                                        self.hidePleaseWait()
                                                        self.isConnectedToNetWithAlert()
                                                    }
                                                }
                                            }
                                            catch
                                            {
                                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                                print(error)
                                                self.hidePleaseWait()
                                            }
                                        }
                                        else if httpResponse.statusCode == 404
                                        {
                                            self.hidePleaseWait()
                                            
                                            self.displayActivityAlert(title: m_errorMsgFile)
                                            print("File not found executed")
                                        }
                                        else{
                                            self.hidePleaseWait()
                                            
                                            self.displayActivityAlert(title: m_errorMsg)
                                            print("else executed")
                                        }
                                    }
                                    else
                                    {
                                        print("Can't cast response to NSHTTPURLResponse")
                                        self.displayActivityAlert(title: m_errorMsg)
                                        self.hidePleaseWait()
                                        
                                    }
                                }
                            }
                            task.resume()
                            
                        }
                        else
                        {
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                            
                        }
                        }
                        else
                        {
                            self.displayActivityAlert(title: m_errorMsg)
                            hidePleaseWait()
                        }
                       
//                }
            }
            else
            {
                displayActivityAlert(title: m_errorMsg)
                hidePleaseWait()
            }
            
            
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
    }
    private func tableView(tableView: UITableView, willDisplayMyCell myCell: PolicyFeaturesTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        TipInCellAnimator.animate(cell: myCell)
    }
    private func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController
    {
        UINavigationBar.appearance().barTintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().tintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().backgroundColor = hexStringToUIColor(hex: hightlightColor)
        return self
    }
    private func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController)
    {
        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
        
    }
    func openSelectedDocumentFromURL(documentURLString: String) throws {
       DispatchQueue.main.async()
        {
            //code
        
           if let documentURL: NSURL? = NSURL(fileURLWithPath: documentURLString)
           {
            UINavigationBar.appearance().barTintColor = self.hexStringToUIColor(hex: hightlightColor)
            UINavigationBar.appearance().tintColor = self.hexStringToUIColor(hex: hightlightColor)
            UINavigationBar.appearance().backgroundColor = self.hexStringToUIColor(hex: hightlightColor)
            documentController = UIDocumentInteractionController(url: documentURL! as URL)
            documentController.delegate = self
            documentController.presentPreview(animated: true)
           self.hidePleaseWait()
           }
        
        }
       
    }
    
    
    // MARK: - UIDocumentInteractionViewController delegate methods
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
       hidePleaseWait()
        
        return self
    }

    

    func getUtilitiesDetailsPortal()
    {
        if(isConnectedToNet())
        {
            
            m_noInternetView.isHidden=true
            var employeeDetailsArray : Array<EMPLOYEE_INFORMATION> = []
            
            employeeDetailsArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: self.m_productCode)
            
            
            if(employeeDetailsArray.count>0)
            {
                
                let userDict:EMPLOYEE_INFORMATION = employeeDetailsArray[0]
                
                showPleaseWait(msg: """
    Please wait...
    Fetching Utilities
    """)
                var groupchildsrno = String()
                var oegrpbasinfsrno = String()
                groupchildsrno = String(userDict.groupChildSrNo)
                groupchildsrno = try! AesEncryption.encrypt(groupchildsrno)
               
                if selectedIndexPosition == 0{
                    oegrpbasinfsrno = String(userDict.oe_group_base_Info_Sr_No)
                    oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                }else{
                    oegrpbasinfsrno = selectedPolicyValue
                    oegrpbasinfsrno = try! AesEncryption.encrypt(oegrpbasinfsrno)
                }
                
                print("m_productCode : ",m_productCode," : groupchildsrno: ",groupchildsrno," : oegrpbasinfsrno: ",oegrpbasinfsrno)
              
                let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getUtilitiesPostUrlPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded) as String)
                                 
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
                
                
                print("Utility url: ",urlreq)
                
             
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                    if error != nil{ //if let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        
                        return
                    }else{
                        if let httpresponse = response as? HTTPURLResponse
                        {
                            if httpresponse.statusCode == 200{
                                do{
                                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                                    if let data = json?["UTILITIES_DATA"] as? [Any] {
                                        
                                        self.resultsDictArray = json?["UTILITIES_DATA"] as? [[String : String]]
                                        self.utilitiesDictArray = json?["UTILITIES_DATA"] as? [[String : String]]
                                        
                                        print("utilitiesDictArray: ",self.utilitiesDictArray)
                                        print("utilitiesDictArray count : ",self.utilitiesDictArray?.count)
                                        
                                        let status = DatabaseManager.sharedInstance.deleteUtilitiesDetails(self.m_productCode)
                                        
                                        for item in data {
                                            if let object = item as? [String: Any] {
                                                if status{
                                                    DatabaseManager.sharedInstance.saveUtilities(contactDict: object as NSDictionary)
                                                }
                                               
                                                // DOWNLOAD_SR_NO
                                                let DOWNLOAD_SR_NO = object["DOWNLOAD_SR_NO"] as? String ?? "0"
                                                print("DOWNLOAD_SR_NO: \(DOWNLOAD_SR_NO)")
                                                
                                                // DOWNLOAD_NAME
                                                let DOWNLOAD_NAME = object["DOWNLOAD_NAME"] as? String ?? ""
                                                print("DOWNLOAD_NAME: \(DOWNLOAD_NAME)")
                                                
                                                // DOWNLOAD_DISPLAY_NAME
                                                let DOWNLOAD_DISPLAY_NAME = object["DOWNLOAD_DISPLAY_NAME"] as? String ?? ""
                                                print("DOWNLOAD_DISPLAY_NAME: \(DOWNLOAD_DISPLAY_NAME)")
                                                
                                                // PRODUCT_NAME
                                                let PRODUCT_NAME = object["PRODUCT_NAME"] as? String ?? "0"
                                                print("PRODUCT_NAME: \(PRODUCT_NAME)")
                                                
                                                // PRODUCT_CODE
                                                let PRODUCT_CODE = object["PRODUCT_CODE"] as? String ?? "0"
                                                print("PRODUCT_CODE: \(PRODUCT_CODE)")
                                                
                                                // DOWNLOAD_VISIBILITY
                                                let DOWNLOAD_VISIBILITY = object["DOWNLOAD_VISIBILITY"] as? String ?? "0"
                                                print("DOWNLOAD_VISIBILITY: \(DOWNLOAD_VISIBILITY)")
                                                
                                                // SYS_GEN_FILE_NAME
                                                let SYS_GEN_FILE_NAME = object["SYS_GEN_FILE_NAME"] as? String ?? "0"
                                                print("SYS_GEN_FILE_NAME: \(SYS_GEN_FILE_NAME)")
                                                
                                                // FILE_TYPE
                                                let FILE_TYPE = object["FILE_TYPE"] as? String ?? "0"
                                                print("FILE_TYPE: \(FILE_TYPE)")
                                                
                                                // GROUPCHILDSRNO
                                                let GROUPCHILDSRNO = object["GROUPCHILDSRNO"] as? String ?? "0"
                                                print("GROUPCHILDSRNO: \(GROUPCHILDSRNO)")
                                                
                                                // OE_GRP_BAS_INF_SR_NO
                                                let OE_GRP_BAS_INF_SR_NO = object["OE_GRP_BAS_INF_SR_NO"] as? String ?? "0"
                                                print("OE_GRP_BAS_INF_SR_NO: \(OE_GRP_BAS_INF_SR_NO)")
                                                
                                                // FILE_PATH
                                                let FILE_PATH = object["FILE_PATH"] as? String ?? ""
                                                print("FILE_PATH: \(FILE_PATH)")
                                                
                                                
                                               
                                            }
                                           
                                        }
                                        
                                        self.utilitiesArray = DatabaseManager.sharedInstance.retrieveUtilitiesDetails(productCode: self.m_productCode)
                                        print(self.utilitiesArray)
                                        //utilitiesDictArray = utilitiesArray
                                       
                                        print("utilitiesDictArray: ",self.utilitiesDictArray?.count)
                                        
                                    }
                                    DispatchQueue.main.async
                                    {
                                     
                                        if self.utilitiesArray.count == 0{
                                            self.m_tableView.isHidden=true
                                            self.m_noInternetView.isHidden=false
                                            self.m_errorImageview.image=UIImage(named: "nodocuments")
                                            self.m_errorMsgLbl.text="Nothing to show"
                                            self.m_errorDescriptionLbl.text=""
                                        }else{
                                            self.m_tableView.isHidden = false
                                            self.m_tableView.reloadData()
                                        }
                                        self.hidePleaseWait()
                                       
                                    }
                                }catch{
                                    
                                }
                            }else if httpresponse.statusCode == 401 {
//                                self.hidePleaseWait()
//                                self.alertForLogout()
                                self.getUserTokenGlobal(completion: { (data,error) in
                                    self.getUtilitiesDetailsPortal()
                                })

                            }else{
                                self.utilitiesArray = DatabaseManager.sharedInstance.retrieveUtilitiesDetails(productCode: self.m_productCode)
                                print(self.utilitiesArray)
                                if self.utilitiesArray != nil{
                                    for object in self.utilitiesArray{
                                        // DOWNLOAD_SR_NO
                                        let DOWNLOAD_SR_NO = object.download_sr_no//object["DOWNLOAD_SR_NO"] as? String ?? "0"
                                        print("DOWNLOAD_SR_NO: \(DOWNLOAD_SR_NO)")
                                        
                                        // DOWNLOAD_NAME
                                        let DOWNLOAD_NAME = object.download_name//object["DOWNLOAD_NAME"] as? String ?? ""
                                        print("DOWNLOAD_NAME: \(DOWNLOAD_NAME)")
                                        
                                        // DOWNLOAD_DISPLAY_NAME
                                        let DOWNLOAD_DISPLAY_NAME = object.download_display_name//object["DOWNLOAD_DISPLAY_NAME"] as? String ?? ""
                                        print("DOWNLOAD_DISPLAY_NAME: \(DOWNLOAD_DISPLAY_NAME)")
                                        
                                        // PRODUCT_NAME
                                        let PRODUCT_NAME = object.product_name//object["PRODUCT_NAME"] as? String ?? "0"
                                        print("PRODUCT_NAME: \(PRODUCT_NAME)")
                                        
                                        // PRODUCT_CODE
                                        let PRODUCT_CODE = object.product_code//object["PRODUCT_CODE"] as? String ?? "0"
                                        print("PRODUCT_CODE: \(PRODUCT_CODE)")
                                        
                                        // DOWNLOAD_VISIBILITY
                                        let DOWNLOAD_VISIBILITY = object.download_visibility//object["DOWNLOAD_VISIBILITY"] as? String ?? "0"
                                        print("DOWNLOAD_VISIBILITY: \(DOWNLOAD_VISIBILITY)")
                                        
                                        // SYS_GEN_FILE_NAME
                                        let SYS_GEN_FILE_NAME = object.sys_gen_file_name//object["SYS_GEN_FILE_NAME"] as? String ?? "0"
                                        print("SYS_GEN_FILE_NAME: \(SYS_GEN_FILE_NAME)")
                                        
                                        // FILE_TYPE
                                        let FILE_TYPE = object.file_type//object["FILE_TYPE"] as? String ?? "0"
                                        print("FILE_TYPE: \(FILE_TYPE)")
                                        
                                        // GROUPCHILDSRNO
                                        let GROUPCHILDSRNO = object.grp_child_sr_no//object["GROUPCHILDSRNO"] as? String ?? "0"
                                        print("GROUPCHILDSRNO: \(GROUPCHILDSRNO)")
                                        
                                        // OE_GRP_BAS_INF_SR_NO
                                        let OE_GRP_BAS_INF_SR_NO = object.oe_grp_base_no//object["OE_GRP_BAS_INF_SR_NO"] as? String ?? "0"
                                        print("OE_GRP_BAS_INF_SR_NO: \(OE_GRP_BAS_INF_SR_NO)")
                                        
                                        // FILE_PATH
                                        let FILE_PATH = object.file_path//object["FILE_PATH"] as? String ?? ""
                                        print("FILE_PATH: \(FILE_PATH)")
                                   
                                    }
                                }
                            }
                        }
                     
                    }
                    
                   
                }
                task.resume()
            }
            else
            {
                self.m_noInternetView.isHidden=false
                self.m_errorImageview.image=UIImage(named: "nodocuments")
                self.m_errorMsgLbl.text="Documents not found"
                self.m_errorDescriptionLbl.isHidden=true
                
            }
        }
        else
        {
//            m_noInternetView.isHidden=false
//            m_errorImageview.image=UIImage(named: "nointernet")
//            m_errorMsgLbl.text="No internet Connection"
//            m_errorDescriptionLbl.isHidden=false
//            m_errorDescriptionLbl.text="Slow or no internet connection. Please check your Internet Settings"
            self.utilitiesArray = DatabaseManager.sharedInstance.retrieveUtilitiesDetails(productCode: self.m_productCode)
            print(self.utilitiesArray)
            //utilitiesDictArray = utilitiesArray
           
            print("utilitiesDictArray: ",self.utilitiesDictArray?.count)
            
        //}
//        DispatchQueue.main.async
//        {
         
            if self.utilitiesArray.count == 0{
                self.m_tableView.isHidden=true
                self.m_noInternetView.isHidden=false
                self.m_errorImageview.image=UIImage(named: "nodocuments")
                self.m_errorMsgLbl.text="Nothing to show"
                self.m_errorDescriptionLbl.text=""
            }else{
                self.m_tableView.isHidden = false
                self.m_noInternetView.isHidden=true
                self.m_tableView.reloadData()
            }
            self.hidePleaseWait()
           
        //}
        }

    }
    
    

    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
        utilitiesDictArray = []
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
            if(elementName=="Utilities1" || elementName=="Utilities2" || elementName=="Utilities3" || elementName=="Utilities4" || elementName=="Utilities5" || elementName=="Utilities6" || elementName=="Utilities7" || elementName=="Utilities8" || elementName=="Utilities9" || elementName=="Utilities10")
            {
                utilitiesDictArray?.append(currentDictionary!)
            }
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

    @IBAction func GMCTabSelected(_ sender: Any)
    {
        selectedIndexPosition = 0
        GMCTabSeleted()
//        getUtilitiesDetails()
        getUtilitiesDetailsPortal()
    }
    
    @IBAction func GPATabSelected(_ sender: Any)
    {
        selectedIndexPosition = 0
        GPATabSelect()
    }
    @IBAction func GTLTabSelected(_ sender: Any)
    {
        selectedIndexPosition = 0
        GTLTabSelect()
    }
    
    func GPATabSelect()
    {
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
        
        
        GPAShadowView.dropShadow()
        
        GMCShadowView.layer.masksToBounds=true
        GTLShadowView.layer.masksToBounds=true
        
        
        m_GPATab.layer.masksToBounds=true
        m_GPATab.layer.cornerRadius=8//m_GPATab.frame.size.height/2
        m_GPATab.layer.borderWidth=0
        
        m_GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_GPATabLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        m_GPATab.setTitleColor(UIColor.white, for: .normal)
        
        
        m_GMCTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GTLTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GMCTab.layer.borderWidth = 2
        m_GTLTab.layer.borderWidth = 2
        
       
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        m_GTLTab.layer.cornerRadius = cornerRadiusForView//8
        GPAShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        //getUtilitiesDetails()
        getUtilitiesDetailsPortal()
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
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        
        GMCShadowView.layer.masksToBounds=true
        GPAShadowView.layer.masksToBounds=true
        GTLShadowView.dropShadow()
        
        m_GTLTab.layer.masksToBounds=true
        m_GTLTab.layer.cornerRadius=8//m_GTLTab.frame.size.height/2
        
        m_GTLTab.layer.borderWidth=0
        m_GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_GTLTabLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        m_GTLTab.setTitleColor(UIColor.white, for: .normal)
        
        
        m_GMCTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GPATabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GPATab.layer.borderWidth = 2
        m_GMCTab.layer.borderWidth = 2
        
       
        m_GPATab.layer.cornerRadius = cornerRadiusForView//8
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        GTLShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        
        //getUtilitiesDetails()
        getUtilitiesDetailsPortal()
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
        
        getUtilitiesDetailsPortal()
    }
    
}
