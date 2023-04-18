//
//  EnrollmentEmployeeViewController.swift
//  MyBenefits
//
//  Created by Semantic on 24/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//
import UIKit
import FlexibleSteppedProgressBar
import AEXML
import FirebaseCrashlytics


extension UIScrollView {
    func scrollToTopList(animated: Bool)
    {
        
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        contentInset = UIEdgeInsets.zero;
        scrollIndicatorInsets = UIEdgeInsets.zero;
        contentOffset = CGPoint(x: 0.0, y: 0.0);
    }
    
        func scrollToTop(animated: Bool)
        {
            
            let topOffset = CGPoint(x: 0, y: -contentInset.top)
            contentInset = UIEdgeInsets.zero;
            scrollIndicatorInsets = UIEdgeInsets.zero;
            contentOffset = CGPoint(x: 0.0, y: 0.0);
        }
    
}


extension UIScrollView {
    func scrollToTop(_ animated: Bool)
    {
        var topContentOffset: CGPoint
        if #available(iOS 11.0, *) {
            topContentOffset = CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top)
        } else {
            topContentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
        }
        setContentOffset(topContentOffset, animated: animated)
    }
}
class EnrollmentEmployeeViewController: UIViewController,XMLParserDelegate,UITextFieldDelegate,FlexibleSteppedProgressBarDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var m_progressBarLbl2: UILabel!
    
    @IBOutlet weak var m_instructionScrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_instructionScrollview: UIScrollView!
    @IBOutlet weak var m_instructionTextLbl: UILabel!
    @IBOutlet weak var m_progressBarLbl3: UILabel!
    @IBOutlet weak var m_progressBarLbl1: UILabel!
    @IBOutlet weak var m_topupTableviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_premiumStatementLbl: UILabel!
    @IBOutlet weak var m_premiumCheckImageView: UIImageView!
    @IBOutlet weak var m_dependantTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_instructionTextView: UITextView!
    @IBOutlet weak var m_mobileNumberLabl: UILabel!
    
    @IBOutlet weak var headerEmrgMobileLbl: UILabel!
    @IBOutlet weak var m_emrgmobileNumberLabl: UILabel!
    @IBOutlet weak var m_emrgmobileTextfield: UITextField!
    var isEditable = false
    
    @IBOutlet weak var m_topView: UIView!
    
    @IBOutlet weak var m_addDependantView: UIView!
    
    @IBOutlet weak var m_dependantNextButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_relationTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var m_nameTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var m_dobTextField: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var m_dependantScrollView: UIScrollView!
    
    @IBOutlet weak var m_ageTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var m_domTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var m_dependantDetailsTableview: UITableView!
    
    @IBOutlet weak var m_topupNextButton: UIButton!
    @IBOutlet weak var m_addDependantButton: UIButton!
    
    @IBOutlet weak var m_addButtonTopHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var m_addEdittitle: UILabel!
    @IBOutlet weak var m_dontKnowDobLabel: UILabel!
    @IBOutlet weak var m_dobCheckImageView: UIImageView!
    @IBOutlet weak var m_dependantCancelButton: UIButton!
    
    //Added By Pranit
    @IBOutlet weak var firstBtnCoreBenefits: UIButton!
    @IBOutlet weak var secondBtnCoreBenefits: UIButton!
    
    //TopLabel
    @IBOutlet weak var headerNameLbl: UILabel!
    @IBOutlet weak var headerEmpIdLbl: UILabel!
    @IBOutlet weak var headerDobLbl: UILabel!
    @IBOutlet weak var headerAgeLbl: UILabel!
    @IBOutlet weak var headerMobileLbl: UILabel!
    
    @IBOutlet weak var headerEmailLbl: UILabel!
    
    @IBOutlet weak var userEmailLbl: UILabel!

    
    
    var reuseIdentifier = "Cell"
    var progressBar = FlexibleSteppedProgressBar()
    var m_membersArray = Array<String>()
    var m_membersRelationIdArray = Array<String>()
    var m_relationID = String()
    var m_gender = String()
    var m_isUpdated = Bool()
    var m_employeedict : EMPLOYEE_INFORMATION?
    var m_webserviceStatus = String()
    var m_isEditing = Bool()
    var m_isPremiumAccepted = false
    var m_isGMCTopupApplicable = String()
    var m_isGPATopupApplicable = String()
    var m_isGTLTopupApplicable = String()
    var m_arrayofGMCTopupOptions = Array<String>()
    var m_arrayofGPATopupOptions = Array<String>()
    var m_arrayofGTLTopupOptions = Array<String>()
    var m_topupTitleArray = Array<String>()
    var m_editPersonDict = PERSON_INFORMATION()
    var m_isGMCTopup1Opted = Bool()
    var m_isGMCTopup2Opted = Bool()
    var m_isOptTopup = Bool()
    var m_arrayofParents = ["MOTHER","FATHER","MOTHER-IN-LAW","FATHER-IN-LAW"]
    @IBOutlet weak var m_instructionLbl: UILabel!
    
    
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var xmlKey = "Adminsettings"
    
    var m_employeeDict : EMPLOYEE_INFORMATION?
    var m_dataSettingsDict = NSDictionary()
    var check = Int()
    var m_windowPeriodEndDate = Date()
    var addTopupDict = NSDictionary()
    
    
    
    var dobTxtFieldTag = Int()
    var m_isDateOfMarrige = Bool()
    var m_currentIndex = Int()
    var m_selectedDate = String()
    var m_dateofBirth = String()
    var m_marrigeDate = String()
    var m_isTopupConditionsAccepted = Bool()
    var m_enrollmentTopUpOptions = NSDictionary()
    var dateArray = ["","","","","","","","","","","",""]
    var nameArray = ["","","","","","","","","","","",""]
    var ageArray = ["","","","","","","","","","","",""]
    var dobArray = ["","","","","","","","","","","",""]
    var dependantsTitleArray : Array<String> = []
    var m_topupPremiumArrays : Array<String> = []
    var m_dependantArray = Array<DependantDetails>()
    var addedPersonDetailsArray = Array<PERSON_INFORMATION>()
    var m_productCode = String()
    var dependantsDictArray: [[String: String]]?
    var pendingRelationsDictArray: [[String: String]]?
    var indexNumber = Int()
    var refreshControl = UIRefreshControl()
    var GMCTopupOptionArray = Array<TopupDetails>()
    var GPATopupOptionArray = Array<TopupDetails>()
    var GTLTopupOptionArray = Array<TopupDetails>()
    var m_isToupChecked = Bool()
    var m_selectedGMCTopupAmount = String()
    var m_selectedGPATopupAmount = String()
    var m_selectedGTLTopupAmount = String()
    var m_enrollmentMiscInformationDict = NSDictionary()
    var m_isEnrollmentConfirmed = Bool()
    var m_calculatedAge = Int()
    var datasource = [TopupCellContent]()
    
    var isPriceChecked = 0
    
    @IBOutlet weak var m_datePicker: UIDatePicker!
    
    @IBOutlet weak var m_selectRelationButton: UIButton!
    @IBOutlet weak var m_tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var m_DOBView: UIView!
    
    @IBOutlet weak var m_DOBPickerSubView: UIView!
    
    @IBOutlet weak var m_addDependantTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_dependantViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_dependantHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_employeeDetailsTitleView: UIView!
    @IBOutlet weak var m_empIDLbl: UILabel!
    
    @IBOutlet weak var m_nameLbl: UILabel!
    
    @IBOutlet weak var m_genderLbl: UILabel!
    
    @IBOutlet weak var m_emailIDLbl: UILabel!
    
    //    @IBOutlet weak var m_mobileNumberLbl: UILabel!
    @IBOutlet weak var m_editButton: UIButton!
    
    @IBOutlet weak var m_mobileNumberTextField: UITextField!
    @IBOutlet weak var m_dateofBirthLbl: UILabel!
    @IBOutlet weak var m_enrollmentDetailsBackgroundView: UIView!
    
    @IBOutlet weak var addDependantTitlevIew: UIView!
    @IBOutlet weak var m_instructionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var employeeDEtailsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_empoyeeDetailsBackgroundView: UIView!
    
    @IBOutlet weak var m_dependantNextButton: UIButton!
    @IBOutlet weak var m_nextButton: UIButton!
    
    var m_dobNotAvailable = Bool()
    @IBOutlet weak var m_scrollView: UIScrollView!
    @IBOutlet weak var m_windowPeriodDayLbl: UILabel!
    @IBOutlet weak var m_windowPeriodLabl: UILabel!
    
    // Jan 2020
    
    @IBOutlet weak var empDetailsScrollView: UIScrollView!
    
    @IBOutlet weak var empDetailsInstructionsView: UIView!
    
    @IBOutlet weak var lblFirstInstructions: UILabel!
    
    @IBOutlet weak var imgInstructions: UIImageView!
    
    @IBOutlet weak var btnEditMobile: UIButton!
    @IBOutlet weak var btnPerEmail: UIButton!
    @IBOutlet weak var btnPerMobile: UIButton!
    
    @IBOutlet weak var imgInstructions2: UIImageView!
    
    @IBOutlet weak var lblEmpDetails: UILabel!
    @IBOutlet weak var imgEmp: UIImageView!
    
    @IBOutlet weak var lblAge: UILabel!
    //Added by Pranit
    var selectedIndexForView = 0
    
    var xmlKeysArray = ["GroupInformation","BrokerInformation","GroupProducts","GroupPolicies","GroupPoliciesEmployees","GroupPoliciesEmployeesDependants","EnrollmentParentalOptions"]
    var dictionaryKeys = ["WINDOW_PERIOD_ACTIVE","PARENTAL_PREMIUM", "CROSS_COMBINATION_ALLOWED", "PAR_POL_INCLD_IN_MAIN_POLICY", "LIFE_EVENT_DOM","LIFE_EVENT_CHILDDOB","SON_MAXAGE","DAUGHTER_MAXAGE","PARENTS_MAXAGE","LIFE_EVENT_DOM_VALDTN_MSG","LIFE_EVENT_CHILDDOB_VALDTN_MSG","SON_MAXAGE_VALDTN_MSG","DAUGHTER_MAXAGE_VALDTN_MSG","PARENTS_MAXAGE_VALDTN_MSG","IS_TOPUP_OPTION_AVAILABLE","TOPUP_OPTIONS","TOPUP_PREMIUMS","ENRL_CNRFM_ALLOWED_FREQ","ENRL_CNRFM_MESSAGE","WINDOW_PERIOD_END_DATE","WINDOW_PERIOD_ACTIVE_TILL_MESSAGE","TOTAL_POLICY_FAMILY_COUNT","RELATION_COVERED_IN_FAMILY","RELATION_ID_COVERED_IN_FAMILY","MAIN_POLICY_FAMILY_COUNT","PARENTAL_POLICY_FAMIL_COUNT","IS_ENROLLMENT_CONFIRMED","EMPLOYEE_EDITABLE_FIELDS","TOPUP_OPT_TOTAL_DAYS_LAPSED","INSTALLMENT_MESSAGE","DBOperationMessage","DB_OPERATION_MESSAGE","EMPLOYEE_RELATION", "EMPLOYEE_RELATION_ID", "EMPLOYEE_NAME", "EMPLOYEE_DOB","EMPLOYEE_AGE","EMPLOYEE_GENDER","PERSON_SR_NO","OFFICIAL_EMAIL_ID","PERSONAL_EMAIL_ID","CELLPHONE_NO","BASE_SUM_INSURED","TOPUP_SUM_INSURED","EMPLOYEE_IDENTIFICATION_NO","EMPLOYEE_GRADE","EMPLOYEE_DEPARTMENT","EMPLOYEE_DESIGNATION","EMPLOYEE_DOJ","EMP_TOPUP_OPTED","EMP_TOPUP_SI","EMP_TOPUP_PREMIUM","EMP_TOPUP_PREM_DEDTN_MESSAGE","EMP_TOPUP_OPTD_SR_NO","PERSON_SR_NO","DependantAddInformation","DependantDeleteInformation","person_sr_no","employee_sr_no","age","date_of_birth","cellphone_no","person_name","gender","relationname","relationid","Dependant1","Dependant2","Dependant3","Dependant4","Dependant5","Dependant6","Dependant7","Dependant8","GroupInformation","OTPValidatedInformation","GROUPCHILDSRNO","GROUPCODE","GROUPNAME","GroupInformation","GroupGMCPolicies","GMCEmployee","GPAEmployee","GTLEmployee","tpa_code","tpa_name","ins_co_code","ins_co_name", "oe_gr_bas_inf_sr_no" ,"policy_number","ins_co_name","policy_commencement_date","policy_validupto_date","PRODUCTCODE","active","employee_id","oe_grp_bas_inf_sr_no","EMPLOYEENAME","GENDER","employee_sr_no","groupchildsrno","BROKERNAME","date_of_joining","official_e_mail_id","department","grade","designation","person_sr_no","employee_sr_no","age","date_of_birth","cellphone_no","person_name","gender","relationname","relationid","policy1","policy2","policy3","policy4","policy5","policy6","policy7","policy8","policy9","policy10","ProductCode","GMC","GPA","GTL","Dependant1","Dependant2","Dependant3","Dependant4","Dependant5","Dependant6","Dependant7","Dependant8","BROKER_NAME","BROKER_CODE","base_suminsured","topup_suminsured","PendingRelations","Relation","Name","ID","status","DependantUpdateInformation","base_suminsured","topup_suminsured","date_of_datainsert","topup_si_pk","topup_si_opted_flag","topup_si_opted","status","TopupInformation","topup_si_premium","ParentsCoveredInBasePolicy","CrossCombinationOfParentsAllowed","ParentalInformation","parent","FatherSumInsured","Premium","MotherSumInsured","FatherInLawSumInsured","MotherInLawSumInsured"]
    
    var policyEmpDictArray : [[String: String]]?
    var textFields: [SkyFloatingLabelTextField]!
    
    var m_employeeDetailsArray = ["","","","","",""]
    var m_titleArray = ["EMPLOYEE ID","NAME","GENDER","EMAIL ID","MOBILE NUMBER","DATE OF BIRTH"]
    let relationDropDown=DropDown()
    var selectedRowIndex = -1
    
    var instructionReadingDelegateEmp:InstructionCompleteProtocol? = nil
    
    let startPoint = CGPoint(x:0.5, y:0.0)
    let endPoint = CGPoint(x:0.5, y:1.0)
    let bottomLine = CALayer()
    
    //MARK:- ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        isEditable = false
        //m_emrgmobileTextfield.delegate=self
        m_emrgmobileTextfield.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        let transitionTemp = CGAffineTransform(translationX: 500  , y: 0)
        headerNameLbl.transform = transitionTemp
        headerEmailLbl.transform = transitionTemp
        headerAgeLbl.transform = transitionTemp
        headerEmpIdLbl.transform = transitionTemp
        headerMobileLbl.transform = transitionTemp
        headerEmrgMobileLbl.transform = transitionTemp
        btnEditMobile.transform = transitionTemp
        headerDobLbl.transform = transitionTemp
        
        m_nameLbl.transform = transitionTemp
        m_empIDLbl.transform = transitionTemp
        m_dateofBirthLbl.transform = transitionTemp
        lblAge.transform = transitionTemp
        m_mobileNumberLabl.transform = transitionTemp
        m_emrgmobileNumberLabl.transform = transitionTemp
        m_emrgmobileTextfield.transform = transitionTemp
        userEmailLbl.transform = transitionTemp
        
        
        //Sroll enabled for iPhone SE and 5s
//        if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
//        {
//            self.empDetailsScrollView.isScrollEnabled = true
//        }
//        else {
//            self.empDetailsScrollView.isScrollEnabled = false
//        }
//
        
        if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            lblEmpDetails.font = Font(.installed(.MontserratBold), size: .custom(22.0)).instance
            
        }
        else {
            lblEmpDetails.font = Font(.installed(.MontserratBold), size: .standard(.bold)).instance
            
        }
        
        
        self.lblEmpDetails.dropShadow()
        self.empDetailsScrollView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.red
        
        
        
        //self.view.setGradientBackgroundColor(colorTop: EnrollmentColor.dependantListTop.value, colorBottom: EnrollmentColor.dependantListBottom.value, startPoint: startPoint, endPoint: endPoint)
        
        // self.empDetailsScrollView.setGradientBackgroundColor(colorTop: EnrollmentColor.dependantListTop.value, colorBottom: EnrollmentColor.dependantListBottom.value, startPoint: startPoint, endPoint: endPoint)
        
        //setColorNew(view: self.view, colorTop: EnrollmentColor.empDetailsTop.value, colorBottom: EnrollmentColor.empDetailsBottom.value,gradientLayer:gradientLayer)
        
        self.view.setGradientForEmpDetails(colorTop: EnrollmentColor.empDetailsTop.value, colorBottom: EnrollmentColor.empDetailsBottom.value, startPoint: startPoint, endPoint: endPoint, angle: 13, gradientLayer: gradientLayer)
        
        // self.view.layer.contents = #imageLiteral(resourceName: "instructionsbg").cgImage
        //self.view.layer.contents = #imageLiteral(resourceName: "gmctopupbg").cgImage
        
        
        // if #available(iOS 13.0, *) {
        //imgInstructions.image = UIImage(systemName: "info.circle.fill")
        // imgInstructions2.image = UIImage(systemName: "info.circle.fill")
        
        //} else {
        // Fallback on earlier versions
        // imgInstructions.image = UIImage(named: "infoBlue")
        //imgInstructions2.image = UIImage(named: "infoBlue")
        //}
        
        //Commented by Pranit
        //UINavigationBar.appearance().tintColor = UIColor.white
        // UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        //self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        //navigationController?.navigationBar.dropShadow()
        
        
        m_dependantDetailsTableview.register(AddDependantTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        m_dependantDetailsTableview.register(UINib(nibName: "AddDependantTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        topupTableView.register(TopupTableViewCell.self, forCellReuseIdentifier: "cell")
        topupTableView.register(UINib(nibName: "TopupTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        /*  if let dict : NSDictionary = UserDefaults.standard.value(forKey: "AdminSettingsDic") as? NSDictionary
         {
         
         if let date = dict.value(forKey: "WINDOW_PERIOD_END_DATE")as? String
         {
         let period :String = dict.value(forKey: "WINDOW_PERIOD_ACTIVE") as! String
         if(period == "0")
         {
         let addDependantVC : AddDependantViewController = AddDependantViewController()
         navigationController?.pushViewController(addDependantVC, animated: true)
         }
         m_windowPeriodLabl.text="active till "+date
         m_windowPeriodEndDate = convertStringToDate(dateString:date)
         calculateRemainingDays()
         }
         
         }*/
        
        //Added By Pranit
        self.m_premiumCheckImageView.isHidden = true
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if(userArray.count>0)
        {
            m_employeeDict=userArray[0]
        }
        if let enrollmentMiscInfo = UserDefaults.standard.value(forKey: "EnrollmentMiscInformation")
        {
            m_enrollmentMiscInformationDict = enrollmentMiscInfo as! NSDictionary
        }
        
        // navigationItem.rightBarButtonItem = getRightNvigationBarButton()
        
        setLayout()
        //getPersonDetails() //commented by pranit on 29th march 2020
        //getLoadSessionValuesFromPostUrl(status: "") //commented by pranit on 29th march 2020
       // getTopupOptions() //commented by pranit on 29th march 2020
        //setupProgressBar()
        m_dependantDetailsTableview.keyboardDismissMode = .interactive
        self.automaticallyAdjustsScrollViewInsets = false;
        
        print(m_isEnrollmentConfirmed)
        //progressBar.currentIndex=0
        
        if selectedIndexForView == 0 {
            progressBar.currentIndex = 0
            showEmployeeDetailsView()
            self.navigationItem.leftBarButtonItem = nil
            
        }
        else if selectedIndexForView == 1 {
            progressBar.currentIndex = 1
            showAddDependantView()
        }
        else {
            self.navigationItem.leftBarButtonItem=getBackButtonHideTabBar()
            progressBar.currentIndex=2
            showTopupView()
            
        }
        
        self.empDetailsScrollView.isDirectionalLockEnabled = false
        m_emrgmobileTextfield.font =  UIFont.init(name: "Montserrat-Medium", size: 16.0)
        m_emrgmobileTextfield.maxLength = 10
        animateUI()
    }
    
    private func animateUI() {
        //Top View
        let transitionNew1 = CGAffineTransform(translationX:self.imgEmp.frame.origin.x - 500  , y: 0)
        self.imgEmp.transform = transitionNew1
        self.lblEmpDetails.transform = transitionNew1
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
            let reset = CGAffineTransform(translationX: 0, y: 0)
            self.imgEmp.transform = reset
            self.lblEmpDetails.transform = reset
        }, completion: {
            (value: Bool) in
        })
        
        
        //Emp Details view
        /*
         let transitionNew2 = CGAffineTransform(translationX:self.m_empoyeeDetailsBackgroundView.frame.origin.x + 500  , y: 0)
         self.m_empoyeeDetailsBackgroundView.transform = transitionNew2
         UIView.animate(withDuration: 0.6, delay: 0.2, options: [], animations: {
         let reset = CGAffineTransform(translationX: 0, y: 0)
         self.m_empoyeeDetailsBackgroundView.transform = reset
         }, completion: {
         (value: Bool) in
         })
         */
        
        let transitionNew2 = CGAffineTransform(translationX: 500  , y: 0)
        self.m_nameLbl.transform = transitionNew2
        self.headerNameLbl.transform = transitionNew2
        
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
            let reset = CGAffineTransform(translationX: 0, y: 0)
            self.m_nameLbl.transform = reset
            self.headerNameLbl.transform = reset
            
        }, completion: {
            (value: Bool) in
            
            //2 start
            let transitionNew2 = CGAffineTransform(translationX: 500  , y: 0)
            self.m_empIDLbl.transform = transitionNew2
            self.headerEmpIdLbl.transform = transitionNew2
            
            UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
                let reset = CGAffineTransform(translationX: 0, y: 0)
                self.m_empIDLbl.transform = reset
                self.headerEmpIdLbl.transform = reset
                
            }, completion: {
                (value: Bool) in
                
                //3start
                let transitionNew2 = CGAffineTransform(translationX: 500  , y: 0)
                self.m_dateofBirthLbl.transform = transitionNew2
                self.headerDobLbl.transform = transitionNew2
                
                self.lblAge.transform = transitionNew2
                self.headerAgeLbl.transform = transitionNew2
                
                UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
                    let reset = CGAffineTransform(translationX: 0, y: 0)
                    self.lblAge.transform = reset
                    self.headerAgeLbl.transform = reset
                    
                    self.m_dateofBirthLbl.transform = reset
                    self.headerDobLbl.transform = reset
                    
                }, completion: {
                    (value: Bool) in
                    //4 start - mobile no
                    let transitionNew1 = CGAffineTransform(translationX:self.imgEmp.frame.origin.x + 500  , y: 0)
                    self.headerMobileLbl.transform = transitionNew1
                    self.m_mobileNumberLabl.transform = transitionNew1
                    
                    UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
                        let reset = CGAffineTransform(translationX: 0, y: 0)
                        self.headerMobileLbl.transform = reset
                        self.m_mobileNumberLabl.transform = reset
                        
                    }, completion: {
                        (value: Bool) in
                        
                        let transitionNew1 = CGAffineTransform(translationX:self.imgEmp.frame.origin.x + 500  , y: 0)
                        self.headerEmrgMobileLbl.transform = transitionNew1
                        self.m_emrgmobileTextfield.transform = transitionNew1
                        self.btnEditMobile.transform = transitionNew1
                        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
                            let reset = CGAffineTransform(translationX: 0, y: 0)
                           
                            self.headerEmrgMobileLbl.transform = reset
                            self.m_emrgmobileTextfield.transform = reset
                            self.btnEditMobile.transform = reset
                            
                            let bottomLine = CALayer()
                            bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:self.m_emrgmobileTextfield.frame.height - 1), size: CGSize(width: self.m_emrgmobileTextfield.frame.width - 40, height:  1))
                            bottomLine.backgroundColor = UIColor.clear.cgColor
                            self.m_emrgmobileTextfield.borderStyle = UITextBorderStyle.none
                            self.m_emrgmobileTextfield.layer.addSublayer(bottomLine)
                            
                        }, completion: {
                            (value: Bool) in
                            
                            
                            //5 start - mobile no
                            let transitionNew1 = CGAffineTransform(translationX: 500  , y: 0)
                            self.headerEmailLbl.transform = transitionNew1
                            self.userEmailLbl.transform = transitionNew1
                            UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
                                let reset = CGAffineTransform(translationX: 0, y: 0)
                                self.headerEmailLbl.transform = reset
                                self.userEmailLbl.transform = reset
                            }, completion: {
                                (value: Bool) in
                            })
                            
                            //5 end
                            
                        })
                        
                    })
                    
                    //4 end
                })
                //3 end
            })
            //2 end
            
            
            
        })
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        super.updateViewConstraints()
        m_dependantTableViewHeightConstraint.constant = self.m_dependantDetailsTableview.contentSize.height
        
        //        m_topupTableviewHeightConstraint.constant = self.topupTableView.contentSize.height
    }
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = self.view.bounds
        CATransaction.commit()
    }
    
    func setColor(view:UIView,colorTop:UIColor,colorBottom:UIColor) {
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        
        //gradientLayer.startPoint = startPoint
        //gradientLayer.endPoint = endPoint
        
        
        
        let startPoint = CGPoint(x:0.0, y:0.0)
        let endPoint = CGPoint(x:1.0, y:1.0)
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = [0.5, 1.0]
        
        
        // gradientLayer.locations = [0.7, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.view.myCustomAnimation()
        let startPoint = CGPoint(x:0.0, y:0.5)
        let endPoint = CGPoint(x:1.0, y:0.5)
        
        //self.view.setGradientBackgroundColor(colorTop: EnrollmentColor.empDetailsTop.value, colorBottom: EnrollmentColor.empDetailsBottom.value, startPoint: startPoint, endPoint: endPoint)
        
        //MARK:- Set Alpha
        m_empoyeeDetailsBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        //m_empoyeeDetailsBackgroundView.layer.borderColor = #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1)
        //m_empoyeeDetailsBackgroundView.layer.borderWidth = 2.0
        // m_empoyeeDetailsBackgroundView.dropShadow()
        
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.title="Enrollment"
        self.navigationItem.leftBarButtonItem=getBackButtonHideTabBar()
        
        //Commented by Pranit - to remove barbutton summary
        //navigationItem.rightBarButtonItem=getRightNvigationBarButton()
        
        m_instructionLbl.layer.masksToBounds=true
        m_instructionLbl.layer.cornerRadius=m_instructionLbl.frame.height/2
        m_enrollmentDetailsBackgroundView.layer.borderColor=hexStringToUIColor(hex: hightlightColor).cgColor
        m_enrollmentDetailsBackgroundView.layer.borderWidth=1
        self.setData()
        
        
        m_employeeDetailsTitleView.layer.masksToBounds=true
        m_employeeDetailsTitleView.layer.cornerRadius=6
        
        
        
    }
    //MARK:- Get Summary Bar Button
    func getRightNvigationBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(title: "Summary", style: .plain, target: self, action: #selector(navigationBarRightButtonClicked))
        
        //            UIBarButtonItem(image:#imageLiteral(resourceName: "notification"), style: .plain, target: self, action: #selector(navigationBarRightButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    
    //MARK:- Get Empty Button
    func getEmptyBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(emptyMethod))
        return button1
    }
    @objc func emptyMethod() {
        
    }
    
    @objc func navigationBarRightButtonClicked()
    {
        print ("rightButtonClicked")
        let enrollmentSummery : EnrollmentSummaryViewController = EnrollmentSummaryViewController()
        enrollmentSummery.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
        enrollmentSummery.m_windowPeriodEndDate=m_windowPeriodEndDate
        navigationController?.pushViewController(enrollmentSummery, animated: true)
        
    }
    override func viewWillLayoutSubviews()
    {
        super.updateViewConstraints()
        m_dependantTableViewHeightConstraint.constant = self.m_dependantDetailsTableview.contentSize.height
        
        //        m_topupTableviewHeightConstraint.constant = self.topupTableView.contentSize.height
    }
    
    //MARK:- Get TopUp Options
    func getTopupOptions()
    {
        if let topupOptions = UserDefaults.standard.value(forKey: "EnrollmentTopUpOptions")
        {
            m_enrollmentTopUpOptions = topupOptions as! NSDictionary
            print(m_enrollmentTopUpOptions)
        }
        
        if let m_isGMCTopupApplicable = m_enrollmentTopUpOptions.value(forKey: "GMCTopup")
        {
            if(m_isGMCTopupApplicable as? String=="YES")
            {
                m_topupTitleArray.append("GHI Top-up Sum Insured")
            }
        }
        if let m_isGPATopupApplicable = m_enrollmentTopUpOptions.value(forKey: "GPATopup")
        {
            if(m_isGPATopupApplicable as? String=="YES")
            {
                m_topupTitleArray.append("GPA Top-up Sum Insured")
            }
        }
        if let m_isGTLTopupApplicable = m_enrollmentTopUpOptions.value(forKey: "GTLTopup")
        {
            if(m_isGTLTopupApplicable as? String=="YES")
            {
                m_topupTitleArray.append("GTL Top-up Sum Insured")
            }
        }
        if var bsi = m_employeeDict?.baseSumInsured
        {
            bsi = bsi.replacingOccurrences(of: ",", with: "")
            let GMCTopupArray = DatabaseManager.sharedInstance.retrieveTopupDetails(productCode: "GMC", bsi: bsi)
            for i in 0..<GMCTopupArray.count
            {
                let dict : TopupDetails = GMCTopupArray[i]
                GMCTopupOptionArray.append(dict)
            }
        }
        let GPATopupArray = DatabaseManager.sharedInstance.retrieveTopupDetails(productCode: "GPA", bsi: "")
        for i in 0..<GPATopupArray.count
        {
            let dict : TopupDetails = GPATopupArray[i]
            GPATopupOptionArray.append(dict)
        }
        let GTLTopupArray = DatabaseManager.sharedInstance.retrieveTopupDetails(productCode: "GTL", bsi: "")
        for i in 0..<GTLTopupArray.count
        {
            let dict : TopupDetails = GTLTopupArray[i]
            GTLTopupOptionArray.append(dict)
        }
        
        //       for i in 0..<m_topupTitleArray.count
        //       {
        //             self.datasource.append(TopupCellContent(title:"Topup", otherInfo:m_topupTitleArray[i]))
        //        }
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if(userArray.count>0)
        {
            m_employeeDict=userArray[0]
        }
        
        
        
    }
    func getPersonDetails()
    {
        addedPersonDetailsArray=[]
        m_membersRelationIdArray=[]
        m_membersArray=[]
        m_productCode="GMC"
        
        let array = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: m_spouse)
        if(array.count>0)
        {
            addedPersonDetailsArray.append(array[0])
        }
        
        let arrayofSon = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "SON")
        if(arrayofSon.count>0)
        {
            
            if(arrayofSon.count==2)
            {
                addedPersonDetailsArray.append(arrayofSon[0])
                addedPersonDetailsArray.append(arrayofSon[1])
            }
            else if(arrayofSon.count==3)
            {
                addedPersonDetailsArray.append(arrayofSon[0])
                addedPersonDetailsArray.append(arrayofSon[1])
                addedPersonDetailsArray.append(arrayofSon[2])
            }
            else
            {
                addedPersonDetailsArray.append(arrayofSon[0])
            }
        }
        
        
        let arrayofDaughter = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "DAUGHTER")
        if(arrayofDaughter.count>0)
        {
            if(arrayofDaughter.count==2)
            {
                addedPersonDetailsArray.append(arrayofDaughter[0])
                addedPersonDetailsArray.append(arrayofDaughter[1])
            }
            else if(arrayofDaughter.count==3)
            {
                addedPersonDetailsArray.append(arrayofDaughter[0])
                addedPersonDetailsArray.append(arrayofDaughter[1])
                addedPersonDetailsArray.append(arrayofDaughter[2])
            }
            else
            {
                addedPersonDetailsArray.append(arrayofDaughter[0])
            }
        }
        
        //        let fatherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER")
        //        if(fatherarray.count>0)
        //        {
        //            addedPersonDetailsArray.append(fatherarray[0])
        //        }
        //        let motherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER")
        //        if(motherarray.count>0)
        //        {
        //            addedPersonDetailsArray.append(motherarray[0])
        //        }
        //        let fatherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER-IN-LAW")
        //        if(fatherInLawarray.count>0)
        //        {
        //            addedPersonDetailsArray.append(fatherInLawarray[0])
        //        }
        //        let motherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER-IN-LAW")
        //        if(motherInLawarray.count>0)
        //        {
        //            addedPersonDetailsArray.append(motherInLawarray[0])
        //        }
        
        self.m_dependantDetailsTableview.reloadData()
        print(addedPersonDetailsArray)
        getRelationsfromServer()
        
        //        let sortedPersonDetailsArray=DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:"EMPLOYEE")
        //        addedPersonDetailsArray.remove(at: 0)
        /* let relationsArray = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: "")
         var addedRelationsArray = Array<String>()
         var personRelationsArray = Array<String>()
         for i in 0..<relationsArray.count
         {
         let dict : EnrollmentGroupRelations = relationsArray[i]
         personRelationsArray.append(dict.relationName!)
         m_membersArray.append(dict.relationName!)
         m_membersRelationIdArray.append(dict.relationID!)
         
         
         }
         for i in 0..<addedPersonDetailsArray.count
         {
         let dict : PERSON_INFORMATION = addedPersonDetailsArray[i]
         addedRelationsArray.append(dict.relationname!)
         
         }
         addedPersonDetailsArray.remove(at: 0)
         for i in 0..<addedRelationsArray.count
         {
         if(personRelationsArray.contains(addedRelationsArray[i]))
         {
         let itemToRemove = addedRelationsArray[i]
         if let index = m_membersArray.index(of: itemToRemove)
         {
         m_membersArray.remove(at: index)
         let itemRemove = m_membersRelationIdArray[index]
         if let index = m_membersRelationIdArray.index(of: itemRemove)
         {
         m_membersRelationIdArray.remove(at: index)
         }
         }
         
         }
         }*/
        
        print(m_membersArray,m_membersRelationIdArray,addedPersonDetailsArray)
        
        
        
        
    }
    
    @IBAction func selectRelationButtonClicked(_ sender: Any)
    {
        view.endEditing(true)
        setupArrowDropDown(sender as! UIButton, at: 0)
        relationDropDown.show()
    }
    
    //MARK:- Get Relations
    func getRelationsfromServer()
    {
        print("#getRelationsfromServer().....")
        if(isConnectedToNetWithAlert())
        {
            
            showPleaseWait(msg: "Please wait updating details...")
            
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getRelationsPostUrl() as String)
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
                
                var oe_group_base_Info_Sr_No = String()
                var groupChildSrNo = String()
                var employeesrno = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                if let employeeno = m_employeedict?.empSrNo
                {
                    employeesrno=String(employeeno)
                }
                
                let yourXML = AEXMLDocument()
                
                let dataRequest = yourXML.addChild(name: "DataRequest")
                dataRequest.addChild(name: "groupchildsrno", value: groupChildSrNo)
                dataRequest.addChild(name: "oegrpbasinfsrno", value: oe_group_base_Info_Sr_No)
                dataRequest.addChild(name: "employeesrno", value: employeesrno)
                
                print(yourXML.xml)
                let uploadData = yourXML.xml.data(using: .utf8)
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "POST"
                request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
                //            request.setValue("application/json", forHTTPHeaderField: "Accept")
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
                                    
                                    self.xmlKey = "PendingRelations"
                                    let parser = XMLParser(data: data!)
                                    parser.delegate = self as? XMLParserDelegate
                                    parser.parse()
                                    
                                    DispatchQueue.main.async(execute:
                                        {
                                            
                                            if((self.pendingRelationsDictArray?.count)!>0)
                                            {
                                                for dict in self.pendingRelationsDictArray!
                                                {
                                                    let infoDict : NSDictionary = dict as NSDictionary
                                                    
                                                    if let name = infoDict.value(forKey: "Name")
                                                    {
                                                        self.m_membersArray.append(name as! String)
                                                        if let ID = infoDict.value(forKey: "ID")
                                                        {
                                                            self.m_membersRelationIdArray.append(ID as! String)
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                            
                                            
                                            if(self.progressBar.currentIndex==1)
                                            {
                                                if(self.m_membersArray.count==0)
                                                {
                                                    self.m_addDependantView.isHidden=true
                                                    self.m_addDependantTableViewTopConstraint.constant=15
                                                }
                                                else
                                                {
                                                    if(self.checkConfirmedStatus())
                                                    {
                                                        self.m_addDependantView.isHidden=false
                                                        self.setAddDependantViewLayout()
                                                        
                                                    }
                                                    else
                                                    {
                                                        self.m_addDependantView.isHidden=true
                                                        self.m_addDependantTableViewTopConstraint.constant=15
                                                    }
                                                    
                                                }
                                            }
                                            
                                            //Commented by Pranit - avoid UI hikup when user come to dependant details screen,
                                            //self.m_dependantDetailsTableview.reloadData()
                                            
                                            self.hidePleaseWait()
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
            
            
        }
    }
    
    //MARK:- Add TopUp DB
    func addTopup(indexpath:IndexPath)
    {
        
        
        var topupoptedsrno = String()
        var topupsuminsured = String()
        var disclaimeragreedflag = String()
        var topupOptedflag = String()
        var userArray = [EMPLOYEE_INFORMATION]()
        switch indexpath.row
        {
        case 0 :
            userArray  = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            topupsuminsured=m_selectedGMCTopupAmount
            
            
            
            break
        case 1 :
            userArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GPA")
            topupsuminsured=m_selectedGPATopupAmount
            break
        case 2 :
            userArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GTL")
            topupsuminsured=m_selectedGTLTopupAmount
            break
        default :
            break
        }
        if(userArray.count>0)
        {
            m_employeeDict=userArray[0]
        }
        
        
        
        if let topupoptedno = m_employeeDict?.topupSrNo
        {
            topupoptedsrno = topupoptedno
        }
        if(m_isTopupConditionsAccepted)
        {
            disclaimeragreedflag="1"
        }
        else
        {
            disclaimeragreedflag="0"
        }
        if(m_isToupChecked)
        {
            topupOptedflag="1"
        }
        else
        {
            topupOptedflag="0"
        }
        
        addTopupDict = ["topupoptedsrno":topupoptedsrno,"topupsuminsured":topupsuminsured,"disclaimeragreedflag":disclaimeragreedflag,"topupOptedflag":topupOptedflag]
        
        
    }
    
    //MARK:- Add TopUp Server WS
    func callAddTopupWebservice()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: """
Please wait...
adding Topup
""")
            let yourXML = AEXMLDocument()
            
            let topupSrNo : String = addTopupDict.value(forKey: "topupoptedsrno") as! String
            var topupsuminsured : String = addTopupDict.value(forKey: "topupsuminsured") as! String
            let topupOptedflag : String = addTopupDict.value(forKey: "topupOptedflag") as! String
            let disclaimeragreedflag : String = addTopupDict.value(forKey: "disclaimeragreedflag") as! String
            
            topupsuminsured=topupsuminsured.replacingOccurrences(of: ",", with: "")
            
            let dataRequest = yourXML.addChild(name: "DataRequest");
            
            dataRequest.addChild(name: "topupoptedsrno", value:topupSrNo)
            
            dataRequest.addChild(name: "topupsuminsured", value:topupsuminsured)
            
            dataRequest.addChild(name: "topupoptedflag", value:topupOptedflag)
            
            dataRequest.addChild(name: "disclaimeragreedflag", value:disclaimeragreedflag)
            
            
            
            print(yourXML.xml)
            let uploadData = yourXML.xml.data(using: .utf8)
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getAddTopupPostUrl())
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
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
                                
                                DispatchQueue.main.async(execute:
                                    {
                                        print(self.resultsDictArray!)
                                        self.hidePleaseWait()
                                        if((self.resultsDictArray?.count)!>0)
                                        {
                                            for dict in self.resultsDictArray!
                                            {
                                                let infoDict : NSDictionary = dict as NSDictionary
                                                
                                                if let status = infoDict.value(forKey: "status")
                                                {
                                                    
                                                    
                                                    
                                                    self.indexNumber=0;                                           self.getUpdatedTopupFromServer()
                                                    
                                                    //self.displayActivityAlert(title: infoDict.value(forKey: "TopupInformation") as! String)
                                                    
                                                    //Display msg topup opted successfuly
                                                    self.displayActivityAlert(title: "Top-up opted successfully")
                                                    
                                                }
                                                
                                            }
                                        }
                                        self.hidePleaseWait()
                                        if(self.m_webserviceStatus != "")
                                        {
                                            self.displayActivityAlert(title: self.m_webserviceStatus)
                                        }
                                        //                                    self.m_dependantDetailsTableview.reloadData()
                                        
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
                            
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed")
                            self.hidePleaseWait()
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
            displayActivityAlert(title: "No Internet Connection")
        }
        
    }
    
    //MARK:- Top Up Deleted
    func topupDeleted()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: """
Please wait...
deleting Topup
""")
            let yourXML = AEXMLDocument()
            
            let topupSrNo : String = addTopupDict.value(forKey: "topupoptedsrno") as! String
            var topupsuminsured = "0"
            let topupOptedflag = "0"
            let disclaimeragreedflag = "0"
            
            
            let dataRequest = yourXML.addChild(name: "DataRequest");
            
            dataRequest.addChild(name: "topupoptedsrno", value:topupSrNo)
            
            dataRequest.addChild(name: "topupsuminsured", value:topupsuminsured)
            
            dataRequest.addChild(name: "topupoptedflag", value:topupOptedflag)
            
            dataRequest.addChild(name: "disclaimeragreedflag", value:disclaimeragreedflag)
            
            
            
            print(yourXML.xml)
            let uploadData = yourXML.xml.data(using: .utf8)
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getAddTopupPostUrl())
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
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
                                
                                DispatchQueue.main.async(execute:
                                    {
                                        print(self.resultsDictArray!)
                                        self.hidePleaseWait()
                                        if((self.resultsDictArray?.count)!>0)
                                        {
                                            for dict in self.resultsDictArray!
                                            {
                                                let infoDict : NSDictionary = dict as NSDictionary
                                                
                                                if let status = infoDict.value(forKey: "status")
                                                {
                                                    
                                                    
                                                    
                                                    self.indexNumber=0;                                           self.getUpdatedTopupFromServer()
                                                    self.displayActivityAlert(title:"Top-up removed successfully")
                                                    
                                                    
                                                }
                                                
                                            }
                                        }
                                        self.hidePleaseWait()
                                        if(self.m_webserviceStatus != "")
                                        {
                                            self.displayActivityAlert(title: self.m_webserviceStatus)
                                        }
                                        //                                    self.m_dependantDetailsTableview.reloadData()
                                        
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
                            
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed")
                            self.hidePleaseWait()
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
            displayActivityAlert(title: "No Internet Connection")
        }
        
    }
    
    @objc private func homeButtonClicked(sender: UIButton)
    {
        let dashboard : NewDashboardViewController = NewDashboardViewController()
        navigationController?.popToViewController(dashboard, animated: true)
        tabBarController!.selectedIndex = 2
    }
    
    //MARK:- Topup Next Button Tapped
    @IBAction func topupNextButtonClicked(_ sender: Any)
    {
        
        
        
        /* if(m_isTopupConditionsAccepted)
         {
         self.progressBar.currentIndex=2
         self.showTopupView()
         let indexpath = IndexPath(row: 0, section: 0)
         addTopup(indexpath: indexpath)
         callAddTopupWebservice()
         
         }
         else
         {
         if(m_windowPeriodStatus)
         {
         if(checkConfirmedStatus())
         {
         displayActivityAlert(title: "Please accept the terms")
         }
         else
         {
         displayActivityAlert(title: "You already confirmed the enrollment")
         }
         
         }
         else
         {
         let summaryVC : EnrollmentSummaryViewController = EnrollmentSummaryViewController()
         self.navigationController?.pushViewController(summaryVC, animated: true)
         }
         
         }*/
        
        if(m_isOptTopup)
        {
            
            if(m_isTopupConditionsAccepted)
            {
                //                let summaryVC : EnrollmentSummaryViewController = EnrollmentSummaryViewController()
                //                summaryVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
                //                summaryVC.m_windowPeriodEndDate=m_windowPeriodEndDate
                //                self.navigationController?.pushViewController(summaryVC, animated: true)
                /*
                let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"HealthPackagesVC") as! HealthPackagesVC
                self.navigationController?.pushViewController(flexIntroVC, animated: true)
                */
                print("m_isTopupConditionsAccepted")
            }
            else
            {
                displayActivityAlert(title: "Please check all disclaimers!!!")
            }
        }
        else
        {
            //            let summaryVC : EnrollmentSummaryViewController = EnrollmentSummaryViewController()
            //            summaryVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            //            summaryVC.m_windowPeriodEndDate=m_windowPeriodEndDate
            //            self.navigationController?.pushViewController(summaryVC, animated: true)
            /*let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"HealthPackagesVC") as! HealthPackagesVC
            self.navigationController?.pushViewController(flexIntroVC, animated: true)
            */
            print("else of m_isOptTopup")
            
        }
        
    }
    
    //MARK:- Validation
    @IBAction func addDependantButtonClicked(_ sender: UIButton)
    {
        m_selectRelationButton.isHidden=false
        m_addDependantView.endEditing(true)
        
        //        if(m_ageTextfield.text != "")
        //        {
        //            let age1 : Int = Int(m_ageTextfield.text!)!
        //            if(age1 != m_calculatedAge)
        //            {
        //                m_dobTextField.text=""
        //            }
        //        }
        if(m_relationTextfield.text=="")
        {
            m_relationTextfield.errorMessage="Select Dependant"
        }
        else if(m_nameTextfield.text=="")
        {
            m_nameTextfield.errorMessage="Enter Name"
        }
        else if(m_dobTextField.text=="")
        {
            if(m_dobNotAvailable)
            {
                if(m_ageTextfield.text=="")
                {
                    m_ageTextfield.errorMessage="Enter Age"
                }
                else
                {
                    addDependantValidation(sender: sender)
                }
            }
            else
            {
                m_dobTextField.errorMessage="Date is required"
            }
            
        } //if dob is empty
        else if(m_ageTextfield.text=="")
        {
            m_ageTextfield.errorMessage="Enter Age"
        }
            
        else if(m_relationTextfield.text=="WIFE"||m_relationTextfield.text=="HUSBAND")
        {
            if(!m_windowPeriodStatus)
            {
                // self.m_domTextfield.isHidden=false
                if m_domTextfield.text == "" {
                    m_domTextfield.errorMessage="Date is required"
                }
                else {
                    addDependantValidation(sender: sender)
                }
            }
                
            else
            {
                addDependantValidation(sender: sender)
            }
        }
            
        else
        {
            addDependantValidation(sender: sender)
        }
        
        
    }
    
    //MARK:- Dependant Validation
    func addDependantValidation(sender:UIButton)
    {
        
        if(m_isUpdated) //edit
        {
            if(m_arrayofParents.contains(m_relationTextfield.text!))
            {
                if(m_dobNotAvailable)
                {
                    if let age = self.m_ageTextfield.text {
                        if age != "" {
                            let ageInt = Int(age)
                            if ageInt! < 18 {
                                //m_ageTextfield.errorMessage = "Age should be greater than 18"
                                
                                displayActivityAlert(title: "Age should be greater than 18")
                            }
                            else if(m_isPremiumAccepted)
                            {
                                updateDependantDetails(indexpath: IndexPath(row: sender.tag, section: 0))
                            }
                            else
                            {
                                //displayActivityAlert(title: "Please check all disclaimers!!!")
                                self.m_premiumStatementLbl.textColor = UIColor.red
                            }
                        }
                        else {
                            //please enter age
                            print("Enter Age")
                        }
                    }
                    
                }
                else {
                    print("Edit Dependant")
                    if(m_isPremiumAccepted)
                    {
                        updateDependantDetails(indexpath: IndexPath(row: sender.tag, section: 0))
                    }
                    else
                    {
                        //displayActivityAlert(title: "Please check all disclaimers!!!")
                        self.m_premiumStatementLbl.textColor = UIColor.red
                    }
                }
                
            }
                //End
                
            else
            {
                updateDependantDetails(indexpath: IndexPath(row: sender.tag, section: 0))
            }
            
            
            
            
        }
        else
        { //Add
            let maxAge = calculateMaxAge()
            if(maxAge != "")
            {
                let selectedDOBDate = convertStringToDate(dateString: m_dobTextField.text!)
                let calculatedAge = calculateAge(selectedDate: selectedDOBDate)
                if(calculatedAge<0)
                {
                    displayActivityAlert(title: "Age should be Zero or greater than Zero")
                }
                else if(calculatedAge > maxAge.intValue)
                {
                    displayActivityAlert(title: "Age should be below \(maxAge)")
                }
                    
                    //Added By Pranit
                else if(m_arrayofParents.contains(m_relationTextfield.text!))
                {
                    if(m_dobNotAvailable)
                    {
                        if let age = self.m_ageTextfield.text {
                            if age != "" {
                                let ageInt = Int(age)
                                if ageInt! < 18 {
                                    //m_ageTextfield.errorMessage = "Age should be greater than 18"
                                    
                                    displayActivityAlert(title: "Age should be greater than 18")
                                }
                                else if(m_isPremiumAccepted)
                                {
                                    addDependantOnServer()
                                }
                                else
                                {
                                    //displayActivityAlert(title: "Please check all disclaimers!!!")
                                    self.m_premiumStatementLbl.textColor = UIColor.red
                                }
                            }
                            else {
                                //please enter age
                                print("Enter Age")
                            }
                        }
                        
                    }
                    else {
                        print("Add Dependant")
                        if(m_isPremiumAccepted)
                        {
                            addDependantOnServer()
                        }
                        else
                        {
                            //displayActivityAlert(title: "Please check all disclaimers!!!")
                            self.m_premiumStatementLbl.textColor = UIColor.red
                        }
                    }
                    
                }
                    //End
                    
                else
                {
                    addDependantOnServer()
                }
                
                
            }
            else
            { //maxAge == ""
                if(m_arrayofParents.contains(m_relationTextfield.text!))
                {
                    if(m_dobNotAvailable)
                    {
                        if let age = self.m_ageTextfield.text {
                            if age != "" {
                                let ageInt = Int(age)
                                if ageInt! < 18 {
                                    displayActivityAlert(title: "Age should be greater than 18")
                                    //m_ageTextfield.errorMessage = "Age should be greater than 18"
                                    
                                }
                                else if(m_isPremiumAccepted)
                                {
                                    addDependantOnServer()
                                }
                                else
                                {
                                    //displayActivityAlert(title: "Please check all disclaimers!!!")
                                    self.m_premiumStatementLbl.textColor = UIColor.red
                                }
                            }
                            else {
                                //please enter age
                                print("Enter Age")
                            }
                        }
                        
                    }
                    else {
                        print("Add Dependant")
                        if(m_isPremiumAccepted)
                        {
                            addDependantOnServer()
                        }
                        else
                        {
                            //displayActivityAlert(title: "Please check all disclaimers!!!")
                            self.m_premiumStatementLbl.textColor = UIColor.red
                        }
                    }
                    
                    
                }
                    //End
                    
                else
                {
                    addDependantOnServer()
                }
                
                
            }
            
        }
        
        
    }
    
    
    /*
     func addDependantValidation(sender:UIButton)
     {
     
     if(m_isUpdated) //edit
     {
     if(m_arrayofParents.contains(m_relationTextfield.text!))
     {
     if(m_isPremiumAccepted)
     {
     updateDependantDetails(indexpath: IndexPath(row: sender.tag, section: 0))
     }
     else
     {
     //displayActivityAlert(title: "Please check all disclaimers!!!")
     self.m_premiumStatementLbl.textColor = UIColor.red
     }
     
     }
     else
     {
     updateDependantDetails(indexpath: IndexPath(row: sender.tag, section: 0))
     }
     
     
     }
     else
     { //Add
     let maxAge = calculateMaxAge()
     if(maxAge != "")
     {
     let selectedDOBDate = convertStringToDate(dateString: m_dobTextField.text!)
     let calculatedAge = calculateAge(selectedDate: selectedDOBDate)
     if(calculatedAge<0)
     {
     displayActivityAlert(title: "Age should be Zero or greater than Zero")
     }
     else if(calculatedAge > maxAge.intValue)
     {
     displayActivityAlert(title: "Age should be below \(maxAge)")
     }
     
     //Added By Pranit
     else if(m_arrayofParents.contains(m_relationTextfield.text!))
     {
     if(m_dobNotAvailable)
     {
     if let age = self.m_ageTextfield.text {
     if age != "" {
     let ageInt = Int(age)
     if ageInt! < 18 || ageInt! > 99 {
     displayActivityAlert(title: "Age Should be between 18 to 100")
     }
     else if(m_isPremiumAccepted)
     {
     addDependantOnServer()
     }
     else
     {
     //displayActivityAlert(title: "Please check all disclaimers!!!")
     self.m_premiumStatementLbl.textColor = UIColor.red
     }
     }
     else {
     //please enter age
     print("Enter Age")
     }
     }
     
     }
     else {
     print("Add Dependant")
     if(m_isPremiumAccepted)
     {
     addDependantOnServer()
     }
     else
     {
     //displayActivityAlert(title: "Please check all disclaimers!!!")
     self.m_premiumStatementLbl.textColor = UIColor.red
     }
     }
     
     //                       else if(m_isPremiumAccepted)
     //                        {
     //                            addDependantOnServer()
     //                        }
     //                        else
     //                        {
     //                            //displayActivityAlert(title: "Please check all disclaimers!!!")
     //                            self.m_premiumStatementLbl.textColor = UIColor.red
     //                        }
     
     }
     //End
     
     else
     {
     addDependantOnServer()
     }
     
     
     }
     else
     { //maxAge == ""
     if(m_arrayofParents.contains(m_relationTextfield.text!))
     {
     if(m_isPremiumAccepted)
     {
     addDependantOnServer()
     }
     else
     {
     //displayActivityAlert(title: "Please check all disclaimers!!!")
     self.m_premiumStatementLbl.textColor = UIColor.red
     
     }
     
     }
     else
     {
     addDependantOnServer()
     }
     
     }
     
     }
     
     
     }
     */
    
    func calculateAge(selectedDate:Date)->Int
    {
        let gregorian = Calendar(identifier: .gregorian)
        let ageComponents = gregorian.dateComponents([.year], from: selectedDate, to: m_serverDate)
        let age = ageComponents.year!
        print(age)
        return age
    }
    @IBAction func cancelDependantButtonClicked(_ sender: Any)
    {
        if(m_relationTextfield.text != "" || m_nameTextfield.text != "" || m_dobTextField.text != "" || m_ageTextfield.text != "")
        {
            indexNumber=0
            m_isUpdated=false
            showPleaseWait(msg: "Please wait...")
            self.getLoadSessionValuesFromPostUrl(status: "")
            resetFields()
        }
    }
    func resetFields()
    {
        m_selectRelationButton.isHidden=false
        m_relationTextfield.text=""
        m_nameTextfield.text=""
        m_dobTextField.text=""
        m_ageTextfield.text=""
        m_domTextfield.text=""
        m_relationTextfield.errorMessage=""
        m_nameTextfield.errorMessage=""
        m_dobTextField.errorMessage=""
        m_ageTextfield.errorMessage=""
        m_domTextfield.errorMessage=""
        hideDOBCheckBox()
        m_dobCheckImageView.image=UIImage(named: "unchecked")
        m_premiumCheckImageView.image=UIImage(named: "checked")
        m_addEdittitle.text="Add Dependant"
        //Edited By Pranit
        m_addDependantButton.setTitle("ADD", for: .normal)
        view.endEditing(true)
        m_isEditing=false
        m_dobNotAvailable=false
        
        
    }
    func getLoadSessionValuesFromPostUrl(status:String)
    {
        if(isConnectedToNetWithAlert())
        {
            //            showPleaseWait(msg: "Please wait fetching dependant details...")
            
            
            let uploadDic:NSDictionary=["mobileno":m_mobileNumberTextField.text!]
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getAppSessionValuesPostUrl() as String)
            
            let yourXML = AEXMLDocument()
            
            let sortedPersonDetailsArray=DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:m_productCode, relationName: "EMPLOYEE")
            if sortedPersonDetailsArray.count > 0 {
                let mobNo = sortedPersonDetailsArray[0].cellPhoneNUmber
                let dataRequest = yourXML.addChild(name: "DataRequest")
                dataRequest.addChild(name: "mobileno", value: mobNo)
                print(m_loginIDMobileNumber)
                
                print(yourXML.xml)
                let uploadData = yourXML.xml.data(using: .utf8)
                
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
                                                        
                                                        break
                                                    case 1:
                                                        
                                                        break
                                                    case 2:
                                                        
                                                        break
                                                        
                                                    case 3 :
                                                        
                                                        break
                                                    case 4 :
                                                        /*let status = DatabaseManager.sharedInstance.deleteEmployeeDetails(productCode: "")
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
                                                         }*/
                                                        break
                                                        
                                                        
                                                    case 5 :
                                                        let status = DatabaseManager.sharedInstance.deletePersonDetails(personSrNo: "")
                                                        
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
                                                
                                                
                                                self.getPersonDetails()
                                                
                                                
                                                //Uncommented By Pranit
                                                self.hidePleaseWait()
                                                
                                            }
                                            else
                                            {
                                                self.hidePleaseWait()
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
                                print("else executed")
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
    }
    
    //MARK:- Get Updated Topup from Server
    func getUpdatedTopupFromServer()
    {
        if(isConnectedToNetWithAlert())
        {
            //            showPleaseWait(msg: "Please wait fetching dependant details...")
            
            
            let uploadDic:NSDictionary=["mobileno":m_mobileNumberTextField.text!]
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getAppSessionValuesPostUrl() as String)
            
            let yourXML = AEXMLDocument()
            
            let sortedPersonDetailsArray=DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:m_productCode, relationName: "EMPLOYEE")
            let mobNo = sortedPersonDetailsArray[0].cellPhoneNUmber
            let dataRequest = yourXML.addChild(name: "DataRequest")
            dataRequest.addChild(name: "mobileno", value: mobNo)
            print(m_loginIDMobileNumber)
            
            print(yourXML.xml)
            let uploadData = yourXML.xml.data(using: .utf8)
            
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
                                                    
                                                    break
                                                case 1:
                                                    
                                                    break
                                                case 2:
                                                    
                                                    break
                                                    
                                                case 3 :
                                                    
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
                                                    
                                                    break
                                                    
                                                default :
                                                    break
                                                    
                                                }
                                                
                                                print(userDict)
                                            }
                                            
                                            
                                            self.topupTableView.reloadData()
                                            
                                            
                                            
                                            //                                            self.hidePleaseWait()
                                            
                                        }
                                        else
                                        {
                                            self.hidePleaseWait()
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
                            print("else executed")
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
    
    //MARK:- ADD dependant on server
    func addDependantOnServer()
    {
        
        view.endEditing(true)
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: """
Please wait...
adding dependant
""")
            
            var employeesrno = String()
            var groupChildSrNo = String()
            var oegrpbasinfsrno = String()
            
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
            let yourXML = AEXMLDocument()
            
            //if(m_selectedDate=="")
            //Updated By Pranit - when we select dont know dob that time previously selected date send to server side
            if(m_dobTextField.text=="")
                
            {
                m_selectedDate="01~01~1900"
            }
            
            let dataRequest = yourXML.addChild(name: "DataRequest");
            dataRequest.addChild(name: "age", value:m_ageTextfield.text)
            dataRequest.addChild(name: "employeesrno", value:employeesrno)
            dataRequest.addChild(name: "dateofbirth", value:m_selectedDate)
            dataRequest.addChild(name: "relationid", value:m_relationID)
            dataRequest.addChild(name: "dependantname", value:m_nameTextfield.text)
            dataRequest.addChild(name: "gender", value:m_gender)
            dataRequest.addChild(name: "windowperiodactive", value:String(m_windowPeriodStatus))
            if(m_marrigeDate != "")
            {
                dataRequest.addChild(name: "dateofmarriage", value:m_marrigeDate)
            }
            else
            {
                dataRequest.addChild(name: "dateofmarriage", value:"01~01~1900")
            }
            
            dataRequest.addChild(name: "parentscoveredinbasepolicy", value:"NO")
            dataRequest.addChild(name: "groupchildsrno", value:groupChildSrNo)
            dataRequest.addChild(name: "oegrpbasinfsrno", value:oegrpbasinfsrno)
            
            
            print(yourXML.xml)
            let uploadData = yourXML.xml.data(using: .utf8)
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getAddDependantPostUrl())
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
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
                                
                                DispatchQueue.main.async(execute:
                                    {
                                        print(self.resultsDictArray!)
                                        self.hidePleaseWait()
                                        if((self.resultsDictArray?.count)!>0)
                                        {
                                            for dict in self.resultsDictArray!
                                            {
                                                let infoDict : NSDictionary = dict as NSDictionary
                                                
                                                if let status = infoDict.value(forKey: "DependantAddInformation")
                                                {
                                                    self.indexNumber=0
                                                    self.getLoadSessionValuesFromPostUrl(status: status as! String)
                                                    self.m_webserviceStatus=status as! String
                                                    self.resetFields()
                                                    
                                                }
                                                
                                            }
                                        }
                                        self.hidePleaseWait()
                                        if(self.m_webserviceStatus != "")
                                        {
                                            self.displayActivityAlert(title: self.m_webserviceStatus.capitalized)
                                        }
                                        //                                    self.m_dependantDetailsTableview.reloadData()
                                        
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
                            
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed")
                            self.hidePleaseWait()
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
            displayActivityAlert(title: "No Internet Connection")
        }
        
    }
    func updateDependantDetails(indexpath:IndexPath)
    {
        
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: """
Please wait...
updating dependant
""")
            
            m_isUpdated=false
            
            
            let yourXML = AEXMLDocument()
            
            let formatter = DateFormatter()
            let date = convertStringToDate(dateString: m_dobTextField.text!)
            formatter.dateFormat = "dd~MM~yyyy"
            var selectedDate = formatter.string(from: date)
            
            //if(m_selectedDate=="")
            //Updated By Pranit - when we select dont know dob that time previously selected date send to server side
            if(m_dobTextField.text=="")
                
            {
                selectedDate="01~01~1900"
            }
            
            print(m_editPersonDict)
            let personNo = m_editPersonDict.personSrNo
            let dataRequest = yourXML.addChild(name: "DataRequest");
            dataRequest.addChild(name: "personsrno", value:String(personNo))
            dataRequest.addChild(name: "age", value:m_ageTextfield.text)
            dataRequest.addChild(name: "dateofbirth", value:selectedDate)
            dataRequest.addChild(name: "dependantname", value:m_nameTextfield.text)
            
            
            print(yourXML.xml)
            let uploadData = yourXML.xml.data(using: .utf8)
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getUpdateDependantPostUrl())
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
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
                                
                                DispatchQueue.main.async(execute:
                                    {
                                        
                                        
                                        if((self.resultsDictArray?.count)!>0)
                                        {
                                            for dict in self.resultsDictArray!
                                            {
                                                let infoDict : NSDictionary = dict as NSDictionary
                                                if let status = infoDict.value(forKey: "DependantUpdateInformation")
                                                {
                                                    self.indexNumber=0
                                                    self.getLoadSessionValuesFromPostUrl(status: status as! String)
                                                    self.m_webserviceStatus=status as! String
                                                }
                                                else
                                                {
                                                    self.hidePleaseWait()
                                                    self.displayActivityAlert(title: "Something went wrong. Please try again")
                                                }
                                            }
                                            
                                        }
                                        self.hidePleaseWait()
                                        if(self.m_webserviceStatus != "")
                                        {
                                            self.displayActivityAlert(title: self.m_webserviceStatus.capitalized)
                                        }
                                        self.resetFields()
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
                            
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed")
                            self.hidePleaseWait()
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
            displayActivityAlert(title: "No Internet Connection")
        }
        
    }
    
    //MARK:- Delete Dependant
    func deleteDependantFromServer(indexpath:IndexPath)
    {
        
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: "Please wait... deleting dependant")
            
            
            
            var employeesrno = String()
            var groupChildSrNo = String()
            var oegrpbasinfsrno = String()
            
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
            let yourXML = AEXMLDocument()
            
            
            let personNo = addedPersonDetailsArray[indexpath.row].personSrNo
            let dataRequest = yourXML.addChild(name: "DataRequest");
            dataRequest.addChild(name: "personsrno", value:String(personNo))
            dataRequest.addChild(name: "employeesrno", value:employeesrno)
            dataRequest.addChild(name: "groupchildsrno", value:groupChildSrNo)
            
            
            print(yourXML.xml)
            let uploadData = yourXML.xml.data(using: .utf8)
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getDeleteDependantPostUrl())
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
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
                                
                                DispatchQueue.main.async(execute:
                                    {
                                        
                                        self.hidePleaseWait()
                                        if((self.resultsDictArray?.count)!>0)
                                        {
                                            for dict in self.resultsDictArray!
                                            {
                                                let infoDict:NSDictionary = dict as NSDictionary
                                                if let status = infoDict.value(forKey: "DependantDeleteInformation")
                                                {
                                                    self.indexNumber=0
                                                    self.getLoadSessionValuesFromPostUrl(status: status as! String)
                                                    self.m_webserviceStatus=status as! String
                                                }
                                            }
                                            
                                        }
                                        self.hidePleaseWait()
                                        if(self.m_webserviceStatus != "")
                                        {
                                            self.displayActivityAlert(title: self.m_webserviceStatus.capitalized)
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
                            print("400 - Failed")
                            
                            //self.displayActivityAlert(title: m_errorMsg)
                            //Updated By Pranit - changed Error Message
                            self.displayActivityAlert(title:"Dependent deletion failed")
                            
                            print("else executed")
                            self.hidePleaseWait()
                        }
                        
                    }
                    else
                    {
                        print("Can't cast response to NSHTTPURLResponse")
                        // self.displayActivityAlert(title: m_errorMsg)
                        //Updated By Pranit - changed Error Message
                        self.displayActivityAlert(title:"Dependent deletion failed")
                        
                        self.hidePleaseWait()
                        
                    }
                    
                }
            }
            
            task.resume()
            
            
        }
        else
        {
            displayActivityAlert(title: "No Internet Connection")
        }
        
    }
    
    //MARK:- Edit Dependant Click
    @objc func dependantEditButtonClicked(sender:UIButton)
    {
        
        if(!m_isEditing)
        {
            
            let indexPath = NSIndexPath(item: sender.tag, section: 0)
            m_dependantDetailsTableview.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.top, animated: true)
            
            //            self.m_scrollView.setContentOffset(CGPoint.zero, animated: true)
            //            m_dependantDetailsTableview.setContentOffset(.zero, animated: true)
            
            m_relationTextfield.errorMessage=nil
            m_nameTextfield.errorMessage=nil
            m_dobTextField.errorMessage=nil
            m_ageTextfield.errorMessage=nil
            m_domTextfield.errorMessage=nil
            
            m_isUpdated=true
            m_isEditing=true
            m_addEdittitle.text="Edit Dependant"
            //Edited By Pranit
            m_addDependantButton.setTitle("SAVE", for: .normal)
            m_selectRelationButton.isHidden=true
            m_editPersonDict = addedPersonDetailsArray[sender.tag]
            m_relationTextfield.text=m_editPersonDict.relationname
            m_nameTextfield.text=m_editPersonDict.personName
            m_dobTextField.text=m_editPersonDict.dateofBirth
            m_ageTextfield.text=String(m_editPersonDict.age)
            addedPersonDetailsArray.remove(at: sender.tag)
            
            switch m_editPersonDict.relationname
            {
            case "SON" :
                self.m_gender="MALE"
                self.hideDOM()
                self.hideDOBCheckBox()
                break
            case "DAUGHTER" :
                self.m_gender="FEMALE"
                self.hideDOM()
                self.hideDOBCheckBox()
                break
            case "WIFE" :
                self.m_gender="FEMALE"
                if(!m_windowPeriodStatus)
                {
                    self.m_domTextfield.isHidden=false
                }
                else
                {
                    self.m_domTextfield.isHidden=true
                }
                
                self.hideDOBCheckBox()
                break
            case "HUSBAND" :
                self.m_gender="MALE"
                if(!m_windowPeriodStatus)
                {
                    self.m_domTextfield.isHidden=false
                }
                else
                {
                    self.m_domTextfield.isHidden=true
                }
                self.hideDOBCheckBox()
                break
            case m_spouse :
                if(!m_windowPeriodStatus)
                {
                    self.m_domTextfield.isHidden=false
                }
                else
                {
                    self.m_domTextfield.isHidden=true
                }
                self.hideDOBCheckBox()
                break
            case "FATHER" :
                self.m_gender="MALE"
                self.hideDOM()
                self.showDOBCheckBox()
                break
            case "MOTHER" :
                self.m_gender="FEMALE"
                self.hideDOM()
                self.showDOBCheckBox()
                break
            case "FATHER-IN-LAW" :
                self.m_gender="MALE"
                self.hideDOM()
                self.showDOBCheckBox()
                break
            case "MOTHER-IN-LAW" :
                self.m_gender="FEMALE"
                self.hideDOM()
                self.showDOBCheckBox()
                break
                
            default :
                break
            }
            m_addDependantView.isHidden=false
            
            //Added by Pranit
            //To add checkbox for dob dont know in edit
            if (m_arrayofParents.contains(m_editPersonDict.relationname ?? ""))
            {
                if m_editPersonDict.dateofBirth == "01-Jan-1900" {
                    m_dobTextField.isUserInteractionEnabled=false
                    m_dobCheckImageView.image=UIImage(named: "checked")
                    m_dobNotAvailable=true
                    m_ageTextfield.isUserInteractionEnabled=true
                    m_dobTextField.text=""
                    m_selectedDate = "01~01~1900"
                }
            }
            
            setAddDependantViewLayout()
            m_dependantDetailsTableview.reloadData()
        }
        else
        {
            displayActivityAlert(title: "Please Save the details first")
        }
        
        
        
        //m_dependantScrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        
        
        
    }
    @objc func deleteButtonClicked(sender:UIButton)
    {
        let alertController = UIAlertController(title: "Are you sure", message: "You want to delete dependant?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
            
            
            
        }
        alertController.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive)
        {
            (result : UIAlertAction) -> Void in
            
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            
            if(self.addedPersonDetailsArray[indexPath.row].personSrNo == nil)
            {
                
            }
            else
            {
                self.deleteDependantFromServer(indexpath: indexPath)
            }
            
        }
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    //MARK:- Info Tapped
    @objc func infoButtonClicked(sender:UIButton)
    {
        
    }
    
    
    func setupArrowDropDown(_ selectButon: UIButton, at index: Int)
    {
        relationDropDown.anchorView = m_relationTextfield
        relationDropDown.bottomOffset = CGPoint(x: 0, y: 25)
        relationDropDown.width = m_relationTextfield.frame.size.width
        displayDropDownat(index: index)
        
    }
    
    //MARK:- Show DropDown
    func displayDropDownat(index:Int)
    {
        relationDropDown.dataSource =
        m_membersArray
        
        // Action triggered on selection
        relationDropDown.selectionAction =
            {
                [unowned self] (index, item) in
                if(self.m_membersRelationIdArray.count > index)
                {
                    self.m_relationID = self.m_membersRelationIdArray[index]
                    self.textFields[0].text=item
                    self.m_relationTextfield.text=item
                    self.m_relationTextfield.errorMessage=""
                    self.m_relationTextfield.textColor=UIColor.black
                    self.m_dobTextField.text=""
                    self.m_ageTextfield.text=""
                    self.m_domTextfield.text=""
                    self.m_nameTextfield.text=""
                    
                    
                    switch item
                    {
                    case "SON" :
                        self.m_gender="MALE"
                        self.hideDOM()
                        self.hideDOBCheckBox()
                        self.m_dependantNextButtonTopConstraint.constant=20
                        break
                    case "DAUGHTER" :
                        self.m_gender="FEMALE"
                        self.hideDOM()
                        self.hideDOBCheckBox()
                        self.m_dependantNextButtonTopConstraint.constant=20
                        break
                    case "WIFE" :
                        
                        self.m_gender="FEMALE"
                        self.hideDOBCheckBox()
                        
                        if(!m_windowPeriodStatus)
                        {
                            self.m_domTextfield.isHidden=false
                            self.m_addButtonTopHeightConstraint.constant=60
                            self.m_dependantNextButtonTopConstraint.constant=40
                        }
                        else
                        { //WP active
                            self.m_domTextfield.isHidden=true
                        }
                        
                        
                        break
                    case "HUSBAND" :
                        self.m_gender="FEMALE"
                        self.hideDOBCheckBox()
                        
                        if(!m_windowPeriodStatus)
                        {
                            self.m_domTextfield.isHidden=false
                            self.m_addButtonTopHeightConstraint.constant=60
                            self.m_dependantNextButtonTopConstraint.constant=40
                        }
                        else
                        {
                            self.m_domTextfield.isHidden=true
                        }
                        
                        
                        break
                    case "FATHER" :
                        self.m_gender="MALE"
                        self.hideDOM()
                        self.showDOBCheckBox()
                        let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "FatherSumInsured")
                        if(dict.count>0)
                        {
                            if let fatherPremium = dict[0].value(forKey: "Premium")
                            {
                                if(fatherPremium as! String != "")
                                {
                                    let premium:String = (fatherPremium as? String)!
                                    self.m_premiumStatementLbl.text = "₹ " + premium + "/- will be deducted from your salary towards parental premium"
                                    //Added By Pranit
                                    self.m_premiumCheckImageView.isHidden = false
                                }
                            }
                        }
                        
                        
                        break
                    case "MOTHER" :
                        self.m_gender="FEMALE"
                        self.hideDOM()
                        self.showDOBCheckBox()
                        let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "MotherSumInsured")
                        if(dict.count>0)
                        {
                            if let fatherPremium = dict[0].value(forKey: "Premium")
                            {
                                if(fatherPremium as! String != "")
                                {
                                    let premium:String = (fatherPremium as? String)!
                                    self.m_premiumStatementLbl.text = "₹ " + premium + "/- will be deducted from your salary towards parental premium"
                                    //Added By Pranit
                                    self.m_premiumCheckImageView.isHidden = false
                                }
                            }
                        }
                        
                        break
                    case "FATHER-IN-LAW" :
                        self.m_gender="MALE"
                        self.hideDOM()
                        self.showDOBCheckBox()
                        let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "FatherInLawSumInsured")
                        if(dict.count>0)
                        {
                            if let fatherPremium = dict[0].value(forKey: "Premium")
                            {
                                if(fatherPremium as! String != "")
                                {
                                    let premium:String = (fatherPremium as? String)!
                                    self.m_premiumStatementLbl.text = "₹ " + premium + "/- will be deducted from your salary towards parental premium"
                                    //Added By Pranit
                                    self.m_premiumCheckImageView.isHidden = false
                                }
                            }
                        }
                        
                        break
                    case "MOTHER-IN-LAW" :
                        self.m_gender="FEMALE"
                        self.hideDOM()
                        self.showDOBCheckBox()
                        let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "MotherInLawSumInsured")
                        if(dict.count>0)
                        {
                            if let fatherPremium = dict[0].value(forKey: "Premium")
                            {
                                if(fatherPremium as! String != "")
                                {
                                    let premium:String = (fatherPremium as? String)!
                                    self.m_premiumStatementLbl.text = "₹ " + premium + "/- will be deducted from your salary towards parental premium"
                                    //Added By Pranit
                                    self.m_premiumCheckImageView.isHidden = false
                                }
                            }
                        }
                        
                        break
                        
                    default :
                        break
                    }
                    self.setAddDependantViewLayout()
                }
                else
                {
                    
                    self.getRelationsfromServer()
                    
                }
                
        }
    }
    func hideDOM()
    {
        m_domTextfield.isHidden=true
        
    }
    func hideDOBCheckBox()
    {
        m_dobCheckImageView.isHidden=true
        m_dontKnowDobLabel.isHidden=true
        m_dobTextField.isUserInteractionEnabled=true
        m_premiumCheckImageView.isHidden=true
        m_premiumStatementLbl.isHidden=true
        m_dobTextField.isUserInteractionEnabled=true
        m_addButtonTopHeightConstraint.constant=20
    }
    func showDOBCheckBox()
    {
        m_dobCheckImageView.isHidden=false
        m_dontKnowDobLabel.isHidden=false
        //Edited by Pranit - changed from true to false
        m_premiumCheckImageView.isHidden = false
        m_premiumStatementLbl.isHidden=false
        m_addButtonTopHeightConstraint.constant=80
    }
    func setupProgressBar()
    {
        progressBar = FlexibleSteppedProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        m_scrollView.addSubview(progressBar)
        
        progressBar.accessibilityElementsHidden=true
        
        let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: m_scrollView.centerXAnchor)
        
        let verticalConstraint = progressBar.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 20
        )
        let widthC = progressBar.widthAnchor.constraint(greaterThanOrEqualToConstant: m_scrollView.frame.width)
        let heightConstraint = progressBar.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([widthC,heightConstraint,verticalConstraint,horizontalConstraint])
        
        if(m_topupTitleArray.count>0)
        {
            progressBar.numberOfPoints = 3
        }
        else
        {
            progressBar.numberOfPoints = 2
            m_progressBarLbl2.isHidden=true
            m_progressBarLbl3.text="2.Dependant Details"
        }
        
        progressBar.lineHeight = 3
        progressBar.delegate = self
        progressBar.radius = 10
        progressBar.progressRadius = 25
        progressBar.progressLineHeight = 3
        progressBar.selectedBackgoundColor = hexStringToUIColor(hex: "e7bf2c")
        progressBar.selectedOuterCircleStrokeColor = hexStringToUIColor(hex: "e7bf2c")
        progressBar.currentSelectedCenterColor = hexStringToUIColor(hex: "e7bf2c")
        progressBar.stepTextColor = UIColor.gray
        progressBar.currentSelectedTextColor = UIColor.black
        progressBar.lastStateCenterColor = UIColor.green
        progressBar.lastStateOuterCircleStrokeColor=UIColor.green
        progressBar.backgroundShapeColor = hexStringToUIColor(hex: hightlightColor)
        
    }
    
    //MARK:- Feature change
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int)
    {
        switch index
        {
            
        case 0:
            
            progressBar.currentIndex=0
            showEmployeeDetailsView()
            m_progressBarLbl1.textColor=UIColor.black
            m_progressBarLbl2.textColor=UIColor.lightGray
            m_progressBarLbl3.textColor=UIColor.lightGray
            
            return
            
        case 1:
            
            progressBar.currentIndex=1
            showAddDependantView()
            if(progressBar.numberOfPoints == 2)
            {
                m_progressBarLbl2.textColor=UIColor.black
                m_progressBarLbl1.textColor=UIColor.lightGray
                m_progressBarLbl3.textColor=UIColor.black
            }
            else
            {
                m_progressBarLbl2.textColor=UIColor.black
                m_progressBarLbl1.textColor=UIColor.lightGray
                m_progressBarLbl3.textColor=UIColor.lightGray
            }
            
            
            return
            
        case 2:
            
            progressBar.currentIndex=2
            showTopupView()
            
            m_progressBarLbl3.textColor=UIColor.black
            m_progressBarLbl2.textColor=UIColor.lightGray
            m_progressBarLbl1.textColor=UIColor.lightGray
            
            return
            
        default :
            return
        }
    }
    private func progressBar(progressBar: FlexibleSteppedProgressBar,
                             willSelectItemAtIndex index: Int)
    {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool
    {
        
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String
    {
        progressBar.currentSelectedTextColor=UIColor.blue
        progressBar.centerLayerTextColor=UIColor.white
        progressBar.stepTextFont=UIFont(name: "OpenSans-Medium", size: 12)
        progressBar.currentSelectedTextColor=UIColor.black
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.right
        style.lineBreakMode = NSLineBreakMode.byTruncatingTail
        style.lineSpacing = 5
        /* if position == FlexibleSteppedProgressBarTextLocation.bottom
         {
         
         
         switch index
         {
         
         case 0:
         return "1.Emp Details"
         
         case 1:
         return "2.Add Dependant"
         
         case 2:
         return "3.Topup"
         
         default:
         
         
         return ""
         
         }
         }*/
        
        return ""
    }
    
    
    @objc func openInstructions(_ sender:UITapGestureRecognizer)
    {
        var newFrame : CGRect = m_enrollmentDetailsBackgroundView!.frame;
        
        if(newFrame.size.height == 125)
        {
            newFrame.size.height = 325;
            
            m_enrollmentDetailsBackgroundView.frame = newFrame;
            employeeDEtailsTopConstraint.constant=166+200
            m_instructionsViewHeight.constant=125+200
        }
        else
        {
            newFrame.size.height = 125;
            m_instructionsViewHeight.constant=125
            m_enrollmentDetailsBackgroundView.frame = newFrame;
            employeeDEtailsTopConstraint.constant=166
        }
    }
    
    func calculateRemainingDays()
    {
        let dateRangeStart = m_serverDate
        let dateRangeEnd = m_windowPeriodEndDate
        var components = Calendar.current.dateComponents([.day,.weekOfYear, .month], from: dateRangeStart, to: dateRangeEnd)
        var days = Calendar.current.dateComponents([.day], from: dateRangeStart, to: dateRangeEnd).day
        days = days!+1
        if(days!<0)
        {
            
            self.m_windowPeriodDayLbl.text = "0"
        }
        else
        {
            self.m_windowPeriodDayLbl.text = String(format: "%d", days!)
            
        }
        
        
        
        print(dateRangeStart)
        
        print("difference is \(components.month ?? 0) months and \(components.weekOfYear ?? 0) weeks")
        
        
        
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView==m_dependantDetailsTableview)
        {
            /*  let rowCount = (m_numberOfDaughter.intValue + m_numberOfSon.intValue+Int(truncating: NSNumber(value: m_isSpouse)))
             
             let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
             
             m_totalRowCount = rowCount+rowCountforParents*/
            print(addedPersonDetailsArray.count)
            return addedPersonDetailsArray.count
        }
        else
        {
            
            return m_topupTitleArray.count
        }
        
        
    }
    func hideEditButtons(cell:AddDependantTableViewCell)
    {
        cell.m_deleteButton.isHidden=true
        cell.m_editButton.isHidden=true
        cell.m_nameTextField.isUserInteractionEnabled=false
        cell.m_dobTextField.isUserInteractionEnabled=false
        cell.m_ageTextField.isUserInteractionEnabled=false
        
        //Added By Pranit - 30 Jan 20
        cell.heightBtnConstant.constant = 0
    }
    func showEditButtons(cell:AddDependantTableViewCell)
    {
        cell.m_deleteButton.isHidden=false
        cell.m_editButton.isHidden=false
        cell.m_nameTextField.isUserInteractionEnabled=false
        cell.m_dobTextField.isUserInteractionEnabled=false
        cell.m_ageTextField.isUserInteractionEnabled=false
        
        //Added By Pranit - 30 Jan 20
        cell.heightBtnConstant.constant = 32
        
    }
    
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(tableView==m_dependantDetailsTableview)
        {
            let cell : AddDependantTableViewCell = m_dependantDetailsTableview.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AddDependantTableViewCell
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            shadowForCell(view: cell.m_backGroundView)
            //cell.m_relationTitleView.layer.cornerRadius=8
            //        shadowForCell(view: cell.m_relationTitleView)
            
            if(m_windowPeriodStatus)
            {
                if let nTimesEnrollmentCanBeConfirmed = m_enrollmentMiscInformationDict.value(forKey: "NTimesEnrollmentCanBeConfirmed")as? String
                {
                    if(nTimesEnrollmentCanBeConfirmed == "MULTIPLE")
                    {
                        showEditButtons(cell:cell)
                    }
                    else
                    {
                        if(m_isEnrollmentConfirmed)
                        {
                            hideEditButtons(cell:cell)
                        }
                        else
                        {
                            showEditButtons(cell:cell)
                        }
                        /*if let noOfTimesEnrollmentActuallyConfirmed = m_enrollmentMiscInformationDict.value(forKey: "NoOfTimesEnrollmentActuallyConfirmed")as? String
                         {
                         if(noOfTimesEnrollmentActuallyConfirmed=="ONE")
                         {
                         hideEditButtons(cell:cell)
                         }
                         else
                         {
                         showEditButtons(cell:cell)
                         }
                         }*/
                    }
                }
                
                
            }
            else
            {
                hideEditButtons(cell:cell)
                
            }
            
            cell.m_deleteButton.tag=indexPath.row
            cell.m_editButton.tag=indexPath.row
            cell.m_deleteButton.addTarget(self, action: #selector(deleteButtonClicked(sender:)), for: .touchUpInside)
            cell.m_editButton.addTarget(self, action: #selector(dependantEditButtonClicked(sender:)), for: .touchUpInside)
            
            //Added by Pranit
            //cell.btnInfo.tag = indexPath.row
            //cell.btnInfo.addTarget(self, action: #selector(infoButtonClicked(sender:)), for: .touchUpInside)
            
            
            cell.m_nameTextField.tag=indexPath.row
            cell.m_dobTextField.tag=indexPath.row
            cell.m_ageTextField.tag=indexPath.row
            //        cell.m_dateOfMarrigeTxtField.tag=indexPath.row
            
            let dict = addedPersonDetailsArray[indexPath.row]
            
            
            cell.m_titleLbl.text=dict.relationname
            
            cell.m_nameTextField.text=dict.personName
            cell.m_dobTextField.text=dict.dateofBirth
            cell.m_ageTextField.text=String(dict.age)
            //        cell.m_dateOfMarrigeTxtField.tag=indexPath.row
            
            
            cell.imgView.image = getRelationWiseImage(relation: dict.relationname?.lowercased() ?? "", m_gender: dict.gender?.lowercased() ?? "")
            
            
            
            var m_premium = String()
            switch cell.m_titleLbl.text
            {
            case "FATHER" :
                let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "FatherSumInsured")
                if(dict.count>0)
                {
                    if let fatherPremium = dict[0].value(forKey: "Premium")
                    {
                        if(fatherPremium as! String != "")
                        {
                            m_premium = fatherPremium as! String
                            
                            cell.m_premiumStatementLbl.text = "₹ " + m_premium + "/-  will be deducted from your salary towards parental premium"
                        }
                    }
                }
                else
                {
                    cell.m_premiumStatementLbl.text = "₹ 0/-  will be deducted from your salary towards parental premium"
                }
                
                
                break
            case "MOTHER" :
                let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "MotherSumInsured")
                if(dict.count>0)
                {
                    if let fatherPremium = dict[0].value(forKey: "Premium")
                    {
                        if(fatherPremium as! String != "")
                        {
                            m_premium = (fatherPremium as? String)!
                            cell.m_premiumStatementLbl.text = "₹ " + m_premium + "/-  will be deducted from your salary towards parental premium"
                        }
                    }
                }
                else
                {
                    cell.m_premiumStatementLbl.text = "₹ 0/- will be deducted from your salary towards parental premium"
                }
                
                break
            case "FATHER-IN-LAW" :
                let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "FatherInLawSumInsured")
                if(dict.count>0)
                {
                    if let fatherPremium = dict[0].value(forKey: "Premium")
                    {
                        if(fatherPremium as! String != "")
                        {
                            m_premium = fatherPremium as! String
                            cell.m_premiumStatementLbl.text = "₹ " + m_premium + "/- will be deducted from your salary towards parental premium"
                        }
                    }
                }
                else
                {
                    cell.m_premiumStatementLbl.text = "₹ 0/- will be deducted from your salary towards parental premium"
                }
                
                break
            case "MOTHER-IN-LAW" :
                let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "MotherInLawSumInsured")
                if(dict.count>0)
                {
                    if let fatherPremium = dict[0].value(forKey: "Premium")
                    {
                        if(fatherPremium as! String != "")
                        {
                            m_premium = (fatherPremium as? String)!
                            cell.m_premiumStatementLbl.text = "₹ " + m_premium + "/- will be deducted from your salary towards parental premium"
                        }
                    }
                }
                    
                    //Added by Pranit to display tooltip for mother in law
                else
                {
                    cell.m_premiumStatementLbl.text = "₹ 0/- will be deducted from your salary towards parental premium"
                }
                
                break
                
            default :
                break
            }
            if(cell.m_titleLbl.text=="FATHER"||cell.m_titleLbl.text=="MOTHER"||cell.m_titleLbl.text=="FATHER-IN-LAW"||cell.m_titleLbl.text=="MOTHER-IN-LAW")
            {
                cell.m_premiumStatementLbl.isHidden=false
                
                
                
            }
            else
            {
                
                cell.m_premiumStatementLbl.isHidden=true
                cell.m_premiumStatementLbl.text=""
                
                
            }
            
            //Added by Pranit to hide 01-Jan-1900
            if dict.dateofBirth == "01-Jan-1900" {
                cell.m_dobTextField.text = "-"
            }
            
            //Added By Pranit To disable delete button if user opted claim
            
            
            
            return cell
        }
        else
        { //Topup Cell
            
            let cell : TopupTableViewCell = topupTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopupTableViewCell
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            shadowForCell(view: cell.m_TopupbackGroundView)
            cell.m_topupTitleView.layer.cornerRadius=cornerRadiusForView//8
            cell.m_addTopupBackgrounView.layer.cornerRadius=cornerRadiusForView//8
            
            cell.m_addTopupSubViewHeightConstraint.constant=0
            
            
            //Switch
            cell.m_optTopupSwitch.tag=indexPath.row
            cell.m_agreeTermsSwitch.tag=indexPath.row
            
            cell.m_optTopupSwitch.addTarget(self, action: #selector(optTopupSwitchValueDidChange(_:)), for: .valueChanged)
            cell.m_optTopupSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.m_agreeTermsSwitch.addTarget(self, action: #selector(agreeTermsSwitchValueDidChange(_:)), for: .valueChanged)
            cell.m_agreeTermsSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            
            //CheckBox
            let gestureCheck1 = UITapGestureRecognizer(target: self, action:  #selector (self.checkedTopup1(_:)))
            cell.m_topup1checkImageview.addGestureRecognizer(gestureCheck1)
            cell.m_topup1checkImageview.tag=indexPath.row
            cell.m_topup1checkImageview.isUserInteractionEnabled=true
            
            let gestureCheck2 = UITapGestureRecognizer(target: self, action:  #selector (self.checkedTopup2(_:)))
            cell.m_topup2CheckImgview.isUserInteractionEnabled=true
            cell.m_topup2CheckImgview.addGestureRecognizer(gestureCheck2)
            cell.m_topup2CheckImgview.tag=indexPath.row
            
            let gestureCheck3 = UITapGestureRecognizer(target: self, action:  #selector (self.checkedTopup3(_:)))
            cell.m_topup3CheckImgview.isUserInteractionEnabled=true
            cell.m_topup3CheckImgview.addGestureRecognizer(gestureCheck3)
            cell.m_topup3CheckImgview.tag=indexPath.row
            
            
            
            if(datasource.count>0)
            {
                cell.setTopupContent(data: datasource[indexPath.row])
            }
            
            if(indexPath.row==0)
            {
                
                
                if(GMCTopupOptionArray.count>0)
                {
                    cell.m_BSIAmountLbl.text="₹ "+GMCTopupOptionArray[0].baseSumInsured!.currencyInputFormatting()
                    print(GMCTopupOptionArray)
                    cell.m_topupOpetion1lbl.text=GMCTopupOptionArray[0].topupInsured?.currencyInputFormatting()
                    cell.m_topupOpetion1lbl.isHidden=false
                    cell.m_premium1lbl.isHidden=false
                    cell.m_topup1checkImageview.isHidden=false
                    let premium = GMCTopupOptionArray[0].premium?.currencyInputFormatting()
                    cell.m_premium1lbl.text="(Insurance premium of ₹ \(premium ?? "0")/- will be deducted from your salary)"
                    
                    if(m_employeeDict?.topupoptedflag=="1")
                    {
                        let amount1 = cell.m_topupOpetion1lbl.text?.replacingOccurrences(of: ",", with: "")
                        print(m_employeeDict?.topupoptedAmount)
                        if(amount1==m_employeeDict?.topupoptedAmount)
                        {
                            cell.m_topup1checkImageview.image=UIImage(named: "checked")
                            m_selectedGMCTopupAmount=cell.m_topupOpetion1lbl.text ?? ""
                            m_isToupChecked=true
                            m_isGMCTopup1Opted=true
                            m_isTopupConditionsAccepted=true
                            
                        }
                        
                    }
                }
                else
                {
                    cell.m_topupOpetion1lbl.isHidden=true
                    cell.m_premium1lbl.isHidden=true
                    cell.m_topup1checkImageview.isHidden=true
                }
                if(GMCTopupOptionArray.count>1)
                {
                    cell.m_topupOption2Lbl.text=GMCTopupOptionArray[1].topupInsured!.currencyInputFormatting()
                    cell.m_topupOption2Lbl.isHidden=false
                    cell.m_premium2Lbl.isHidden=false
                    cell.m_topup2CheckImgview.isHidden=false
                    let premium = GMCTopupOptionArray[1].premium?.currencyInputFormatting()
                    cell.m_premium2Lbl.text="(Insurance premium of ₹ \(premium ?? "0")/- will be deducted from your salary)"
                    if(m_employeeDict?.topupoptedflag=="1")
                    {
                        print(m_employeedict)
                        let amount1 = cell.m_topupOption2Lbl.text?.replacingOccurrences(of: ",", with: "")
                        if(amount1==m_employeeDict?.topupoptedAmount)
                        {
                            cell.m_topup2CheckImgview.image=UIImage(named: "checked")
                            m_selectedGMCTopupAmount=cell.m_topupOption2Lbl.text ?? ""
                            m_isToupChecked=true
                            m_isGMCTopup2Opted=true
                            
                            m_isTopupConditionsAccepted=true
                        }
                        
                    }
                }
                else
                {
                    cell.m_topupOption2Lbl.isHidden=true
                    cell.m_premium2Lbl.isHidden=true
                    cell.m_topup2CheckImgview.isHidden=true
                }
                
            }
            else if(indexPath.row==1)
            {
                
                if(GPATopupOptionArray.count>0)
                {
                    cell.m_BSIAmountLbl.text=GPATopupOptionArray[0].baseSumInsured!.currencyInputFormatting()
                    cell.m_topupOpetion1lbl.text=GPATopupOptionArray[0].topupInsured!.currencyInputFormatting()
                    cell.m_topupOpetion1lbl.isHidden=false
                    cell.m_topup1checkImageview.isHidden=false
                    cell.m_premium1lbl.isHidden=false
                    cell.m_premium1lbl.text="(Insurance premium of ₹ \(GPATopupOptionArray[0].premium ?? "0")/- will be deducted from your salary)"
                    if(m_employeeDict?.topupoptedflag=="1")
                    {
                        let amount1 = cell.m_topupOpetion1lbl.text?.replacingOccurrences(of: ",", with: "")
                        if(amount1==m_employeeDict?.topupoptedAmount)
                        {
                            cell.m_topup1checkImageview.image=UIImage(named: "checked")
                            m_selectedGMCTopupAmount=cell.m_topupOpetion1lbl.text ?? ""
                            m_isToupChecked=true
                            
                        }
                        
                    }
                }
                else
                {
                    cell.m_topupOpetion1lbl.isHidden=true
                    cell.m_premium1lbl.isHidden=true
                    cell.m_topup1checkImageview.isHidden=true
                }
                if(GPATopupOptionArray.count>1)
                {
                    cell.m_topupOption2Lbl.isHidden=false
                    cell.m_premium2Lbl.isHidden=false
                    cell.m_topup2CheckImgview.isHidden=false
                    cell.m_topupOption2Lbl.text=GPATopupOptionArray[1].topupInsured!.currencyInputFormatting()
                    cell.m_premium2Lbl.text="(Insurance premium of ₹ \(GPATopupOptionArray[1].premium ?? "0")/- will be deducted from your salary)"
                    if(m_employeeDict?.topupoptedflag=="1")
                    {
                        let amount1 = cell.m_topupOption2Lbl.text?.replacingOccurrences(of: ",", with: "")
                        if(amount1==m_employeeDict?.topupoptedAmount)
                        {
                            cell.m_topup2CheckImgview.image=UIImage(named: "checked")
                            m_selectedGMCTopupAmount=cell.m_topupOption2Lbl.text ?? ""
                            
                            m_isTopupConditionsAccepted=true
                        }
                        
                    }
                }
                else
                {
                    cell.m_topupOption2Lbl.isHidden=true
                    cell.m_premium2Lbl.isHidden=true
                    cell.m_topup2CheckImgview.isHidden=true
                }
                
            }
            else if(indexPath.row==2)
            {
                
                if(GTLTopupOptionArray.count>0)
                {
                    cell.m_BSIAmountLbl.text=GTLTopupOptionArray[0].baseSumInsured!.currencyInputFormatting()
                    print("GTLTopupOptionArray : \(GTLTopupOptionArray)")
                    if GTLTopupOptionArray[0].topupInsured != nil
                    {
                        cell.m_topupOpetion1lbl.text=GTLTopupOptionArray[0].topupInsured!.currencyInputFormatting()
                        cell.m_topupOpetion1lbl.isHidden=false
                        cell.m_topup1checkImageview.isHidden=false
                        cell.m_premium1lbl.text="(Insurance premium of ₹ \(GTLTopupOptionArray[0].premium ?? "0") will be deducted from your salary)"
                        if(m_employeeDict?.topupoptedflag=="1")
                        {
                            let amount1 = cell.m_topupOpetion1lbl.text?.replacingOccurrences(of: ",", with: "")
                            if(amount1==m_employeeDict?.topupoptedAmount)
                            {
                                cell.m_topup1checkImageview.image=UIImage(named: "checked")
                                m_selectedGMCTopupAmount=cell.m_topupOpetion1lbl.text ?? ""
                                
                                m_isToupChecked=true
                            }
                            
                        }
                    }
                    
                }
                else
                {
                    cell.m_topupOpetion1lbl.isHidden=true
                    cell.m_premium1lbl.isHidden=true
                    cell.m_topup1checkImageview.isHidden=true
                }
                if(GTLTopupOptionArray.count>1)
                {
                    cell.m_topupOption2Lbl.text=GTLTopupOptionArray[1].topupInsured!.currencyInputFormatting()
                    cell.m_topupOption2Lbl.isHidden=false
                    cell.m_premium2Lbl.isHidden=false
                    cell.m_topup2CheckImgview.isHidden=false
                    cell.m_premium2Lbl.text="(Insurance premium of ₹ \(GTLTopupOptionArray[1].premium ?? "0") will be deducted from your salary)"
                    if(m_employeeDict?.topupoptedflag=="1")
                    {
                        
                        let amount1 = cell.m_topupOpetion1lbl.text?.replacingOccurrences(of: ",", with: "")
                        if(amount1==m_employeeDict?.topupoptedAmount)
                        {
                            cell.m_topup2CheckImgview.image=UIImage(named: "checked")
                            m_selectedGMCTopupAmount=cell.m_topupOption2Lbl.text ?? ""
                        }
                        
                    }
                }
                else
                {
                    cell.m_topupOption2Lbl.isHidden=true
                    cell.m_premium2Lbl.isHidden=true
                    cell.m_topup2CheckImgview.isHidden=true
                }
                
            }
            cell.m_topUpTitlelbl.text=m_topupTitleArray[indexPath.row]
            
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(tableView==m_dependantDetailsTableview)
        {
            let dict : PERSON_INFORMATION = addedPersonDetailsArray[indexPath.row]
            if(dict.relationname=="FATHER" || dict.relationname=="MOTHER" || dict.relationname=="FATHER-IN-LAW" || dict.relationname=="MOTHER-IN-LAW")
            {
                //return 260
                // return 295
                //return UITableViewAutomaticDimension
                if(m_windowPeriodStatus)
                {
                    if(m_isEnrollmentConfirmed)
                    {
                        return 260
                    }
                    else
                    {
                        return 295
                    }
                }
                return 295
                
                
            }
            else {
                //return 210
                // return 250
                if(m_windowPeriodStatus)
                {
                    
                    if(m_isEnrollmentConfirmed)
                    {
                        return 210 //hide
                    }
                    else
                    {
                        return 240
                    }
                    //return UITableViewAutomaticDimension
                }
                return 210 //hide
            }
        }
        else if(tableView==topupTableView)
        {
            print(datasource.count)
            if(datasource.count>0)
            {
                if(datasource[indexPath.row].expanded)
                {
                    
                    return UITableViewAutomaticDimension
                }
                else
                {
                    return 170
                }
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkConfirmedStatus() -> Bool
    {
        if let nTimesEnrollmentCanBeConfirmed = m_enrollmentMiscInformationDict.value(forKey: "NTimesEnrollmentCanBeConfirmed")as? String
        {
            if(nTimesEnrollmentCanBeConfirmed == "MULTIPLE")
            {
                return true
            }
            else
            {
                
                return !m_isEnrollmentConfirmed
                /* if let noOfTimesEnrollmentActuallyConfirmed = m_enrollmentMiscInformationDict.value(forKey: "NoOfTimesEnrollmentActuallyConfirmed")as? String
                 {
                 if(noOfTimesEnrollmentActuallyConfirmed=="ONE")
                 {
                 return false
                 }
                 else
                 {
                 return true
                 }
                 }*/
            }
        }
        return true
    }
    @objc func checkedTopup1(_ sender:UITapGestureRecognizer)
    {
        if(m_windowPeriodStatus)
        {
            if(checkConfirmedStatus())
            {
                let indexpath = IndexPath(row: (sender.view?.tag)!, section: 0)
                let cell : TopupTableViewCell = topupTableView.cellForRow(at: indexpath) as! TopupTableViewCell
                
                cell.m_agreeTermsSwitch.isOn=false
                //Added By Pranit
                m_isTopupConditionsAccepted = false
                if(m_isGMCTopup1Opted)
                {
                    //            cell.m_topup1checkImageview.image=UIImage(named: "unchecked")
                    //            m_isGMCTopup1Opted=false
                    
                }
                else
                {
                    m_isGMCTopup2Opted=false
                    m_isGMCTopup1Opted=true
                    cell.m_topup1checkImageview.image=UIImage(named: "checked")
                    cell.m_topup2CheckImgview.image=UIImage(named: "unchecked")
                    cell.m_topup3CheckImgview.image=UIImage(named: "unchecked")
                    m_isToupChecked = true
                    switch indexpath.row
                    {
                    case 0 :
                        m_selectedGMCTopupAmount = cell.m_topupOpetion1lbl.text ?? ""
                        break
                    case 1 :
                        m_selectedGPATopupAmount = cell.m_topupOpetion1lbl.text ?? ""
                        break
                    case 2 :
                        m_selectedGTLTopupAmount = cell.m_topupOpetion1lbl.text ?? ""
                        break
                    default :
                        break
                    }
                    
                }
            }
            else
            {
                displayActivityAlert(title: "You already confirmed the enrollment")
            }
        }
        else
        {
            
            displayActivityAlert(title: "Window period is closed. Now you are not able to opt Top-up")
        }
        
    }
    @objc func checkedTopup2(_ sender:UITapGestureRecognizer)
    {
        if(m_windowPeriodStatus)
        {
            if(checkConfirmedStatus())
            {
                let indexpath = IndexPath(row: (sender.view?.tag)!, section: 0)
                let cell : TopupTableViewCell = topupTableView.cellForRow(at: indexpath) as! TopupTableViewCell
                cell.m_agreeTermsSwitch.isOn=false
                //Added By Pranit
                m_isTopupConditionsAccepted = false
                
                
                if(m_isGMCTopup2Opted)
                {
                    //            cell.m_topup2CheckImgview.image=UIImage(named: "unchecked")
                    //            m_isGMCTopup2Opted=false
                }
                else
                {
                    m_isGMCTopup1Opted=false
                    m_isGMCTopup2Opted=true
                    m_isToupChecked = true
                    cell.m_topup2CheckImgview.image=UIImage(named: "checked")
                    cell.m_topup1checkImageview.image=UIImage(named: "unchecked")
                    cell.m_topup3CheckImgview.image=UIImage(named: "unchecked")
                    switch indexpath.row
                    {
                    case 0 :
                        m_selectedGMCTopupAmount = cell.m_topupOption2Lbl.text ?? ""
                        break
                    case 1 :
                        m_selectedGPATopupAmount = cell.m_topupOption2Lbl.text ?? ""
                        break
                    case 2 :
                        m_selectedGTLTopupAmount = cell.m_topupOption2Lbl.text ?? ""
                        break
                    default :
                        break
                    }
                    
                }
            }
            else
            {
                displayActivityAlert(title: "You already confirmed the enrollment")
            }
        }
        else
        {
            
            displayActivityAlert(title: "Window period is closed. Now you are not able to opt Top-up")
        }
        
    }
    @objc func checkedTopup3(_ sender:UITapGestureRecognizer)
    {
        if(m_windowPeriodStatus)
        {
            if(checkConfirmedStatus())
            {
                
                let indexpath = IndexPath(row: (sender.view?.tag)!, section: 0)
                let cell : TopupTableViewCell = topupTableView.cellForRow(at: indexpath) as! TopupTableViewCell
                cell.m_agreeTermsSwitch.isOn=false
                //Added By Pranit
                m_isTopupConditionsAccepted = false
                
                
                if(cell.m_topup3CheckImgview.image==UIImage(named: "checked"))
                {
                    cell.m_topup3CheckImgview.image=UIImage(named: "unchecked")
                    
                }
                else
                {
                    m_isToupChecked = true
                    cell.m_topup3CheckImgview.image=UIImage(named: "checked")
                    cell.m_topup1checkImageview.image=UIImage(named: "unchecked")
                    cell.m_topup2CheckImgview.image=UIImage(named: "unchecked")
                    switch indexpath.row
                    {
                    case 0 :
                        m_selectedGMCTopupAmount = cell.m_topupOption3Lbl.text ?? ""
                        break
                    case 1 :
                        m_selectedGPATopupAmount = cell.m_topupOption3Lbl.text ?? ""
                        break
                    case 2 :
                        m_selectedGTLTopupAmount = cell.m_topupOption3Lbl.text ?? ""
                        break
                    default :
                        break
                    }
                    
                    
                }
            }
            else
            {
                displayActivityAlert(title: "You already confirmed the enrollment")
            }
        }
        else
        {
            
            displayActivityAlert(title: "Window period is closed. Now you are not able to opt Top-up")
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        /* if selectedRowIndex == indexPath.row
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
         topupTableView.reloadData()
         }
         selectedRowIndex = indexPath.row
         let content = datasource[indexPath.row]
         content.expanded = !content.expanded
         }
         topupTableView.reloadRows(at: [indexPath], with: .automatic)
         topupTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)*/
        
        
    }
    //MARK:- Switch-1 Tapped
    @objc func optTopupSwitchValueDidChange(_ sender: UISwitch)
    {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell : TopupTableViewCell = topupTableView.cellForRow(at: indexPath) as! TopupTableViewCell
        if(m_windowPeriodStatus)
        {
            if(checkConfirmedStatus())
            {
                
                if(sender.isOn)
                {
                    m_isOptTopup=true
                    let content = datasource[indexPath.row]
                    content.expanded = !content.expanded
                    //                m_isOptTopup = !content.expanded
                    
                    
                    topupTableView.reloadRows(at: [indexPath], with: .automatic)
                    topupTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                    cell.m_agreeTermsSwitch.isOn=false
                    m_isTopupConditionsAccepted=false
                    
                }
                else
                {
                    m_isOptTopup=false
                    let content = datasource[indexPath.row]
                    content.expanded = !content.expanded
                    //                m_isOptTopup = !content.expanded
                    
                    topupTableView.reloadRows(at: [indexPath], with: .automatic)
                    topupTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                    addTopup(indexpath: indexPath)
                    topupDeleted()
                    cell.m_agreeTermsSwitch.isOn=false
                    m_isTopupConditionsAccepted=false
                    cell.m_topup1checkImageview.image=UIImage(named: "unchecked")
                    cell.m_topup2CheckImgview.image=UIImage(named: "unchecked")
                    m_isGMCTopup1Opted=false
                    m_isGMCTopup2Opted=false
                }
                
            }
            else
            {
                displayActivityAlert(title: "You already confirmed the enrollment")
                
                
                
            }
        }
        else
        {
            
            displayActivityAlert(title: "Window period is closed. Now you are not able to opt Top-up")
        }
        
        
    }
    
    //MARK:- Switch2 Changed
    @objc func agreeTermsSwitchValueDidChange(_ sender: UISwitch)
    {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell : TopupTableViewCell = topupTableView.cellForRow(at: indexpath) as! TopupTableViewCell
        if(m_windowPeriodStatus)
        {
            if(checkConfirmedStatus())
            {
                
                if(m_isGMCTopup1Opted || m_isGMCTopup2Opted)
                {
                    if sender.isOn == true
                    {
                        print("On")
                        
                        m_isTopupConditionsAccepted = true
                        self.progressBar.currentIndex=2
                        self.showTopupView()
                        let indexpath = IndexPath(row: 0, section: 0)
                        addTopup(indexpath: indexpath)
                        callAddTopupWebservice()
                        
                    }
                    else
                    {
                        print("Off")
                        
                        m_isTopupConditionsAccepted = false
                    }
                    
                }
                else
                {
                    sender.isOn=false
                    displayActivityAlert(title: "Please select top-up first")
                }
                
            }
            else
            {
                displayActivityAlert(title: "You already confirmed the enrollment")
                cell.m_agreeTermsSwitch.isEnabled=false
                
            }
        }
        else
        {
            sender.isEnabled=false
            displayActivityAlert(title: "Window period is closed. Now you are not able to opt Top-up")
        }
        
        
        
    }
    /*   if let adminSettingsDict = UserDefaults.standard.value(forKey: "DataSettingsDict")as? NSDictionary
     {
     
     
     
     
     //        textFields=[cell.m_titleTextField]
     cell.m_titleTextField.tag = indexPath.row
     cell.m_selectButton.tag = indexPath.row
     
     //        setupField(textField: cell.m_titleTextField, with: m_titleArray[indexPath.row])
     switch indexPath.row
     {
     case 0:
     cell.m_titleTextField.isUserInteractionEnabled=false
     cell.m_selectButton.isHidden=false
     let image = #imageLiteral(resourceName: "usersmall")
     cell.m_selectButton.setImage(image, for: .normal)
     cell.m_titleTextField.text=adminSettingsDict.value(forKey: "EMPLOYEE_RELATION_ID") as? String
     
     break
     case 1:
     cell.m_titleTextField.isUserInteractionEnabled=false
     cell.m_selectButton.isHidden=false
     let image = #imageLiteral(resourceName: "usersmall")
     cell.m_selectButton.setImage(image, for: .normal)
     cell.m_titleTextField.text=adminSettingsDict.value(forKey: "EMPLOYEE_NAME") as? String
     break
     case 2:
     cell.m_titleTextField.isUserInteractionEnabled=false
     cell.m_titleTextField.keyboardType=UIKeyboardType.numbersAndPunctuation
     cell.m_selectButton.isHidden=false
     let image = #imageLiteral(resourceName: "usersmall")
     cell.m_selectButton.setImage(image, for: .normal)
     cell.m_titleTextField.text=adminSettingsDict.value(forKey: "EMPLOYEE_GENDER") as? String
     break
     case 3:
     
     cell.m_titleTextField.isUserInteractionEnabled=false
     cell.m_selectButton.isHidden=false
     let image = #imageLiteral(resourceName: "mail1")
     cell.m_selectButton.setImage(image, for: .normal)
     cell.m_titleTextField.text=adminSettingsDict.value(forKey: "OFFICIAL_EMAIL_ID") as? String
     
     break
     
     case 4:
     cell.m_titleTextField.isUserInteractionEnabled=true
     cell.m_selectButton.isHidden=false
     let image = #imageLiteral(resourceName: "EditSymbol")
     cell.m_selectButton.setImage(image, for: .normal)
     cell.m_selectButton.addTarget(self, action: #selector(editMobileNumberButtonClicked), for: .touchUpInside)
     cell.m_titleTextField.text=adminSettingsDict.value(forKey: "CELLPHONE_NO") as? String
     break
     case 5:
     cell.m_titleTextField.isUserInteractionEnabled=false
     cell.m_selectButton.isHidden=false
     let image = #imageLiteral(resourceName: "calendar")
     cell.m_selectButton.setImage(image, for: .normal)
     cell.m_titleTextField.text=adminSettingsDict.value(forKey: "EMPLOYEE_DOB") as? String
     break
     
     
     default:
     break
     }
     }
     
     //        cell.m_titleTextField.text=m_employeeDetailsArray[indexPath.row]
     
     cell.selectionStyle=UITableViewCellSelectionStyle.none*/
    
    
    
    
    
    
    
    @objc func editMobileNumberButtonClicked(sender:UIButton)
    {
        let indexpath = IndexPath (row: sender.tag, section: 0)
        //        let cell = m_tableView.cellForRow(at:indexpath) as? IntimateClaimTableViewCell
        //        cell?.m_titleTextField.isUserInteractionEnabled=true
    }
    
    
    func scrollToTableTop()
    {
        let indexpath = IndexPath(row: 0, section: 0)
        topupTableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
        if #available(iOS 11.0, *) {
            topupTableView.contentInsetAdjustmentBehavior = .scrollableAxes
        }
        else {
            // Fallback on earlier versions
        }
    }
    
    //MARK:- Set EMP Details Data
    func setData()
    {
        
        let array : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        let personArray : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
        if(array.count>0)
        {
            
            let dict = array[0]
            let personDict = personArray[0]
            
            m_empIDLbl.text=dict.empIDNo
            var emailId = dict.officialEmailID
            emailId = emailId?.replacingOccurrences(of: "\r\n", with: "")
            m_emailIDLbl.text=emailId
            userEmailLbl.text = emailId
            m_nameLbl.text=personDict.personName
            m_genderLbl.text=personDict.gender
            m_mobileNumberLabl.text=personDict.cellPhoneNUmber
            m_emrgmobileNumberLabl.text=personDict.cellPhoneNUmber // Add emrg mob number
            if personDict.emrgContactNumber == "NOT AVAILABLE" || personDict.emrgContactNumber == "-" || personDict.emrgContactNumber == "nil" || personDict.emrgContactNumber == "null" {
                m_emrgmobileTextfield.text = ""
            }else{
                m_emrgmobileTextfield.text = personDict.emrgContactNumber
            }
            m_dateofBirthLbl.text=personDict.dateofBirth
    
            
            imgEmp.image = getRelationWiseImage(relation: "employee", m_gender: personDict.gender ?? "Male")
            
            if m_dateofBirthLbl.text != "" {
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateStyle = .medium
                dateFormatter1.timeStyle = .none
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMM-yyyy"
                let m_selectedDate = formatter.date(from: m_dateofBirthLbl.text!)
                //let dateString = dateFormatter1.string(from: datePicker.date)
                //print(dateString)
                let serverDt = Date()
                let age = String(serverDt.years(from: m_selectedDate ?? Date()))

                self.lblAge.text = String(format:"%@ years",age)
            }
            
            
        }
        
        //m_nextButton.makeCicular()
        //m_nextButton.layer.masksToBounds=true
        
        //shadowForCell(view: m_empoyeeDetailsBackgroundView)
        m_enrollmentDetailsBackgroundView.layer.cornerRadius=cornerRadiusForView//8
        m_empoyeeDetailsBackgroundView.setCornerRadius()
        
            if isEditable == true  {

                m_emrgmobileTextfield.becomeFirstResponder()
                m_emrgmobileTextfield.isUserInteractionEnabled = true
                //m_emrgmobileTextfield.borderStyle = UITextBorderStyle.roundedRect
            }
            else {

                m_emrgmobileTextfield.resignFirstResponder()
                m_emrgmobileTextfield.isUserInteractionEnabled = false
                //m_emrgmobileTextfield.borderStyle = UITextBorderStyle.none
            }
        
    }
    func getDataSettingsUrl()
    {
        
        /* var groupchildsrno = String()
         var oegrpbasinfsrno = String()
         
         if let childNo = m_employeeDict?.groupChildSrNo
         {
         groupchildsrno = childNo
         }
         if let oeinfNo = m_employeeDict?.oeGroupBasSrNo
         {
         oegrpbasinfsrno = oeinfNo
         }
         
         let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEnrollmentDataSettings(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, employeesrno: UserDefaults.standard.value(forKey: "EmployeeSrNo") as! String))
         
         let request : NSMutableURLRequest = NSMutableURLRequest()
         request.url = urlreq as URL?// NSURL(string: urlreq)
         request.httpMethod = "GET"
         
         
         let task = URLSession.shared.dataTask(with: urlreq! as URL)
         {
         (data, response, error)  -> Void in
         if error != nil
         {
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
         {    self.xmlKey = "EmployeeSettings"
         let parser = XMLParser(data: data!)
         parser.delegate = self as XMLParserDelegate
         parser.parse()
         print(self.resultsDictArray ?? "")
         for obj in self.resultsDictArray!
         {
         
         print(obj)
         let userDict : NSDictionary = obj as NSDictionary
         UserDefaults.standard.set(userDict, forKey: "DataSettingsDict")
         print(userDict)
         
         
         }
         }
         catch let JSONError as NSError
         {
         print(JSONError)
         }
         }
         else
         {
         self.hidePleaseWait()
         self.handleServerError(httpResponse: httpResponse)
         }
         }
         else
         {
         print("Can't cast response to NSHTTPURLResponse")
         }
         
         }
         
         
         }
         task.resume()*/
    }
    func setLayout()
    {
        m_dependantDetailsTableview.separatorStyle=UITableViewCellSeparatorStyle.none
        topupTableView.separatorStyle=UITableViewCellSeparatorStyle.none
        shadowForCell(view: m_addDependantView)
        addDependantTitlevIew.layer.cornerRadius=8
        m_addDependantButton.layer.masksToBounds=true
        m_dependantCancelButton.layer.masksToBounds=true; m_addDependantButton.layer.cornerRadius=m_addDependantButton.frame.size.height/2
        m_dependantCancelButton.layer.cornerRadius=m_dependantCancelButton.frame.size.height/2
        
        //Added by Pranit - Add border on RESET Button
        //m_dependantCancelButton.layer.borderWidth = 1.0
        //m_dependantCancelButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4392156863, blue: 0.8352941176, alpha: 1)
        
        //        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.selectRelation (_:)))
        //        self.m_relationTextfield.addGestureRecognizer(gesture)
        
        
        m_relationTextfield.isUserInteractionEnabled=false
        m_selectRelationButton.isHidden=false
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.clickedDOBCheckBox(_:)))
        m_dobCheckImageView.isUserInteractionEnabled=true
        m_dobCheckImageView.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.clickedPremiumCheckBox(_:)))
        m_premiumCheckImageView.isUserInteractionEnabled=true
        m_premiumCheckImageView.addGestureRecognizer(gesture1)
        m_addButtonTopHeightConstraint.constant=20
        
        textFields=[m_relationTextfield,m_nameTextfield,m_dobTextField,m_ageTextfield,m_domTextfield]
        
    }
    
    @IBAction func editTapped(_ sender: Any) {
        
        if btnEditMobile.isSelected {
            if m_emrgmobileTextfield.text?.isEmpty ?? true {
                
                displayActivityAlert(title: "Enter mobile number")
            }
                
            else if m_emrgmobileTextfield.text == m_mobileNumberLabl.text{
                displayActivityAlert(title: "Emergency Mobile Number should not be same as Official Mobile Number")
            }
            else {
                if m_emrgmobileTextfield.text?.count == 10 {
                    
                    
                    
                    btnEditMobile.setImage(UIImage(named: "Asset 59"), for: .normal)//
                    btnEditMobile.isSelected  = false
                    print("updated")
                    isEditable = false
                    m_emrgmobileTextfield.resignFirstResponder()
                    m_emrgmobileTextfield.isUserInteractionEnabled = false
                   
                    bottomLine.backgroundColor = UIColor.clear.cgColor
                    m_emrgmobileTextfield.borderStyle = UITextBorderStyle.none
                    m_emrgmobileTextfield.layer.addSublayer(bottomLine)
                    UpdateEmployeeEmergencyNo()
                  
                }else {
                    displayActivityAlert(title: "Please enter valid mobile number")
                }
            }
        }else {
            btnEditMobile.setImage(UIImage(named: "emergency_tick"), for: .normal)
            btnEditMobile.isSelected  = true
            isEditable = true
            print("edit")
            m_emrgmobileTextfield.becomeFirstResponder()
            m_emrgmobileTextfield.isUserInteractionEnabled = true
            
            
            bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:m_emrgmobileTextfield.frame.height - 1), size: CGSize(width: m_emrgmobileTextfield.frame.width - 60, height:  1))
            bottomLine.backgroundColor = UIColor.lightGray.cgColor
            m_emrgmobileTextfield.borderStyle = UITextBorderStyle.none
            m_emrgmobileTextfield.layer.addSublayer(bottomLine)
        }
   
    }
    /*
     Update Emergency contact no-
     API : Post Method
URL - http://mybenefits360.in/mb360api/api/EnrollmentDetails/UpdateEmployeeEmergency?employeesrno=1137732&EmergencyContactNo=999999999
     http://mybenefits360.in/mb360api/api/EnrollmentDetails/UpdateEmployeeEmergency?employeesrno=1137732&EmergencyContactNo=9999999999
     Response -
      Status code - 200 ok
     {
         "message": {
             "Message": "EMERGENCY CONTACT NUMBER UPDATED SUCCESSFULLY",
             "Status": true
         }
     }
     */
    
    //MARK: - UpdateEmployeeEmergencyNo API Call
    
    
   //MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        view.endEditing(true)
        
        return true
    }
    
    @objc func textFieldDidChange(_ textfield:UITextField)
       {
          
           if((textfield.text?.count)!>9)
           {
               textfield.resignFirstResponder()
           }
       }
       
       
    
    //MARK:- DOB Checkbox Tapped
    @objc func clickedDOBCheckBox(_ sender:UITapGestureRecognizer)
    {
        if(m_dobCheckImageView.image==UIImage(named: "checked"))
        {
            m_dobCheckImageView.image=UIImage(named: "unchecked")
            m_dobTextField.isUserInteractionEnabled=true
            m_dobNotAvailable=false
            m_ageTextfield.isUserInteractionEnabled=false
            
        }
        else
        {
            m_dobTextField.isUserInteractionEnabled=false
            m_dobCheckImageView.image=UIImage(named: "checked")
            m_dobNotAvailable=true
            m_ageTextfield.isUserInteractionEnabled=true
            m_dobTextField.text=""
            
        }
    }
    
    //MARK:- CheckBox Premium
    @objc func clickedPremiumCheckBox(_ sender:UITapGestureRecognizer)
    {
        self.m_premiumStatementLbl.textColor = UIColor.darkGray
        //uncommented by Pranit
        if(m_premiumCheckImageView.image==UIImage(named: "checked"))
        {
            m_premiumCheckImageView.image=UIImage(named: "unchecked")
            m_isPremiumAccepted=false
        }
        else
        {
            m_isPremiumAccepted=true
            m_premiumCheckImageView.image=UIImage(named: "checked")
        }
    }
    
    //MARK:- Show 2
    func showAddDependantView()
    {
        
        navigationItem.rightBarButtonItem=getRightNvigationBarButton()
        
        m_instructionScrollview.scrollToTop(true)
        
        //m_instructionScrollViewHeightConstraint.constant=115
        //Updated value to remove instructions and add on new view controller
        //commented by psh
        m_instructionScrollViewHeightConstraint.constant=45
        //  m_instructionScrollViewHeightConstraint.constant = 0
        
        let dict : NSDictionary = (UserDefaults.standard.value(forKey: "EnrollmentGroupAdminBasicSettings") as? NSDictionary)!
        let count:String = dict.value(forKey: "DependantCount") as! String
        let countInt = Int(count)! - 1
        let countStr = String(countInt)
        let array:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: "SON")
        var age = "0"
        if array.count > 0 {
            age = array[0].maxAge!
        }
        
        let array1:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: "DAUGHTER")
        var age1  = "0"
        if array1.count > 0 {
            age1 = array1[0].maxAge!
        }
        
        m_dependantScrollView.isScrollEnabled=true
        m_empoyeeDetailsBackgroundView.isHidden=true
        //m_nextButton.isHidden=true
        m_addDependantView.isHidden=false
        m_dependantDetailsTableview.isHidden=false
        m_dependantNextButton.isHidden=false
        m_instructionTextLbl.isHidden=false
        topupTableView.isHidden=true
        m_topupNextButton.isHidden=true
        
        m_scrollView.scrollToTop(true)
        m_instructionTextLbl.text="""
        1. You can add upto \(countStr) dependants
        2. Son age cannot be greater than \(age) years
        3. Daughter age cannot be greater than \(age1) years
        """
        
        //Added By Pranit
        m_instructionTextLbl.text=""
        
        print(m_membersArray)
        if(m_membersArray.count==0)
        {
            m_addDependantView.isHidden=true
            m_addDependantTableViewTopConstraint.constant=15
        }
        else
        {
            
            m_addDependantView.isHidden=false
            setAddDependantViewLayout()
            if(!checkConfirmedStatus())
            {
                m_addDependantView.isHidden=true
                m_addDependantTableViewTopConstraint.constant=15
            }
            
        }
        
        m_dependantTableViewHeightConstraint.constant = self.m_dependantDetailsTableview.contentSize.height
        //Added By Pranit for hide checkbox firsttime
        m_premiumCheckImageView.isHidden = true
        
        m_dependantScrollView.scrollToTop(true)
        
        //let gesture = UITapGestureRecognizer.init(target: self, action:#selector(showDependantInstructions(_:)))
        //m_enrollmentDetailsBackgroundView.addGestureRecognizer(gesture)
        m_enrollmentDetailsBackgroundView.isHidden = true
        
        
        //m_dependantScrollView.setContentOffset(m_dependantScrollView.contentOffset, animated: false)
        // m_dependantScrollView.setContentOffset(CGPoint(x: 0, y: 600), animated: false)
        
        //self.firstBtnCoreBenefits.isHidden = true
        //self.secondBtnCoreBenefits.isHidden = false
        
        self.m_dependantScrollView.isHidden = false
        self.empDetailsScrollView.isHidden = true
        
        
    }
    
    @objc private func showDependantInstructions(_ sender:UITapGestureRecognizer) {
        
        if progressBar.currentIndex == 1 {
            let instructionsVC = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "AddDependantInstructionsVC") as! AddDependantInstructionsVC
            instructionsVC.modalPresentationStyle = .fullScreen
            instructionsVC.modalPresentationStyle = .custom
            
            self.navigationController?.present(instructionsVC, animated: true, completion: nil)
        }
    }
    
    //MARK:- Show 2 Add Dependants View
    func setAddDependantViewLayout()
    {
        if(m_arrayofParents.contains(m_relationTextfield.text!))
        {
            
            //If condition added for every time extra space added betn tableview and addDepView
            
            if m_addDependantTableViewTopConstraint.constant < 350.0 {
                m_addDependantTableViewTopConstraint.constant=m_addDependantView.frame.size.height+90
            }
            //Added By Pranit - To unheck checkbox every time when user change dependants.
            m_premiumCheckImageView.image=UIImage(named: "unchecked")
            m_isPremiumAccepted=false
        }
        else
        {
            print(m_addDependantView.frame.size.height)
            if(m_addDependantView.frame.size.height>300)
            {
                m_addDependantTableViewTopConstraint.constant=m_addDependantView.frame.size.height-30
            }
            else if(m_relationTextfield.text=="WIFE" || m_relationTextfield.text=="HUSBAND")
            {
                //Added By Pranit - To hide extra space between Dependant View and tableview.
                //Start
                
                if(!m_windowPeriodStatus)
                {//If WP is closed
                    m_addDependantTableViewTopConstraint.constant=m_addDependantView.frame.size.height+70
                    
                }
                else
                {
                    m_addDependantTableViewTopConstraint.constant=m_addDependantView.frame.size.height+30
                    
                }
                
                //End
                //Commented By Pranit
                // m_addDependantTableViewTopConstraint.constant=m_addDependantView.frame.size.height+70
            }
            else
            {
                m_addDependantTableViewTopConstraint.constant=m_addDependantView.frame.size.height+30
            }
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        view.endEditing(true)
        //UITextField.resignFirstResponder(self)
        super.viewWillDisappear(animated)
        
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell1 = topupTableView.cellForRow(at: indexPath)
        {
            let cell : TopupTableViewCell = topupTableView.cellForRow(at: indexPath) as! TopupTableViewCell
            for i in 0..<m_topupTitleArray.count
            {
                self.datasource.append(TopupCellContent(title:"Topup", otherInfo:m_topupTitleArray[i], expanded:m_isToupChecked))
            }
            if(m_isToupChecked)
            {
                cell.m_agreeTermsSwitch.isOn=true
                cell.m_optTopupSwitch.isOn=true
                //Added By Pranit - 15 Jan
                m_isOptTopup = true
                
                if(!checkConfirmedStatus() || !m_windowPeriodStatus)
                {
                    cell.m_agreeTermsSwitch.isEnabled=false
                    cell.m_optTopupSwitch.isEnabled=false
                    cell.m_agreeTermsSwitch.isOn=true
                }
                
                
            }
            else
            {
                if(!checkConfirmedStatus() || !m_windowPeriodStatus)
                {
                    cell.m_agreeTermsSwitch.isEnabled=false
                    cell.m_optTopupSwitch.isEnabled=false
                    cell.m_agreeTermsSwitch.isOn=false
                    cell.m_optTopupSwitch.isOn=false
                    
                    //Added By Pranit - 15 Jan
                    m_isOptTopup = false
                    
                }
            }
            
            topupTableView.reloadData()
            m_dependantTableViewHeightConstraint.constant=0
        }
        
        
    }
    
    private func getRelationWiseImage(relation:String,m_gender:String) -> UIImage {
        
        switch relation
        {
        case "EMPLOYEE".lowercased() :
            
            if(m_gender.lowercased() == "male")
            {
                return UIImage(named: "Asset 36")!
            }
            else
            {
                return UIImage(named: "Female Employee")!
            }
            
        case "SPOUSE".lowercased() :
            
            if(m_gender.lowercased() == "male")
            {
                return UIImage(named: "Male")!
            }
            else
            {
                return UIImage(named: "women")!
            }
            
        case "wife" :
            return UIImage(named: "women")!
            
        case "husband" :
            return UIImage(named: "Male")!
            
            
            
        case "SON".lowercased() :
            
            return #imageLiteral(resourceName: "son")
            
            
        case "DAUGHTER".lowercased() :
            
            return #imageLiteral(resourceName: "daughter")
            
            
        case "FATHER".lowercased() :
            
            return #imageLiteral(resourceName: "Male")
            
            
        case "MOTHER".lowercased() :
            
            return #imageLiteral(resourceName: "women")
            
            
        case "FATHER-IN-LAW".lowercased():
            
            return #imageLiteral(resourceName: "Male")
            
            
        case "MOTHER-IN-LAW".lowercased() :
            
            return #imageLiteral(resourceName: "women")
            
            
        default :
            return #imageLiteral(resourceName: "Male")
            
            
            
        }
    }
    
    //MARK:-  Show 1
    func showEmployeeDetailsView()
    {
        //navigationItem.rightBarButtonItem=getRightNvigationBarButton()
        //        m_dependantScrollView.scrollToTop(true)
        
        m_instructionScrollview.scrollToTop(true)
        m_instructionScrollViewHeightConstraint.constant=70
        
        
        m_empoyeeDetailsBackgroundView.isHidden=false
        //m_nextButton.isHidden=true
        
        m_addDependantView.isHidden=true
        m_dependantDetailsTableview.isHidden=true
        m_dependantNextButton.isHidden=true
        m_instructionTextLbl.isHidden=false
        topupTableView.isHidden=true
        
        if(!m_windowPeriodStatus)
        {
            //            m_instructionTextLbl.text="""
            //            1. Window period has closed on \(convertDatetoString(m_windowPeriodEndDate))
            //            """
            m_instructionTextLbl.text="""
            Window period ended on \(convertDatetoString(m_windowPeriodEndDate))
            """
            
            // self.lblFirstInstructions.text = "Window period ended on \(convertDatetoString(m_windowPeriodEndDate))"
            
        }
        else
        {
            m_instructionTextLbl.text="""
            Window period active till \(convertDatetoString(m_windowPeriodEndDate))
            """
            
            //self.lblFirstInstructions.text = "Window period active till \(convertDatetoString(m_windowPeriodEndDate))"
        }
        
        m_topupNextButton.isHidden=true
        
        
        //        scrollToTableTop()
        
        //Added By Pranit
        empDetailsInstructionsView.layer.cornerRadius = 6.0
        empDetailsInstructionsView.layer.borderColor = #colorLiteral(red: 0, green: 0.4478194714, blue: 0.8638948202, alpha: 1)
        empDetailsInstructionsView.layer.borderWidth = 1.0
        m_dependantTableViewHeightConstraint.constant=self.m_dependantDetailsTableview.contentSize.height
        //m_dependantScrollView.isScrollEnabled=true
        //m_dependantScrollView.scrollToTop(true)
        
        // self.firstBtnCoreBenefits.isHidden = false
        //self.secondBtnCoreBenefits.isHidden = true
        //self.view.layoutIfNeeded()
        
        
        //self.btnPerMobile.makeCicular()
        //self.btnPerEmail.makeCicular()
        //self.btnEditMobile.makeCicular()
        
        self.m_dependantScrollView.isHidden = true
        self.empDetailsScrollView.isHidden = false
        
        //btnPerMobile.layer.masksToBounds = true
        //btnPerEmail.layer.masksToBounds = true
        
        self.navigationItem.leftBarButtonItem = nil
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Scroll...\(scrollView.contentSize),\(scrollView.contentOffset)")
        
        if scrollView == self.m_dependantScrollView {
            
            if progressBar.currentIndex == 0 {
                if scrollView.contentOffset.y >= 180.0 && scrollView.contentOffset.y <= 200 {
                    // m_dependantScrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: false)
                }
                
            }
            else {
                //m_dependantScrollView.setContentOffset(scrollView.contentOffset, animated: false)
                // m_dependantScrollView.setContentOffset(CGPoint(x: 0, y: 600), animated: false)
            }
        }
        else {
            //            if scrollView.contentOffset.x>0 {
            //                                      scrollView.contentOffset.x = 0
            //                                      }
            
            if scrollView.contentOffset.y >= 180.0 && scrollView.contentOffset.y <= 200 {
                m_dependantScrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: false)
            }
            
        }
    }
    
    
    
    func showTopupView()
    {
        navigationItem.rightBarButtonItem=getEmptyBarButton()
        
        m_dependantScrollView.isScrollEnabled=true
        m_empoyeeDetailsBackgroundView.isHidden=true
        
        // m_nextButton.isHidden=true
        m_addDependantView.isHidden=true
        m_dependantDetailsTableview.isHidden=true
        m_dependantNextButton.isHidden=true
        m_instructionTextLbl.isHidden=true
        m_topupNextButton.isHidden=false
        
        
        m_dependantTableViewHeightConstraint.constant=0
        
        self.empDetailsScrollView.isHidden = true
        topupTableView.isHidden=false
        
        
        
    }
    @IBAction func backButtonClicked(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Next Tapped - Emp Details
    @IBAction func nextButtonClicked(_ sender: Any)
    {
        //showAddDependantView()
        //progressBar.currentIndex=1
        
        
        //        let addDependantVC : AddDependantViewController = AddDependantViewController()
        //        navigationController?.pushViewController(addDependantVC, animated: true)
        
        
        //Delegate call to move next on card collection view
        //        if self.instructionReadingDelegateEmp != nil {
        //                              self.instructionReadingDelegateEmp?.completedInstructionReading()
        //        }
        
        let depDetails = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "DependantsListVCNew") as! DependantsListVCNew
        depDetails.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
        depDetails.m_windowPeriodEndDate=m_windowPeriodEndDate
        self.navigationController?.pushViewController(depDetails, animated: true)
        
        
    }
    
    func validateTextFields(textField:UITextField)->Int
    {
        
        let whitespaceSet = CharacterSet.whitespaces
        if((textField.text?.isEmpty)! || (textField.text?.trimmingCharacters(in: whitespaceSet).isEmpty)!)
        {
            
            if (textField.tag == 4)
            {
                textField.text = "Enter Mobile Number"
                return 1
            }
        }
        else
        {
            //            updateDetails()
        }
        return 0
    }
    
    
    @IBAction func editButtonClicked(_ sender: Any)
    {
        if(m_editButton.currentImage==#imageLiteral(resourceName: "icCheck"))
        {
            m_editButton.setImage(#imageLiteral(resourceName: "icEdit"), for: .normal)
            
            updateDetails()
        }
        else
        {
            m_editButton.setImage(#imageLiteral(resourceName: "icCheck"), for: .normal)
            
            
        }
        
    }
    func updateDetails()
    {
        
        /* if(isConnectedToNetWithAlert())
         {
         showPleaseWait()
         let userArray : [EmployeeDetails] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
         if (userArray.count>0)
         {
         
         m_employeeDict=userArray[0]
         
         
         var employeesrno = String()
         var groupchildsrno = String()
         var oegrpbasinfsrno = String()
         
         if let childNo = m_employeeDict?.groupChildSrNo
         {
         groupchildsrno = childNo
         }
         if let oeinfNo = m_employeeDict?.oeGroupBasSrNo
         {
         oegrpbasinfsrno = oeinfNo
         }
         if let empNo = m_employeeDict?.empSrNo
         {
         employeesrno = empNo
         }
         
         
         print(m_dataSettingsDict)
         
         /*  var personNo = String()
         var mobileNo = String()
         var officialMailId = String()
         var personalMailId = String()
         
         if let childNo = m_dataSettingsDict.value(forKey: "CELLPHONE_NO")
         {
         mobileNo = childNo as! String
         }
         if let oeinfNo = m_dataSettingsDict.value(forKey: "OFFICIAL_EMAIL_ID")
         {
         officialMailId = oeinfNo as! String
         }
         if let mailId = m_dataSettingsDict.value(forKey: "PERSONAL_EMAIL_ID")
         {
         personalMailId = mailId as! String
         }*/
         var personalMailId = String()
         var personNo = String()
         if let mailId = m_dataSettingsDict.value(forKey: "PERSONAL_EMAIL_ID")
         {
         personalMailId = mailId as! String
         }
         if let person = m_dataSettingsDict.value(forKey: "PERSON_SR_NO")
         {
         personNo = person as! String
         }
         let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getUpdateEmployeeEnrollmentDetailsUrl(employeesrno: employeesrno, personSrNo: personNo, groupchildsrno: groupchildsrno, mobileNO: m_mobileNumberTextField.text!, officialMailId: m_emailIDLbl.text!, personalMailId: personalMailId))
         
         let request : NSMutableURLRequest = NSMutableURLRequest()
         request.url = urlreq as URL?// NSURL(string: urlreq)
         request.httpMethod = "GET"
         
         let task = URLSession.shared.dataTask(with: urlreq! as URL)
         {
         (data, response, error) in
         
         if data == nil
         {
         
         return
         }
         self.xmlKey = "DBOperationMessage"
         let parser = XMLParser(data: data!)
         parser.delegate = self
         parser.parse()
         
         
         var resultDict = NSDictionary()
         for dict in self.resultsDictArray!
         {
         resultDict = dict as NSDictionary
         resultDict.value(forKey: "DB_OPERATION_MESSAGE")
         print(dict)
         }
         
         
         //                            self.m_tableView.reloadData()
         
         if let status:String = resultDict.value(forKey: "DB_OPERATION_MESSAGE") as? String
         {
         if (status=="SUCCESS")
         {
         self.getDataSettingsUrl()
         DispatchQueue.main.async
         {
         let alertController = UIAlertController(title: "Updated Successfully", message: "", preferredStyle: UIAlertControllerStyle.alert)
         
         let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
         {
         (result : UIAlertAction) -> Void in
         print("Cancel")
         self.m_editButton.setImage(#imageLiteral(resourceName: "icEdit"), for: .normal)
         
         }
         alertController.addAction(cancelAction)
         
         self.present(alertController, animated: true, completion: nil)
         }
         }
         }
         DispatchQueue.main.async
         {
         //                            self.m_tableView.reloadData()
         self.hidePleaseWait()
         
         }
         
         
         }
         task.resume()
         }
         }
         else
         {
         
         //            m_tableView.reloadData()
         
         }*/
        
    }
    
    var isSubmitButtonPressed = false
    
    var showingTitleInProgress = false
    func showingTitleInAnimationComplete(_ completed: Bool) {
        // If a field is not filled out, display the highlighted title for 0.3 seco
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.showingTitleInProgress = false
            if !self.isSubmitButtonPressed {
                self.hideTitleVisibleFromFields()
            }
        }
    }
    func hideTitleVisibleFromFields()
    {
        
        for textField in textFields {
            textField.setTitleVisible(false, animated: true)
            textField.isHighlighted = false
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
        m_dependantDetailsTableview.endEditing(true)
        m_scrollView.endEditing(true)
        if touches.first != nil
        {
            print(event)
        }
        super.touchesBegan(touches, with: event)
    }
    
    //MARK:- Textfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        //        let indexpath = IndexPath(row: dobTxtFieldTag, section: 0)
        //        let cell : AddDependantTableViewCell = m_addDependantTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexpath)as! AddDependantTableViewCell
        //        cell.isEdit=true
        
     
        
        animateTextField(textField, with: true)
        let Newtextfield : SkyFloatingLabelTextField = textField as! SkyFloatingLabelTextField
        Newtextfield.textColor=UIColor.black
        Newtextfield.errorMessage=""
        Newtextfield.titleColor=UIColor.lightGray
            
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if(textField.tag==101)
        {
            if(m_relationTextfield.text == "")
            {
                displayActivityAlert(title: "Select Relation first")
            }
            
        }
        else if(textField.tag==102) //dob
        {
            if(m_relationTextfield.text != "")
            {
                view.endEditing(true)
                textField.resignFirstResponder()
                dobTxtFieldTag = textField.tag
                m_isDateOfMarrige=false
                selectDate(textfield:textField)
                //m_datePicker.date = oldDate
                
            }
            else
            {
                displayActivityAlert(title: "Select Relation first")
            }
            return false
        }
        else if(textField.placeholder=="Date of Marrige")
        {
            view.endEditing(true)
            m_isDateOfMarrige=true
            selectDate(textfield: textField)
            m_datePicker.date = oldDate
            
            return false
        }
        else if(textField.placeholder=="Age(yrs)")
        {
            if(m_relationTextfield.text == "")
            {
                
                //                displayActivityAlert(title: "Select Relation first")
                
                return false
            }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //        textField.setBorderToView(color: UIColor.white)
        if(textField.placeholder=="Name")
        {
            
            if(m_nameTextfield.text?.count==1)
            {
                m_nameTextfield.text = m_nameTextfield.text!.uppercased()
                m_nameTextfield.textColor=UIColor.black
            }
            
            let MAX_LENGTH_PHONENUMBER = 100
            let ACCEPTABLE_NUMBERS     = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        else if(textField.placeholder=="Age(yrs)")
        {
            let MAX_LENGTH_PHONENUMBER = 2
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        if isEditable == true{
            let MAX_LENGTH_PHONENUMBER = 10
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly) == nil
            
            if(newLength>MAX_LENGTH_PHONENUMBER+1)
            {
                textField.resignFirstResponder()
            }
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(textFields.contains(textField as! SkyFloatingLabelTextField))
        {
            animateTextField(textField, with: false)
            
        }
        else
        {
            if(textField.placeholder=="Name")
            {
                nameArray[textField.tag]=textField.text!
                animateTextField(textField, with: false)
                textField.resignFirstResponder()
            }
            else if(textField.placeholder=="Age(yrs)")
            {
                let age : Int = Int(textField.text!)!
                if(age<101)
                {
                    ageArray[textField.tag]=textField.text!
                    animateTextField(textField, with: false)
                    
                }
                else if(age != m_calculatedAge)
                {
                    m_dobTextField.text = ""
                }
                else
                {
                    textField.text=""
                }
                textField.resignFirstResponder()
            }
            else if(textField.placeholder=="DOB")
            {
                textField.resignFirstResponder()
            }
            else
            {
                view.endEditing(true)
            }
        }
        
        let Newtextfield : SkyFloatingLabelTextField = textField as! SkyFloatingLabelTextField
        Newtextfield.textColor=UIColor.black
        Newtextfield.errorMessage=""
        Newtextfield.titleColor=UIColor.lightGray
        
        
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//        // Try to find next responder
//        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField
//        {
//            nextField.becomeFirstResponder()
//
//        }
//        else
//        {
//            // Not found, so remove keyboard.
//            textField.resignFirstResponder()
//        }
//        // Do not add a line break
//        return false
//    }
    func animateTextField(_ textField:UITextField, with up: Bool)
    {
        var movementDistance=0
        let movementDuration=0.3
        if(textField.tag==0)
        {
            movementDistance=0;
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
            movementDistance=140;
        }
        else if(textField.tag==101)
        {
            movementDistance=140;
        }
        else
        {
            movementDistance=245;
        }
        
        
        let movement = (up ? -movementDistance : movementDistance);
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
        
    }
    
    ///Datepicker
    
    //Select Date By Hemangi
    /*
     func selectDate(textfield:UITextField)
     {
     
     _ = Bundle.main.loadNibNamed("DatePicker", owner: self, options: nil)?[0];
     m_DOBView.frame=view.frame
     view.addSubview(m_DOBView)
     addBordersToComponents()
     print(m_dobTextField.text)
     
     if(m_dobTextField.text != nil)
     {
     let date=convertStringToDate(dateString: m_dobTextField.text!)
     m_datePicker.maximumDate=date
     }
     else
     {
     m_datePicker.maximumDate=m_serverDate
     }
     
     
     
     if(!m_windowPeriodStatus)
     {
     if(m_enrollmentLifeEventInfoDict.count>0)
     {
     let birthlifeEvent : NSString = m_enrollmentLifeEventInfoDict.value(forKey: "Childbirth") as! NSString
     let lifeEvent : NSString = m_enrollmentLifeEventInfoDict.value(forKey: "Marriage") as! NSString
     
     
     if(textfield.tag==0) //Date marrige
     {
     if(textfield.placeholder=="Date of Marrige")
     {
     let minimumDate = Calendar.current.date(byAdding: .day, value: Int(-lifeEvent.intValue), to: m_serverDate)
     m_datePicker.minimumDate=minimumDate
     }
     }
     else
     { //Date DOB
     if(m_relationTextfield.text=="SON" || m_relationTextfield.text=="DAUGHTER")
     {
     let minimumDate = Calendar.current.date(byAdding: .day, value: Int(-birthlifeEvent.intValue), to: m_serverDate)
     m_datePicker.minimumDate=minimumDate
     }
     else if(m_relationTextfield.text=="WIFE"||m_relationTextfield.text=="HUSBAND")
     {
     let maxAge = calculateMaxAge()
     if(textfield.tag==0)
     {
     //Added By Pranit test
     let minimumDate = Calendar.current.date(byAdding: .day, value: Int(-lifeEvent.intValue), to: m_serverDate)
     m_datePicker.minimumDate=minimumDate
     }
     else
     {
     let minimumDate = Calendar.current.date(byAdding: .year, value: Int(-maxAge.intValue), to: m_serverDate)
     m_datePicker.minimumDate=minimumDate
     }
     }
     }
     
     }
     else
     {
     
     let maxAge = calculateMaxAge()
     if(textfield.tag==0)
     {
     
     }
     else
     {
     let minimumDate = Calendar.current.date(byAdding: .year, value: Int(-maxAge.intValue), to: m_serverDate)
     m_datePicker.minimumDate=minimumDate
     
     }
     }
     
     }
     else
     {
     let maxAge = calculateMaxAge()
     if(textfield.tag==0)
     {
     
     }
     else
     {
     if(maxAge=="")
     {
     
     }
     else
     {
     let minimumDate = Calendar.current.date(byAdding: .year, value: Int(-maxAge.intValue), to: m_serverDate)
     m_datePicker.minimumDate=minimumDate
     if(m_relationTextfield.text=="FATHER" || m_relationTextfield.text=="MOTHER" || m_relationTextfield.text=="WIFE" || m_relationTextfield.text=="MOTHER-IN-LAW" || m_relationTextfield.text=="FATHER-IN-LAW")
     
     {
     let maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: m_serverDate)
     m_datePicker.maximumDate=maximumDate
     }
     }
     
     }
     }
     
     }
     */
    
    //MARK:- Select Date
    func selectDate(textfield:UITextField)
    {
        _ = Bundle.main.loadNibNamed("DatePicker", owner: self, options: nil)?[0];
        m_DOBView.frame=view.frame
        view.addSubview(m_DOBView)
        addBordersToComponents()
        print(m_dobTextField.text)
        
        if(m_dobTextField.text != nil)
        {
            let date=convertStringToDate(dateString: m_dobTextField.text!)
            m_datePicker.maximumDate=date
            
            if(m_relationTextfield.text=="FATHER" || m_relationTextfield.text=="MOTHER" || m_relationTextfield.text=="WIFE" || m_relationTextfield.text=="MOTHER-IN-LAW" || m_relationTextfield.text=="FATHER-IN-LAW")
                
            {
                let maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: m_serverDate)
                m_datePicker.maximumDate=maximumDate
                //m_datePicker.date = maximumDate!
            }
            else {
                m_datePicker.maximumDate=m_serverDate
                
            }
            
        }
        else
        {
            m_datePicker.maximumDate=m_serverDate
        }
        
        
        
        if(!m_windowPeriodStatus) //WP is closed
        {
            if(m_enrollmentLifeEventInfoDict.count>0)
            {
                let birthlifeEvent : NSString = m_enrollmentLifeEventInfoDict.value(forKey: "Childbirth") as! NSString
                let lifeEvent : NSString = m_enrollmentLifeEventInfoDict.value(forKey: "Marriage") as! NSString
                
                
                if(textfield.tag==0) //Date marrige
                {
                    //if(textfield.placeholder=="Date of Marrige")
                    // {
                    let minimumDate = Calendar.current.date(byAdding: .day, value: Int(-lifeEvent.intValue), to: m_serverDate)
                    
                    m_datePicker.minimumDate=minimumDate
                    m_datePicker.maximumDate=m_serverDate
                    
                    //}
                }
                else
                { //Date DOB Tag-102
                    if(m_relationTextfield.text=="SON" || m_relationTextfield.text=="DAUGHTER")
                    {
                        let minimumDate = Calendar.current.date(byAdding: .day, value: Int(-birthlifeEvent.intValue), to: m_serverDate)
                        m_datePicker.minimumDate=minimumDate
                        m_datePicker.maximumDate=m_serverDate
                        
                    }
                    else if(m_relationTextfield.text=="WIFE"||m_relationTextfield.text=="HUSBAND")
                    {
                        let maxAge = calculateMaxAge()
                        
                        let minimumDate = Calendar.current.date(byAdding: .year, value: Int(-maxAge.intValue), to: m_serverDate)
                        m_datePicker.minimumDate=minimumDate
                        
                        let maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: m_serverDate)
                        m_datePicker.maximumDate=maximumDate
                        //m_datePicker.date = maximumDate!
                        
                    }
                }
                
            }
            else
            {
                
                let maxAge = calculateMaxAge()
                if(textfield.tag==0)
                {
                    
                }
                else
                {
                    let minimumDate = Calendar.current.date(byAdding: .year, value: Int(-maxAge.intValue), to: m_serverDate)
                    m_datePicker.minimumDate=minimumDate
                    
                }
            }
            
        }
        else
        {
            let maxAge = calculateMaxAge()
            if(textfield.tag==0)
            { //marrige - 0, dob-102
                
            }
            else
            { //DOB
                if(maxAge=="")
                {
                    
                    if(m_relationTextfield.text=="FATHER" || m_relationTextfield.text=="MOTHER" || m_relationTextfield.text=="WIFE" || m_relationTextfield.text=="MOTHER-IN-LAW" || m_relationTextfield.text=="FATHER-IN-LAW")
                        
                    {
                        let minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: m_serverDate)
                        m_datePicker.minimumDate=minimumDate
                        
                        let maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: m_serverDate)
                        m_datePicker.maximumDate=maximumDate
                        //m_datePicker.date = maximumDate!
                    }
                }
                else
                {
                    let minimumDate = Calendar.current.date(byAdding: .year, value: Int(-maxAge.intValue), to: m_serverDate)
                    m_datePicker.minimumDate=minimumDate
                    if(m_relationTextfield.text=="FATHER" || m_relationTextfield.text=="MOTHER" || m_relationTextfield.text=="WIFE" || m_relationTextfield.text=="MOTHER-IN-LAW" || m_relationTextfield.text=="FATHER-IN-LAW")
                        
                    {
                        let maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: m_serverDate)
                        m_datePicker.maximumDate=maximumDate
                        //m_datePicker.date = maximumDate!
                    }
                }
                
            }
        }
        
    }
    func calculateMaxAge()->NSString
    {
        if(m_relationTextfield.text=="SON")
        {
            let array : [EnrollmentGroupRelations] = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation:"SON")
            if((array.count)>0)
            {
                
                let maxAge : NSString = array[0].maxAge! as NSString
                
                return maxAge
            }
            
        }
        else if(m_relationTextfield.text=="DAUGHTER")
        {
            let array : [EnrollmentGroupRelations] = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation:"DAUGHTER")
            if((array.count)>0)
            {
                
                let maxAge : NSString = array[0].maxAge! as NSString
                return maxAge
                
            }
        }
        else if(m_relationTextfield.text=="FATHER")
        {
            let array : [EnrollmentGroupRelations] = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation:"FATHER")
            if((array.count)>0)
            {
                
                let maxAge : NSString = array[0].maxAge! as NSString
                return maxAge
                
            }
        }
        else if(m_relationTextfield.text=="MOTHER")
        {
            let array : [EnrollmentGroupRelations] = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation:"MOTHER")
            if((array.count)>0)
            {
                
                let maxAge : NSString = array[0].maxAge! as NSString
                return maxAge
                
            }
        }
        else if(m_relationTextfield.text=="WIFE"||m_relationTextfield.text=="HUSBAND")
        {
            
            let maxAge : NSString = "100" as NSString
            return maxAge
            
        }
        return ""
    }
    @IBAction func dateCancelButtonClicked(_ sender: Any)
    {
        hideDatePickerView()
        
    }
    
    @IBOutlet weak var topupTableView: UITableView!
    
    //MARK:- Next Clicked
    @IBAction func dependantNextButtonClicked(_ sender: Any)
    {
        
        //        if(progressBar.numberOfPoints==2)
        //        {
        //            let summaryVC : EnrollmentSummaryViewController = EnrollmentSummaryViewController()
        //            summaryVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
        //            summaryVC.m_windowPeriodEndDate=m_windowPeriodEndDate
        //            self.navigationController?.pushViewController(summaryVC, animated: true)
        //        }
        //        else
        //        {
        //            progressBar.currentIndex=2
        //            showTopupView()
        //        }
        
        //Parental Premium
        let coreBenefitsVc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "ParentalPremiumVC") as! ParentalPremiumVC
        coreBenefitsVc.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
        coreBenefitsVc.m_windowPeriodEndDate=m_windowPeriodEndDate
        navigationController?.pushViewController(coreBenefitsVc, animated: true)
        
    }
    
    var oldDate = Date()
    
    //MARK:-  Date Done Tapped
    @IBAction func dateDoneButtonClicked(_ sender: UIButton)
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd~MM~yyyy"
        let selectedDate = formatter.string(from: m_datePicker.date)
        //oldDate = m_datePicker.date
        if(selectedDate=="")
        {
            m_selectedDate = "00~00~0000"
            
        }
        else
        {
            
            m_selectedDate = selectedDate
        }
        
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: m_datePicker.date)
        print(dateString)
        if(m_isDateOfMarrige)
        {
            m_marrigeDate = dateString
            m_domTextfield.text=m_marrigeDate
            m_domTextfield.errorMessage=""
            m_domTextfield.textColor=UIColor.black
        }
        else
        {
            m_dateofBirth = dateString;
            
            let gregorian = Calendar(identifier: .gregorian)
            let ageComponents = gregorian.dateComponents([.year], from: m_datePicker.date, to: m_serverDate)
            let age = ageComponents.year!
            print(age)
            m_dobTextField.text=m_dateofBirth
            m_ageTextfield.text = String(age)
            m_calculatedAge = age
            
            //            ageArray[dobTxtFieldTag]=String(age)
            
        }
        
        view.endEditing(true)
        let Newtextfield : SkyFloatingLabelTextField = m_dobTextField as! SkyFloatingLabelTextField
        Newtextfield.textColor=UIColor.black
        Newtextfield.errorMessage=""
        Newtextfield.titleColor=UIColor.lightGray
        
        
        //        m_addDependantTableView.beginUpdates()
        //        m_addDependantTableView.reloadRows(at: [indexpath], with: .automatic)
        //        m_addDependantTableView.endUpdates()
        m_dependantDetailsTableview.reloadData()
        hideDatePickerView()
    }
    
    func hideDatePickerView()
    {
        m_DOBView.removeFromSuperview()
        //        m_dobtf.resignFirstResponder()
    }
    func addBordersToComponents()
    {
        
        //        m_datePicker.setDate(m_selectedDate, animated: true)
    }
    
    func alertMessage(msg:String)
    {
        let alertController = UIAlertController(title: "Instruction", message:msg , preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
        dependantsDictArray = []
        pendingRelationsDictArray = []
        policyEmpDictArray = []
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
            if(xmlKeysArray.contains(xmlKey))
            {
                print(indexNumber,xmlKeysArray)
                indexNumber=indexNumber+1
                if(xmlKeysArray.count>indexNumber)
                {
                    xmlKey=xmlKeysArray[indexNumber]
                }
            }
            
        }
        else if(elementName=="Dependant1"||elementName=="Dependant2"||elementName=="Dependant3"||elementName=="Dependant4"||elementName=="Dependant5"||elementName=="Dependant6"||elementName=="Dependant7"||elementName=="Dependant8")
        {
            dependantsDictArray?.append(currentDictionary!)
        }
        else if(elementName=="Relation")
        {
            if currentDictionary != nil
            {
                pendingRelationsDictArray?.append(currentDictionary!)
            }
            
        }
        else if(elementName=="GMCEmployee"||elementName=="GPAEmployee"||elementName=="GTLEmployee")
        {
            policyEmpDictArray?.append(currentDictionary!)
            
        }
        else if(elementName=="parent")
        {
            if currentDictionary != nil
            {
                let dict : NSDictionary = (currentDictionary as NSDictionary?)!
                DatabaseManager.sharedInstance.deleteParentalPremiumDetails(productCode: "")
                DatabaseManager.sharedInstance.saveParentalPremiumDetails(enrollmentDetailsDict: dict)
            }
            
        }
        else if dictionaryKeys.contains(elementName)
        {
            if self.currentDictionary != nil
            {
                self.currentDictionary![elementName] = currentValue
                self.currentValue = ""
            }
            
            
        }
        
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
        
    }
    
    //FLEXBEN CODE
    
    
    var alertID = 0
    
    private func showAlertWithTextField(msg:String,type:String) {
        
        let alertController = UIAlertController(title: msg, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = ""
            if type == "number" {
                textField.keyboardType = .phonePad
            }
            else {
                textField.keyboardType = .emailAddress
            }
            
            // textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            
        }
        
        
        
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
            //let firstTextField = alertController.textFields![0] as UITextField
            
            print(alertController.textFields![0].text!)
            print(self.alertID)
            
            switch self.alertID {
            case 1:
                let status = alertController.textFields![0].text!.isValidContact
                if status {
                    
                }
                else {
                    self.displayActivityAlert(title: "Please Enter valid Official Mobile Number")
                }
                
                break
            case 11:
                let status = alertController.textFields![0].text!.isValidContact
                if status {
                    
                }
                else {
                    self.displayActivityAlert(title: "Please Enter valid Personal Mobile Number")
                }
                break
            case 2:
                if self.isValidEmail(emailStr: alertController.textFields![0].text!) == false {
                    //  displayActivityAlert(title: "Please Enter valid Official E-Mail ID")
                }
                break
            case 22:
                
                if self.isValidEmail(emailStr: alertController.textFields![0].text!) == false {
                    self.displayActivityAlert(title: "Please Enter valid Personal E-Mail ID")
                }
                
                break
            default:
                break
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func textChanged(_ sender:UITextField) {
        // self.actionToEnable?.enabled = (sender.text! == "Validation")
        print(sender.text!)
        print(alertID)
        
        switch alertID {
        case 1:
            let status = sender.text!.isValidContact
            if status {
                
            }
            else {
                self.displayActivityAlert(title: "Please Enter valid Official Mobile Number")
            }
            
            break
        case 11:
            let status = sender.text!.isValidContact
            if status {
                
            }
            else {
                self.displayActivityAlert(title: "Please Enter valid Personal Mobile Number")
            }
            break
        case 2:
            if isValidEmail(emailStr: sender.text!) == false {
                //  displayActivityAlert(title: "Please Enter valid Official E-Mail ID")
            }
            break
        case 22:
            
            if isValidEmail(emailStr: sender.text!) == false {
                displayActivityAlert(title: "Please Enter valid Personal E-Mail ID")
            }
            
            break
        default:
            break
        }
        
        
    }
    
    @IBAction func editOfficialMobile(_ sender: Any) {
        alertID = 1
        showAlertWithTextField(msg: "Enter Official Mobile Number", type: "number")
    }
    
    @IBAction func editOfficialEmail(_ sender: Any) {
        alertID = 2
        
        showAlertWithTextField(msg: "Enter Official E-Mail ID", type: "email")
    }
    
    @IBAction func editPersonalMobile(_ sender: Any) {
        alertID = 11
        
        showAlertWithTextField(msg: "Enter Personal Mobile Number", type: "number")
    }
    
    @IBAction func editPersonalEmail(_ sender: Any) {
        alertID = 22
        
        showAlertWithTextField(msg: "Enter Personal E-Mail ID", type: "email")
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}

extension EnrollmentEmployeeViewController {
    
    
    func UpdateEmployeeEmergencyNo() {
        if(isConnectedToNetWithAlert())
        {
            
          let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
          if(userArray.count>0)
          {
                var m_employeedict : EMPLOYEE_INFORMATION?
                m_employeedict=userArray[0]
                
                var empSrNo = String()
                if let empSr = m_employeedict?.empSrNo
                {
                    empSrNo = String(empSr)
                }
                
            let url = APIEngine.shared.updateEmployeeEmergencyJsonURL(Employeesrno: empSrNo, ContactNo: m_emrgmobileTextfield.text!)
                let dict = ["":""]
                
                EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        //self.hidePleaseWait()
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        // self.hidePleaseWait()
                        print("found updateEmployeeEmergencyJsonURL....")
                        
                        do {
                            print("Started parsing updateEmployeeEmergencyJsonURL...")
                            print(data)

                            if let jsonResult = data?.dictionary?["message"]
                            {
                                if let status = jsonResult["Status"].bool {
                                    if status == true
                                    {
                                        self.displayActivityAlert(title: "Emergency Mobile Number updated successfully.")
                                        
                                        self.getNewLoadSessionDataFromServer()
                                        
                                    }
                                    else {
                                        //No Data found
                                    }
                                }
                            }
                        }
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }
                }//server call
        }
     }
    }
    
    func getNewLoadSessionDataFromServer() {
        if(isConnectedToNetWithAlert())
        {
            let loginType =  UserDefaults.standard.value(forKey: "loginTypeForJson") as! String
            //let url = APIEngine.shared.getLoadSessionJsonURL(mobileNo:mobNo)
            let url = APIEngine.shared.getLoadSessionJsonURLPortal(mobileNo:loginType)

            let urlreq = NSURL(string : url)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?
            request.httpMethod = "post"
            
            let session = URLSession(configuration: .default)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
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
            
            //self.showPleaseWait(msg: "")
            print("6118 getLoadSessionJsonURL : \(url)")
            
            EnrollmentServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (data, error) in
                
                
                //let request : NSMutableURLRequest = NSMutableURLRequest()
                //request.url = urlreq as URL?// NSURL(string: urlreq)
                //request.httpMethod = "GET"
                
                //let task = URLSession.shared.dataTask(with: urlreq! as URL)
                //{(data, response, error)  -> Void in
                if error != nil
                {
                    print("error ",error!)
                    //self.hidePleaseWait()
                    self.displayActivityAlert(title: m_errorMsg)
                }
                else
                {
                    // self.hidePleaseWait()
                    print("found some")
                    
                    do {
                        print("Started parsing Load Session...")
                        print(data)
                        
                        // let user = try! JSONDecoder().decode(Welcome.self, from: data ?? Data())
                        
                        if let jsonResult = data as? NSDictionary
                        {
                            print("Data Found")
                            
                            print(jsonResult)
                            if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                if let statusVal = msgDict.value(forKey: "Status") as? Bool {
                                    if statusVal == true {
                                        
                                        if let groupInfo = jsonResult.value(forKey: "Group_Info_data") as? NSDictionary {
                                            
                                            if let groupCodeString = groupInfo.value(forKey:"GROUPCODE") as? String {
                                                UserDefaults.standard.set(groupCodeString, forKey: "groupCodeString")
                                            }
                                            
                                        }
                                        
                           
                              //Group_Policies_Employees_Dependants
                            let statusDelDep = DatabaseManager.sharedInstance.deletePersonDetails(personSrNo: "")
                            if(statusDelDep)
                            {
                                print("Dependant found....")
                                
                                if let groupPolicyMainDepDictArray = jsonResult.value(forKey: "Group_Policies_Employees_Dependants") as? NSArray {
                                    print(groupPolicyMainDepDictArray)
                                    
                                    if groupPolicyMainDepDictArray.count > 0 {
                                        self.dependantsDictArray?.removeAll()
                                        print("saved dependant data...")
                                        if let mainDict = groupPolicyMainDepDictArray[0] as? NSDictionary {
                                            if let mainGmcPEDict = mainDict.value(forKey: "GroupGMCPolicyEmpDependants_data") as? NSArray {
                                                for innerDict1 in mainGmcPEDict {
                                                    self.dependantsDictArray?.append(innerDict1 as? NSDictionary as! [String : String])
                                                    DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict1 as! NSDictionary)
                                                }
                                            }
                                            
                                            if let mainGpaPEDict = mainDict.value(forKey: "GroupGPAPolicyEmpDependants_data") as? NSArray {
                                                for innerDict2 in mainGpaPEDict {
                                                    self.dependantsDictArray?.append(innerDict2 as? NSDictionary as! [String : String])
                                                    DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict2 as! NSDictionary)
                                                }
                                            }
                                            
                                            if let mainGTLPEDict = mainDict.value(forKey: "GroupGTLPolicyEmpDependants_data") as? NSArray {
                                                for innerDict3 in mainGTLPEDict {
                                                    self.dependantsDictArray?.append(innerDict3 as? NSDictionary as! [String : String])
                                                    DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict3 as! NSDictionary)
                                                }
                                            }
                                            
                                        }
                                    }//>0
                                }
                                
                                DispatchQueue.main.async {
                                    
                                    let tempDict = NSDictionary()
                                    //self.setupTabbar(userDict:tempDict)
                                    UserDefaults.standard.set(true, forKey: "isAlreadylogin")
                                }
                            }//emp depend status
                            
                            print("Complete Parsing....")

                            // dispatch_async(dispatch_get_main_queue(), {
                                }
                            }
                        }
                        }
                    }//do
                    catch let JSONError as NSError
                    {
                        print(JSONError)
                    }
                    
                    
                }
                
                
            }
            // task.resume()
        }
    }
    
}
