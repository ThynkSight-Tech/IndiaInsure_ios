//
//  DependantViewController.swift
//  MyBenefits
//
//  Created by Semantic on 04/02/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
public extension UITableView {
    
    /// This method returns the indexPath of the cell that contains the specified view
    /// - parameter view: The view to find.
    /// - returns: The indexPath of the cell containing the view, or nil if it can't be found
    
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let origin = view.bounds.origin
        let viewOrigin = self.convert(origin, from: view)
        let indexPath = self.indexPathForRow(at: viewOrigin)
        return indexPath
    }
}
class DependantViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,FlexibleSteppedProgressBarDelegate {

    
   
   
    @IBOutlet weak var m_topView: UIView!
    
    @IBOutlet weak var m_instructionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var m_dependantsviewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_instructionsLbl: UILabel!
    @IBOutlet weak var m_openInstructionArrow: UIImageView!
    @IBOutlet weak var m_dependantBackgroundView: UIView!
    
    @IBOutlet weak var m_daughterCountLbl: UILabel!
    @IBOutlet weak var sonCountLabl: UILabel!
    @IBOutlet weak var m_motherInLawCheckbox: UIButton!
    @IBOutlet weak var m_motherCheckbox: UIButton!
    @IBOutlet weak var m_fatherInLawCheckbox: UIButton!
    @IBOutlet weak var m_fatherCheckBox: UIButton!
    @IBOutlet weak var m_spouseCheckBox: UIButton!
    @IBOutlet weak var m_instructionsView: UIView!
    @IBOutlet weak var m_dependantTableView: UITableView!
    
    @IBOutlet weak var m_datePicker: UIDatePicker!
    
    @IBOutlet var m_DOBView: UIView!
    
    @IBOutlet weak var m_DOBPickerSubView: UIView!
    
    
    let reuseIdentifier = "Cell"
    var progressBar = FlexibleSteppedProgressBar()
     var m_dependantArray = Array<DependantDetails>()
    
    var textFields: [SkyFloatingLabelTextField]!
    var dateArray = ["","","","","","","","","","","",""]
    var nameArray = ["","","","","","","","","","","",""]
    var ageArray = ["","","","","","","","","","","",""]
    var dependantsTitleArray = ["","","","","","","","","","","",""]
    var dobArray = ["","","","","","","","","","","",""]
    var domArray = ["","","","","","","","","","","",""]
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
    var m_isDateOfMarrige = Bool()
    var m_currentIndex = Int()
    var m_selectedDate = String()
    var m_dateofBirth = String()
    var m_marrigeDate = String()
    var m_isAcceptedConditions = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m_dependantTableView.register(AddDependantTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib = UINib (nibName: "AddDependantTableViewCell", bundle: nil)
        m_dependantTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        m_dependantTableView.separatorStyle=UITableViewCellSeparatorStyle.none
        setupProgressBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=false
        
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.title="Enrollment"
        self.navigationItem.leftBarButtonItem=getBackButton()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openInstructions (_:)))
        self.m_instructionsView.addGestureRecognizer(gesture)
        m_instructionsView.layer.masksToBounds=true
        m_instructionsView.layer.cornerRadius=m_instructionsLbl.frame.height/2
        m_instructionsView.layer.borderColor=hexStringToUIColor(hex: "0070d5").cgColor
        m_instructionsView.layer.borderWidth=1
        shadowForCell(view: m_instructionsView)
        shadowForCell(view: m_dependantBackgroundView)
    
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        menuButton.backgroundColor = UIColor.white
       
        menuButton.setImage(UIImage(named:"Home-2"), for: .normal)
        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        let dashboard : NewDashboardViewController = NewDashboardViewController()
        navigationController?.popToViewController(dashboard, animated: true)
        tabBarController!.selectedIndex = 2
    }
    override func backButtonClicked()
    {
        self.tabBarController?.tabBar.isHidden=false
        _ = navigationController?.popViewController(animated: true)
    }
    @objc func openInstructions(_ sender:UITapGestureRecognizer)
    {
        var newFrame : CGRect = m_instructionsView!.frame;
        
        if(newFrame.size.height == 125)
        {
            newFrame.size.height = 325;
            
            m_instructionsView.frame = newFrame;
            m_dependantsviewTopConstraint.constant=166+200
            m_instructionViewHeight.constant=125+200
        }
        else
        {
            newFrame.size.height = 125;
            m_instructionViewHeight.constant=125
            m_instructionsView.frame = newFrame;
            m_dependantsviewTopConstraint.constant=166
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView==m_dependantTableView)
        {
            let rowCount = (m_numberOfDaughter.intValue + m_numberOfSon.intValue+Int(truncating: NSNumber(value: m_isSpouse)))
            
            let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
            
            m_totalRowCount = rowCount+rowCountforParents
            return m_totalRowCount
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : AddDependantTableViewCell = m_dependantTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AddDependantTableViewCell
        
        shadowForCell(view: cell.m_backGroundView)
//        cell.m_backGroundView.ShadowForView()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 230
    }
    
    @IBAction func selectSpouseButtonClicked(_ sender: Any)
    {
        
        if(m_isSpouse)
        {
            m_spouseCheckBox.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_spouseCheckBox.backgroundColor=UIColor.white
            m_isSpouse = false
            DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: "Spouse")
        }
        else
        {
            m_isSpouse = true
            m_spouseCheckBox.setImage(UIImage(named: "checkSymbol"), for: .normal)
            m_spouseCheckBox.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            dependantsTitleArray.append("Spouse Details")
            addDependantsinDatabase(relation: "Spouse")
            
        }
        
        m_dependantTableView.reloadData()
    }
    
    @IBAction func addDaughterButtonClicked(_ sender: Any)
    {
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
                dependantsTitleArray.append("Daughter Details")
                m_dependantTableView.reloadData()
            }
            
            m_daughterCountLbl.text = m_numberOfDaughter.stringValue
        }
        else
        {
            alertMessage(msg: "You cannot add more than two children")
        }

    }
    
    @IBAction func deleteDaughterButtonClickde(_ sender: Any)
    {
        if(m_numberOfDaughter.intValue>0)
        {
            m_numberOfDaughter = NSNumber(integerLiteral: m_numberOfDaughter.intValue-1)
            m_daughterCountLbl.text = m_numberOfDaughter.stringValue
        DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: "Daughter")
            m_dependantTableView.reloadData()
        }
    }
    @IBAction func deleteSonButtonClicked(_ sender: Any)
    {
        if (m_numberOfSon.intValue>0)
        {
            m_numberOfSon = NSNumber(integerLiteral: m_numberOfSon.intValue-1)
            sonCountLabl.text = m_numberOfSon.stringValue
            DatabaseManager.sharedInstance.deleteDependantDetailswithRelation(relation: "Son")
            m_dependantTableView.reloadData()
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
                sonCountLabl.text = m_numberOfSon.stringValue
                addDependantsinDatabase(relation: "Son")
                m_dependantTableView.reloadData()
            }
        }
        else
        {
            alertMessage(msg: "You cannot add more than two children")
        }
    }
    
    @IBAction func addFatherButtonClicked(_ sender: Any)
    {
        let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
        print(rowCountforParents)
        
        if(m_isFather)
        {
            m_fatherCheckBox.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_fatherCheckBox.backgroundColor=UIColor.white
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
            m_fatherCheckBox.setImage(UIImage(named: "checkSymbol"), for: .normal)
            m_fatherCheckBox.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            addDependantsinDatabase(relation: "Father")
            
        }
        m_dependantTableView.reloadData()
    }
    
    @IBAction func addFatherInLawButtonClicked(_ sender: Any)
    {
        let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
        print(rowCountforParents)
        if(m_isFatherinLaw)
        {
            m_fatherInLawCheckbox.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_fatherInLawCheckbox.backgroundColor=UIColor.white
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
            m_fatherInLawCheckbox.setImage(UIImage(named: "checkSymbol"), for: .normal)
            m_fatherInLawCheckbox.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            addDependantsinDatabase(relation: "Father-In-Law")
        }
        m_dependantTableView.reloadData()
    }
    
    @IBAction func addMotherButtonClicked(_ sender: Any)
    {
        let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
        if(m_isMother)
        {
            m_motherCheckbox.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_motherCheckbox.backgroundColor=UIColor.white
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
            m_motherCheckbox.setImage(UIImage(named: "checkSymbol"), for: .normal)
            m_motherCheckbox.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            addDependantsinDatabase(relation: "Mother")
        }
        m_dependantTableView.reloadData()
    }
    @IBAction func addMotherInLawButtonClicked(_ sender: Any)
    {
        let rowCountforParents = (Int(truncating: NSNumber(value: m_isFather))+Int(NSNumber(value: m_isFatherinLaw))+Int(NSNumber(value: m_isMother))+Int(NSNumber(value: m_isMotherinLaw)))
        if(m_isMotherinLaw)
        {
            m_motherInLawCheckbox.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            m_motherInLawCheckbox.backgroundColor=UIColor.white
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
            m_motherInLawCheckbox.setImage(UIImage(named: "checkSymbol"), for: .normal)
            m_motherInLawCheckbox.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            addDependantsinDatabase(relation: "Mother-In-Law")
        }
        m_dependantTableView.reloadData()
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
        m_dependantTableView.endEditing(true)
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
        m_datePicker.maximumDate=m_serverDate
        
        if(!m_windowPeriodStatus)
        {
            let birthlifeEvent : NSString = m_enrollmentLifeEventInfoDict.value(forKey: "Childbirth") as! NSString
            let lifeEvent : NSString = m_enrollmentLifeEventInfoDict.value(forKey: "Childbirth") as! NSString
            
            
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
                let minimumDate = Calendar.current.date(byAdding: .day, value: Int(-birthlifeEvent.intValue), to: Date())
                m_datePicker.minimumDate=minimumDate
            }
            
        }
        else
        {
            
            let array : [EnrollmentGroupRelations] = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation:"DAUGHTER")
            let maxAge : NSString = array[0].maxAge as! NSString
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
        m_dependantTableView.reloadData()
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
    func setupProgressBar()
    {
       /* progressBar = FlexibleSteppedProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        m_topView.addSubview(progressBar)
        
        progressBar.accessibilityElementsHidden=true
        
        let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: m_topView.centerXAnchor)
        
        let verticalConstraint = progressBar.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 20
        )
        let widthC = progressBar.widthAnchor.constraint(greaterThanOrEqualToConstant: m_topView.frame.width-25)
        let heightConstraint = progressBar.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([widthC,heightConstraint,verticalConstraint,horizontalConstraint])
        
        progressBar.delegate = self
        progressBar.currentIndex = 1
        progressBar.numberOfPoints = 3
        progressBar.lineHeight = 3
        
        /*  progressBar.radius = 20
         progressBar.progressRadius = 0
         progressBar.progressLineHeight = 3
         progressBar.currentSelectedCenterColor=hexStringToUIColor(hex: "e7bf2c")
         progressBar.selectedOuterCircleStrokeColor=hexStringToUIColor(hex: "#e7bf2c")
         progressBar.selectedBackgoundColor=hexStringToUIColor(hex: hightlightColor)
         progressBar.currentIndex=0*/
        
        
        
        progressBar.radius = 10
        progressBar.progressRadius = 25
        progressBar.progressLineHeight = 3
        progressBar.selectedBackgoundColor = hexStringToUIColor(hex: "e7bf2c")
        progressBar.selectedOuterCircleStrokeColor = hexStringToUIColor(hex: "e7bf2c")
        progressBar.currentSelectedCenterColor = hexStringToUIColor(hex: "e7bf2c")
        progressBar.stepTextColor = UIColor.gray
        progressBar.currentSelectedTextColor = UIColor.black*/
        
        
    }
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int)
    {
        switch index
        {
            
        case 0:
            progressBar.currentIndex=0
            navigationController?.popViewController(animated: true)
            return
            
        case 1:
            let addDependant: DependantViewController = DependantViewController()
            navigationController?.pushViewController(addDependant, animated: true)
            progressBar.currentIndex=1
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
       
        
        
        if position == FlexibleSteppedProgressBarTextLocation.bottom
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

}
