//
//  SelectDateForDentalVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 02/01/21.
//  Copyright © 2021 Semantic. All rights reserved.
//

import UIKit

class SelectDateForDentalVC: UIViewController,YesNoProtocol,AppointmentConfirmedProtocol {
    
    
    
    //Date 1
    @IBOutlet weak var txtDate1: UITextField!
    @IBOutlet weak var txtTime1: UITextField!
    @IBOutlet weak var backgroundFirst: UIView!
    
    //Date 2
    @IBOutlet weak var txtDate2: UITextField!
    @IBOutlet weak var txtTime2: UITextField!
    @IBOutlet weak var backgroundSecond: UIView!
    
    //Date 3
    @IBOutlet weak var txtDate3: UITextField!
    @IBOutlet weak var txtTime3: UITextField!
    @IBOutlet weak var backgroundThird: UIView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    
    var selectedDate = String()
    var serverDate = Date()
    
    var dateFlag = 0
    var timeFlag = 0
    
    
    var datePicker : UIDatePicker!
    var toolBar = UIToolbar()
    var personDetailsModel = FamilyDetailsModel()
    var selectedHospitalModel = HospitalModel()
    
    //Used this flag on Select Date Screen for Schedule Appointment.
    //Set This Flag From When user coming from family details screen and Appointment screen.
    //set zero from family and set one from schedule appointment
    var isFromFamily = 0
    var selectedAppointmentModel = AppointmentModel()
    
    //MARK:- New Change Oe_Group May 2020
    var memberDetailsModel = PersonCheckupModel()
    var hcPackageDetailsModel = HealthCheckupModel()
    var dateArray = [String]()

    //Date & Time Array
    var datePickerArray = [String]()
    var timeArray = ["10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM"]
    let pickerView = ToolbarPickerView()
    let dateTimePickerView = ToolbarPickerView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Schedule here"
        self.navigationController?.navigationBar.changeFont()
        print("In \(navigationItem.title ?? "") SelectDateForDentalVC")
        ConstantContent.sharedInstance.circularView(view: backgroundFirst)
        ConstantContent.sharedInstance.circularView(view: backgroundSecond)
        ConstantContent.sharedInstance.circularView(view: backgroundThird)
        
        setColor()
        
        self.btnConfirm.layer.cornerRadius = btnConfirm.frame.size.height / 2
     
        self.btnConfirm.dropShadow()

        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        txtDate1.delegate = self
        txtDate2.delegate = self
        txtDate3.delegate = self
        
        getDateArray()
    }
    
    private func setColor()
    {
        txtDate1.textColor = Color.fontColor.value
        txtDate2.textColor = Color.fontColor.value
        txtDate3.textColor = Color.fontColor.value
        
        btnConfirm.backgroundColor = Color.buttonBackgroundGreen.value
    }
    
    private func getDateArray () {
        self.txtDate1.inputView = self.pickerView
        self.txtDate1.inputAccessoryView = self.pickerView.toolbar
        self.txtTime1.inputView = self.pickerView
        self.txtTime1.inputAccessoryView = self.pickerView.toolbar

        self.txtDate2.inputView = self.pickerView
        self.txtDate2.inputAccessoryView = self.pickerView.toolbar
        self.txtTime2.inputView = self.pickerView
        self.txtTime2.inputAccessoryView = self.pickerView.toolbar

        self.txtDate3.inputView = self.pickerView
        self.txtDate3.inputAccessoryView = self.pickerView.toolbar
        self.txtTime3.inputView = self.pickerView
        self.txtTime3.inputAccessoryView = self.pickerView.toolbar
        
        let today = Date().dayAfter
        if let futureDate = Calendar.current.date(byAdding: .day, value: 230, to: Date()) {

        let dateArray1 = Date.dates(from: today, to: futureDate)
            self.datePickerArray = dateArray1
        }

    self.pickerView.dataSource = self
    self.pickerView.delegate = self
    self.pickerView.toolbarDelegate = self

    self.pickerView.reloadAllComponents()
        
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
    
    func didSelectDateFromPicker(date: String,time:String) {
        print(dateArray)
        
        if dateFlag == 1 {
            if dateArray.contains(date) {
                displayActivityAlert(title: "Please Select Different Date")
                    
                    if self.txtDate1.text != "Select Date" {
                        if let index = dateArray.index(of: self.txtDate1.text!) {
                            self.dateArray.remove(at: index)
                        }
                    }
                    
                self.txtDate1.text = "Select Date"
                
            }
            else {
                if let index = dateArray.index(of: self.txtDate1.text!) {
                    self.dateArray.remove(at: index)
                }
                self.dateArray.append(date)
                self.txtDate1.text = date
                self.txtTime1.text = time
            }
        }
        else if dateFlag == 2 {
            selectedDate = date
            if dateArray.contains(date) {
                if self.txtDate2.text != date {

                displayActivityAlert(title: "Please Select Different Date")
                    
                    if self.txtDate2.text != "Select Date" {
                        if let index = dateArray.index(of: self.txtDate2.text!) {
                            self.dateArray.remove(at: index)
                        }
                    }
                    
                self.txtDate2.text = "Select Date"
                }
            }
            else {
                if let index = dateArray.index(of: self.txtDate2.text!) {
                    self.dateArray.remove(at: index)
                }
                self.dateArray.append(date)
                self.txtDate2.text = date
                self.txtTime2.text = time

            }
        }
        else if dateFlag == 3  {
            if dateArray.contains(date) {
                if self.txtDate3.text != date {
                displayActivityAlert(title: "Please Select Different Date")
                    if self.txtDate3.text != "Select Date" {
                        if let index = dateArray.index(of: self.txtDate3.text!) {
                            self.dateArray.remove(at: index)
                        }
                    }
                self.txtDate3.text = "Select Date"
                }
                
            }
            else {
                if let index = dateArray.index(of: self.txtDate3.text!) {
                    self.dateArray.remove(at: index)
                }
                self.dateArray.append(date)
                self.txtDate3.text = date
                self.txtTime3.text = time
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
        //moveToCalendar()
    }
    
    @IBAction func date3Tapped(_ sender: Any) {
        self.dateFlag = 3
        
        //moveToCalendar()
    }
    
    
    
    @IBAction func showCalender(_ sender: Any) {
        self.dateFlag = 1
       // moveToCalendar()
    }
    
    private func moveToCalendar() {
        
    }
    
    /*
     {"PrefDate1":"12/01/2018","PrefTime1":"08:30","PrefDate2":"12/01/2018","PrefTime2":"08:30","PrefDate3":"12/01/2018","PrefTime3":"08:30","GroupName":"TATA COMMUNICATION LIMITED","IsPersonOrFamily":1,"PersonSrNo":"766565","FamilySrNo":"655356","DaigcenterNo":"64","ISRescheduled":"","OldApptInfoSrNo":"","RejtApptSrNo":"","PaidOrNot":"" }
     */
    
    //MARK:- Validation
    @IBAction func confirmDidTapped(_ sender: Any) {
        
        if txtDate1.text == "Select Date" {
            displayActivityAlert(title: "Preferred dates cannot be same ")
        }
            
        else if txtDate2.text == "Select Date"  {
            displayActivityAlert(title: "Preferred dates cannot be same ")
        }
            
        else if txtDate3.text == "Select Date"  {
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
    
    //Call Schedule API - For Dental
    func scheduleAppointment()
    {
        
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
//        for controller in self.navigationController!.viewControllers as Array {
//            print(controller)
//            if controller.isKind(of: AppointmentsViewController.self) || controller.isKind(of: HealthCheckupOptVC.self) {
//                isRefreshAppointment = 1
//                isReloadFamilyDetails = 1
//                self.navigationController!.popToViewController(controller, animated: true)
//                break
//            }
//        }
    }
    
    //MARK:- Send Schedule Data To Server.
    private func sendScheduleAppointmentDataToServer(parameter:NSDictionary) {
        
    }
    
    
    //MARK:- TIME PICKER
    //Disabled Time Picker Functionality
//    @objc func doneClick() {
//        let dateFormatter1 = DateFormatter()
//        dateFormatter1.dateStyle = .none
//        dateFormatter1.timeStyle = .short
//
//        if timeFlag == 1 {
//            self.lblTime1.text = dateFormatter1.string(from: datePicker.date)
//        }
//        else if timeFlag == 2 {
//            self.lblTime2.text = dateFormatter1.string(from: datePicker.date)
//        }
//        else if timeFlag == 3  {
//            self.lblTime3.text = dateFormatter1.string(from: datePicker.date)
//        }
//        self.datePicker.removeFromSuperview()
//        self.toolBar.removeFromSuperview()
//    }
//
//    @objc func cancelClick() {
//        self.datePicker.removeFromSuperview()
//        self.toolBar.removeFromSuperview()
//    }
    

}

//FOR _ CUUSTOM DATE PICKER
extension SelectDateForDentalVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return self.datePickerArray.count
        }
        else {
            return self.timeArray.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       
        return 2

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.datePickerArray[row]
        }
        else {
            return self.timeArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // self.txtCigarette.text = self.cigratteArray[row]
    }
}

//MARK:- Select Date and Time Picker
extension SelectDateForDentalVC : ToolbarPickerViewDelegate,UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDate1 {
            dateFlag = 1
        }
        else if textField == txtDate2 {
            dateFlag = 2
        }
        else {
            dateFlag = 3
        }
    }
    
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        let row1 = self.pickerView.selectedRow(inComponent: 1)
        let selectedDate = datePickerArray[row]
        let selectedTime = timeArray[row1]
        
        didSelectDateFromPicker(date: selectedDate, time: selectedTime)
        self.view.endEditing(true)

        /*
        if txtDate1.isFirstResponder || txtTime1.isFirstResponder {
            txtDate1.text = selectedDate
            txtTime1.text = selectedTime
            self.view.endEditing(true)
        }
        else if txtDate2.isFirstResponder || txtTime2.isFirstResponder{
            txtDate2.text = selectedDate
            txtTime2.text = selectedTime
            self.view.endEditing(true)
        }
        else {
            txtDate3.text = selectedDate
            txtTime3.text = selectedTime
            self.view.endEditing(true)
        }
        */
    }
    
        func didTapCancel() {
            self.view.endEditing(true)
        }
    }
