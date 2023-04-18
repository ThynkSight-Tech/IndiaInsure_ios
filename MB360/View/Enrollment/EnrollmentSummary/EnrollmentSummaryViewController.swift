//
//  EnrollmentSummaryViewController.swift
//  MyBenefits
//
//  Created by Semantic on 02/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import FirebaseCrashlytics

import AEXML

class EnrollmentSummaryViewController: UIViewController,FlexibleSteppedProgressBarDelegate,XMLParserDelegate {
    @IBOutlet weak var m_topView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var m_gmcTopupTitleLbl: UILabel!
    var m_employeedict : EMPLOYEE_INFORMATION?
    @IBOutlet weak var m_GMCTopupLbl: UILabel!
    @IBOutlet weak var m_GMCBSILbl: UILabel!
    
    @IBOutlet weak var m_topupSITitleLbl: UILabel!
    @IBOutlet weak var m_GMCSILbl: UILabel!
    
    @IBOutlet weak var m_GMCTotalSILbl: UILabel!
    
    @IBOutlet weak var m_GPATitleLbl: UILabel!
    @IBOutlet weak var m_GPABSILbl: UILabel!
    
    @IBOutlet weak var m_GPATotalSI: UILabel!
    @IBOutlet weak var m_GPADIvider: UILabel!
    @IBOutlet weak var m_GTLTitleLbl: UILabel!
    @IBOutlet weak var m_GTLDivider: UILabel!
    @IBOutlet weak var m_GTLBSILbl: UILabel!
    @IBOutlet weak var m_GTLTotalSILbl: UILabel!
    @IBOutlet weak var m_installmentDetailsLbl: UILabel!
    @IBOutlet weak var m_totalPremium: UILabel!
    @IBOutlet weak var GMCPremiumLbl: UILabel!
    @IBOutlet weak var m_view1: UIView!
    @IBOutlet weak var m_view2: UIView!
    @IBOutlet weak var m_view3: UIView!
    @IBOutlet weak var m_view4: UIView!
    
    @IBOutlet weak var m_empAgeLbl: UILabel!
    
    @IBOutlet weak var m_spouseLbl: UILabel!
    
    @IBOutlet weak var m_spouseAgeLbl: UILabel!
    
    @IBOutlet weak var m_member2Lbl: UILabel!
    
    @IBOutlet weak var m_member3Lbl: UILabel!
    
    @IBOutlet weak var m_member4Lbl: UILabel!
    
    @IBOutlet weak var m_member5Lbl: UILabel!
    
    @IBOutlet weak var m_member6Lbl: UILabel!
    
    @IBOutlet weak var m_member7Lbl: UILabel!
    
    @IBOutlet weak var m_member1AgeLbl: UILabel!
    
    @IBOutlet weak var m_member2AgeLbl: UILabel!
    
    @IBOutlet weak var m_member3AgeLbl: UILabel!
    
    @IBOutlet weak var m_member4AgeLbl: UILabel!
    
    @IBOutlet weak var m_member5AgeLbl: UILabel!
    
    @IBOutlet weak var m_member6AgeLbl: UILabel!
    @IBOutlet weak var familyCountLbl: UILabel!
    @IBOutlet weak var m_parentalPremiumTitleLbl: UILabel!
    
    @IBOutlet weak var m_statusLbl: UILabel!
    @IBOutlet weak var m_motherPremiumTitleLbl: UILabel!
    @IBOutlet weak var m_fatherPremiumTitleLbl: UILabel!
    @IBOutlet weak var m_GTLTopupPremiumTitle: UILabel!
    @IBOutlet weak var m_gpaTopupPremiumTitle: UILabel!
    
    @IBOutlet weak var m_GTLBSITitleLbl: UILabel!
    @IBOutlet weak var m_totalParentalPremium: UILabel!
    
    @IBOutlet weak var m_scrollView: UIScrollView!
    
    @IBOutlet weak var m_installmentdetailsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_installmentTitleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var m_installmentDetailsTitleview: UIView!
    @IBOutlet weak var m_installmentDetailsTitleLbl: UILabel!
    @IBOutlet weak var m_GTLTotalSITitleLbl: UILabel!
    @IBOutlet weak var m_GPATotalSITitleLbl: UILabel!
    @IBOutlet weak var m_GTLTopupPremium: UILabel!
    
    @IBOutlet weak var m_GPATopupPremium: UILabel!
    
    @IBOutlet weak var m_fatherTopupPremium: UILabel!
    
    @IBOutlet weak var m_motherTopupPremium: UILabel!
    
    @IBOutlet weak var m_GPABSITitleLbl: UILabel!
    var relationArray = Array<String>()
    var personDetailsArray = Array<PERSON_INFORMATION>()
    var sortedPersonDetailsArray = Array<PERSON_INFORMATION>()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var xmlKey = String()
    var dictionaryKeys = ["status","EnrollmentConfirmInformation"]
    var m_enrollmentMiscInformationDict = NSDictionary()
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate=Date()
    var m_productCode = String()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.title="Enrollment Summary"
        self.navigationItem.leftBarButtonItem=getBackButtonHideTabBar()
         self.navigationItem.rightBarButtonItem=getRightButton()
        getCovragesDetails()
        setLayout()
        setTopupData()
        setData()
        if let enrollmentMiscInfo = UserDefaults.standard.value(forKey: "EnrollmentMiscInformation")
        {
            m_enrollmentMiscInformationDict = enrollmentMiscInfo as! NSDictionary
        }
        if(m_windowPeriodStatus)
        {
        if let nTimesEnrollmentCanBeConfirmed = m_enrollmentMiscInformationDict.value(forKey: "NTimesEnrollmentCanBeConfirmed")as? String
        {
            if(nTimesEnrollmentCanBeConfirmed == "MULTIPLE")
            {
                m_confirmEnrollmentButton.isHidden=false
            }
            else
            {
                
                if(m_isEnrollmentConfirmed)
                {
                    m_confirmEnrollmentButton.isHidden=true
                }
                else if(!m_isEnrollmentConfirmed)
                {
                    m_confirmEnrollmentButton.isHidden=false
                }
               /* if let noOfTimesEnrollmentActuallyConfirmed = m_enrollmentMiscInformationDict.value(forKey: "NoOfTimesEnrollmentActuallyConfirmed")as? String
                {
                    if(noOfTimesEnrollmentActuallyConfirmed=="ONE")
                    {
                        m_confirmEnrollmentButton.isHidden=true
                    }
                    else
                    {
                        m_confirmEnrollmentButton.isHidden=false
                    }
                }*/
            }
        }
        }
        else
        {
            m_confirmEnrollmentButton.isHidden=true
        }
        
        
        if(m_isEnrollmentConfirmed)
        {
            m_statusLbl.text="Confirmed"
        }
        else if(!m_isEnrollmentConfirmed)
        {
            if (!m_windowPeriodStatus) { //closed
                m_statusLbl.text="Confirmed"
                m_statusLbl.backgroundColor=hexStringToUIColor(hex: "ed6b75")

            }
            else {
            m_statusLbl.text="Not Confirmed"
            m_statusLbl.backgroundColor=hexStringToUIColor(hex: "ed6b75")
            }
        }
        
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        let healthMeterVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"HealthMeterVC") as! HealthMeterVC
               navigationController?.pushViewController(healthMeterVC, animated: true)
    }
    
    
   func getRightButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "Home-2"), style: .plain, target: self, action: #selector(rightButtonClicked1)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func rightButtonClicked1()
    {
        tabBarController?.selectedIndex=2
         _ = navigationController?.popToRootViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.isNavigationBarHidden=false
            
    }
    func setData()
    {
        let count = String(personDetailsArray.count-1)
        familyCountLbl.text="1 + "+count
        m_empAgeLbl.text=String(personDetailsArray[0].age)+" Years"
        if(personDetailsArray.count>1)
        {
            
            m_spouseLbl.text=personDetailsArray[1].relationname
            m_spouseAgeLbl.text=String(personDetailsArray[1].age)+" Years"
            if(personDetailsArray.count>2)
            {
                m_member2Lbl.text=personDetailsArray[2].relationname
                m_member1AgeLbl.text=String(personDetailsArray[2].age)+" Years"
                m_member2Lbl.isHidden=false
                m_member1AgeLbl.isHidden=false
            }
            else
            {
                m_member2Lbl.isHidden=true
                m_member1AgeLbl.isHidden=true
            }
            if(personDetailsArray.count>3)
            {
                m_member3Lbl.text=personDetailsArray[3].relationname
                m_member2AgeLbl.text=String(personDetailsArray[3].age)+" Years"
                m_member3Lbl.isHidden=false
                m_member2AgeLbl.isHidden=false
            }
            else
            {
                m_member3Lbl.isHidden=true
                m_member2AgeLbl.isHidden=true
            }
            if(personDetailsArray.count>4)
            {
                m_member4Lbl.text=personDetailsArray[4].relationname
                m_member3AgeLbl.text=String(personDetailsArray[4].age)+" Years"
                m_member4Lbl.isHidden=false
                m_member3AgeLbl.isHidden=false
            }
            else
            {
                m_member4Lbl.isHidden=true
                m_member3AgeLbl.isHidden=true
            }
            
            if(personDetailsArray.count>5)
            {
                m_member5Lbl.text=personDetailsArray[5].relationname
                m_member4AgeLbl.text=String(personDetailsArray[5].age)+" Years"
                m_member5Lbl.isHidden=false
                m_member4AgeLbl.isHidden=false
            }
            else
            {
                m_member5Lbl.isHidden=true
                m_member4AgeLbl.isHidden=true
            }
            if(personDetailsArray.count>6)
            {
                m_member6Lbl.text=personDetailsArray[6].relationname
                m_member5AgeLbl.text=String(personDetailsArray[6].age)+" Years"
                m_member6Lbl.isHidden=false
                m_member5AgeLbl.isHidden=false
            }
            else
            {
                m_member6Lbl.isHidden=true
                m_member5AgeLbl.isHidden=true
            }
            if(personDetailsArray.count>7)
            {
                m_member7Lbl.text=personDetailsArray[7].relationname
                m_member6AgeLbl.text=String(personDetailsArray[7].age)+" Years"
                m_member7Lbl.isHidden=false
                m_member6AgeLbl.isHidden=false
            }
            else
            {
                m_member7Lbl.isHidden=true
                m_member6AgeLbl.isHidden=true
            }
            
        }
        else
        {
            m_member2Lbl.isHidden=true
            m_member1AgeLbl.isHidden=true
            m_member7Lbl.isHidden=true
            m_member6AgeLbl.isHidden=true
            m_member6Lbl.isHidden=true
            m_member5AgeLbl.isHidden=true
            m_member5Lbl.isHidden=true
            m_member4AgeLbl.isHidden=true
            m_member4Lbl.isHidden=true
            m_member3AgeLbl.isHidden=true
            m_member3Lbl.isHidden=true
            m_member2AgeLbl.isHidden=true
            m_member2Lbl.isHidden=true
            m_member1AgeLbl.isHidden=true
            
        }
        
    }
    func getCovragesDetails()
    {
        personDetailsArray=[]
        print(personDetailsArray)
       m_productCode="GMC"
        sortedPersonDetailsArray=DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:m_productCode, relationName: "EMPLOYEE")
        
        
        let array = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: m_spouse)
        if(array.count>0)
        {
            personDetailsArray.append(array[0])
        }
        
        let arrayofSon = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "SON")
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
        
        
        let arrayofDaughter = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "DAUGHTER")
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
        
        let fatherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER")
        if(fatherarray.count>0)
        {
            personDetailsArray.append(fatherarray[0])
        }
        let motherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER")
        if(motherarray.count>0)
        {
            personDetailsArray.append(motherarray[0])
        }
        let fatherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER-IN-LAW")
        if(fatherInLawarray.count>0)
        {
            personDetailsArray.append(fatherInLawarray[0])
        }
        let motherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER-IN-LAW")
        if(motherInLawarray.count>0)
        {
            personDetailsArray.append(motherInLawarray[0])
        }
        
        
        personDetailsArray.insert(sortedPersonDetailsArray[0], at: 0)
        print(personDetailsArray)
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var contentRect = CGRect.zero
        for view: UIView in m_scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        contentRect.size.height = contentRect.size.height + 20
        m_scrollView.contentSize = contentRect.size
    }
    func setTopupData()
    {
        
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if(userArray.count>0)
        {
            m_employeedict=userArray[0]
            
            let total : NSString = m_employeedict?.baseSumInsured as NSString? ?? "0"
            let sum : NSString = m_employeedict?.topupoptedAmount as NSString? ?? "0"
            if let amountString = m_employeedict?.baseSumInsured!.currencyInputFormatting()
            {
                m_GMCBSILbl.text = amountString
            }
            if(m_employeedict?.topupoptedflag=="1")
            {
                m_GMCTopupLbl.isHidden=false
                m_topupSITitleLbl.isHidden=false
                m_topupSITitleLbl.text="Top-Up Sum Insured"
                if(sum==""||sum=="0")
                {
                    m_GMCTopupLbl.text = "0"
                }
                else
                {
                    if let amountString1 = m_employeedict?.topupoptedAmount!.currencyInputFormatting()
                    {
                        m_GMCTopupLbl.text = amountString1
                    }
                }
            
            
           
            
           print(m_employeedict)
           
            if let gmcPremium = m_employeedict?.topupSIPremium
            {
                GMCPremiumLbl.isHidden=false
                m_gmcTopupTitleLbl.isHidden=false
                m_gmcTopupTitleLbl.text="GHI Top-Up Premium"
               if(gmcPremium==""||gmcPremium=="0")
               {
                    GMCPremiumLbl.text="0"
                }
                else
               {
                    GMCPremiumLbl.text=m_employeedict?.topupSIPremium!.currencyInputFormatting()
                }
                
                let totalPremium = m_employeedict?.topupSIPremium!
                if(totalPremium==""||totalPremium=="0")
                {
                    m_totalPremium.text="0"
                }
                else
                {
                m_totalPremium.text=m_employeedict?.topupSIPremium!.currencyInputFormatting()
                }
            }
            else
            {
                GMCPremiumLbl.isHidden=true
                m_gmcTopupTitleLbl.isHidden=true
                m_gmcTopupTitleLbl.text=""
            }
            }
            else
            {
                m_GMCTopupLbl.isHidden=true
                m_topupSITitleLbl.isHidden=true
                m_topupSITitleLbl.text=""
                GMCPremiumLbl.isHidden=true
                m_gmcTopupTitleLbl.isHidden=true
                m_gmcTopupTitleLbl.text=""
            }
            let amountString2 = String(total.intValue+sum.intValue).currencyInputFormatting()
            
            //To avoid -1 value adding adding in Total Sum insured amount
            if sum.intValue > 0 {
                let amountString2 = String(total.intValue+sum.intValue).currencyInputFormatting()
                m_GMCTotalSILbl.text = amountString2
            }
            else { //If sum == -1
                let amountString2 = String(total.intValue).currencyInputFormatting()
                m_GMCTotalSILbl.text = amountString2
            }
        }
        
        let userArrayGPA : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GPA")
        if(userArrayGPA.count>0)
        {
            m_employeedict=userArrayGPA[0]
            m_GPATitleLbl.text="Group Personal Accident"
            m_GPABSITitleLbl.text="Base Sum Insured"
            m_GPATotalSITitleLbl.text="Total Sum Insured"
            
            let total : NSString = m_employeedict?.baseSumInsured as NSString? ?? "0"
           
            if let amountString = m_employeedict?.baseSumInsured!.currencyInputFormatting()
            {
                m_GPABSILbl.text = amountString
                m_GPATotalSI.text = amountString
                m_GPATitleLbl.isHidden=false
                m_GPABSITitleLbl.isHidden=false
                m_GPATotalSITitleLbl.isHidden=false
                m_GPATotalSI.isHidden=false
                m_GPABSILbl.isHidden=false
                m_GPADIvider.isHidden=false
                m_gpaTopupPremiumTitle.isHidden=false
                m_GPATopupPremium.isHidden=false
            }
            
        }
        else
        {
            m_GPATitleLbl.isHidden=true
            m_GPABSITitleLbl.isHidden=true
            m_GPATotalSITitleLbl.isHidden=true
            m_GPATotalSI.isHidden=true
            m_GPABSILbl.isHidden=true
            m_GPADIvider.isHidden=true
            m_gpaTopupPremiumTitle.isHidden=true
            m_GPATopupPremium.isHidden=true
            
            
        }
        
        let userArrayGTL : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GTL")
        if(userArrayGTL.count>0)
        {
            m_employeedict=userArrayGTL[0]
            m_GTLTitleLbl.text="Group Term Life"
            m_GTLBSITitleLbl.text="Base Sum Insured"
            m_GTLTotalSITitleLbl.text="Total Sum Insured"
            let total : NSString = m_employeedict?.baseSumInsured as NSString? ?? "0"
            
            if let amountString = m_employeedict?.baseSumInsured!.currencyInputFormatting()
            {
                m_GTLBSILbl.text = amountString
                m_GTLTotalSILbl.text = amountString
                m_GTLTitleLbl.isHidden=false
                m_GTLBSITitleLbl.isHidden=false
                m_GTLTotalSITitleLbl.isHidden=false
                m_GTLBSILbl.isHidden=false
                m_GTLTotalSILbl.isHidden=false
                m_GTLDivider.isHidden=false
                m_GTLTitleLbl.isHidden=false
                m_GTLTopupPremium.isHidden=false
                m_GTLTopupPremiumTitle.isHidden=false
            }
            
        }
        else
        {
            m_GTLBSILbl.isHidden=true
            m_GTLTotalSILbl.isHidden=true
            m_GTLDivider.isHidden=true
            m_GTLTitleLbl.isHidden=true
            m_GTLBSITitleLbl.isHidden=true
            m_GTLTotalSITitleLbl.isHidden=true
            m_GTLTopupPremium.isHidden=true
            m_GTLTopupPremiumTitle.isHidden=true
        }
        print(m_employeedict)
        if var premiumTotal = m_employeedict?.topupSIPremium
        {
            
            premiumTotal = premiumTotal.currencyInputFormatting()
            var totalPremium : String = "₹ " + premiumTotal
       
        if(premiumTotal==""||premiumTotal=="0")
        {
            m_view4.isHidden=false
            m_installmentTitleViewHeight.constant=45
            m_installmentdetailsTopConstraint.constant=15
             m_installmentDetailsTitleLbl.text="Installment Details"
            totalPremium = "₹ 0/-"
            let premiumStatment = "Total Premium of \(totalPremium) will be deducted from your salary"
            let rangeOfColoredString = (premiumStatment as NSString).range(of: (totalPremium))
            let attributedString = NSMutableAttributedString(string:premiumStatment)
            attributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.black],range: rangeOfColoredString)
            m_installmentDetailsLbl.attributedText = attributedString
            print(attributedString)
        }
        else
        {
            m_installmentTitleViewHeight.constant=45
            m_installmentdetailsTopConstraint.constant=15
            m_installmentDetailsTitleLbl.text="Installment Details"
            totalPremium.append("/-")
        let premiumStatment = "Total Premium of \(totalPremium) will be deducted from your salary"
        let rangeOfColoredString = (premiumStatment as NSString).range(of: (totalPremium))
        
        let attributedString = NSMutableAttributedString(string:premiumStatment)
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.black],range: rangeOfColoredString)
        m_installmentDetailsLbl.attributedText = attributedString
            print(attributedString)
        }
        }
        else
        {
            m_view4.isHidden=false
            m_installmentTitleViewHeight.constant=45
            m_installmentdetailsTopConstraint.constant=15
            m_installmentDetailsTitleLbl.text="Installment Details"
            let totalPremium = "₹ 0/-"
            let premiumStatment = "Total Premium of \(totalPremium) will be deducted from your salary"
            let rangeOfColoredString = (premiumStatment as NSString).range(of: (totalPremium))
            let attributedString = NSMutableAttributedString(string:premiumStatment)
            attributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.black],range: rangeOfColoredString)
            m_installmentDetailsLbl.attributedText = attributedString
            print(attributedString)
        }
        
        let array = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "")
        if(array.count>0)
        {
            
        if(array[0].isParentsCovered=="NO")
        {
            m_totalParentalPremium.isHidden=true
            m_parentalPremiumTitleLbl.isHidden=true
            
            for i in 0..<personDetailsArray.count
            {
                relationArray.append(personDetailsArray[i].relationname!)
            }
            if(relationArray.contains("FATHER"))
            {
                let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "FatherSumInsured")
                if(dict.count>0)
                {
                    if let fatherPremium = dict[0].value(forKey: "Premium")
                    {
                        if(fatherPremium as! String=="")
                        {
                            m_fatherTopupPremium.isHidden=true
                            m_fatherPremiumTitleLbl.isHidden=true
                        }
                        else if(fatherPremium as! String=="0")
                        {
                            m_fatherTopupPremium.text = "0"
                            m_fatherPremiumTitleLbl.text="Premium for Father"
                            
                            m_totalParentalPremium.text=m_fatherTopupPremium.text
                            m_totalParentalPremium.isHidden=false
                            m_parentalPremiumTitleLbl.isHidden=false
                            m_parentalPremiumTitleLbl.text="Total Parental Premium"
                            m_fatherTopupPremium.isHidden=false
                            m_fatherPremiumTitleLbl.isHidden=false
                        }
                        else
                        {
                            m_fatherTopupPremium.text =
                                ((fatherPremium as? String)?.currencyInputFormatting())!
                            m_fatherPremiumTitleLbl.text="Premium for Father"
                            
                            m_totalParentalPremium.text=m_fatherTopupPremium.text
                            m_totalParentalPremium.isHidden=false
                            m_parentalPremiumTitleLbl.isHidden=false
                            m_parentalPremiumTitleLbl.text="Total Parental Premium"
                            m_fatherTopupPremium.isHidden=false
                            m_fatherPremiumTitleLbl.isHidden=false
                        }
                        
                    }
                    
                }
                else
                {
                    m_fatherTopupPremium.text = "0"
                    m_fatherPremiumTitleLbl.text="Premium for Father"
                    
                    m_totalParentalPremium.text=m_fatherTopupPremium.text
                    m_totalParentalPremium.isHidden=false
                    m_parentalPremiumTitleLbl.isHidden=false
                    m_parentalPremiumTitleLbl.text="Total Parental Premium"
                    m_fatherTopupPremium.isHidden=false
                    m_fatherPremiumTitleLbl.isHidden=false
                }
            }
            else
            {
                m_fatherTopupPremium.isHidden=true
                m_fatherPremiumTitleLbl.isHidden=true
            }
            if(relationArray.contains("MOTHER"))
            {
                let dict1 = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "MotherSumInsured")
                
                if(dict1.count>0)
                {
                    if let fatherPremium = dict1[0].value(forKey: "Premium")
                    {
                        
                        if(fatherPremium as! String=="")
                        {
                            m_motherTopupPremium.isHidden=true
                            m_motherPremiumTitleLbl.isHidden=true
                        }
                        else if(fatherPremium as! String=="0")
                        {
                            m_motherTopupPremium.text = "0"
                            m_motherPremiumTitleLbl.text="Premium for Mother"
                            m_totalParentalPremium.isHidden=false
                            m_parentalPremiumTitleLbl.isHidden=false
                            m_parentalPremiumTitleLbl.text="Total Parental Premium"
                            m_motherTopupPremium.isHidden=false
                            m_motherPremiumTitleLbl.isHidden=false
                        }
                        else
                        {
                            m_motherTopupPremium.text = ((fatherPremium as? String)?.currencyInputFormatting())!
                            m_motherPremiumTitleLbl.text="Premium for Mother"
                            //                    let premiumIntValue = NSNumber(m_fatherTopupPremium.text ?? "0")
                            //                    let premiumIntValue1 = NSNumber(m_motherTopupPremium.text ?? "0")
                            //                   let sum = premiumIntValue + premiumIntValue1
                            //                    m_totalParentalPremium.text=String(sum)
                            
                            m_totalParentalPremium.isHidden=false
                            m_parentalPremiumTitleLbl.isHidden=false
                            m_parentalPremiumTitleLbl.text="Total Parental Premium"
                            m_motherTopupPremium.isHidden=false
                            m_motherPremiumTitleLbl.isHidden=false
                        }
                    }
                }
                else
                {
                    m_motherTopupPremium.text = "0"
                    m_motherPremiumTitleLbl.text="Premium for Mother"
                    m_totalParentalPremium.isHidden=false
                    m_parentalPremiumTitleLbl.isHidden=false
                    m_parentalPremiumTitleLbl.text="Total Parental Premium"
                    m_motherTopupPremium.isHidden=false
                    m_motherPremiumTitleLbl.isHidden=false
                }
            }
            else
            {
                m_motherTopupPremium.isHidden=true
                m_motherPremiumTitleLbl.isHidden=true
            }
            
            if(relationArray.contains("FATHER-IN-LAW"))
            {
                let dict2 = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "FatherInLawSumInsured")
                if(dict2.count>0)
                {
                    if let fatherPremium = dict2[0].value(forKey: "Premium")
                    {
                        if(fatherPremium as! String=="")
                        {
                            m_fatherTopupPremium.isHidden=true
                            m_fatherPremiumTitleLbl.isHidden=true
                        }
                        else if(fatherPremium as! String=="0")
                        {
                            m_fatherTopupPremium.text = "0"
                            m_fatherPremiumTitleLbl.text="Premium for FatherInLaw"
                            
                            m_totalParentalPremium.isHidden=false
                            m_parentalPremiumTitleLbl.isHidden=false
                            m_parentalPremiumTitleLbl.text="Total Parental Premium"
                            m_fatherTopupPremium.isHidden=false
                            m_fatherPremiumTitleLbl.isHidden=false
                        }
                        else
                        {
                            m_fatherTopupPremium.text = ((fatherPremium as? String)?.currencyInputFormatting())!
                            m_fatherPremiumTitleLbl.text="Premium for FatherInLaw"
                            
                            m_totalParentalPremium.isHidden=false
                            m_parentalPremiumTitleLbl.isHidden=false
                            m_parentalPremiumTitleLbl.text="Total Parental Premium"
                            m_fatherTopupPremium.isHidden=false
                            m_fatherPremiumTitleLbl.isHidden=false
                        }
                    }
                }
                else
                {
                    m_fatherTopupPremium.text = "0"
                    m_fatherPremiumTitleLbl.text="Premium for FatherInLaw"
                    
                    m_totalParentalPremium.isHidden=false
                    m_parentalPremiumTitleLbl.isHidden=false
                    m_parentalPremiumTitleLbl.text="Total Parental Premium"
                    m_fatherTopupPremium.isHidden=false
                    m_fatherPremiumTitleLbl.isHidden=false
                }
            }
            else
            {
                //                m_fatherTopupPremium.isHidden=true
                //                m_fatherPremiumTitleLbl.isHidden=true
            }
            
            if(relationArray.contains("MOTHER-IN-LAW"))
            {
                let dict3 = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "MotherInLawSumInsured")
                if(dict3.count>0)
                {
                    if let fatherPremium = dict3[0].value(forKey: "Premium")
                    {
                        if(fatherPremium as! String=="")
                        {
                            m_motherTopupPremium.isHidden=true
                            m_motherPremiumTitleLbl.isHidden=true
                        }
                        else if(fatherPremium as! String=="0")
                        {
                            m_motherTopupPremium.text = "0"
                            m_motherPremiumTitleLbl.text="Premium for MotherInLaw"
                            
                            m_totalParentalPremium.isHidden=false
                            m_parentalPremiumTitleLbl.isHidden=false
                            m_parentalPremiumTitleLbl.text="Total Parental Premium"
                            m_motherTopupPremium.isHidden=false
                            m_motherPremiumTitleLbl.isHidden=false
                        }
                        else
                        {
                            m_motherTopupPremium.text = ((fatherPremium as? String)?.currencyInputFormatting())!
                            m_motherPremiumTitleLbl.text="Premium for MotherInLaw"
                            
                            m_totalParentalPremium.isHidden=false
                            m_parentalPremiumTitleLbl.isHidden=false
                            m_parentalPremiumTitleLbl.text="Total Parental Premium"
                            m_motherTopupPremium.isHidden=false
                            m_motherPremiumTitleLbl.isHidden=false
                        }
                        
                    }
                }
                else
                {
                    m_motherTopupPremium.text = "0"
                    m_motherPremiumTitleLbl.text="Premium for MotherInLaw"
                    
                    m_totalParentalPremium.isHidden=false
                    m_parentalPremiumTitleLbl.isHidden=false
                    m_parentalPremiumTitleLbl.text="Total Parental Premium"
                    m_motherTopupPremium.isHidden=false
                    m_motherPremiumTitleLbl.isHidden=false
                }
            }
            else
            {
                //                m_motherTopupPremium.isHidden=true
                //                m_motherPremiumTitleLbl.isHidden=true
            }
            if(m_totalParentalPremium.text=="₹ ")
            {
                m_totalParentalPremium.text="0"
            }
            m_totalParentalPremium.text="0"
        }
        else
        {
            m_totalParentalPremium.isHidden=true
            m_parentalPremiumTitleLbl.isHidden=true
        }
        }
        
        
        //Added By Pranit
        //var relArray = ["MOTHER","FATHER","FATHER-IN-LAW","MOTHER-IN-LAW"]
       // if relationArray.contains("MOTHER") || relationArray.contains("FATHER") || relationArray.contains("MOTHER-IN-LAW") || relationArray.contains("FATHER-IN-LAW") {
            
            if(m_employeedict?.topupoptedflag=="1" || relationArray.contains("MOTHER") || relationArray.contains("FATHER") || relationArray.contains("MOTHER-IN-LAW") || relationArray.contains("FATHER-IN-LAW"))
            {

            m_view3.isHidden = false
            m_view4.isHidden = false
        }
        else {
            m_view3.isHidden = true
            m_view4.isHidden = true
        }
        
        if(array.count>0)
        {
            //if parent is covered and not get top up
            if(array[0].isParentsCovered != "NO" && m_employeedict?.topupoptedflag != "1")
            {
                    m_view3.isHidden = true
                    m_view4.isHidden = true
            }
            else { //If parents is not covered
                if (relationArray.contains("MOTHER") || relationArray.contains("FATHER") || relationArray.contains("MOTHER-IN-LAW") || relationArray.contains("FATHER-IN-LAW") || m_employeedict?.topupoptedflag=="1")
                {
                    m_view3.isHidden = false
                    m_view4.isHidden = false

                }
                else {
                m_view3.isHidden = true
                m_view4.isHidden = true
                }

            }
        }
        
    }
    func setLayout()
    {
        shadowForCell(view: m_view1)
        shadowForCell(view: m_view2)
        shadowForCell(view: m_view3)
        shadowForCell(view: m_view4)
        familyCountLbl.layer.masksToBounds=true
        familyCountLbl.layer.cornerRadius=cornerRadiusForView//8
    }
    
   
    
    
    @IBOutlet weak var m_confirmEnrollmentButton: UIButton!
    @IBAction func confirmEnrollmentBtnClicked(_ sender: Any)
    {
        

        
        
        let date = convertDatetoString(m_windowPeriodEndDate)
        let alert = UIAlertController(title: title, message:"""
Your Enrollment window closes on \(date). You can modify enrollment information before the window closes. After closure of the enrollment window, data submitted by you will be no editable and considered as final.
Do you wish to confirm enrollment?
""", preferredStyle: .alert)
        
        //Edited By Pranit
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Close")
            
            
        }
        
        let acceptAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("OK")
            
            self.confirmEnrollment()
           
            
        }
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    func confirmEnrollment()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: "Please wait...")
            
            
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getconfirmDataPostUrl() as String)
            
            let yourXML = AEXMLDocument()
            
            let sortedPersonDetailsArray=DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:m_productCode, relationName: "EMPLOYEE")
            let employeesrno = String(sortedPersonDetailsArray[0].empSrNo)
            let dataRequest = yourXML.addChild(name: "DataRequest")
            dataRequest.addChild(name: "employeesrno", value: employeesrno)
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
                                
                                self.xmlKey = "DocumentElement"
                                let parser = XMLParser(data: data!)
                                parser.delegate = self as? XMLParserDelegate
                                parser.parse()
                                print(self.resultsDictArray ?? "")
                                
                                DispatchQueue.main.async(execute:
                                    {
                                        if ((self.resultsDictArray?.count)!>0)
                                        {
                                            var userDict = self.resultsDictArray![0] as NSDictionary
                                                print(userDict)
                                            let details:String = userDict.value(forKey: "EnrollmentConfirmInformation") as! String
                                            self.displayActivityAlert(title: details.capitalized )
                                            let status :String = (userDict.value(forKey: "status")as? String)!
                                            if(status=="SUCCESS")
                                            {
                                                self.m_isEnrollmentConfirmed=true
                                                if let nTimesEnrollmentCanBeConfirmed = self.m_enrollmentMiscInformationDict.value(forKey: "NTimesEnrollmentCanBeConfirmed")as? String
                                                {
                                                    if(nTimesEnrollmentCanBeConfirmed == "MULTIPLE")
                                                    {
                                                        self.m_confirmEnrollmentButton.isHidden=false
                                                        
                                                    }
                                                    else
                                                    {
                                                        
                                                        self.m_confirmEnrollmentButton.isHidden=true
                                                      
                                                    }
                                                }
                                                
                                                
                                            }
                                            
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
            tabBarController?.selectedIndex=2
            _ = navigationController?.popToRootViewController(animated: true)
            
        }
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

    func setupProgressBar()
    {
        let progressBar = FlexibleSteppedProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        m_topView.addSubview(progressBar)
        
        progressBar.selectedOuterCircleStrokeColor=UIColor.darkGray
        progressBar.accessibilityElementsHidden=true
        
        let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: m_topView.centerXAnchor)
        
        let verticalConstraint = progressBar.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 20
        )
        let widthC = progressBar.widthAnchor.constraint(greaterThanOrEqualToConstant: m_topView.frame.width-12)
        let heightConstraint = progressBar.heightAnchor.constraint(equalToConstant: 35)
        
        NSLayoutConstraint.activate([widthC,heightConstraint,verticalConstraint,horizontalConstraint])
        //        NSLayoutConstraint.activate([horizontalConstraint!, verticalConstraint!, widthC!, heightConstraint!])
        
        // Customise the progress bar here
        progressBar.numberOfPoints = 2
        progressBar.lineHeight = 3
        progressBar.radius = 25
        progressBar.progressRadius = 0
        progressBar.progressLineHeight = 3
        
        progressBar.currentSelectedCenterColor=hexStringToUIColor(hex: hightlightColor)
        //        progressBar.selectedOuterCircleStrokeColor=hexStringToUIColor(hex: "#1e89ea")
        progressBar.selectedBackgoundColor=hexStringToUIColor(hex: hightlightColor)
        //        progressBar.s
        progressBar.currentIndex=0
        progressBar.delegate = self
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int)
    {
        switch index {
            
        case 0:
            let addDEpendantVC : AddDependantViewController = AddDependantViewController()
            navigationController?.popToViewController(addDEpendantVC, animated: true)
            
            break
            
        case 1:
            
            
            break
            
        case 2:navigationController?.popViewController(animated: true)
            break
        case 3: break
        case 4: break
        default: break
            
        }
    }
    
    private func progressBar(progressBar: FlexibleSteppedProgressBar,
                             willSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String
    {
        progressBar.currentSelectedTextColor=UIColor.blue
        progressBar.centerLayerTextColor=UIColor.white
        
        
        if position == FlexibleSteppedProgressBarTextLocation.center {
            switch index {
                
            case 0: return "1"
            case 1: return "2"
            case 2: return "3"
            case 3: return "4"
            case 4: return "5"
            default: return "Date"
                
            }
        }
        return ""
    }
    

}
