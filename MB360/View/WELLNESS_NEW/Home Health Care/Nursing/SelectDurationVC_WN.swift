//
//  SelectDurationVC_WN.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 13/09/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
enum DurationType {
    case daily
    case weekly
    case monthly
    case noOfDays
}


//For Multiple Dates - Daily
//stringSelectionArray is string with, comma for selected months
//selectedDatesArray is Date Array for daily selection
//if isDateRange = when user selects dateRange

//For Multiple Months - Monthly
// monthModelArray is model Array for selected months
//stringSelectionArray is string with, comma for selected months


class SelectDurationVC_WN: UIViewController,UICollectionViewDelegateFlowLayout {

    //Top Package Details
    @IBOutlet weak var lblSelectedPackage: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblAttendant: UILabel!
    
    @IBOutlet weak var stackPackageView: UIStackView!
    @IBOutlet weak var stackDailyView: UIStackView!
    @IBOutlet weak var stackMonthly_MonthView: UIStackView!
    @IBOutlet weak var stackMonthlyDateRangeView: UIStackView!
    
    @IBOutlet weak var circularCollectionView: UIView!
    @IBOutlet weak var selectedDatesStackView: UIStackView!
    
    
    @IBOutlet weak var heightForDateCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btnSelectMonth1: UIButton!
    @IBOutlet weak var btnSelectMonth2: UIButton!

    @IBOutlet weak var btnDateRange1: UIButton!
    @IBOutlet weak var btnDateRange2: UIButton!
    
    
    //@IBOutlet weak var btnDailyDate: UIButton!
    
    @IBOutlet weak var btnMonthlyMonth: UIButton!
    
    @IBOutlet weak var btnNoOfMonth: UIButton!
    
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var btnChangePackage: UIButton!
    @IBOutlet weak var viewMonthView2: UIView!
    
    
    //BACKVIEW
    @IBOutlet weak var viewPackageView: UIView!
    @IBOutlet weak var viewDuration: UIView!
    @IBOutlet weak var viewMonthView: UIView!
    
    @IBOutlet weak var lblNoOfWeekMonth: UILabel!
    
    @IBOutlet weak var txtNumberOfMonths: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtDailyDate: UITextField!
    
    
    //Bottom Price View
    @IBOutlet weak var bottomCartView: UIView!
    @IBOutlet weak var lblPerDayLabel: UILabel!
    @IBOutlet weak var lblPerDayPrice: UILabel!
    @IBOutlet weak var lblNoOfDays: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    
    @IBOutlet weak var stackDateTypeView: UIStackView!
    @IBOutlet weak var heightForMonthlyStackView: NSLayoutConstraint!
    
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    @IBOutlet weak var lblChangePackage: UILabel!
    
    @IBOutlet weak var heightForPackageSelection: NSLayoutConstraint!
    var isDaily = true
    var selectedPackageObj = NusringPackageModel()
    
    //let monthArray = 1...12
   // let monthArray = ["1", "2", "3","4","5","6","7","8","9","10","11","12"]
    var monthArray = (1...40).map { "\($0)" }

    let pickerView = ToolbarPickerView()
    let dateTimePickerView = ToolbarPickerView()

    var datePicker = UIDatePicker()
    var selectedCityObject = CityListModel()

    var isDateSelected = false
    var memberObject : FamilyDetailsModelHHC?
    var selectedDateString = ""
    var dateCondition = 1
    
    var selectedNursingType : NursingType?
    var selectedDurationType : DurationType?
    
    //For multiple months selection
    var monthModelArray = [CustomMonthYearModel]()
    var stringSelectionArray = [String]()
    
    //For multiple dates selection
    var selectedDatesArray = [Date]()
    
    
    var isDateRange = false
    var noOfDays = 0
    
    //when user select custom month year picker -> On done click -> set start and end string for API Call
    var firstDayAllMonthString = ""
    var lastDayAllMonthString = ""
    
    //For Reschedule
    var isReschedule = false
    var appointmentObject = AppointmentHHCModel()
    
    var country = [String]()
    var timeArray = ["10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM"]

    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true

        super.viewDidLoad()
        selectedDatesStackView.isHidden = true
        bottomCartView.isHidden = true
        if isReschedule {
            self.selectedPackageObj.PKG_PRICE_MB = self.appointmentObject.PKG_PRICE ?? "0"
            //self.navigationItem.title = "Reschedule Appointments"
            self.navigationItem.title = "Select Duration"
        }else{
            self.navigationItem.title = "Select Duration"
        }
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        if isReschedule{
            //lbNavTitle.text = "Reschedule Appointments"
            lbNavTitle.text = "Select Duration"
        }else{
            lbNavTitle.text = "Select Duration"
        }
        self.navigationItem.titleView = lbNavTitle
        
        print("In \(navigationItem.title ?? "") SelectDurationVC_WN")

        setPackageData()
        //btnChangePackage.makeHHCButton()
        //btnReview.makeHHCCircularButton()
        btnReview.makeHHCButton()
        
        
        //HIDE/UNHIDE Views depend on selected conditions
        switch selectedDurationType {
        case .daily :
            stackDailyView.isHidden = false
            stackMonthly_MonthView.isHidden = true
            stackMonthlyDateRangeView.isHidden = true
        case .weekly:
            stackDailyView.isHidden = true
            heightForMonthlyStackView.constant = 0
            stackMonthly_MonthView.isHidden = true
            stackMonthlyDateRangeView.isHidden = false
           // stackDateTypeView.isHidden = true
            lblNoOfWeekMonth.text = "No. of Week"
            isDateRange = true //accept dates from range selection
        case .monthly :
            stackDailyView.isHidden = true
            stackMonthly_MonthView.isHidden = false
            stackMonthlyDateRangeView.isHidden = true
            lblNoOfWeekMonth.text = "No. of Month"

        case .noOfDays : //used in physiotherapy-10Days, Post Natal Care-15Days,30 Days
            stackDailyView.isHidden = true
            heightForMonthlyStackView.constant = 0
            stackMonthly_MonthView.isHidden = true
            stackMonthlyDateRangeView.isHidden = false
            stackDateTypeView.isHidden = true
            lblNoOfWeekMonth.text = "No. of Days"
            txtNumberOfMonths.text = noOfDays.description
            
            txtNumberOfMonths.isUserInteractionEnabled = false
            txtNumberOfMonths.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            isDateRange = true

            break
        default:
            break
        }
        
        
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn


        //setButtonAppearance(btn: btnDailyDate)
        setButtonAppearance(btn: btnMonthlyMonth)
        setButtonAppearance(btn: btnNoOfMonth)
        setButtonAppearance(btn: btnStartDate)
        setButtonAppearance(btn: btnEndDate)
        
        //viewPackageView.layer.cornerRadius = 10.0
        //viewMonthView.layer.cornerRadius = 10.0
        //viewMonthView2.layer.cornerRadius = 10.0
        //viewDuration.layer.cornerRadius = 10.0
        //circularCollectionView.layer.cornerRadius = 10.0

        self.txtNumberOfMonths.inputView = self.pickerView
        self.txtNumberOfMonths.inputAccessoryView = self.pickerView.toolbar
        
        if selectedNursingType == .physiotherapy || selectedNursingType == .doctorServices || selectedNursingType == .shortTerm
        {
        self.txtDailyDate.inputView = self.pickerView
        self.txtDailyDate.inputAccessoryView = self.pickerView.toolbar
            
            let today = Date().dayAfter
            if let futureDate = Calendar.current.date(byAdding: .day, value: 230, to: Date()) {

            let dateArray = Date.dates(from: today, to: futureDate)
                self.country = dateArray
            }
            self.pickerView.reloadAllComponents()

        }


//        self.pickerView.dataSource = self
//        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        //AddDate picker
        txtStartDate.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        txtDailyDate.addTarget(self, action: #selector(pickUpDateTime(_:)), for: .editingDidBegin)


        //SET BOTTOM PRICE
        switch selectedNursingType {
        case .trainedAttendants:
            if #available(iOS 16.0, *) {
                navigationItem.rightBarButtonItem?.isHidden = true
            } else {
                // Fallback on earlier versions
                navigationItem.rightBarButtonItem = nil
            }
            setBottomPriceView()

        case .longTerm:
            setBottomPriceView()

        case .shortTerm:
            calculateShortTermPrice()

        case .doctorServices :
            calculateShortTermPrice()
            
        case .physiotherapy,.postNatelCare :
            calculateShortTermPrice()

        default:
            break
        }
       
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: self.view.frame.width/2, height: self.view.frame.height/2)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        dateCollectionView.collectionViewLayout = layout


    }
    
    @objc func cartTapped() {
        //let summaryVC : ViewCartMD_VC = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"ViewCartMD_VC") as! ViewCartMD_VC
        
        //menuButton.isHidden = true
        //tabBarController?.tabBar.isHidden = true
       // bottomConstraint.constant = 0
        //self.navigationController?.pushViewController(summaryVC, animated: true)
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "NursingReviewVC_WN") as! NursingReviewVC_WN
        
        vc.isDataPresent = true
        //bottomConstraint.constant = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        print("changed!!")
        let calender: Calendar = Calendar(identifier: .gregorian)
        let weekday = calender.component(.weekday, from: sender.date)
        //sunday
        if weekday == 1 {
            datePicker.setDate(Date(timeInterval: 60*60*24*1, since: sender.date), animated: true)
        } else if weekday == 7 {
            datePicker.setDate(Date(timeInterval: 60*60*24*(-1), since: sender.date), animated: true)
        }
    }

    private func setPackageData() {
        lblChangePackage.textColor = Color.buttonBackgroundGreen.value
        lblChangePackage.isHidden = true
        
        switch selectedNursingType {
        case .trainedAttendants,.longTerm:
            
            heightForPackageSelection.constant = 165.0

            txtDailyDate.text = "Select Date"
            
            if isReschedule {
                lblAttendant.text = "Nursing Attendant : \(appointmentObject.Nursing_COUNT ?? "" )"
                lblHours.text = "Hours : \(appointmentObject.HOURS ?? "" )"
                lblDuration.text = "Duration : \(appointmentObject.DURATIONS?.capitalizingFirstLetter() ?? "")"
                
                if selectedNursingType == NursingType.longTerm {
                lblSelectedPackage.text = "Selected Package : \(appointmentObject.CATEGORY?.capitalizingFirstLetter() ?? "")"
                }
                else {
                lblSelectedPackage.text = "Selected Package : \(appointmentObject.DURATIONS?.capitalizingFirstLetter() ?? "")"
                }
            }
            else {
                lblSelectedPackage.text = "Selected Package : \(selectedPackageObj.packageName)"
                lblAttendant.text = "Nursing Attendant : \(selectedPackageObj.HHC_NA_NACOUNT)"
                lblHours.text = "Hours : \(selectedPackageObj.HHC_NA_HOURS )"
                lblDuration.text = "Duration : \(selectedPackageObj.HHC_NA_DURATIONS.capitalizingFirstLetter())"
            }
            
        case .shortTerm,.doctorServices,.physiotherapy,.postNatelCare:
            heightForPackageSelection.constant = 120.0
            if isReschedule {
                lblHours.text = "\(appointmentObject.CATEGORY ?? "")"
            }
            else {
            lblHours.text = "\(selectedPackageObj.packageName)"
            }
            lblDuration.text = ""
            lblAttendant.text = ""
            if selectedNursingType == NursingType.postNatelCare {
                txtDailyDate.text = "Select Date"
            }
            else {
            txtDailyDate.text = "  Select Date and Time  "
            }
        default:
            break
        }
        
    }
    
    private func calculateShortTermPrice() {
        let price = selectedPackageObj.PKG_PRICE_MB
            self.btnReview.isUserInteractionEnabled = true
            self.btnReview.backgroundColor = Color.buttonBackgroundGreen.value
            
            self.lblPerDayLabel.text = "Per Visit Price"
            self.lblNoOfDays.text = ""
            self.lblTotalPrice.text = "(₹) \(price.currencyInputFormatting())"
            self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"
    }
    
    
    func setButtonAppearance(btn:UIButton) {
        txtNumberOfMonths.makeRoundedBorderGreen()
        txtStartDate.makeRoundedBorderGreen()
        txtEndDate.makeRoundedBorderGreen()
        txtDailyDate.makeRoundedBorderGreen()
        
        btn.makeRoundedBorderGreenWithWhiteBackground()
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var selectedDaysCount = 0
    
    //MARK:- Set Price
    private func setBottomPriceView() {
        let price = selectedPackageObj.PKG_PRICE_MB
        let priceStr = price.currencyInputFormatting()
        
        switch selectedDurationType {
        case .daily:
            self.lblPerDayLabel.text = "Per Day Price"
            self.lblNoOfDays.text = "No. of Days :"
            self.lblPerDayPrice.text = "(₹) \(priceStr)"
            self.lblTotalPrice.text = "(₹)"
            
            //Set No Of Labels and Total Price
            if selectedPackageObj.numberOfDaysMonths > 0  {
                self.lblNoOfDays.text = "No. of Days :\(selectedPackageObj.numberOfDaysMonths.description)"
                
                var totalPrice = 0.0
                if let priceDouble = Double(price) {
                    totalPrice = priceDouble
                    totalPrice = Double(selectedPackageObj.numberOfDaysMonths) * priceDouble
                    self.lblTotalPrice.text = "(₹) \(totalPrice.description)"
                    self.selectedPackageObj.totalPrice = Double(totalPrice)

                }
                
            }
            else {
                self.lblTotalPrice.text = "(₹) \(priceStr)"
            }

            
            
//            if isDateRange {
//
//            }
//            else {
//
//            }

        case .weekly: //WEEKLY
            var totalPrice = 0.0
            if let priceInt = Double(price) {
                totalPrice = priceInt
                if let noOfMonths = Int(txtNumberOfMonths.text!.trimmingCharacters(in: .whitespaces)) {
                    self.selectedPackageObj.numberOfDaysMonths = noOfMonths
                    totalPrice = Double(noOfMonths) * priceInt
                }
            }
            
            self.selectedPackageObj.totalPrice = Double(totalPrice)
            self.lblPerDayLabel.text = "Per Week Price"
            self.lblNoOfDays.text = "No. of Week : \(txtNumberOfMonths.text!)"
            self.lblTotalPrice.text = "(₹) \(totalPrice.description.currencyInputFormatting())"
            self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"

        case .monthly:
            var totalPrice = 0.0
            if let priceInt = Double(price) {
                totalPrice = priceInt
                if let noOfMonths = Int(txtNumberOfMonths.text!.trimmingCharacters(in: .whitespaces)) {
                    self.selectedPackageObj.numberOfDaysMonths = noOfMonths

                    totalPrice = Double(noOfMonths) * priceInt
                }
            }
            
            self.selectedPackageObj.totalPrice = Double(totalPrice)
            self.lblPerDayLabel.text = "Per Month Price"
            self.lblNoOfDays.text = "No. of Months : \(txtNumberOfMonths.text!)"
            self.lblTotalPrice.text = "(₹) \(totalPrice.description.currencyInputFormatting())"
            self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"

        default:
            break
        }
       
    }
    
    
    @IBAction func numberOfMonthTapped(_ sender: Any) {
      

    }
    
    @IBAction func changePackageTapped(_ sender: UIButton) {
       // self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Radio Button Tapped
    @IBAction func displaySelectMonthView(_ sender: Any) {
        print("Display Month View")
        if isDateRange { //To handle when user tap multiple time on radio button

        dateCondition = 2
        isDateRange = false
        isDateSelected = false
            
            //Clear All previous selection when user change condition from no of month to monthly month selection
            self.selectedDatesArray.removeAll()
            self.selectedDateString = ""
            self.monthModelArray.removeAll()
            
        stackMonthly_MonthView.isHidden = false
        stackMonthlyDateRangeView.isHidden = true
        if isDateSelected {
            selectedDatesStackView.isHidden = false
        }
        }
        setBottomPriceView()

    }
    
    @IBAction func displayDateRangeView(_ sender: Any) {
        print("Display Date Range View")
        if !isDateRange { //To handle when user tap multiple time on radio button
        dateCondition = 3
        isDateRange = true
        isDateSelected = false
            
            //Clear All previous selection when user change condition from no of month to monthly month selection
            self.selectedDatesArray.removeAll()
            self.selectedDateString = ""
            self.monthModelArray.removeAll()
            txtStartDate.text = "Start Date"
            txtEndDate.text = "End Date"
        

        stackMonthly_MonthView.isHidden = true
        stackMonthlyDateRangeView.isHidden = false
        selectedDatesStackView.isHidden = true
        }
        setBottomPriceView()

    }
    
    //MARK:- Submit Tapped
    @IBAction func btnReviewTapped(_ sender: Any) {
        
        //Validation for Date Range
//        if isDateRange {
//
//        }
//        else {
//
//        }
        
        //Validation For No Of Weeks And No Of Months
        
        
        if isDateSelected {
            
            switch selectedDurationType {
            case .daily:
                break
            case .weekly:
                break
            case .monthly:
                break
            default:
                break
            }
            
            let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "NursingReviewVC_WN") as! NursingReviewVC_WN
            vc.selectedPackageObj = self.selectedPackageObj
            vc.memberObject = memberObject
            vc.fromDate = txtStartDate.text!
            vc.endDate = txtEndDate.text!
            vc.dateCondition = self.dateCondition
            vc.selectedNursingType = self.selectedNursingType
            vc.selectedCityObject = self.selectedCityObject
            vc.selectedDurationType = self.selectedDurationType
            vc.isDateRange = isDateRange
            vc.isReschedule = isReschedule
            vc.appointmentObject = self.appointmentObject
            
            //handle for month and week count selection
            //isDateRange is always true for weekly selection
            if !isDateRange {
            if stringSelectionArray.count > 0 {
                var formattedArrayString = ""
                if selectedDurationType == DurationType.daily {
                    //For Dates
                   //Append 05-Dec-2020
                 formattedArrayString = (self.stringSelectionArray.map{String($0.description.getStrDateEnrollment())}).joined(separator: ", ")
                }
                else {
                    //For Months
                     formattedArrayString = (self.stringSelectionArray.map{String($0.description)}).joined(separator: ", ")
                }
                
                self.selectedDateString = formattedArrayString
                self.selectedPackageObj.numberOfDaysMonths = stringSelectionArray.count
                
                //For Monthly Month selection
                vc.fromDate = firstDayAllMonthString
                vc.endDate = lastDayAllMonthString
            }
            }
            else {
                if txtStartDate.text != "Start Date" {
                self.selectedDateString = String(format: "%@ to %@", txtStartDate.text!, txtEndDate.text!)
                    self.selectedPackageObj.numberOfDaysMonths = Int(txtNumberOfMonths.text!)!
                }
                else {
                    self.displayActivityAlert(title: "Please Select Duration")
                }
            }
            
            //This string is for Daily Multiple Date selection string
            //"25/11/2020, 26/11/2020, 27/11/2020"
            vc.selectedDateStr = self.selectedDateString
            

            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            self.displayActivityAlert(title: "Please Select Duration")
        }
    }
    
    @IBAction func displayCustomMonthPicker(_ sender: UIButton) {
        
        let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"CustomMonthYearPickerVC") as! CustomMonthYearPickerVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.calendarModelArray = self.monthModelArray
        vc.delegateObject = self

        self.navigationController?.present(vc, animated: true, completion: nil)

    }
    
}


//MARK:- MONTHLY
extension SelectDurationVC_WN : ToolbarPickerViewDelegate {
        
        func didTapDone() {
            if txtNumberOfMonths.isFirstResponder {
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            self.txtNumberOfMonths.text = self.monthArray[row]
            self.txtNumberOfMonths.resignFirstResponder()

            calculateEndDate()
            }
            else if txtDailyDate.isFirstResponder {
                self.isDateSelected = true
                let row = self.pickerView.selectedRow(inComponent: 0)
                let row1 = self.pickerView.selectedRow(inComponent: 1)
                
                self.pickerView.selectRow(row, inComponent: 0, animated: false)
                
                self.txtDailyDate.text = String(format: " %@ %@ ", self.country[row],self.timeArray[row1])
                
                self.selectedDateString = txtDailyDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)

                self.txtDailyDate.resignFirstResponder()

            }
    }
    
        func didTapCancel() {
            self.txtNumberOfMonths.resignFirstResponder()
            self.txtDailyDate.resignFirstResponder()

        }
    }

//extension SelectDurationVC_WN: UIPickerViewDataSource, UIPickerViewDelegate {
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if txtNumberOfMonths.isFirstResponder {
//        return self.monthArray.count
//        }
//        else {
//            if component == 0 {
//            return self.country.count
//            }
//            else {
//                return self.timeArray.count
//            }
//        }
//    }
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        if txtNumberOfMonths.isFirstResponder {
//
//        return 1
//        }
//        return 2
//
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if txtNumberOfMonths.isFirstResponder {
//
//        return self.monthArray[row]
//        }
//        else {
//            if component == 0 {
//            return self.country[row]
//            }
//            else {
//                return self.timeArray[row]
//            }
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        // self.txtCigarette.text = self.cigratteArray[row]
//    }
//}

//SELECT START DATE - MONTHLY - SELECT RANGE
extension SelectDurationVC_WN {
    
    //MARK:- DOB
    @objc func pickUpDate(_ textField : UITextField){
        print("Pickup Date..\(textField)")
        
        //createDatePicker()
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 190))
        self.datePicker.backgroundColor = UIColor.white
        
        if txtStartDate.isFirstResponder {
            print("Date")
            self.datePicker.datePickerMode = UIDatePickerMode.date
            self.datePicker.minimumDate = Date().dayAfter
            txtStartDate.inputView = self.datePicker
            // self.txtDob.inputAccessoryView = self.datePicker.toolbar
            
        }
       
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = self.hexStringToUIColor(hex: hightlightColor)
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        if txtStartDate.isFirstResponder {
            txtStartDate.inputAccessoryView = toolBar
        }
     
    }
    
    @objc func doneClick() {
        if txtStartDate.isFirstResponder {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .short
            dateFormatter1.timeStyle = .none
            dateFormatter1.dateFormat = "dd-MMM-yyyy"
            txtStartDate.text = dateFormatter1.string(from: datePicker.date)

            calculateEndDate()
            txtStartDate.resignFirstResponder()
        }
    }
    
    private func calculateEndDate() {
        if txtStartDate.text!.trimmingCharacters(in: .whitespaces) != "" && txtStartDate.text! != "Start Date" {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .short
            dateFormatter1.timeStyle = .none
            dateFormatter1.dateFormat = "dd-MMM-yyyy"
            
            let startDate = dateFormatter1.date(from: txtStartDate.text!)
            
            
            switch selectedDurationType {
            case .monthly:
                if let noOfMonths = Int(txtNumberOfMonths.text!.trimmingCharacters(in: .whitespaces)) {
                    let endDate = startDate?.addMonthFC(month: noOfMonths)
                    txtEndDate.text = dateFormatter1.string(from: endDate!)
                }
            case .weekly:
                if let noOfWeeks = Int(txtNumberOfMonths.text!.trimmingCharacters(in: .whitespaces)) {
                    let endDate = startDate?.addWeek(noOfWeeks:noOfWeeks)
                    txtEndDate.text = dateFormatter1.string(from: endDate!)
                }
            case .daily:
                break
                
            case .noOfDays:
                if let noOfDays = Int(txtNumberOfMonths.text!.trimmingCharacters(in: .whitespaces)) {
                    let endDate = startDate?.addDays(noOfDays: noOfDays)
                    txtEndDate.text = dateFormatter1.string(from: endDate!)
                }

            default:
                break
            }

            setBottomPriceView()

            isDateSelected = true
            self.selectedDateString = "\(txtStartDate.text!) To \(txtEndDate.text!)"
        }
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
        
}

//MARK:- SHORT TERM DAILY DATE
extension SelectDurationVC_WN {
    @objc func pickUpDateTime(_ textField : UITextField) {
        //DISPLAY DATE AND TIME PICKER FOR SHORT TERM
        
        //DISPLAY MULTIPLE DATE PICKER FOR LONG AND NA
        
        if selectedNursingType == NursingType.postNatelCare || selectedNursingType == NursingType.longTerm || selectedNursingType == NursingType.trainedAttendants /*|| selectedNursingType == NursingType.shortTerm */|| selectedNursingType == NursingType.physiotherapy{
            self.view.endEditing(true)
            let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"MultipleDateSelectionCalendarVC") as! MultipleDateSelectionCalendarVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            vc.selectedDateArray = self.selectedDatesArray
            vc.multipleDateDelegateObj = self
            navigationController?.present(vc, animated: true, completion: nil)

        }
        else {
        
         //createDatePicker()
         // DatePicker
         self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 190))
         self.datePicker.backgroundColor = UIColor.white

         if txtDailyDate.isFirstResponder {
             print("Date")
             if #available(iOS 13.4, *) {
                 self.datePicker.preferredDatePickerStyle = .wheels
             } else {
                 // Fallback on earlier versions
             }
            self.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
             self.datePicker.minimumDate = Date()
            self.datePicker.minuteInterval = 10
        
            let cal = Calendar.current
            let now = Date()  // get the current date and time (2018-03-27 19:38:44)
            let components = cal.dateComponents([.day, .month, .year], from: now)  // extract the date components 28, 3, 2018
            let today = cal.date(from: components)!  // build another Date value just with date components, without the time (2018-03-27 00:00:00)
            datePicker.minimumDate = today.addingTimeInterval(60 * 60 * 9)  // adds 9h
            datePicker.maximumDate = today.addingTimeInterval(60 * 60 * 21) // adds 21h

            let dateComponentsMax = cal.dateComponents([.day, .month, .year], from: Date().addMonthFC(month: 11))
            let maxDate = Calendar.current.date(from: dateComponentsMax)

            datePicker.maximumDate = maxDate?.addingTimeInterval(60 * 60 * 21) // adds 21h

            

            txtDailyDate.inputView = self.datePicker
             
             // ToolBar
                     let toolBar = UIToolbar()
                     toolBar.barStyle = .default
                     
                     toolBar.barStyle = UIBarStyle.default
                     toolBar.isTranslucent = true
                     toolBar.tintColor = self.hexStringToUIColor(hex: hightlightColor)
                     toolBar.sizeToFit()
                     // Adding Button ToolBar
                     let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClickDatTime))
                     let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                     let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
                     toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
                     toolBar.isUserInteractionEnabled = true
                     
                     if txtDailyDate.isFirstResponder {
                         txtDailyDate.inputAccessoryView = toolBar
                     }
             
         }
        }
    }
//         func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return 10.0
//        }
//
//         func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 10.0
//        }
         
        

    
    
        @objc func doneClickDatTime() {
            if txtDailyDate.isFirstResponder {
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateStyle = .short
                dateFormatter1.timeStyle = .none
                dateFormatter1.dateFormat = "dd-MMM-yyyy hh:mm a"
                txtDailyDate.text = String(format: "  %@  ", dateFormatter1.string(from: datePicker.date))
                
                isDateSelected = true
                self.selectedDateString = txtDailyDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                calculateEndDate()
                txtDailyDate.resignFirstResponder()
            }
        }
    }
    

//MARK:- Custom Calendar Protocol
extension SelectDurationVC_WN : MonthYearProtocol,MultipleDateSelectionProtocol {
    //For Multiple Dates - Daily
    //stringSelectionArray is string with, comma for selected months
    //selectedDatesArray is Date Array for daily selection
    
    func datesSelected(selectedDatesArray: [Date], stringSelectionArray: [String]) {
        self.selectedDatesArray = selectedDatesArray
        isDateSelected = true

        if selectedDatesArray.count > 0 {
        self.selectedDatesStackView.isHidden = false
            self.stringSelectionArray = stringSelectionArray
        }
        else {
            self.selectedDatesStackView.isHidden = true
        }
        self.dateCollectionView.reloadData()
        self.view.layoutIfNeeded()

        self.heightForDateCollectionView.constant = self.dateCollectionView.contentSize.height + 45.0
        self.selectedPackageObj.numberOfDaysMonths = selectedDatesArray.count
        setBottomPriceView()

    }
    
    //For Multiple Months - Monthly
    // monthModelArray is model Array for selected months
    //stringSelectionArray is string for selected months
    func monthsSelected(monthString: String, monthCount: Int, monthModelArray: [CustomMonthYearModel], stringSelectionArray: [String], firstDayAllMonthString:String,lastDayAllMonthString:String)
    {
        isDateSelected = true
        self.selectedDateString = monthString
        self.txtNumberOfMonths.text = monthCount.description
        self.monthModelArray = monthModelArray
        if stringSelectionArray.count > 0 {
        self.selectedDatesStackView.isHidden = false
        }
        else {
            self.selectedDatesStackView.isHidden = true
        }
        self.stringSelectionArray = stringSelectionArray
        self.dateCollectionView.reloadData()
        setBottomPriceView()
        
        self.view.layoutIfNeeded()
        self.heightForDateCollectionView.constant = self.dateCollectionView.contentSize.height + 45.0
        
        self.selectedPackageObj.numberOfDaysMonths = monthCount
        
        //initialize for start date and end date parameter for custom multiple monthly picker
        self.firstDayAllMonthString = firstDayAllMonthString
        self.lastDayAllMonthString = lastDayAllMonthString
    }
}

//MARK:- TIME PICKER
extension SelectDurationVC_WN {
    
}

//MARK:- TableView Delegate Datasource
extension SelectDurationVC_WN : UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if selectedNursingType == NursingType.trainedAttendants {
           // if btnc
       // }
        
    return stringSelectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForDateSelection", for: indexPath) as! CellForDateSelection
        if selectedDurationType == DurationType.daily {
        cell.lblDate.text = stringSelectionArray[indexPath.row].getStrDateEnrollment()
        }
        else {
        cell.lblDate.text = stringSelectionArray[indexPath.row]
        }
        return cell
    }
    
}


class CellForDateSelection : UICollectionViewCell
{

    @IBOutlet weak var lblDate: UILabel!
    
   
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [String] {
        var dates: [String] = []
        var date = fromDate

        while date <= toDate {
            //append date only dd/mm/yyyy format
            if date.getDay() != "Sun" {
                let simpleDate = date.getSimpleDateDD_MMM_yyyy()
                dates.append(simpleDate)
            }
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
