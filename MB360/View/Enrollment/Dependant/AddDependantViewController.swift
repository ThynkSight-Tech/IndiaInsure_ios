//
//  AddDependantViewController.swift
//  MyBenefits
//
//  Created by Semantic on 26/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: range)
        self.attributedText = attribute
    }
}
class AddDependantViewController: UIViewController,FlexibleSteppedProgressBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AddDependantTableViewCellDelegate,XMLParserDelegate{
    
    @IBOutlet weak var addNameInstructionLbl: UILabel!
    
    var m_currentIndex = Int()
    var m_selectedDate = String()
    var m_dateofBirth = String()
    var m_marrigeDate = String()
    var m_isAcceptedConditions = Bool()
    let reuseIdentifier = "Cell"
    var textFields: [SkyFloatingLabelTextField]!
    var dateArray = ["","","","","","","","","","","",""]
    var nameArray = ["","","","","","","","","","","",""]
    var ageArray = ["","","","","","","","","","","",""]
    var dependantsTitleArray : Array<String> = []
    var m_topupPremiumArrays : Array<String> = []
    var m_productCode = String()
    
    var m_isSpouse = Bool()
    var m_isFirstSon = Bool()
    var m_isSecondSon = Bool()
    var m_isFirstDaughter = Bool()
    var m_isSecondDaughter = Bool()
    
    var m_isFather = Bool()
    var m_isFatherinLaw = Bool()
    var m_isMother = Bool()
    var m_isMotherinLaw = Bool()
    var isCrossCombination = String()
    
    var m_numberOfSon : NSNumber = NSNumber(value: 0)
    var m_numberOfDaughter : NSNumber = NSNumber(value: 0)
    
    
    var m_totalRowCount = Int()
    var m_isEditing = Bool()
    var dobTxtFieldTag = Int()
    
    var progressBar = FlexibleSteppedProgressBar()
    var m_employeeDict : EMPLOYEE_INFORMATION?
    var m_enrollmentDict = NSDictionary()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var xmlKey = String()
    var m_isDateOfMarrige = Bool()
    var dictionaryKeys = ["DBOperationMessage","DB_OPERATION_MESSAGE","PERSON_SR_NO","DEPENDANT_RELATION","DEPENDANT_RELATION_ID","DEPENDANT_NAME","DEPENDANT_DOB","DEPENDANT_AGE","PERSON_SR_NO","DataSettings","DependantSettings"]
    
    @IBOutlet weak var m_deleteDaughterbutton: UIButton!
    @IBOutlet weak var m_daughterLbl: UILabel!
    @IBOutlet weak var m_spouseLbl: UILabel!
    var m_dependantArray = Array<DependantDetails>()
    
    @IBOutlet weak var m_addSonButton: UIButton!
    @IBOutlet weak var m_deleteSonButton: UIButton!
    @IBOutlet weak var m_enrollmentSummeryTableview: UITableView!
    
    @IBOutlet weak var m_addDaughterButton: UIButton!
    @IBOutlet weak var m_agreeTermsButton: UIButton!
    @IBOutlet weak var m_selectTopupButton: UIButton!
    @IBOutlet weak var m_addTopupSelectionButton: UIButton!
    @IBOutlet weak var m_countOfDaughterLbl: UILabel!
    @IBOutlet weak var m_countOfSonLbl: UILabel!
    @IBOutlet weak var addDaughterButtonClicked: UIButton!
    
    @IBOutlet weak var m_addFatherButton: UIButton!
    
    @IBOutlet weak var m_addFatherInLawButton: UIButton!
    
    @IBOutlet weak var m_addMotherButton: UIButton!
    
    @IBOutlet weak var m_addMotherInLawButton: UIButton!
    
    @IBOutlet weak var m_sonLbl: UILabel!
    
    @IBOutlet weak var m_addTopUpBackgroundView: UIView!
    @IBOutlet weak var m_dependentInfoButton: UIButton!
    @IBOutlet weak var m_parentsInfoButton: UIButton!
   
   
    @IBOutlet weak var m_selectTopupAmountButton2: UIButton!
    
    @IBOutlet weak var m_topUpScrollView: UIScrollView!
    
    @IBOutlet weak var topUpAmountlbl1: UILabel!
    
    @IBOutlet weak var topupAmountLbl2: UILabel!
    @IBOutlet weak var m_topBar: UIView!
    
    @IBOutlet weak var m_GTLTab: UIButton!
    @IBOutlet weak var m_GPATab: UIButton!
    @IBOutlet weak var m_GMCTab: UIButton!
    @IBOutlet weak var m_GTLShadowView: UIView!
    @IBOutlet weak var m_GPAShadowView: UIView!
    @IBOutlet weak var m_shadowView: UIView!
    
    @IBOutlet weak var m_datePicker: UIDatePicker!
    
    @IBOutlet var m_DOBView: UIView!
    
    @IBOutlet weak var m_DOBPickerSubView: UIView!
    
    @IBOutlet weak var m_topView: UIView!
    
    @IBOutlet weak var m_addDependantTableView: UITableView!
    
    @IBOutlet weak var m_nextButton: UIButton!
    
    @IBOutlet weak var m_addDependantScrollView: UIScrollView!
    
    @IBOutlet weak var m_dependantDetailsBackgroundView: UIView!
    
    @IBOutlet weak var m_parentDetailsBackgroundView: UIView!
    
    @IBAction func dependantInformationButtonClicked(_ sender: Any) {
    }
    
    @IBOutlet weak var m_selectSpouseButton: UIButton!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        m_addDependantTableView.register(AddDependantTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib = UINib (nibName: "AddDependantTableViewCell", bundle: nil)
        m_addDependantTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        m_enrollmentSummeryTableview.register(EnrollmentDetailsSummaryTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib1 = UINib (nibName: "EnrollmentDetailsSummaryTableViewCell", bundle: nil)
        m_enrollmentSummeryTableview.register(nib1, forCellReuseIdentifier: reuseIdentifier)
        m_addDependantTableView.separatorStyle=UITableViewCellSeparatorStyle.none
        m_enrollmentSummeryTableview.separatorStyle=UITableViewCellSeparatorStyle.none

        addNameInstructionLbl.halfTextColorChange(fullText: addNameInstructionLbl.text ?? "", changeText: "First Name & Last Name")
        m_addDependantTableView.keyboardDismissMode = .interactive
        m_addDependantTableView.keyboardDismissMode = .onDrag
        
        m_currentIndex=0
        
        if(isConnectedToNetWithAlert())
        {
            getDataSettingsUrl()
        }
        setupProgressBar()
    }

    func getDataSettingsUrl()
    {
//        let userArray : [OE_GROUP_BASIC_INFORMATION] = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "")
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
        if (userArray.count>0)
        {
            showPleaseWait(msg: "Please wait...")
            m_employeeDict=userArray[0]
        
        var employeesrno = String()
        var groupchildsrno = String()
        var oegrpbasinfsrno = String()
        
            if let childNo = m_employeeDict?.groupChildSrNo
        {
            groupchildsrno = String(childNo)
        }
        if let oeinfNo = m_employeeDict?.oe_group_base_Info_Sr_No
        {
            oegrpbasinfsrno = String(oeinfNo)
        }
        if let empSrno = m_employeeDict?.empSrNo
        {
            employeesrno = String(empSrno)
        }
        
        
        let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEnrollmentDataSettings(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, employeesrno:employeesrno))
        
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
                        {
                            self.xmlKey = "DataSettings"
                            let parser = XMLParser(data: data!)
                            parser.delegate = self as XMLParserDelegate
                            parser.parse()
                            print(self.resultsDictArray ?? "")
                            let status = DatabaseManager.getSharedInstance().deleteDependantDetails()
                            if(status)
                            {
                                for obj in self.resultsDictArray!
                                {
                                    let userDict : NSDictionary = obj as NSDictionary
                               DatabaseManager.sharedInstance.saveDependantDetails(contactDict: userDict)
                                    print(userDict)
                                    
                                }
                                self.m_dependantArray = DatabaseManager.sharedInstance.retrieveDependantDetails()
                                if(self.m_dependantArray.count>0)
                                {
                                    self.setDependantDetails()
                                    
                                }
                                
                            }
                            self.hidePleaseWait()
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
                    self.hidePleaseWait()
                }
                else
                {
                    print("Can't cast response to NSHTTPURLResponse")
                }
                
            }
            
            
        }
        task.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden=false
        
        navigationController?.isNavigationBarHidden=false
       
        m_addDependantTableView.isHidden=true
 
        shadowForCell(view: m_dependantDetailsBackgroundView)
        shadowForCell(view: m_parentDetailsBackgroundView)
        m_nextButton.layer.cornerRadius=m_nextButton.frame.size.height/2
        m_nextButton.layer.masksToBounds=true
        
        setData()
       
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        let dashboard : NewDashboardViewController = NewDashboardViewController()
        navigationController?.popToViewController(dashboard, animated: true)
        tabBarController!.selectedIndex = 2
    }
    func setData()
    {
        self.navigationItem.title="Add Dependant"
        self.navigationItem.leftBarButtonItem=getBackButton()
        
        m_topBar.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        m_dependentInfoButton.layer.masksToBounds=true
    m_dependentInfoButton.layer.cornerRadius=m_dependentInfoButton.frame.size.height/2
        m_dependentInfoButton.layer.borderColor=hexStringToUIColor(hex: hightlightColor).cgColor
        m_dependentInfoButton.layer.borderWidth=1
    m_parentsInfoButton.layer.cornerRadius=m_parentsInfoButton.frame.size.height/2
        m_parentsInfoButton.layer.borderColor=hexStringToUIColor(hex: hightlightColor).cgColor
        m_parentsInfoButton.layer.borderWidth=1
        
        shadowForCell(view: m_addTopUpBackgroundView)
//        m_topView.isHidden=true
        
//        applyEnrollmentValidations()
        
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
                GPATabSelected()
                m_GMCTab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
                m_GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GTL"))
            {
                GTLTabSelected()
                m_GPATab.isUserInteractionEnabled=false
                m_GMCTab.isUserInteractionEnabled=false
                
                m_GPATab.setTitleColor(UIColor.white, for: .normal)
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
            }
            
        }
        else
        {
            GMCTabSeleted()
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView==m_enrollmentSummeryTableview)
        {
            return 5
        }
          return m_dependantArray.count
       
    }
   
    func applyEnrollmentValidations()
    {
      
//        m_enrollmentDict = UserDefaults.standard.value(forKey: "AdminSettingsDic") as! NSDictionary
        print(m_enrollmentDict)
        let windowPeriod :String = m_enrollmentDict.value(forKey: "WINDOW_PERIOD_ACTIVE") as! String
        if(windowPeriod=="0")
        {
           
            m_parentDetailsBackgroundView.isHidden=true
           
        }
        else
        {
            let confirm :String = m_enrollmentDict.value(forKey: "IS_ENROLLMENT_CONFIRMED") as! String
           
            if(confirm=="YES")
            {
               let allowedFreq :String = m_enrollmentDict.value(forKey: "ENRL_CNRFM_ALLOWED_FREQ") as! String
                if(allowedFreq=="-1")
                {
                    
                    isCrossCombination = m_enrollmentDict.value(forKey: "CROSS_COMBINATION_ALLOWED") as! String
                        if(isCrossCombination=="YES")
                        {
                            
                        }
                        else
                        {
                            
                        }
                    
                }
                else
                {
                    
                }
                
            }
            else
            {
                
                isCrossCombination = m_enrollmentDict.value(forKey: "CROSS_COMBINATION_ALLOWED") as! String
                print(isCrossCombination)
                    if(isCrossCombination=="YES")
                    {
                        
                    }
                
            }
            
        }
       
       
        
    }
    func setDependantDetails()
    {
        DispatchQueue.main.async
        {
             print(self.m_dependantArray)
        for i in 0..<self.m_dependantArray.count
        {
            if(self.m_dependantArray[i].dependantRelation=="Spouse/Partner")
            {
                self.m_isSpouse=true
                self.m_selectSpouseButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                self.nameArray[i]=self.m_dependantArray[i].name!
                self.dateArray[i]=self.m_dependantArray[i].dob!
                self.ageArray[i]=self.m_dependantArray[i].age!
                let relation = self.m_dependantArray[i].dependantRelation!
                
            }
            if(self.m_dependantArray[i].dependantRelation=="Spouse")
            {
                self.m_isSpouse=true
//                self.m_selectSpouseButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                
                self.m_spouseLbl.isHidden=true
                self.m_selectSpouseButton.isHidden=true
                self.nameArray[i]=self.m_dependantArray[i].name!
                self.dateArray[i]=self.m_dependantArray[i].dob!
                self.ageArray[i]=self.m_dependantArray[i].age!
            }
            if(self.m_dependantArray[i].dependantRelation=="Son")
            {
                print(self.m_numberOfSon.intValue)
                if(self.m_numberOfSon.intValue<2)
                {
                    self.m_numberOfSon = NSNumber(integerLiteral: self.m_numberOfSon.intValue+1)
                    
                }
                else 
                {
                   
                        self.m_sonLbl.textColor=UIColor.lightGray
                        self.m_addSonButton.isUserInteractionEnabled=false
                        self.m_deleteSonButton.isUserInteractionEnabled=false
                        self.m_addSonButton.setTitleColor(UIColor.lightGray, for: .normal)
                        self.m_deleteSonButton.setTitleColor(UIColor.lightGray, for: .normal)
                }
                self.m_countOfSonLbl.text=self.m_numberOfSon.stringValue
                self.m_isFirstSon=true
                if(self.m_numberOfSon.intValue>1)
                {
                    self.m_isSecondSon=true
                }
                self.nameArray[i]=self.m_dependantArray[i].name!
                self.dateArray[i]=self.m_dependantArray[i].dob!
                self.ageArray[i]=self.m_dependantArray[i].age!
                print(self.nameArray)
            }
            if(self.m_dependantArray[i].dependantRelation=="Daughter")
            {
                
                self.m_isFirstDaughter=true
                if(self.m_numberOfDaughter.intValue<2)
                {
                    self.m_numberOfDaughter = NSNumber(integerLiteral: self.m_numberOfDaughter.intValue+1)
                }
                else
                {
                    
                }
                self.m_countOfDaughterLbl.text=self.m_numberOfDaughter.stringValue
                if(self.m_numberOfDaughter.intValue>1)
                {
                    self.m_isSecondDaughter=true
                }
                self.nameArray[i]=self.m_dependantArray[i].name!
                self.dateArray[i]=self.m_dependantArray[i].dob!
                self.ageArray[i]=self.m_dependantArray[i].age!
            }
            if(self.m_dependantArray[i].dependantRelation=="Father")
            {
                self.m_isFather=true
                self.m_addFatherButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                self.nameArray[i]=self.m_dependantArray[i].name!
                self.dateArray[i]=self.m_dependantArray[i].dob!
                self.ageArray[i]=self.m_dependantArray[i].age!
            }
            if(self.m_dependantArray[i].dependantRelation=="Mother")
            {
                self.m_isMother=true
                self.m_addMotherButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                self.nameArray[i]=self.m_dependantArray[i].name!
                self.dateArray[i]=self.m_dependantArray[i].dob!
                self.ageArray[i]=self.m_dependantArray[i].age!
            }
            if(self.m_dependantArray[i].dependantRelation=="Father-In-Law")
            {
                self.m_isFatherinLaw=true
                self.m_addFatherInLawButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                self.nameArray[i]=self.m_dependantArray[i].name!
                self.dateArray[i]=self.m_dependantArray[i].dob!
                self.ageArray[i]=self.m_dependantArray[i].age!
            }
            if(self.m_dependantArray[i].dependantRelation=="Mother-In-Law")
            {
                self.m_isMotherinLaw=true
                self.m_addMotherInLawButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                self.nameArray[i]=self.m_dependantArray[i].name!
                self.dateArray[i]=self.m_dependantArray[i].dob!
                self.ageArray[i]=self.m_dependantArray[i].age!
            }
            
        }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if(tableView==m_enrollmentSummeryTableview)
        {
            let cell : EnrollmentDetailsSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)as! EnrollmentDetailsSummaryTableViewCell
            
            shadowForCell(view: cell.m_titleBackgroundView)
            shadowForCell(view: cell.m_backgroundView)
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            
            switch indexPath.row
            {
            case 0:
                cell.m_countLbl.isHidden=false
                cell.m_countLbl.layer.masksToBounds=false
            cell.m_countLbl.layer.cornerRadius=cell.m_countLbl.layer.cornerRadius/2
                cell.m_titleLbl.text = "Family Definition"
                cell.m_countLbl.text = "1 + "+String(m_totalRowCount)
                cell.m_imageview.image = #imageLiteral(resourceName: "family")
                cell.m_title1Lbl.text="self"
                if(dependantsTitleArray.count>0)
                {
                    cell.m_title2Lbl.text=dependantsTitleArray[0]
                }
                
                break;
            case 1:
                cell.m_countLbl.isHidden=true
                cell.m_titleLbl.text = "Parental Coverage"
                cell.m_imageview.image = #imageLiteral(resourceName: "family")
                break;
            case 2:
                cell.m_countLbl.isHidden=true
                cell.m_titleLbl.text = "Sum Insured Breakup"
                cell.m_imageview.image = #imageLiteral(resourceName: "SumInsured")
                break;
            case 3:
                cell.m_countLbl.isHidden=true
                cell.m_titleLbl.text = "Premium Payable"
                cell.m_imageview.image = #imageLiteral(resourceName: "rupee-1")
                break;
            case 4:
                cell.m_countLbl.isHidden=true
                cell.m_titleLbl.text = "Installment Details"
                cell.m_imageview.image = #imageLiteral(resourceName: "rupee-1")
                break;
            default :
                    break;
                
            }
            
            return cell
        }
        else
        {
            let cell : AddDependantTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AddDependantTableViewCell
            shadowForCell(view: cell.m_backGroundView)
            
            cell.tag=indexPath.row
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            cell.delegate=self
            cell.m_dateOfMarrigeTxtField.delegate=self
            
            /* if(nameArray[indexPath.row]=="")
             {
                cell.m_editButton.isHidden=true
                cell.m_saveButton.isHidden=false
             }
             else
             {

                cell.m_editButton.isHidden=false
                cell.m_saveButton.isHidden=true
             }*/
            
            cell.m_saveButton.tag=indexPath.row
            
            
            if(nameArray[indexPath.row]=="" || m_dependantArray[indexPath.row].personSrNo=="")
            {
                editDetailsLayout(cell: cell)
               
            }
            else
            {
                
                
                if(cell.isEdit || m_dependantArray[indexPath.row].personSrNo=="")
                {
                    
                    editDetailsLayout(cell: cell)
                }
                else
                {
                    
                    cell.m_nameTextField.isUserInteractionEnabled=false
                    cell.m_dobTextField.isUserInteractionEnabled=false
                    cell.m_ageTextField.isUserInteractionEnabled=false
                    cell.m_dateOfMarrigeTxtField.isUserInteractionEnabled=false
                    cell.m_editButton.isHidden=false
                    cell.m_saveButton.isHidden=true
                    
                    
                }
                print(m_dependantArray.count,indexPath.row)
                if(cell.isEdit || nameArray[indexPath.row]=="" || indexPath.row == m_dependantArray.count)
                {
                    
                    editDetailsLayout(cell: cell)
                }
                else
                {
                    
                    cell.m_nameTextField.isUserInteractionEnabled=false
                    cell.m_dobTextField.isUserInteractionEnabled=false
                    cell.m_ageTextField.isUserInteractionEnabled=false
                    cell.m_dateOfMarrigeTxtField.isUserInteractionEnabled=false
                    cell.m_editButton.isHidden=false
                    cell.m_saveButton.isHidden=true
                    
                    
                }
                
                
            }
           
           
//            cell.m_nameTextField.textRect(forBounds: <#T##CGRect#>)
            
            
            cell.m_deleteButton.tag=indexPath.row
            
            textFields = [cell.m_nameTextField,cell.m_dobTextField,cell.m_ageTextField,cell.m_dateOfMarrigeTxtField]
            setupField(textField: cell.m_nameTextField, with: "Name")
            setupField(textField: cell.m_dobTextField, with: "DOB")
            setupField(textField: cell.m_ageTextField, with: "Age")
            setupField(textField: cell.m_dateOfMarrigeTxtField, with: "Date of Marrige")
            
            cell.m_nameTextField.tag=indexPath.row
            cell.m_dobTextField.tag=indexPath.row
            cell.m_ageTextField.tag=indexPath.row
            cell.m_dateOfMarrigeTxtField.tag=indexPath.row
            
            print(dateArray)
           /* if(m_dependantArray.count <= dependantsTitleArray.count && m_dependantArray.count>0)
            {
                
                print(dependantsTitleArray[indexPath.row],m_dependantArray[indexPath.row].dependantRelation!+" Details")
                if(dependantsTitleArray[indexPath.row]==(m_dependantArray[indexPath.row].dependantRelation!+" Details"))
                    {
                       
                cell.m_titleLbl.text=m_dependantArray[indexPath.row].dependantRelation!+" Details"
                        nameArray[indexPath.row]=m_dependantArray[indexPath.row].name!
                    }
                    else
                    {
                        cell.m_titleLbl.text=dependantsTitleArray[indexPath.row]
                        nameArray[indexPath.row]=""
                    }
                
            }
            else
            {
                cell.m_titleLbl.text=dependantsTitleArray[indexPath.row]
            }*/
            
            
            if let relation = m_dependantArray[indexPath.row].dependantRelation
            {
                cell.m_titleLbl.text=relation+" Details"
            }
            
            cell.m_nameTextField.text = nameArray[indexPath.row]
            cell.m_dobTextField.text = dateArray[indexPath.row]
            cell.m_ageTextField.text = ageArray[indexPath.row]
            cell.m_dateOfMarrigeTxtField.text = m_marrigeDate
           print(cell.m_nameTextField.text,nameArray)
            cell.m_conditionsView.isHidden=true
            if((m_isFather || m_isMother || m_isFatherinLaw || m_isMotherinLaw) && (indexPath.row == m_totalRowCount-1))
            {
                
//                if(ageArray[indexPath.row]>99)
//                {
//                    cell.m_dobTextField.errorMessage=Parent\'s max age is 100 years
//                }
                
                cell.m_conditionsView.isHidden=false
//                let premium : String = m_enrollmentDict.value(forKey: "PARENTAL_PREMIUM") as! String
//                cell.m_parentalPremiumAmountLbl.text = "Rs."+premium+" Amount will be deducted from your salary towards parental premium"
                cell.m_acceptConditionsButton.tag=indexPath.row
                cell.m_acceptConditionsButton.addTarget(self, action: #selector(acceptConditionButtonClicked), for: .touchUpInside)
            }
            if(cell.m_titleLbl.text=="Spouse Details")
            {
                
                let windowPeriod :String = m_enrollmentDict.value(forKey: "WINDOW_PERIOD_ACTIVE") as? String ?? ""
                if(windowPeriod=="0")
                {
                
                   
                    cell.m_dateOfMarrigeTxtField.isHidden=false
                
                }
                else
                {
                    cell.m_dateOfMarrigeTxtField.isHidden=true
                }
            }
            else
            {
                cell.m_dateOfMarrigeTxtField.isHidden=true
            }
            
           /* if(indexPath.section==0)
            {
                switch indexPath.row
                {
                case 0:
                    cell.m_dateOfMarrigeTxtField.isHidden=false
                    if(m_isSpouse)
                    {
                        cell.m_titleLbl.text="Spouse Details"
                        
                    }
                    else if(m_isFirstSon)
                    {
                        cell.m_titleLbl.text="Son Details"
                    }
                    else if(m_isFirstDaughter)
                    {
                        cell.m_titleLbl.text="Daughter Details"
                    }
                    break
                case 1:
                    cell.m_dateOfMarrigeTxtField.isHidden=true
                    if(m_isSpouse && m_isFirstSon)
                    {
                        cell.m_titleLbl.text="Son Details"
                    }
                    else if(m_isSecondSon)
                    {
                        cell.m_titleLbl.text="Son Details"
                    }
                    else if(m_isSpouse && m_isFirstDaughter)
                    {
                        cell.m_titleLbl.text="Daughter Details"
                    }
                    else if(m_isFirstDaughter)
                    {
                        cell.m_titleLbl.text="Daughter Details"
                    }
                    break
                case 2:
                    cell.m_dateOfMarrigeTxtField.isHidden=true
                    if(m_isSecondSon && m_isSpouse)
                    {
                        cell.m_titleLbl.text="Son Details"
                    }
                    else if(m_isSecondDaughter && m_isSpouse)
                    {
                        cell.m_titleLbl.text="Daughter Details"
                    }
                    else if(m_isFirstDaughter && m_isFirstSon && m_isSpouse)
                    {
                        cell.m_titleLbl.text="Daughter Details"
                    }
                    break
                default:
                    break
                }
                
                cell.m_editButton.setImage(#imageLiteral(resourceName: "icEdit"), for: .normal)
                cell.m_editButton.tag=indexPath.row
                cell.m_deleteButton.tag=indexPath.row
               
                cell.m_nameTextField.text = nameArray[indexPath.row]
                cell.m_dobTextField.text = dateArray[indexPath.row]
                cell.m_ageTextField.text = ageArray[indexPath.row]
                cell.m_dateOfMarrigeTxtField.text = m_marrigeDate
                
                
            }
            else
            {
                switch indexPath.row
                {
                case 0:
                    cell.m_dateOfMarrigeTxtField.isHidden=true
                    if(m_isFather)
                    {
                        cell.m_titleLbl.text="Father Details"
                    }
                    else if(m_isFatherinLaw)
                    {
                        cell.m_titleLbl.text="FatherinLaw Details"
                    }
                    else if(m_isMother)
                    {
                        cell.m_titleLbl.text="Mother Details"
                    }
                    else if(m_isMotherinLaw)
                    {
                        cell.m_titleLbl.text="MotherinLaw Details"
                    }
                    break
                case 1:
                    cell.m_dateOfMarrigeTxtField.isHidden=true
                    if(m_isFather && m_isMother)
                    {
                        cell.m_titleLbl.text="Mother Details"
                    }
                    else if(m_isFatherinLaw && m_isMotherinLaw)
                    {
                        cell.m_titleLbl.text="MotherinLaw Details"
                    }
                    else if(m_isFather && m_isMotherinLaw)
                    {
                        cell.m_titleLbl.text="MotherinLaw Details"
                    }
                    else if(m_isFatherinLaw && m_isMother)
                    {
                        cell.m_titleLbl.text="Mother Details"
                    }
                    
                    break
                    
                default:
                    break
                }
                
                
                
            }*/
            
            
           
            
            return cell
        }
        
    }
    func editDetailsLayout(cell:AddDependantTableViewCell)
    {
        cell.m_nameTextField.isUserInteractionEnabled=true
        cell.m_dobTextField.isUserInteractionEnabled=true
        cell.m_ageTextField.isUserInteractionEnabled=true
        cell.m_dateOfMarrigeTxtField.isUserInteractionEnabled=true
        cell.m_saveButton.isHidden=false
        cell.m_editButton.isHidden=true
        
    }
    @objc func acceptConditionButtonClicked(sender : UIButton)
    {
        let index = IndexPath(row: sender.tag, section: 0)
        let cell : AddDependantTableViewCell = m_addDependantTableView.cellForRow(at: index) as! AddDependantTableViewCell
        if(cell.m_acceptConditionsButton.currentImage==#imageLiteral(resourceName: "checked"))
        {
            m_isAcceptedConditions = false
            cell.m_acceptConditionsButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        else
        {
            m_isAcceptedConditions = true
            cell.m_acceptConditionsButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(tableView==m_enrollmentSummeryTableview)
        {
            
            return UITableViewAutomaticDimension
          
        }
        else
        {
            if(indexPath.row==0)
            {
                return 270
            }
            else if((m_isFather || m_isMother || m_isFatherinLaw || m_isMotherinLaw) && (indexPath.row == m_totalRowCount-1))
            {
                return UITableViewAutomaticDimension
            }
            else
            {
                return 270
            }
        }
        
    }
    func setupProgressBar()
    {
        progressBar = FlexibleSteppedProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        m_topView.addSubview(progressBar)
        
        progressBar.selectedOuterCircleStrokeColor=UIColor.clear
        progressBar.accessibilityElementsHidden=true
        
        let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: m_topView.centerXAnchor)
        
        let verticalConstraint = progressBar.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 20
        )
        let widthC = progressBar.widthAnchor.constraint(greaterThanOrEqualToConstant: m_topView.frame.width+20)
        let heightConstraint = progressBar.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([widthC,heightConstraint,verticalConstraint,horizontalConstraint])
        
//        NSLayoutConstraint.activate([horizontalConstraint!, verticalConstraint!, widthC!, heightConstraint!])
        
        // Customise the progress bar here
      /*  let isTopUpAvailable:String = m_enrollmentDict.value(forKey: "IS_TOPUP_OPTION_AVAILABLE")as! String
        if(isTopUpAvailable=="NO")
        {
            progressBar.numberOfPoints = 2
        }
        else
        {
            progressBar.numberOfPoints = 3
        }*/
        progressBar.numberOfPoints = 3
        progressBar.lineHeight = 3
        progressBar.radius = 20
        progressBar.progressRadius = 0
        progressBar.progressLineHeight = 3
       
        
        progressBar.currentSelectedCenterColor=hexStringToUIColor(hex: hightlightColor)
        //        progressBar.selectedOuterCircleStrokeColor=hexStringToUIColor(hex: "#1e89ea")
        progressBar.selectedBackgoundColor=hexStringToUIColor(hex: hightlightColor)
        //        progressBar.s
        progressBar.currentIndex=1
        progressBar.delegate = self
    
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int)
    {
        switch index
        {

        case 0:
            progressBar.currentIndex=0
            navigationController?.popViewController(animated: true)
        case 1:
          
            m_addDependantTableView.isHidden=true
            m_addDependantScrollView.isHidden=false
            m_topUpScrollView.isHidden=true
            m_enrollmentSummeryTableview.isHidden=true
            progressBar.removeFromSuperview()
            m_topView.isHidden=true
            m_currentIndex=1
            m_nextButton.setTitle("Next".localized(), for: .normal)
           break
      
        case 1:
            
            if(!m_isAcceptedConditions && (m_isMotherinLaw || m_isFatherinLaw || m_isFather || m_isMother))
            {
                m_currentIndex=0
                progressBar.currentIndex=0
                alertMessage(msg: "Please accept the terms and conditions")
                
            }
            else
            {
                let isTopUpAvailable:String = m_enrollmentDict.value(forKey: "IS_TOPUP_OPTION_AVAILABLE")as? String ?? " "
                if(isTopUpAvailable=="NO")
                {
                    m_addDependantTableView.isHidden=true
                    m_addDependantScrollView.isHidden=true
                    m_topUpScrollView.isHidden=true
                    m_enrollmentSummeryTableview.isHidden=false
                    m_currentIndex=2
                    progressBar.currentIndex=1
                    m_nextButton.setTitle("confirmEnrollment".localized(), for: .normal)
                    
                }
                else
                {
                    
                    
                    m_addDependantTableView.isHidden=true
                    m_addDependantScrollView.isHidden=true
                    m_topUpScrollView.isHidden=false
                    m_enrollmentSummeryTableview.isHidden=true
                    m_currentIndex=2
                    print(m_currentIndex)
                    progressBar.currentIndex=1
                    let topupPremiums:String = m_enrollmentDict.value(forKey: "TOPUP_OPTIONS")as? String ?? " "
                    
                    
                    var topupPremiumArray = topupPremiums.components(separatedBy: ",")
                    if (topupPremiumArray.count>0)
                    {
                        topUpAmountlbl1.text=topupPremiumArray[0]
                    }
                    else
                    {
                        topUpAmountlbl1.isHidden=true
                    }
                    if(topupPremiumArray.count>1)
                    {
                        topupAmountLbl2.text=topupPremiumArray[1]
                    }
                    else
                    {
                        topupAmountLbl2.isHidden=true
                    }
                }
            
            }
            
            break
        
        case 2:
           
            if(m_totalRowCount==0)
            {
                m_addDependantTableView.isHidden=true
                m_addDependantScrollView.isHidden=true
                m_topUpScrollView.isHidden=true
                m_enrollmentSummeryTableview.isHidden=false
                m_enrollmentSummeryTableview.reloadData()
                
                progressBar.currentIndex=2
                m_currentIndex=2
            }
            else if(m_agreeTermsButton.currentImage==#imageLiteral(resourceName: "checked") && m_addTopupSelectionButton.currentImage==#imageLiteral(resourceName: "checked") )
            {
                m_addDependantTableView.isHidden=true
                m_addDependantScrollView.isHidden=true
                m_topUpScrollView.isHidden=true
                m_enrollmentSummeryTableview.isHidden=false
                m_enrollmentSummeryTableview.reloadData()
                
                progressBar.currentIndex=2
                m_currentIndex=2
                 m_nextButton.setTitle("confirmEnrollment".localized(), for: .normal)
            }
            else
            {
                alertMessage(msg: "Please accept the terms and conditions")
                progressBar.currentIndex=1
            }
            
            break
       
        default: break
            
        }
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
        
        
        if position == FlexibleSteppedProgressBarTextLocation.center
        {
            switch index
            {
                
            case 0: return "1"
            case 1: return "2"
            case 2: return "3"
            
            default: return ""
                
            }
        }
        return ""
    }
    
    @IBAction func nextButtonClicked(_ sender: Any)
    {
        m_topView.isHidden=false
        setupProgressBar()
        print(m_currentIndex)
        let rowCount = (m_numberOfDaughter.intValue + m_numberOfSon.intValue+Int(truncating: NSNumber(value: m_isSpouse)))
        
        let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
        
        m_totalRowCount = rowCount+rowCountforParents
       
        if(m_currentIndex==0 && m_totalRowCount>0)
        {
            m_addDependantScrollView.isHidden=true
            m_addDependantTableView.isHidden=false
            addNameInstructionLbl.isHidden=false
            m_currentIndex=1
            switch m_numberOfSon
            {
            case 0 :
                m_isFirstSon = false
                m_isSecondSon = false
                break
            case 1 :
                m_isFirstSon = true
                m_isSecondSon = false
                break
            case 2 :
                m_isFirstSon = true
                m_isSecondSon = true
                break
            default:
                break
            }
            switch m_numberOfDaughter
            {
            case 0 :
                m_isFirstDaughter = false
                m_isSecondDaughter = false
                break
            case 1 :
                m_isFirstDaughter = true
                m_isSecondDaughter = false
                break
            case 2 :
                m_isFirstDaughter = true
                m_isSecondDaughter = true
                break
                
            default:
                break
            }
            
            m_dependantArray=DatabaseManager.sharedInstance.retrieveDependantDetails()
            m_nextButton.setTitle("NEXT", for: .normal)
            m_addDependantTableView.reloadData()
          /*  if(m_isSpouse)
            {
                dependantsTitleArray.append("Spouse Details")
            }
            if(m_isFirstSon)
            {
                dependantsTitleArray.append("Son Details")
            }
            if(m_isSecondSon)
            {
                dependantsTitleArray.append("Son Details")
            }
            if(m_isFirstDaughter)
            {
                dependantsTitleArray.append("Daughter Details")
            }
            if(m_isSecondDaughter)
            {
                dependantsTitleArray.append("Daughter Details")
            }
            if(m_isFather)
            {
                dependantsTitleArray.append("Father Details")
            }
            if(m_isMother)
            {
                dependantsTitleArray.append("Mother Details")
            }
            if(m_isFatherinLaw)
            {
                dependantsTitleArray.append("FatherinLaw Details")
            }
            if(m_isMotherinLaw)
            {
                dependantsTitleArray.append("MotherinLaw Details")
            }
           */
            
  
        }
        else if(m_currentIndex==1)
        {
            
            progressBar(progressBar, didSelectItemAtIndex: 1)
            m_nextButton.setTitle("NEXT", for: .normal)
            addNameInstructionLbl.isHidden=true
            
            
        }
        else
        {
            addNameInstructionLbl.isHidden=true
            m_nextButton.setTitle("NEXT", for: .normal)
            let isTopUpAvailable:String = m_enrollmentDict.value(forKey: "IS_TOPUP_OPTION_AVAILABLE")as? String ?? " "
            if(isTopUpAvailable=="NO")
            {
                
                progressBar(progressBar, didSelectItemAtIndex: 1)
                
            }
            else
            {
                progressBar(progressBar, didSelectItemAtIndex: 2)
                
            }
        }
    }
    
    func setupField(textField:SkyFloatingLabelTextField,with placeholder:String)
    {
        
        textField.delegate = self
        
        // plane icon as per https://fortawesome.github.io/Font-Awesome/cheatsheet/
        textField.placeholder = NSLocalizedString(
            placeholder,
            tableName: "SkyFloatingLabelTextField",
            comment: ""
        )
        textField.selectedTitle = NSLocalizedString(
            placeholder,
            tableName: "SkyFloatingLabelTextField",
            comment: ""
        )
        textField.title = NSLocalizedString(
            placeholder,
            tableName: "SkyFloatingLabelTextField",
            comment: ""
        )
        applySkyscannerTheme(textField: textField)
    
    }
    func applySkyscannerTheme(textField: SkyFloatingLabelTextField)
    {
        
        textField.tintColor = hexStringToUIColor(hex: hightlightColor)
        
//        textField.setBorderToView(color: UIColor.lightGray)
        
        
        
            

        textField.lineView .isHidden = false
        textField.selectedTitleColor = hexStringToUIColor(hex: hightlightColor)
        textField.selectedLineColor = hexStringToUIColor(hex: hightlightColor)
        //        SanFranciscoText-Regular 19.0
        // Set custom fonts for the title, placeholder and textfield labels
        textField.titleLabel.font = UIFont(name: "Poppins-Regular", size: 14)
        textField.titleLabel.adjustsFontSizeToFitWidth = true
        textField.placeholderFont = UIFont(name: "Poppins-Light", size: 14)
        textField.font = UIFont(name: "Poppins-Regular", size: 14)
        
        
    }
    
    // MARK: - validation
    
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
        m_addDependantTableView.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
//        let indexpath = IndexPath(row: dobTxtFieldTag, section: 0)
//        let cell : AddDependantTableViewCell = m_addDependantTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexpath)as! AddDependantTableViewCell
//        cell.isEdit=true
        
        
        if(textField.placeholder=="Date of Birth")
        {
            view.endEditing(true)
            dobTxtFieldTag = textField.tag
            textField.resignFirstResponder()
            m_isDateOfMarrige=false
            selectDate(textfield:textField)
            
        }
        else if(textField.placeholder=="Date of Marrige")
        {
            view.endEditing(true)
            m_isDateOfMarrige=true
            selectDate(textfield: textField)
        }
        animateTextField(textField, with: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
//        textField.setBorderToView(color: UIColor.white)
        if(textField.placeholder=="Name")
        {
            let MAX_LENGTH_PHONENUMBER = 20
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS)
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        else if(textField.placeholder=="Age")
        {
            let MAX_LENGTH_PHONENUMBER = 2
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if(textField.placeholder=="Name")
        {
            nameArray[textField.tag]=textField.text!
            animateTextField(textField, with: false)
        }
        else if(textField.placeholder=="Age")
        {
            ageArray[textField.tag]=textField.text!
            animateTextField(textField, with: false)
        }
        else if(textField.placeholder=="Date of Birth")
        {
            
        }
        else
        {
            view.endEditing(true)
        }
//        textField.setBorderToView(color: UIColor.white)
        
        
    }
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
    
    func selectDate(textfield:UITextField)
    {
        
        _ = Bundle.main.loadNibNamed("DatePicker", owner: self, options: nil)?[0];
        m_DOBView.frame=view.frame
        view.addSubview(m_DOBView)
        addBordersToComponents()
        
        let windowPeriod :String = m_enrollmentDict.value(forKey: "WINDOW_PERIOD_ACTIVE") as! String
        if(windowPeriod=="0")
        {
            let lifeEvent : NSString = m_enrollmentDict.value(forKey: "LIFE_EVENT_DOM") as! NSString
            m_datePicker.maximumDate=Date()
        
            if(textfield.tag==0)
            {
                if(textfield.placeholder=="Date of Marrige")
                {
                    let minimumDate = Calendar.current.date(byAdding: .day, value: Int(-lifeEvent.intValue), to: Date())
                    m_datePicker.minimumDate=minimumDate
                }
            }
            else
            {
                let minimumDate = Calendar.current.date(byAdding: .day, value: Int(-lifeEvent.intValue), to: Date())
                m_datePicker.minimumDate=minimumDate
            }
           
        }
        else
        {
            let maxAge : NSString = m_enrollmentDict.value(forKey: "DAUGHTER_MAXAGE") as! NSString
            if(textfield.tag==0)
            {
                
            }
            else
            {
                let minimumDate = Calendar.current.date(byAdding: .year, value: Int(-maxAge.intValue), to: Date())
                m_datePicker.minimumDate=minimumDate
            }
        }
        
    }
    @IBAction func dateCancelButtonClicked(_ sender: Any)
    {
         hideDatePickerView()
       
    }
    @IBAction func dateDoneButtonClicked(_ sender: UIButton)
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd~MM~yyyy"
        let selectedDate = formatter.string(from: m_datePicker.date)
        if(selectedDate=="")
        {
            m_selectedDate = "00/00/0000"
            
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
        }
        else
        {
            m_dateofBirth = dateString;
            print(dobTxtFieldTag)
            dateArray[dobTxtFieldTag]=dateString
            print(dateArray)
            let gregorian = Calendar(identifier: .gregorian)
            let ageComponents = gregorian.dateComponents([.year], from: m_datePicker.date, to: Date())
            let age = ageComponents.year!
            print(age)
            ageArray[dobTxtFieldTag]=String(age)
            
        }
        
        view.endEditing(true)
        
        
//        m_addDependantTableView.beginUpdates()
//        m_addDependantTableView.reloadRows(at: [indexpath], with: .automatic)
//        m_addDependantTableView.endUpdates()
        m_addDependantTableView.reloadData()
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
    
    @IBAction func selectSpouseButtonClicked(_ sender: Any)
    {
       if(m_isSpouse)
       {
            m_selectSpouseButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_isSpouse = false
        }
        else
       {
            m_isSpouse = true
            m_selectSpouseButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
       
            addDependantsinDatabase(relation: "Spouse")
       
        }
    }
    
    
   
    
   
    
    @IBAction func parentDetailsInfoButtonClicked(_ sender: Any) {
    }
    
    @IBAction func selectFatherButtonClicked(_ sender: Any)
    {
         let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
        print(rowCountforParents)
        
        if(m_isFather)
        {
            m_addFatherButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_isFather=false
            DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: "Father")
        }
        else if(isCrossCombination=="No" && (m_isMotherinLaw || m_isFatherinLaw))
        {
            alertMessage(msg: "Cross combination not allowed")
        }
        else if(rowCountforParents>=2)
        {
            alertMessage(msg: "You can add only two parents")
        }
        else
        {
            m_isFather = true
            m_addFatherButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
             addDependantsinDatabase(relation: "Father")
            
        }
        
    }
    
    @IBAction func selectFatherinLawButtonClicked(_ sender: Any)
    {
       
        let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
        print(rowCountforParents)
        if(m_isFatherinLaw)
        {
            m_addFatherInLawButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_isFatherinLaw=false
            DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: "Father-In-Law")
        }
        else if((isCrossCombination=="No") && (m_isMother || m_isFather))
        {
            alertMessage(msg: "Cross combination not allowed")
        }
        else if(rowCountforParents>=2)
        {
            alertMessage(msg: "You can add only two parents")
        }
        else
        {
            m_isFatherinLaw = true
            m_addFatherInLawButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
             addDependantsinDatabase(relation: "Father-In-Law")
        }
        
    }
    
    @IBAction func selectMotherButtonClicked(_ sender: Any)
    {
         let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
        if(m_isMother)
        {
            m_addMotherButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_isMother=false
            DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: "Mother")
        }
        else if((isCrossCombination=="No") && (m_isFatherinLaw || m_isMotherinLaw))
        {
            alertMessage(msg: "Cross combination not allowed")
        }
        else if(rowCountforParents>=2)
        {
            alertMessage(msg: "You can add only two parents")
        }
        else
        {
            m_isMother = true
            m_addMotherButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            addDependantsinDatabase(relation: "Mother")
        }
        
       
    }
    
    @IBAction func selectMotherinLawButtonClicked(_ sender: Any)
    {
         let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
        if(m_isMotherinLaw)
        {
            m_addMotherInLawButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_isMotherinLaw=false
            DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: "Mother-In-Law")
        }
        else if((isCrossCombination=="No") && (m_isFather || m_isMother))
        {
            alertMessage(msg: "Cross combination not allowed")
        }
        else if(rowCountforParents>=2)
        {
            alertMessage(msg: "You can add only two parents")
        }
        else
        {
            m_isMotherinLaw = true
            m_addMotherInLawButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            addDependantsinDatabase(relation: "Mother-In-Law")
        }
        
    }
    
    @IBAction func addSonButtonClicked(_ sender: Any)
    {
        if(m_numberOfSon.intValue<2 && m_numberOfDaughter.intValue<2)
        {
            if(m_numberOfDaughter.intValue==1 && m_numberOfSon.intValue==1)
            {
                alertMessage(msg: "You cannot add more than two children")
            }
            else
            {
                m_numberOfSon = NSNumber(integerLiteral: m_numberOfSon.intValue+1)
                m_countOfSonLbl.text = m_numberOfSon.stringValue
                addDependantsinDatabase(relation: "Son")
            }
        }
        else
        {
            alertMessage(msg: "You cannot add more than two children")
        }
    }
    @IBAction func substractSonButtonClicked(_ sender: Any)
    {
        if (m_numberOfSon.intValue>0)
        {
            m_numberOfSon = NSNumber(integerLiteral: m_numberOfSon.intValue-1)
            m_countOfSonLbl.text = m_numberOfSon.stringValue
            DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: "Son")
        }
    }
    @IBAction func addDaughterButtonClicked(_ sender: Any)
    {
        print(m_numberOfSon.intValue)
        if(m_numberOfDaughter.intValue<2 && m_numberOfSon.intValue<2)
        {
            if(m_numberOfDaughter.intValue==1 && m_numberOfSon.intValue==1)
            {
                alertMessage(msg: "You cannot add more than two childen")

                
            }
            else
            {
               m_numberOfDaughter = NSNumber(integerLiteral: m_numberOfDaughter.intValue+1)
                addDependantsinDatabase(relation: "Daughter")
            }
            
            m_countOfDaughterLbl.text = m_numberOfDaughter.stringValue
        }
        else
        {
            alertMessage(msg: "You cannot add more than two children")
        }
    }
    @IBAction func substractDaughterButtonClicked(_ sender: Any)
    {
        if(m_numberOfDaughter.intValue>0)
        {
            m_numberOfDaughter = NSNumber(integerLiteral: m_numberOfDaughter.intValue-1)
            m_countOfDaughterLbl.text = m_numberOfDaughter.stringValue
            DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: "Daughter")
        }
    }
    
    func addDependantsinDatabase(relation:String)
    {
        let dict = NSMutableDictionary()
        dict.setValue("", forKey: "DEPENDANT_AGE")
        dict.setValue("", forKey: "DEPENDANT_DOB")
        dict.setValue("", forKey: "DEPENDANT_NAME")
        dict.setValue(relation, forKey: "DEPENDANT_RELATION")
        dict.setValue("", forKey: "DEPENDANT_RELATION_ID")
        dict.setValue("", forKey: "PERSON_SR_NO")
        DatabaseManager.sharedInstance.saveDependantDetails(contactDict: dict)
    }
    func btnCloseTapped(cell: AddDependantTableViewCell)
    {
       
        cell.m_editButton.isHidden = true
        cell.m_saveButton.isHidden = false
        
        cell.m_nameTextField.isUserInteractionEnabled=true
        cell.m_dobTextField.isUserInteractionEnabled=true
        cell.m_ageTextField.isUserInteractionEnabled=true
        cell.m_dateOfMarrigeTxtField.isUserInteractionEnabled=true
        cell.m_nameTextField.becomeFirstResponder()
        cell.isEdit=true
        
    }
    
    func saveButtonClicked(cell:AddDependantTableViewCell)
     {
        print(cell.tag)
        
        if(cell.m_nameTextField.text=="")
        {
            displayActivityAlert(title: "Enter Name")
        }
        else if(cell.m_dobTextField.text=="")
        {
            displayActivityAlert(title: "Enter Date of birth")
        }
        else if(cell.m_ageTextField.text=="")
        {
            displayActivityAlert(title: "Enter age")
        }
        else
        {
           
            cell.m_saveButton.isHidden = true
            cell.m_editButton.isHidden = false
            
            var dob = String()
            if(cell.isEdit)
            {
                
               if let personSrNo = m_dependantArray[cell.tag].personSrNo
               {
                    if(m_selectedDate=="")
                    {
                        dob = cell.m_dobTextField.text!
                        dob = dob.replacingOccurrences(of: "/", with: "~")
                    }
                    else
                    {
                        dob = m_selectedDate
                   
                    }
                
                    UpdateDependantDetails(age: cell.m_ageTextField.text!, dateofbirth: dob, personname: cell.m_nameTextField.text!, personSrNo: personSrNo)
                }
            }
            else
            {
                dob = cell.m_dobTextField.text!
                dob = dob.replacingOccurrences(of: "/", with: "~")
                let name = cell.m_nameTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                addDependantDetails(age: cell.m_ageTextField.text!, dateofbirth: dob, personname: name!, relation:cell.m_titleLbl.text!, dateOfMarrige: m_marrigeDate)
            }
            
            cell.m_nameTextField.isUserInteractionEnabled=false
            cell.m_dobTextField.isUserInteractionEnabled=false
            cell.m_ageTextField.isUserInteractionEnabled=false
        }
        cell.isEdit=false
    }
    func deleteButtonClicked(cell:AddDependantTableViewCell)
    {
        let alertController = UIAlertController(title: "Are you sure", message: "You want to delete dependant?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
            
            
            
        }
        alertController.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive)
        {
            (result : UIAlertAction) -> Void in
           
            
          if let indexPath = self.m_addDependantTableView.indexPath(for: cell)
          {
            
            if(self.m_dependantArray[indexPath.row].personSrNo!=="")
            {
                _ = DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: self.m_dependantArray[(indexPath.row)].dependantRelation!)
                
                self.tableView(self.m_addDependantTableView, commit: .delete, forRowAt: indexPath)
            }
            else
            {
                self.deleteDependant(indexpath:indexPath)
            }
        }
            
        }
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
        
        
       
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
            m_totalRowCount = m_totalRowCount-1
            m_dependantArray=DatabaseManager.sharedInstance.retrieveDependantDetails()
            self.m_addDependantTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    func deleteDependant(indexpath:IndexPath)
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: "Please wait...")
            
//            let m_dataSettingsDict = UserDefaults.standard.value(forKey: "DataSettingsDict") as! NSDictionary
            
           if(m_dependantArray.count>0)
           {
            print(m_dependantArray)
            let dataSettingsDict = m_dependantArray[indexpath.row]
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
            if (userArray.count>0)
            {
                
                m_employeeDict=userArray[0]
                
                
                var employeesrno = String()
                var groupchildsrno = String()
                
                
                if let childNo = m_employeeDict?.groupChildSrNo
                {
                    groupchildsrno = String(childNo)
                }
                if let empNo = m_employeeDict?.empSrNo
                {
                    employeesrno = String(empNo)
                }
             

                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getDeleteDependantUrl(employeesrno: employeesrno, personSrNo: dataSettingsDict.personSrNo!, groupchildsrno: groupchildsrno))
                
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
                    
                    DispatchQueue.main.async
                        {
                            //                            self.m_tableView.reloadData()
                            
                            if let status:String = resultDict.value(forKey: "DB_OPERATION_MESSAGE") as? String
                            {
                                if (status=="SUCCESS")
                                {
                                
                                    let alertController = UIAlertController(title: "Dependant deleted Successfully", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                                    {
                                        (result : UIAlertAction) -> Void in
                                      
//                                      self.getDataSettingsUrl()
                                        
                                        DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: dataSettingsDict.dependantRelation!)
                                        
                                         self.tableView(self.m_addDependantTableView, commit: .delete, forRowAt: indexpath)
                                        
                                    }
                                    alertController.addAction(cancelAction)
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                else
                                {
                                    let alertController = UIAlertController(title: "Fail to delete", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                                    {
                                        (result : UIAlertAction) -> Void in
                                        print("Cancel")
                                        
//                                        self.tableView(self.m_addDependantTableView, commit: .delete, forRowAt: indexpath)
                                        
                                    }
                                    alertController.addAction(cancelAction)
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                            self.hidePleaseWait()
                            
                    }
                }
                task.resume()
            }
            }
        }
        else
        {
            
            //            m_tableView.reloadData()
            
        }
        
    }
    @IBOutlet weak var m_premiumMsgLbl: UILabel!
    @IBAction func addTopupSelectionButtonClicked(_ sender: Any)
    {
        if(m_addTopupSelectionButton.currentImage==#imageLiteral(resourceName: "checked"))
        {
    
            m_addTopupSelectionButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_selectTopupButton.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
        }
        else
        {
            m_addTopupSelectionButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            m_selectTopupButton.setImage(#imageLiteral(resourceName: "radioactive"), for: .normal)
            m_premiumMsgLbl.isHidden=false
            let premiumMsg:String = m_enrollmentDict.value(forKey: "INSTALLMENT_MESSAGE")as? String ?? " "
            m_premiumMsgLbl.text=premiumMsg
        }
    }
    @IBAction func agreeTermsButtonClicked(_ sender: Any)
    {
        if(m_agreeTermsButton.currentImage==#imageLiteral(resourceName: "checked"))
        {
            m_agreeTermsButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        else
        {
            m_agreeTermsButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
    }
    @IBAction func selctTopupAmountButton2Clicked(_ sender: Any)
    {
        if(m_selectTopupAmountButton2.currentImage==#imageLiteral(resourceName: "radioactive"))
        {
            m_selectTopupAmountButton2.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
            m_selectTopupButton.setImage(#imageLiteral(resourceName: "radioactive"), for: .normal)
        }
        else
        {
            m_selectTopupAmountButton2.setImage(#imageLiteral(resourceName: "radioactive"), for: .normal)
            m_selectTopupButton.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
            let premiumMsg:String = m_enrollmentDict.value(forKey: "INSTALLMENT_MESSAGE")as! String
            m_premiumMsgLbl.isHidden=false
            m_premiumMsgLbl.text=premiumMsg
        }
    }
    @IBAction func selectTopupButtonClicked(_ sender: Any)
    {
        if(m_selectTopupButton.currentImage==#imageLiteral(resourceName: "radioactive"))
        {
             m_selectTopupAmountButton2.setImage(#imageLiteral(resourceName: "radioactive"), for: .normal)
            m_selectTopupButton.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
        }
        else
        {
            m_selectTopupAmountButton2.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
            m_selectTopupButton.setImage(#imageLiteral(resourceName: "radioactive"), for: .normal)
            let premiumMsg:String = m_enrollmentDict.value(forKey: "INSTALLMENT_MESSAGE")as? String ?? " "
            m_premiumMsgLbl.isHidden=false
            m_premiumMsgLbl.text=premiumMsg
        }
    }
    func addDependantDetails(age: String, dateofbirth: String, personname: String, relation: String, dateOfMarrige: String)
    {
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
            if (userArray.count>0)
            {
                
                m_employeeDict=userArray[0]
                
                var employeesrno = String()
                var groupchildsrno = String()
                var oegrpbasinfsrno = String()
                
                if let childNo = m_employeeDict?.groupChildSrNo
                {
                    groupchildsrno = String(childNo)
                }
                if let oeinfNo = m_employeeDict?.oe_group_base_Info_Sr_No
                {
                    oegrpbasinfsrno = String(oeinfNo)
                }
                if let empNo = m_employeeDict?.empSrNo
                {
                    employeesrno = String(empNo)
                }
               
                var relationId = String()
                var windowperiodactive = String()
                var marrigeDate = String()
                var parpolicyseperate = String()
                
                if let relationNo = m_enrollmentDict.value(forKey: "RELATION_ID_COVERED_IN_FAMILY")
                {
                    relationId = relationNo as! String
                }
                if let active = m_enrollmentDict.value(forKey: "WINDOW_PERIOD_ACTIVE")
                {
                    windowperiodactive = active as! String
                }
                if let date = m_enrollmentDict.value(forKey: "")
                {
                    marrigeDate = date as! String
                }
                if let parpolicy = m_enrollmentDict.value(forKey: "PAR_POL_INCLD_IN_MAIN_POLICY")
                {
                    parpolicyseperate = parpolicy as! String
                }
              
                
               if(relation.contains("Spouse"))
               {
                    relationId = "11"
                    if(dateOfMarrige=="")
                    {
                        marrigeDate = "01~01~1900"
                    }
                    else
                    {
                        marrigeDate = dateOfMarrige.replacingOccurrences(of: "/", with: "~")
                        
                    }
                }
               else if(relation.contains("Motherinlaw"))
               {
                    relationId = "6"
                    marrigeDate = "01~01~1900"
               }
                else if(relation.contains("Fatherinlaw"))
               {
                relationId = "5"
                marrigeDate = "01~01~1900"
               }
                else if(relation.contains("Daughter"))
               {
                    relationId = "4"
                    marrigeDate = "01~01~1900"
                }
               else if(relation.contains("Son"))
               {
                    relationId = "3"
                    marrigeDate = "01~01~1900"
                }
                else if(relation.contains("Mother"))
               {
                    relationId = "2"
                    marrigeDate = "01~01~1900"
               }
                else if(relation.contains("Father"))
               {
                    relationId = "1"
                    marrigeDate = "01~01~1900"
                }
                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getAddDependentUrl(employeesrno: employeesrno, age: age, dateofbirth: dateofbirth, relationid: relationId, personname: personname, dateofmarriage: marrigeDate, windowperiodactive: windowperiodactive, parpolicyseperate: parpolicyseperate, groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno))
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "GET"
                
                
                /////check crash
                if let url = urlreq as URL?
                {
                    showPleaseWait(msg: "Please wait...")
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
                                    do {
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
                                        
                                        DispatchQueue.main.async
                                            {
                                                //                            self.m_tableView.reloadData()
                                                
                                                if let status:String = resultDict.value(forKey: "DB_OPERATION_MESSAGE") as? String
                                                {
                                                    if (status=="SUCCESS")
                                                    {
                                                       self.getDataSettingsUrl()
                                                        
                                                        let alertController = UIAlertController(title: "Dependant added Successfully", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                                        
                                                        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                                                        {
                                                            (result : UIAlertAction) -> Void in
                                                            print("Cancel")
                                                            
                                                            
                                                            
                                                        }
                                                        alertController.addAction(cancelAction)
                                                        
                                                        self.present(alertController, animated: true, completion: nil)
                                                    }
                                                }
                                                self.hidePleaseWait()
                                                
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
                task.resume()
                }
            }
        }
        else
        {
            
            //            m_tableView.reloadData()
            
        }
    }
    
    
    func UpdateDependantDetails(age: String, dateofbirth: String, personname: String, personSrNo: String)
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg:"Please wait...")
           
                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getupdateDependantUrl(personSrNo: personSrNo, age: age, dateofbirth: dateofbirth, personname: personname))
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "GET"
                
                
                /////check crash
                if let url = urlreq as URL?
                {
                    
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
                                    do {
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
                                        
                                        DispatchQueue.main.async
                                            {
                                                //                            self.m_tableView.reloadData()
                                                print(resultDict.value(forKey: "DB_OPERATION_MESSAGE") as? String)
                                                if let status:String = resultDict.value(forKey: "DB_OPERATION_MESSAGE") as? String
                                                {
                                                    if (status=="SUCCESS")
                                                    {
                                                        let alertController = UIAlertController(title: "Dependant details edited successfully", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                                        
                                                        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                                                        {
                                                            (result : UIAlertAction) -> Void in
                                                            print("Cancel")
                                                            
                                                            
                                                            
                                                        }
                                                        alertController.addAction(cancelAction)
                                                        
                                                        self.present(alertController, animated: true, completion: nil)
                                                    }
                                                }
                                                self.hidePleaseWait()
                                                
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
                    task.resume()
                }
            
        }
        else
        {
            
            //            m_tableView.reloadData()
            
        }
    }
    
    
    @IBAction func dependentInfoButtonClicked(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Instructions", message: "You can add upto 5 dependants. Self + Spouse + 2 Dependant Children. Son age cannot be greater than 25 years. Daughters age cannot be greater than 25 years.", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
           
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func parentsInfoButtonClicked(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Instructions", message: "Parent's max age is 100 years", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
            
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
   /* func saveDependentsOnServer()
    {
       
            if(isConnectedToNetWithAlert())
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
                    setData()
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getAddDependentUrl(employeesrno: empNo, age: , dateofbirth: <#T##String#>, relationid: <#T##String#>, personname: <#T##String#>, dateofmarriage: <#T##String#>, windowperiodactive: <#T##String#>, parpolicyseperate: <#T##String#>, groupchildsrno: <#T##String#>, oegrpbasinfsrno: <#T##String#>))
                    
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
                        self.xmlKey = "Adminsettings"
                        let parser = XMLParser(data: data!)
                        parser.delegate = self
                        parser.parse()
                        
                        
                        for dict in self.resultsDictArray!
                        {
                            UserDefaults.standard.set(dict, forKey: "AdminSettingsDic")
                            print(dict)
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
                
            }
        

    }*/
    
   
    
//    @IBAction func addFatherButtonClicked(_ sender: Any)
//    {
//        
//    }
//    @IBAction func addFatherInLawButtonClicked(_ sender: Any)
//    {
//        
//    }
//    @IBAction func addMotherInLawButtonClicked(_ sender: Any)
//    {
//        
//    }
//    @IBAction func addMotherButtonClicked(_ sender: Any)
//    {
//        
//    }
    @IBAction func GMCTabSelected(_ sender: Any)
    {
        GMCTabSeleted()
    }
    
    @IBAction func GPATabSelected(_ sender: Any)
    {
        GPATabSelected()
    }
    @IBAction func GTLTabSelected(_ sender: Any)
    {
        GTLTabSelected()
    }
    func GMCTabSeleted()
    {
        m_productCode="GMC"
        
        m_shadowView.dropShadow()
        m_GTLShadowView.layer.masksToBounds=true
        m_GPAShadowView.layer.masksToBounds=true
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius=m_GMCTab.frame.size.height/2
        //m_GMCTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        //        GMCLine.backgroundColor=hexStringToUIColor(hex: "4B66EA")
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        //        GPALine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        //        GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GPATab.layer.borderColor=UIColor.white.cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor.white.cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        
        
    }
    func GPATabSelected()
    {
        m_productCode = "GPA"
        
        m_GPAShadowView.dropShadow()
        m_shadowView.layer.masksToBounds = true
        m_GTLShadowView.layer.masksToBounds=true
        
        m_GPATab.layer.masksToBounds=true
        m_GPATab.layer.cornerRadius=m_GPATab.frame.size.height/2
        //GPATab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GPATab.layer.borderWidth=0
        m_GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_GPATab.setTitleColor(UIColor.white, for: .normal)
        
        //        GPALine.backgroundColor=hexStringToUIColor(hex: "4B66EA")
        //        GMCLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        //        GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor.white.cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        
        //        m_tableView.reloadData()
    }
    func GTLTabSelected()
    {
        m_productCode = "GTL"
        m_GTLShadowView.dropShadow()
        m_GPAShadowView.layer.masksToBounds=true
        m_shadowView.layer.masksToBounds=true
        m_GTLTab.layer.masksToBounds=true
        m_GTLTab.layer.cornerRadius=m_GTLTab.frame.size.height/2
        //GTLTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GTLTab.layer.borderWidth=0
        m_GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_GTLTab.setTitleColor(UIColor.white, for: .normal)
        
        //        GTLLine.backgroundColor=hexStringToUIColor(hex: "4B66EA")
        //        GMCLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        //        GPALine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GPATab.layer.borderColor=UIColor.white.cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        
        
        //        m_tableView.reloadData()
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
            if(xmlKey=="DataSettings")
            {
                xmlKey = "DependantSettings"
            }
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

}
