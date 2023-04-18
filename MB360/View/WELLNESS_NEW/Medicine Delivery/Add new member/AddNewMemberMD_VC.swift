//
//  AddNewMemberMD_VC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 11/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class AddNewMemberMD_VC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtRelation: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var btnDob: UIButton!
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnAddMember: UIButton!
    
    @IBOutlet weak var genderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewGender: UIView!
    
    @IBOutlet weak var m_datePickerSubview: UIView!
    @IBOutlet weak var m_datePicker: UIDatePicker!
    @IBOutlet var m_dateView: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRelation: UILabel!
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    
    @IBOutlet weak var chkBoxView: UIView!
    let relationDropDown = DropDown()
    let ageDropDown = DropDown()
    
    var dataSourceArray = [String]()
    var relationId = ""
    
    //Relation Gender
    var m_gender = "MALE"
    
    //Application User Gender
    var userGender = "MALE"
    
    //age array
    var array = [Int](18...100)
    var ageStringArray = [String]()
    var relationModelArray = [RelationDataModel]()
    
    var knowDob = 1
    var friendGender = 0
    var m_selectedDate = Date()
    var serverDate = ""
    
    var memberDelegate : NewMemberAddedProtocol? = nil
    var isKeyboardAppear = false
    
    //Set date picker limit  0 to 100 and, Hide checkbox
    var smallAgeRelations = ["Brother","Brother-In-Law","Sister-In-Law","Daughter","Friend","Nephew","Niece","Sister","Son"]
    
    //Set  date picker limit 18+ and, UnHide checkbox
    var AgeRealtions18 = ["Daughter-In-Law","Son-In-Law","Spouse","Father-In-Law","Mother-In-Law","Father","Mother"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = UIColor.yellow
        //view.isOpaque = false
        //view.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        //view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.navigationController?.navigationBar.changeFont()
        setColors()
        
        self.viewHeight.constant = 355
        self.genderViewHeight.constant = 0
        self.viewGender.isHidden = true
        
        txtRelation.delegate = self
        txtAge.delegate = self
        txtDateOfBirth.delegate = self
        txtName.autocapitalizationType = UITextAutocapitalizationType.words
        txtName.delegate = self
        
        self.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        print(array)
        self.ageStringArray = self.array.map({String($0)})
        
        print(self.ageStringArray)
        
        txtRelation.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        
        txtAge.addTarget(self, action: #selector(showAgeList), for: .touchDown)
        txtDateOfBirth.addTarget(self, action:#selector(selectDateButtonClicked), for: .touchDown)
        
        
        self.txtDateOfBirth.isEnabled = true
        self.txtDateOfBirth.text = ""
        
        self.txtAge.text = "-"
        self.txtAge.isEnabled = false
        
        if serverDate != "" {
            
            if let backdate = Calendar.current.date(byAdding: .year, value: -18, to: convertDate(serverDate)) {
                self.m_selectedDate = backdate
            }
        }
        
        
        let array : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:"EMPLOYEE")
        if(array.count>0)
        {
            let personInfo = array[0]
            if let gender = personInfo.gender
            {
                self.userGender = gender
            }
            
        }
         print("In \(self.title ?? "") AddNewMemberMD_VC")
    }
    
    private func setColors() {
        lblAge.textColor = Color.fontColor.value
        lblName.textColor = Color.fontColor.value
        lblRelation.textColor = Color.fontColor.value
        lblDob.textColor = Color.fontColor.value
        btnAddMember.backgroundColor = Color.buttonBackgroundGreen.value
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        
        showRelationDropDown()
    }
    
    private func showRelationDropDown() {
        relationDropDown.anchorView = self.txtRelation
        relationDropDown.bottomOffset = CGPoint(x: 0, y: 25)
        relationDropDown.width = txtRelation.frame.size.width - 30
        relationDropDown.show()
        
        self.relationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txtRelation.text = item
            self.displayDropDownat(index: index, item: item)
        }
        
    }
    
    @objc func showAgeList(textField: UITextField) {
        
        ageDropDown.dataSource = self.ageStringArray
        ageDropDown.anchorView = self.txtAge
        ageDropDown.bottomOffset = CGPoint(x: 0, y: 25)
        ageDropDown.width = txtAge.frame.size.width
        ageDropDown.show()
        
        self.ageDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txtAge.text = item
        }
        
    }
    
    //Add Done Button On Keyboard
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        // doneToolbar.tintColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
        
        txtName.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        txtName.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= 180
                }
            }
            isKeyboardAppear = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += 180
                }
            }
            isKeyboardAppear = false
        }
    }
    
    //MARK:- Dont know Dob Tapped
    @IBAction func dobDidTapper(_ sender: Any) {
        
        var smallAgeRelations = ["Son","Daughter"] //if relations is son/daughter then age limit is 1 and set max date to current date
        //o.w age limit is 18 and max date is before 18.
        
        if self.txtRelation.text == "" {
            self.displayActivityAlert(title: "Please select relation first")
        }
        else {
        if knowDob == 0 { //select date
            self.txtDateOfBirth.isEnabled = true
            self.txtDateOfBirth.text = ""
            btnDob.setImage(UIImage(named: "checkbox"), for: .normal)
            
            self.txtAge.text = "-"
            self.txtAge.isEnabled = false
            
            knowDob = 1
            
            if smallAgeRelations.contains(self.txtRelation.text!) { //if S,D then age 1 to 100
                array = [Int](1...100)
                self.ageStringArray = self.array.map({String($0)})
            }
            else {//if S,D then age 18 to 100
                array = [Int](18...100)
                self.ageStringArray = self.array.map({String($0)})
            }
            
        }
        else {//select age
            knowDob = 0
            self.txtDateOfBirth.text = " "
            self.txtDateOfBirth.isEnabled = false
            btnDob.setImage(UIImage(named: "checked1"), for: .normal)
            self.txtAge.text = ""
            self.txtAge.placeholder = "Select Age"
            self.txtAge.isEnabled = true
            
           
        }
        }
    }
    
    @IBAction func maleDidTapped(_ sender: Any) {
        self.friendGender = 0
        btnMale.setImage(UIImage(named: "radio_selected"), for: .normal)
        btnFemale.setImage(UIImage(named: "radio"), for: .normal)
        self.m_gender="MALE"
        
        
    }
    
    @IBAction func femaleDidTapped(_ sender: Any) {
        self.friendGender = 0
        btnFemale.setImage(UIImage(named: "radio_selected"), for: .normal)
        btnMale.setImage(UIImage(named: "radio"), for: .normal)
        self.m_gender="FEMALE"
        
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Select Relation
    func displayDropDownat(index:Int,item:String)
    {
        if(self.dataSourceArray.count > index)
        {
            self.relationId = self.dataSourceArray[index]
            self.txtRelation.text = self.dataSourceArray[index]
            
            if smallAgeRelations.contains(item) { //age 0 to 100
                //Hide Checkbox
                self.chkBoxView.isHidden = true
                self.txtDateOfBirth.text = ""
                self.txtAge.text = ""
            }
            else {
                //unhide checkbox age 18 to 100
                self.chkBoxView.isHidden = false
                self.txtDateOfBirth.text = ""
                self.txtAge.text = ""
            }
            
            btnDob.setImage(UIImage(named: "checkbox"), for: .normal)
            self.txtAge.text = "-"
            self.txtAge.isEnabled = false
            //knowDob = 0
            
            
            
            switch item
            {
            case "Brother" :
                self.m_gender="MALE"
                hideGenderView()
                break
                
            case "Daughter" :
                self.m_gender="FEMALE"
                hideGenderView()
                break
                
            case "Brother-In-Law" :
                self.m_gender="MALE"
                hideGenderView()
                break
                
            case "Daughter-In-Law" :
                self.m_gender="FEMALE"
                hideGenderView()
                break
                
            case "Father" :
                self.m_gender="MALE"
                hideGenderView()
                break
                
            case "Father-In-Law" :
                self.m_gender="MALE"
                hideGenderView()
                break
                
            case "Mother" :
                self.m_gender="FEMALE"
                hideGenderView()
                break
                
            case "Friend" :
                self.m_gender="MALE"
                self.viewHeight.constant = 405
                self.genderViewHeight.constant = 40
                self.viewGender.isHidden = false
                break
                
            case "MOTHER-IN-LAW","Mother-In-Law" :
                self.m_gender="FEMALE"
                hideGenderView()
                break
                
            case "Nephew" :
                self.m_gender="MALE"
                hideGenderView()
                break
                
            case "Niece":
                self.m_gender="FEMALE"
                hideGenderView()
                break
            case "Sister":
                self.m_gender="FEMALE"
                hideGenderView()
                break
            case "Sister-In-Law":
                self.m_gender="FEMALE"
                hideGenderView()
                break
            case "Son" :
                self.m_gender="MALE"
                hideGenderView()
                break
                
            case "Son-In-Law" :
                self.m_gender="MALE"
                hideGenderView()
                break
                
            case "Spouse" :
                if userGender == "MALE" {
                    self.m_gender = "FEMALE"
                }
                else {
                    self.m_gender="MALE"
                }
                hideGenderView()
                break
                
            default :
                break
            }
            
            
        }
        
    }
    
    func hideGenderView() {
        self.viewHeight.constant = 355
        self.genderViewHeight.constant = 0
        self.viewGender.isHidden = true
    }
    
    ///Datepicker
    
    //MARK:- Select Date Tapped
    @objc func selectDateButtonClicked()
    {
       // var smallAgeRelations = ["Son","Daughter"] //if relations is son/daughter then age limit is 1 and set max date to current date
        //o.w age limit is 18 and max date is before 18.
        
        if self.txtRelation.text == "" {
            self.displayActivityAlert(title: "Please select relation first")
        }

        else {
        self.txtDateOfBirth.endEditing(true)
        view.endEditing(true)
        
        //For DEFAULT DATE PICKER
        _ = Bundle.main.loadNibNamed("ProfileDatePicker", owner: self, options: nil)?[0];
        m_dateView.frame=view.frame
        view.addSubview(m_dateView)
        addBordersToComponents()
        
        if serverDate != "" {
            if self.smallAgeRelations.contains(self.txtRelation.text!) {
                let backdate = Calendar.current.date(byAdding: .year, value: 0, to: convertDate(serverDate))
                self.m_datePicker.setDate(m_selectedDate as Date, animated: false)
                self.m_datePicker.maximumDate = backdate
            }
            else {
                let backdate = Calendar.current.date(byAdding: .year, value: -18, to: convertDate(serverDate))
                self.m_datePicker.setDate(m_selectedDate as Date, animated: false)
                self.m_datePicker.maximumDate = backdate
            }
        }
            
        }
       
    }
    func addBordersToComponents()
    {
        m_datePickerSubview.layer.borderWidth = 1
        m_datePickerSubview.layer.borderColor = UIColor.darkGray.cgColor
        m_datePickerSubview.layer.cornerRadius = 5
    }
    
    @IBAction func showRelationDidTapped(_ sender: Any) {
        showRelationDropDown()
        
    }
    @IBAction func dateCancelButtonClicked(_ sender: Any)
    {
        m_dateView.removeFromSuperview()
    }
    
    @IBAction func DateDonebuttonClicked(_ sender: Any)
    {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        //        formatter.dateFormat = "yyyy-MM-dd"
        m_selectedDate = m_datePicker.date
        let dateString = formatter.string(from: m_datePicker.date)
        print(dateString)
        self.txtDateOfBirth.text = dateString
        
        let serverDt = convertDate(serverDate)
        
        self.txtAge.text = String(serverDt.years(from: m_datePicker.date))
        
        //String(m_datePicker.date.years(from: Date()))
        m_dateView.removeFromSuperview()
    }
    
    //MARK:- Convert Date
    func convertDate(_ date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date1 = dateFormatter.date(from: date)
        {
            return date1
            //dateFormatter.dateFormat = "dd/MM/yyyy"
            // return  dateFormatter.string(from: date1)
        }
        else
        {
            return Date()
        }
    }
    
   
    
    //MARK:- Move to calendar
    private func moveToCalendar() {
        let CalendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomCalendarVC") as! CustomCalendarVC
        CalendarViewController.modalPresentationStyle = .overCurrentContext
        CalendarViewController.delegate = self as? CalendarCallBackNew
        
        let cal = Calendar.current
        
        var startDate = Date()
        if serverDate != nil {
            if let backdate = Calendar.current.date(byAdding: .year, value: -18, to: convertDate(serverDate)) {
                startDate = backdate
            }
        }
        
        CalendarViewController.selectedDate = startDate
        self.present(CalendarViewController, animated: false, completion: nil)
    }
    
    //MARK:- Calendar Delegate
    func didSelectDate(date: Date) {
        
    }
    
    @IBAction func addMemberDidTapped(_ sender: Any) {
        //  "PersonName": null,"Age": null, "DateOfBirth": null, "Gender": null, "RelationID": null,"FamilySrNo":"",
        
        let nameText = self.txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let relationText = self.txtRelation.text
        let age = self.txtAge.text
        let dob = self.txtDateOfBirth.text
        let gender = self.m_gender
        
        if nameText.count == 0 {
            displayActivityAlert(title: "Please Enter Name")
        }
        else if relationText?.count == 0 {
            displayActivityAlert(title: "Please Select Relation")
        }
        else if dob?.count == 0 {
            if knowDob == 1 {
                displayActivityAlert(title: "Please Select Date of Birth")
            }
        }
        else if age?.count == 0 && age == ""{
            if knowDob == 0 {
                displayActivityAlert(title: "Please Select age")
            }
            
        }
            
        else {
            
            isReloadFamilyDetails = 1
            
            guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
                return
            }
            
            var relationID = ""
            if relationText?.count != 0 {
                let relationModel = self.relationModelArray.filter{$0.relationName == relationText}
                relationID = relationModel[0].relationId ?? ""
            }
            
            var dobStr = ""
            if knowDob == 0 {
                dobStr = "01/01/1900"
            }
            else {
                dobStr = dob ?? "01/01/1900"
            }
            let parameter = ["PersonName":nameText,"Age":age,"DateOfBirth":dobStr,"Gender":gender,"RelationID":relationID,"FamilySrNo":familySrNo]
            
            self.postAddMemberDataToServer(parameter: parameter as NSDictionary)
        }
    }
    
    private func postAddMemberDataToServer(parameter:NSDictionary) {
        print("Insert EMP Info")
        
        let url = APIEngine.shared.addMemberURL()
        print(url)
        ServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    // self.dismiss(animated: true, completion: nil)
                    //self.tabBarController?.selectedIndex = 2
                    
                    self.dismiss(animated: true, completion: {
                        print("Dismiss...")
                        if self.memberDelegate != nil {
                            print("Delegate...")
                            
                            self.memberDelegate?.newMemberAdded()
                        }
                    })
                }
                else {
                    //Failed to send member info
                    let msg = response?["Message"].stringValue
                    self.displayActivityAlert(title: msg ?? "")
                    
                }
            }
        })
    }
    
    
}


extension AddNewMemberMD_VC {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
           if txtName == textField {
           return true
           }
           return false
       }
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
       {
           if(textField == txtName)
           {
               let MAX_LENGTH_PHONENUMBER = 50
               let ACCEPTABLE_NUMBERS     = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ"
               let newLength: Int = textField.text!.count + string.count - range.length
               let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
               let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
               return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
           }
           
           return true
       }
}
