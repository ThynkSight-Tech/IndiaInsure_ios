//
//  SelectDateViewController.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 06/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class SelectDateViewController: UIViewController,CalendarCallBack,YesNoProtocol,AppointmentConfirmedProtocol {
    
    //Date 1
    @IBOutlet weak var lblDate1: UILabel!
    @IBOutlet weak var lblTime1: UILabel!
    @IBOutlet weak var backgroundFirst: UIView!
    
    //Date 2
    @IBOutlet weak var lblDate2: UILabel!
    @IBOutlet weak var lblTime2: UILabel!
    @IBOutlet weak var backgroundSecond: UIView!
    
    //Date 3
    @IBOutlet weak var lblDate3: UILabel!
    @IBOutlet weak var lblTime3: UILabel!
    @IBOutlet weak var backgroundThird: UIView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    
    var selectedDate = Date()
    var serverDate = Date()
    
    var dateFlag = 0
    var timeFlag = 0
    
    
    var dateArray = [String]()
    
    var datePicker : UIDatePicker!
    var toolBar = UIToolbar()
    var personDetailsModel = FamilyDetailsModel()
    var selectedHospitalModel = HospitalModel()
    
    
    //Used this flag on Select Date Screen for Schedule Appointment.
    //Set This Flag From When user coming from family details screen and Appointment screen.
    //set zero from family and set one from appointment
    var isFromFamily = 0
    var selectedAppointmentModel = AppointmentModel()
    
    //MARK:- New Change Oe_Group May 2020
    var memberDetailsModel = PersonCheckupModel()
    var hcPackageDetailsModel = HealthCheckupModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "Schedule here"
        //self.navigationController?.navigationBar.changeFont()
        print("In \(self.title ?? "") SelectDateViewController")
        
        ConstantContent.sharedInstance.circularView(view: backgroundFirst)
        ConstantContent.sharedInstance.circularView(view: backgroundSecond)
        ConstantContent.sharedInstance.circularView(view: backgroundThird)
        
        setColor()
        
        self.btnConfirm.layer.cornerRadius = btnConfirm.frame.size.height / 2
        //self.btnConfirm.layer.masksToBounds=true
       // self.btnConfirm.plainView.setGradientBackground(colorTop: hexStringToUIColor(hex: "3ed9b1"), colorBottom:hexStringToUIColor(hex: "40e0d0"))
        self.btnConfirm.dropShadow()

        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        
        lbNavTitle.text = "Schedule here"
        self.navigationItem.titleView = lbNavTitle
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        
        getDateArray()
    }
    
    private func setColor()
    {
        lblDate1.textColor = Color.fontColor.value
        lblDate2.textColor = Color.fontColor.value
        lblDate3.textColor = Color.fontColor.value
        
        btnConfirm.backgroundColor = Color.buttonBackgroundGreen.value
    }
    
    private func getDateArray () {
        let cal = Calendar.current
        // Get the date of 2 years ago today
        let stopDate = cal.date(byAdding: .month, value: 6, to: Date())!
        
        // We want to find dates that match on Sundays at midnight local time
        var comps = DateComponents()
        comps.weekday = 1 // Sunday
        //comps.weekday = 2
        // Enumerate all of the dates
        
        
        let startDate = cal.date(byAdding: .day, value: 2, to: Date())!
        
        //let dateArray =  startDate.allDates(till: stopDate)
        //  print(dateArray)
        
        
        
    }
    
    //MARK:- Show Time Picker
    @IBAction func timeFirstTapped(_ sender: Any) {
        timeFlag = 1
        // showDatePicker()
    }
    
    @IBAction func timeSecondTapped(_ sender: Any) {
        timeFlag = 2
        
        //showDatePicker()
        
    }
    
    @IBAction func time3Tapped(_ sender: Any) {
        timeFlag = 3
        
        //showDatePicker()
        
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didSelectDate(date: Date) {
        print(dateArray)
        
        if dateFlag == 1 {
            selectedDate = date
            let formDate = getFormattedDate(date: date)
            if dateArray.contains(formDate) {
                
                if self.lblDate1.text != formDate {
                displayActivityAlert(title: "Please Select Different Date")
                    
                    if self.lblDate1.text != "Select Date" {
                        if let index = dateArray.index(of: self.lblDate1.text!) {
                            self.dateArray.remove(at: index)
                        }
                    }
                    
                self.lblDate1.text = "Select Date"
                    
                    
                }
            }
            else {
                if let index = dateArray.index(of: self.lblDate1.text!) {
                    self.dateArray.remove(at: index)
                }
                self.dateArray.append(formDate)
                self.lblDate1.text = formDate
            }
            
        }
        else if dateFlag == 2 {
            selectedDate = date
            let formDate = getFormattedDate(date: date)
            
            if dateArray.contains(formDate) {
                if self.lblDate2.text != formDate {

                displayActivityAlert(title: "Please Select Different Date")
                    
                    if self.lblDate2.text != "Select Date" {
                        if let index = dateArray.index(of: self.lblDate2.text!) {
                            self.dateArray.remove(at: index)
                        }
                    }
                    
                self.lblDate2.text = "Select Date"
                }
            }
            else {
                
                if let index = dateArray.index(of: self.lblDate2.text!) {
                    self.dateArray.remove(at: index)
                }
                self.dateArray.append(formDate)
                self.lblDate2.text = formDate
            }
        }
        else if dateFlag == 3  {
            selectedDate = date
            let formDate = getFormattedDate(date: date)
            if dateArray.contains(formDate) {
                
                if self.lblDate3.text != formDate {

                displayActivityAlert(title: "Please Select Different Date")
                    if self.lblDate3.text != "Select Date" {
                        if let index = dateArray.index(of: self.lblDate3.text!) {
                            self.dateArray.remove(at: index)
                        }
                    }
                    
                self.lblDate3.text = "Select Date"
                }
                
            }
            else {
                if let index = dateArray.index(of: self.lblDate3.text!) {
                    self.dateArray.remove(at: index)
                }
                self.dateArray.append(formDate)
                self.lblDate3.text = formDate
            }
        }
    }
    
    func getFormattedDate(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    @IBAction func dateTwoTapped(_ sender: Any) {
        self.dateFlag = 2
        moveToCalendar()
    }
    
    @IBAction func date3Tapped(_ sender: Any) {
        self.dateFlag = 3
        
        moveToCalendar()
    }
    
    
    
    @IBAction func showCalender(_ sender: Any) {
        self.dateFlag = 1
        moveToCalendar()
    }
    
    private func moveToCalendar() {
        let CalendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        CalendarViewController.modalPresentationStyle = .overCurrentContext
        CalendarViewController.delegate = self
        
        let cal = Calendar.current
        
        var startDate = Date()
        if serverDate != nil {
            if serverDate.getDay() == "Sat" {
                //+3
                startDate = cal.date(byAdding: .day, value: 3, to: serverDate)!
            }
            else{
                startDate = cal.date(byAdding: .day, value: 2, to: serverDate)!
            }
        }
        else {
            if Date().getDay() == "Sat" {
                //+3
                startDate = cal.date(byAdding: .day, value: 3, to: Date())!
            }
            else{
                startDate = cal.date(byAdding: .day, value: 2, to: Date())!
            }
            
        }
        
        CalendarViewController.selectedDate = startDate
        CalendarViewController.currentDate = startDate
        
        self.present(CalendarViewController, animated: false, completion: nil)
    }
    
    /*
     {"PrefDate1":"12/01/2018","PrefTime1":"08:30","PrefDate2":"12/01/2018","PrefTime2":"08:30","PrefDate3":"12/01/2018","PrefTime3":"08:30","GroupName":"TATA COMMUNICATION LIMITED","IsPersonOrFamily":1,"PersonSrNo":"766565","FamilySrNo":"655356","DaigcenterNo":"64","ISRescheduled":"","OldApptInfoSrNo":"","RejtApptSrNo":"","PaidOrNot":"" }
     */
    
    //MARK:- Validation
    @IBAction func confirmDidTapped(_ sender: Any) {
        
        if lblDate1.text == "Select Date" {
            displayActivityAlert(title: "Preferred dates cannot be same ")
            
        }
        else if lblDate2.text == "Select Date"  {
            displayActivityAlert(title: "Preferred dates cannot be same ")
            
        }
        else if lblDate3.text == "Select Date"  {
            displayActivityAlert(title: "Preferred dates cannot be same ")
        }
            

        
        else {
            isReloadFamilyDetails = 1

            let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"ScheduleAppointmentAlert") as! ScheduleAppointmentAlert
            vc.yesNoDelegate = self
            vc.modalPresentationStyle = .custom
            vc.modalTransitionStyle = .crossDissolve
            navigationController?.present(vc, animated: true, completion: nil)

            
        }
    }
    
    
    func scheduleAppointment() {
        
        let groupName = "Travel Container Services Limited"
        
        //Family Sr No
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") as? String else {
            return
        }
        
        guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") else {
            return
        }

//        guard let groupCode = UserDefaults.standard.value(forKey: "GroupCode") else {
//            return
//        }
        
        //Get Group Info
        var groupCode = ""
        let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
        if groupMasterArray.count > 0 {
            groupCode = groupMasterArray[0].groupCode!
        }
       
        var empId = ""
       let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
       if(userArray.count>0)
       {
        empId = userArray[0].empIDNo!
       }
        
        
        //If is SELF then set 1 else 0
        var isPersonORFamily = "2"
        personDetailsModel.RelationID == "17" ? (isPersonORFamily = "1") : (isPersonORFamily = "2")
        
        //isReScheduled
        var isRescheduled = "0"
        isFromFamily == 1 ? (isRescheduled = "0") : (isRescheduled = "1")
        
        //Old Appointment Sr No "ELSE set Old Appointment SR No."
        var oldApptSRNo = "0"
        isFromFamily == 1 ? (oldApptSRNo = "0") : (oldApptSRNo = self.selectedAppointmentModel.ApptSrNo ?? "")
        
        //Reject Appointment SRNo if 0 "ELSE set RejectSRNO"
        var rejectAppSRNo = "-1"
        isFromFamily == 1 ? (rejectAppSRNo = "-1") : (rejectAppSRNo = self.selectedAppointmentModel.RejApptSrNo ?? "")
        
        //set Paid or not flag "ELSE set "
        var isPaidOrNot = "0"
        isFromFamily == 1 ? (isPaidOrNot = "0") : (isPaidOrNot = self.selectedAppointmentModel.PaymentFlag ?? "")
        
        let familysrno = String(format: "%@", familySrNo as CVarArg)
        
        var personSRNo = ""
        isFromFamily == 1 ? (personSRNo = self.memberDetailsModel.PersonSRNo?.description ?? "") : (personSRNo = self.selectedAppointmentModel.PersonSrNo ?? "")
        
        //PACKAGE SR NUMBER IS EMPTY NEED TO ADD PACKAGESRNUMBER ON HEALTH PACKAGE...
        var packageSrNumber = ""
        if isFromFamily == 1 {
            guard let packageSrNo = hcPackageDetailsModel.PackageSrNo else {
                return
            }
            packageSrNumber = packageSrNo
        }
        else {
            guard let packageSrNo = selectedAppointmentModel.PackageSrNo else {
                return
            }
            packageSrNumber = packageSrNo

        }
        
        //GroupSrNo, GroupCode, EmployeeIdentificationNo, PackageSrNo
        let param = ["PrefDate1":self.lblDate1.text!,"PrefTime1":"08:30","PrefDate2":self.lblDate2.text!,"PrefTime2":"08:30","PrefDate3":self.lblDate3.text!,"PrefTime3":"08:30","GroupName":groupName,"IsPersonOrFamily":isPersonORFamily,"PersonSrNo":personSRNo,"FamilySrNo":familysrno,"DiagcenterNo":self.selectedHospitalModel.CenterSrNo!,"ISRescheduled":isRescheduled,"OldApptInfoSrNo":oldApptSRNo,"RejtApptSrNo":rejectAppSRNo,"PaidOrNot":isPaidOrNot,"PackageSrNo":packageSrNumber, "GroupSrNo":groupSrNo,"GroupCode":groupCode,"EmployeeIdentificationNo":empId] as [String : Any]
        print(param)
        
        sendScheduleAppointmentDataToServer(parameter: param as NSDictionary)

    }
    
    //MARK:- Yes/No Protocol
    func yesTapped() {
        print("Yes Tapped")
        scheduleAppointment()
    }
    
    func noTapped() {
        
    }
    
    //MARK:- Delegate Method
    func okTapped() {
        for controller in self.navigationController!.viewControllers as Array {
            print(controller)
            if controller.isKind(of: AppointmentsViewController.self) || controller.isKind(of: HealthCheckupOptVC.self) {
                isRefreshAppointment = 1
                isReloadFamilyDetails = 1
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    //MARK:- Send Schedule Data To Server.
    private func sendScheduleAppointmentDataToServer(parameter:NSDictionary) {
        //http://mybenefits360.in/mbapi/api/v1/HealthCheckup/ScheduleAppointment
  
        let url = APIEngine.shared.scheduleAppointmentURL()
            print(url)
            ServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
                
                if let msgDic = response?["message"].dictionary {

                    if let status = msgDic["Status"]?.bool
                {
                    if status == true {
                        
                        if let msgValue = msgDic["Message"]?.stringValue
                        {
                            
                            let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"AppointmentScheduledVC") as! AppointmentScheduledVC
                            vc.modalPresentationStyle = .custom
                            vc.modalTransitionStyle = .crossDissolve
                            vc.appointmentOkDelegate = self as AppointmentConfirmedProtocol
                            self.navigationController?.present(vc, animated: true, completion: nil)

                            
                            
                            //self.displayActivityAlert(title:msgValue)
                            
                        //    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                
                              //  DispatchQueue.delay(.milliseconds(30)) {
                            
                  /* let alert = UIAlertController(title: "", message: msgValue, preferredStyle: UIAlertController.Style.alert)
                            
                            
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: FamilyDetailsViewController.self) || controller.isKind(of: AppointmentsViewController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                            }))
                            
                            
                                self.present(alert, animated: true, completion: nil)
                                */
                           
                      //  }//dispatch
                        }
                    }
                
                    else {
                        //Failed to Schedule Appointment
                        if let msgValue = response?["Message"].stringValue
                        {
                            self.displayActivityAlert(title:msgValue )
                        }
                    }
                }
                }
            })
        }
    
    
    
    
    
    //MARK:- TIME PICKER
    //Disabled Time Picker Functionality
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .none
        dateFormatter1.timeStyle = .short
        
        if timeFlag == 1 {
            self.lblTime1.text = dateFormatter1.string(from: datePicker.date)
        }
        else if timeFlag == 2 {
            self.lblTime2.text = dateFormatter1.string(from: datePicker.date)
        }
        else if timeFlag == 3  {
            self.lblTime3.text = dateFormatter1.string(from: datePicker.date)
        }
        self.datePicker.removeFromSuperview()
        self.toolBar.removeFromSuperview()
    }
    
    @objc func cancelClick() {
        self.datePicker.removeFromSuperview()
        self.toolBar.removeFromSuperview()
    }
    
    func showDatePicker() {
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 216, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.time
        
        // ToolBar
        toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height - (self.datePicker.frame.height + 40), width:self.view.frame.size.width , height: 40))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        toolBar.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        //   doneButton.tintColor = UIColor.white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        //cancelButton.tintColor = UIColor.white
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.view.addSubview(toolBar)
        self.view.addSubview(datePicker)
    }
}

extension Date {
    
    func allDates(till endDate: Date) -> [Date] {
        var date = self
        var array: [Date] = []
        while date <= endDate {
            
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: date)
            if weekDay != 1 {
                array.append(date)
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        return array
    }
}
