//
//  SelectOptionsVC_WN.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 12/09/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class SelectOptionsVC_WN: UIViewController {
    
    
    
    @IBOutlet weak var txtStartDate: UITextField!
    
    @IBOutlet weak var txtEndDate: UITextField!
    
    @IBOutlet weak var lblMemberName: UILabel!
    
    @IBOutlet weak var lblMemberRelation: UILabel!
    
    @IBOutlet weak var btnChangeMember: UIButton!
    
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnDuration: UIButton!
    @IBOutlet weak var btnNursingCount: UIButton!
    
    @IBOutlet weak var stackDailyView: UIStackView!
    
    
    @IBOutlet weak var btnChangePackage: UIButton!
    
    @IBOutlet weak var backViewDuration: UIView!
    @IBOutlet weak var backViewHours: UIView!
    @IBOutlet weak var backViewNA: UIView!
    @IBOutlet weak var backViewMember: UIView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var backViewCategory: UIView!
    @IBOutlet weak var bottomPriceView: UIView!
    @IBOutlet weak var lblNoOfWeekMonth: UILabel!
    
    @IBOutlet weak var txtNumberOfMOnths: UITextField!
    //Stack View
    @IBOutlet weak var stackDateTypeView: UIStackView!
    @IBOutlet weak var stackCategoryView: UIStackView!
    @IBOutlet weak var stackHoursView: UIStackView!
    @IBOutlet weak var stackDurationView: UIStackView!
    @IBOutlet weak var stackNoOfAttendantView: UIStackView!
    @IBOutlet weak var stackReviewBtnView: UIStackView!
    @IBOutlet weak var stackMonthly_MonthView: UIStackView!
    @IBOutlet weak var stackMonthlyDateRangeView: UIStackView!
    
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedDatesStackview: UIStackView!
    
    @IBOutlet weak var heightForCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var circularCollectionView: UIView!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var btnDaily: UIButton!
    
    @IBOutlet weak var btnWeekly: UIButton!
    
    @IBOutlet weak var weeklyBackView: UIView!
    @IBOutlet weak var btnMonthly: UIButton!
    
    //Bottom Price View
    @IBOutlet weak var lblPerDayLabel: UILabel!
    @IBOutlet weak var lblPerDayPrice: UILabel!
    @IBOutlet weak var lblNoOfDays: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var btn12: UIButton!
    
    @IBOutlet weak var btn14: UIButton!
    
    @IBOutlet weak var btn1NA: UIButton!
    @IBOutlet weak var btn2NA: UIButton!
    
    //Category View
    @IBOutlet weak var btnCategory1: UIButton!
    @IBOutlet weak var btnCategory2: UIButton!
    @IBOutlet weak var btnCategory3: UIButton!
    
    @IBOutlet weak var viewCategory1: UIView!
    @IBOutlet weak var viewCategory2: UIView!
    @IBOutlet weak var viewCategory3: UIView!

    @IBOutlet weak var heightCategoryStack: NSLayoutConstraint!
    
    @IBOutlet weak var heightForMonthlyStackView: NSLayoutConstraint!
    
    @IBOutlet weak var lblChangeMember: UILabel!
    @IBOutlet weak var viewBtnCategory2: UIView!
    
    @IBOutlet weak var txtDailyDate: UITextField!
    
    @IBOutlet weak var btnMonthlyMonth: UIButton!
    
    
    @IBOutlet weak var btnNoOfMonth: UIButton!
    
    @IBOutlet weak var vewTxtStrtEndDate: UIView!
    
    @IBOutlet weak var HeightVewTxtStrtEndDate: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblDuration: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblNoOfMonth: NSLayoutConstraint!
    
    @IBOutlet weak var heightBtnNoOfMonth: NSLayoutConstraint!
    
    @IBOutlet weak var heightTxtNoOfMonth: NSLayoutConstraint!
    
    @IBOutlet weak var heightStackMonthlyMonthVew: NSLayoutConstraint!
    
    @IBOutlet weak var heightStackDateTypeVew: NSLayoutConstraint!
    
    @IBOutlet weak var heightStackCategory: NSLayoutConstraint!
    var nursingPackageModelArray = [NusringPackageModel]()
    var selectedCityObject = CityListModel()
    var selectedPersonObj = FamilyDetailsModelHHC()
    var selectedPackage = NusringPackageModel()
    
    var selectedNursingType : NursingType?
    var isPackageSelected = ""
    //For Reschedule
    var isReschedule = false
    var appointmentObject = AppointmentHHCModel()
    
    var isDaily = true
    var selectedPackageObj = NusringPackageModel()
    
    //let monthArray = 1...12
   // let monthArray = ["1", "2", "3","4","5","6","7","8","9","10","11","12"]
    var monthArray = (1...40).map { "\($0)" }

    let pickerView = ToolbarPickerView()
    let dateTimePickerView = ToolbarPickerView()

    var datePicker = UIDatePicker()
    //var selectedCityObject = CityListModel()

    var isDateSelected = false
    var memberObject : FamilyDetailsModelHHC?
    var selectedDateString = ""
    var dateCondition = 1
    
    //var selectedNursingType : NursingType?
    var selectedDurationType : DurationType?
    var selectedHours : String? = ""
    
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
    var cartBarButton = UIBarButtonItem()
    var selectedDateTime : String = ""
    
    
    var country = [String]()
    var timeArray = ["10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM"]
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true

        super.viewDidLoad()
        
        print("in  Select Option : SelectOptionsVC_WN")
        if isReschedule {
            self.selectedPackageObj.PKG_PRICE_MB = self.appointmentObject.PKG_PRICE ?? "0"
        }

        //btnChangeMember.makeRoundedBorderGreenWithWhiteBackground()
        btnReview.makeHHCButton()
        self.btnReview.disabledButton()

        //btnReview.makeRoundedBorderGreenWithWhiteBackground()
        lblChangeMember.textColor = Color.buttonBackgroundGreen.value
        btnHours.makeRoundedBorderGreen()
        btn12.makeRoundedBorderGray()
        btn14.makeRoundedBorderGray()
        
        btn1NA.makeRoundedBorderGray()
        btn2NA.makeRoundedBorderGray()
        
        btnDaily.makeRoundedBorderGray()
        btnWeekly.makeRoundedBorderGray()
        btnMonthly.makeRoundedBorderGray()

        //btnDuration.makeRoundedBorderGreen()
        //btnNursingCount.makeRoundedBorderGreen()
        btnCategory.makeRoundedBorderGreen()

        btnNursingCount.layer.cornerRadius = 10.0
        btnCategory.layer.cornerRadius = 10.0

        //Set Corner Radius For All BackViews
        //backViewDuration.layer.cornerRadius = 10.0
        //backViewNA.layer.cornerRadius = 10.0
        //backViewHours.layer.cornerRadius = 10.0
        //backViewMember.layer.cornerRadius = 10.0
        //backViewCategory.layer.cornerRadius = 10.0
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        lbNavTitle.text = "Select Package"
        self.navigationItem.titleView = lbNavTitle
        
        self.cartBarButton =  UIBarButtonItem(image:UIImage(named: "cartW") , style: .plain, target: self, action: #selector(cartTapped))
        self.cartBarButton.imageInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
        navigationItem.rightBarButtonItem = cartBarButton
    
        //let yearsStr = " (" + (self.selectedPersonObj.AGE ?? "0") + " Years)"
        //lblMemberName.text = (self.selectedPersonObj.PersonName?.capitalized ?? "") + yearsStr
        var yearsStr = ""
        if let years = self.selectedPersonObj.AGE {
            if years == "" || years == "0" {
                yearsStr = " (0 Year)"
                lblMemberName.text = (self.selectedPersonObj.PersonName?.capitalized ?? "") //+ yearsStr
                lblMemberRelation.text = (self.selectedPersonObj.RelationName?.capitalized ?? "") + yearsStr
                
            }
            else {
                let yearsStr = " (" + (self.selectedPersonObj.AGE ?? "0") + " Years)"
                lblMemberName.text = (self.selectedPersonObj.PersonName?.capitalized ?? "") //+ yearsStr
                lblMemberRelation.text = (self.selectedPersonObj.RelationName?.capitalized ?? "") + yearsStr
            }
        }
        
        //bottomPriceView.backgroundColor = Color.buttonBackgroundGreen.value
        self.getPackageListForNursingAttendant()
        
        switch selectedNursingType {
        case .trainedAttendants:

            stackCategoryView.isHidden = true
            stackHoursView.isHidden = false
            stackDurationView.isHidden = false
            stackDurationView.isHidden = false
            stackReviewBtnView.isHidden = false
            stackNoOfAttendantView.isHidden = false
            selectedDatesStackview.isHidden = true
            //self.btnCategory.setTitle("Classic", for: .normal)
            btnWeekly.isHidden = true
            weeklyBackView.isHidden = true
            weeklyBackView.removeFromSuperview()
            break
            
        case .longTerm :
            stackCategoryView.isHidden = false
            stackHoursView.isHidden = false
            stackDurationView.isHidden = false
            stackDurationView.isHidden = false
            stackReviewBtnView.isHidden = false
            stackNoOfAttendantView.isHidden = false
            btnWeekly.isHidden = false
            weeklyBackView.isHidden = false
            selectedDatesStackview.isHidden = true

            self.viewBtnCategory2.isHidden = true
            self.btnCategory2.isHidden = true
            btnCategory1.makeRoundedBorderGray()
            btnCategory3.makeRoundedBorderGray()
            heightCategoryStack.constant = 45

            btnCategory1.setTitle("Classic", for: .normal)
            btnCategory3.setTitle("Specialized", for: .normal)
            btnCategory1.titleLabel?.textAlignment = .center
            btnCategory3.titleLabel?.textAlignment = .center

            break
            
        case .shortTerm :
            stackCategoryView.isHidden = false
            stackHoursView.isHidden = true
            stackDurationView.isHidden = true
            stackDurationView.isHidden = true
            stackReviewBtnView.isHidden = false
            stackNoOfAttendantView.isHidden = true
            stackDailyView.isHidden = true
            selectedDatesStackview.isHidden = true
            
            btnCategory1.makeRoundedBorderGray()
            btnCategory2.makeRoundedBorderGray()
            btnCategory3.makeRoundedBorderGray()
            
            btnCategory1.setTitle("Specialized Nursing Procedures", for: .normal)
            btnCategory2.setTitle("Ascitic Tapping", for: .normal)
            btnCategory3.setTitle("Peritoneal Dialysis", for: .normal)

            btnCategory1.titleLabel?.textAlignment = .center
            btnCategory2.titleLabel?.textAlignment = .center
            btnCategory3.titleLabel?.textAlignment = .center

            //self.btnCategory.setTitle("Specialized Nursing Procedures", for: .normal)
            //self.calculateShortTermPrice(packageId:1)

            self.lblPerDayLabel.text = "Per Visit Price"
            self.lblNoOfDays.text = ""
            self.lblTotalPrice.text = "(₹) "
            self.lblPerDayPrice.text = "(₹) "

            break
            
        case .doctorServices :
            stackCategoryView.isHidden = false
            stackHoursView.isHidden = true
            stackDurationView.isHidden = true
            stackDailyView.isHidden = true
            stackReviewBtnView.isHidden = false
            stackNoOfAttendantView.isHidden = true
            circularCollectionView.isHidden = true
            
            btnCategory1.isHidden = true
            btnCategory3.isHidden = true
            viewCategory1.isHidden = true
            viewCategory3.isHidden = true
            
            btnCategory2.makeRoundedBorderGray()
            btnCategory2.titleLabel?.textAlignment = .center
            btnCategory2.setTitle("Physician/M.B.B.S.", for: .normal)
            heightCategoryStack.constant = 45
            self.lblPerDayLabel.text = "Per Visit Price"
            self.lblNoOfDays.text = ""
            self.lblTotalPrice.text = "(₹) "
            self.lblPerDayPrice.text = "(₹) "

            break
            
        case .physiotherapy :
        if #available(iOS 16.0, *) {
                            navigationItem.rightBarButtonItem?.isHidden = true
                        } else {
                            // Fallback on earlier versions
                            navigationItem.rightBarButtonItem = nil
                        }
            stackCategoryView.isHidden = false
            heightStackCategory.constant = 60
            stackHoursView.isHidden = true
            stackDurationView.isHidden = true
            stackDurationView.isHidden = true
            stackReviewBtnView.isHidden = false
            stackNoOfAttendantView.isHidden = true
            btnWeekly.isHidden = true
            weeklyBackView.isHidden = true
            selectedDatesStackview.isHidden = true
            self.viewBtnCategory2.isHidden = true
            self.btnCategory2.isHidden = true
            
            btnCategory1.makeRoundedBorderGray()
            btnCategory3.makeRoundedBorderGray()
            self.lblNoOfDays.text = ""

            btnCategory1.setTitle("Per Day", for: .normal)
            btnCategory3.setTitle("10 Days", for: .normal)
            btnCategory1.titleLabel?.textAlignment = .center
            btnCategory3.titleLabel?.textAlignment = .center

            //btnReview.disabledButton()
            
            break
        case .postNatelCare :
            stackCategoryView.isHidden = false
            stackHoursView.isHidden = true
            stackDurationView.isHidden = true
            stackDurationView.isHidden = true
            stackReviewBtnView.isHidden = false
            stackNoOfAttendantView.isHidden = true
            selectedDatesStackview.isHidden = true
            btnCategory1.makeRoundedBorderGray()
            btnCategory2.makeRoundedBorderGray()
            btnCategory3.makeRoundedBorderGray()
            
            btnCategory1.setTitle("Per Day", for: .normal)
            btnCategory2.setTitle("15 Days", for: .normal)
            btnCategory3.setTitle("30 Days", for: .normal)
            heightCategoryStack.constant = 45

            btnCategory1.titleLabel?.textAlignment = .center
            btnCategory2.titleLabel?.textAlignment = .center
            btnCategory3.titleLabel?.textAlignment = .center

            

            self.lblPerDayLabel.text = "Package Price"
            self.lblNoOfDays.text = ""
            self.lblTotalPrice.text = "(₹) "
            self.lblPerDayPrice.text = "(₹) "

            break

            

            
        default:
            break
        }
        
        
        //HIDE/UNHIDE Views depend on selected conditions
        switch selectedDurationType {
        case .daily :
            stackDailyView.isHidden = false
            stackMonthly_MonthView.isHidden = true
            stackMonthlyDateRangeView.isHidden = true
        case .weekly:
            stackDailyView.isHidden = true
            //heightForMonthlyStackView.constant = 0
            stackMonthly_MonthView.isHidden = true
            stackMonthlyDateRangeView.isHidden = false
            //stackDateTypeView.isHidden = true
            lblNoOfWeekMonth.text = "No. of Week"
            isDateRange = true //accept dates from range selection
        case .monthly :
            stackDailyView.isHidden = true
            stackMonthly_MonthView.isHidden = false
            stackMonthlyDateRangeView.isHidden = true
            lblNoOfWeekMonth.text = "No. of Month"

        case .noOfDays : //used in physiotherapy-10Days, Post Natal Care-15Days,30 Days
            stackDailyView.isHidden = true
           // heightForMonthlyStackView.constant = 0
            stackMonthly_MonthView.isHidden = true
            stackMonthlyDateRangeView.isHidden = false
            stackDateTypeView.isHidden = true
            lblNoOfWeekMonth.text = "No. of Days"
            txtNumberOfMOnths.text = noOfDays.description
            
            txtNumberOfMOnths.isUserInteractionEnabled = false
            txtNumberOfMOnths.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            isDateRange = true

            break
        default:
            break
        }
        setButtonAppearance(btn: btnMonthlyMonth)
        setButtonAppearance(btn: btnNoOfMonth)
        setButtonAppearance(btn: btnStartDate)
        setButtonAppearance(btn: btnEndDate)
        
        self.txtNumberOfMOnths.inputView = self.pickerView
        self.txtNumberOfMOnths.inputAccessoryView = self.pickerView.toolbar
        
        if selectedNursingType == .physiotherapy || selectedNursingType == .doctorServices 
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
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        //AddDate picker
        txtStartDate.addTarget(self, action: #selector(pickUpDate(_:)), for: .editingDidBegin)
        txtDailyDate.addTarget(self, action: #selector(pickUpDateTime(_:)), for: .editingDidBegin)
        //heightForMonthlyStackView.constant = 0
        stackMonthly_MonthView.isHidden = true
        stackMonthlyDateRangeView.isHidden = true
       // stackDateTypeView.isHidden = true
        self.heightForCollectionView.constant = 0
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

    
    @objc func cartTapped() {
      
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "NursingReviewVC_WN") as! NursingReviewVC_WN
        selectedPackageObj.HHC_NA_HOURS = selectedHours!
        selectedPackageObj.HHC_NA_DURATIONS = (btnDuration.titleLabel?.text) ?? ""
        selectedPackageObj.HHC_NA_NACOUNT = (btnNursingCount.titleLabel?.text) ?? ""
        print("selectedPackageObj: ",selectedPackageObj)
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
                self.selectedPackageObj.numberOfDaysMonths = Int(txtNumberOfMOnths.text!)!
            }
            else {
                self.displayActivityAlert(title: "Please Select Duration")
            }
        }
        
        //This string is for Daily Multiple Date selection string
        //"25/11/2020, 26/11/2020, 27/11/2020"
        selectedPackageObj.packageName = btnCategory.titleLabel?.text ?? ""
        vc.selectedDateStr = self.selectedDateString
        vc.selectedTimePT = self.selectedDateTime
        print(self.selectedPackageObj)
        
        vc.selectedPackageObj = self.selectedPackageObj
        vc.memberObject = self.selectedPersonObj//memberObject
        vc.fromDate = txtStartDate.text!
        vc.endDate = txtEndDate.text!
        vc.dateCondition = self.dateCondition
        vc.selectedNursingType = self.selectedNursingType
        vc.selectedCityObject = self.selectedCityObject
        vc.selectedDurationType = self.selectedDurationType
        vc.isDateRange = isDateRange
        vc.isReschedule = isReschedule
        vc.appointmentObject = self.appointmentObject
        vc.isDataPresent = true
        //bottomConstraint.constant = 0
        self.navigationController?.pushViewController(vc, animated: true)
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
        txtNumberOfMOnths.makeRoundedBorderGreen()
        txtStartDate.makeRoundedBorderGreen()
        txtEndDate.makeRoundedBorderGreen()
        txtDailyDate.makeRoundedBorderGreen()
        
        btn.makeRoundedBorderGreenWithWhiteBackground()
    }
    
    @IBAction func displayCustomMonthPicker(_ sender: UIButton) {
        
        let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"CustomMonthYearPickerVC") as! CustomMonthYearPickerVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.calendarModelArray = self.monthModelArray
        vc.delegateObject = self

        self.navigationController?.present(vc, animated: true, completion: nil)

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
            
        stackMonthly_MonthView.isHidden = true
        stackMonthlyDateRangeView.isHidden = false
        if isDateSelected {
            selectedDatesStackview.isHidden = false
        }
        }
        setBottomPriceView()

    }
    
    
    //MARK:- Set Price
    private func setBottomPriceView() {
        print(selectedPackageObj)
        
        let price = selectedPackageObj.PKG_PRICE_MB.replacingOccurrences(of: ",", with: " ").removeWhitespace()
        let priceStr = price.currencyInputFormatting()
        if btnCategory.titleLabel?.text == "10 Days"{
            selectedPackageObj.numberOfDaysMonths = 10
            var totalPrice = 0.0
            if let priceDouble = Double(price) {
           // let priceDouble = Double(price)!
            totalPrice = priceDouble
            print(selectedPackageObj.numberOfDaysMonths)
                //print(priceDouble)
                totalPrice = Double(selectedPackageObj.numberOfDaysMonths) * priceDouble
                self.selectedPackageObj.totalPrice = Double(totalPrice)

            }
        }else if btnCategory.titleLabel?.text == "15 Days"{
            selectedPackageObj.numberOfDaysMonths = 15
            var totalPrice = 0.0
            if let priceDouble = Double(price) {
           // let priceDouble = Double(price)!
            totalPrice = priceDouble
            print(selectedPackageObj.numberOfDaysMonths)
                //print(priceDouble)
                totalPrice = Double(selectedPackageObj.numberOfDaysMonths) * priceDouble
                self.selectedPackageObj.totalPrice = Double(totalPrice)

            }
        }else if btnCategory.titleLabel?.text == "30 Days"{
            selectedPackageObj.numberOfDaysMonths = 30
            var totalPrice = 0.0
            if let priceDouble = Double(price) {
           // let priceDouble = Double(price)!
            totalPrice = priceDouble
            print(selectedPackageObj.numberOfDaysMonths)
                //print(priceDouble)
                totalPrice = Double(selectedPackageObj.numberOfDaysMonths) * priceDouble
                self.selectedPackageObj.totalPrice = Double(totalPrice)

            }
        }
        print(selectedDurationType)
        switch selectedDurationType {
        case .daily:
           
            
            //Set No Of Labels and Total Price
            if selectedPackageObj.numberOfDaysMonths > 0  {
               
                
                var totalPrice = 0.0
                if let priceDouble = Double(price) {
               // let priceDouble = Double(price)!
                totalPrice = priceDouble
                print(selectedPackageObj.numberOfDaysMonths)
                    //print(priceDouble)
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
                if let noOfMonths = Int(txtNumberOfMOnths.text!.trimmingCharacters(in: .whitespaces)) {
                    self.selectedPackageObj.numberOfDaysMonths = noOfMonths
                    totalPrice = Double(noOfMonths) * priceInt
                }
            }
            
            self.selectedPackageObj.totalPrice = Double(totalPrice)
            self.lblPerDayLabel.text = "Per Week Price"
            self.lblNoOfDays.text = "No. of Week : \(txtNumberOfMOnths.text!)"
            self.lblTotalPrice.text = "(₹) \(totalPrice.description.currencyInputFormatting())"
            self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"

        case .monthly:
            var totalPrice = 0.0
            if let priceInt = Double(price) {
                totalPrice = priceInt
                if let noOfMonths = Int(txtNumberOfMOnths.text!.trimmingCharacters(in: .whitespaces)) {
                    self.selectedPackageObj.numberOfDaysMonths = noOfMonths

                    totalPrice = Double(noOfMonths) * priceInt
                }
            }
            
            self.selectedPackageObj.totalPrice = Double(totalPrice)
            self.lblPerDayLabel.text = "Per Month Price"
            self.lblNoOfDays.text = "No. of Months : \(txtNumberOfMOnths.text!)"
            self.lblTotalPrice.text = "(₹) \(totalPrice.description.currencyInputFormatting())"
            self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"

        default:
            break
        }
       
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
        

        stackMonthly_MonthView.isHidden = false
        stackMonthlyDateRangeView.isHidden = true
        selectedDatesStackview.isHidden = true
        }
        //setBottomPriceView()

    }

    
    private func checkAttendantConditions() {
        switch selectedNursingType {
        case .trainedAttendants:
            guard let strHours = selectedHours else {
                return
            }
            
            if strHours == "" {
                
               // btn2NA.backgroundColor = UIColor.white
               // btn2NA.isUserInteractionEnabled = true
            }
            else if strHours == "12" {
                btn2NA.disabledButton()
            }
            else if strHours == "24" {
                
                if let txtDuration = btnDuration.titleLabel?.text as? String {
                    if txtDuration == "Monthly" {
                        if !btn2NA.isUserInteractionEnabled {
                        btn2NA.makeRoundedBorderGray()
                        }
                        //btn2NA.backgroundColor = UIColor.white
                        //btn2NA.isUserInteractionEnabled = true
                    }
                    else if txtDuration == "Daily" {
                        btn2NA.disabledButton()
                    }
                    else {
                        if !btn2NA.isUserInteractionEnabled {
                        btn2NA.makeRoundedBorderGray()
                        }
                    }
                }
            }
            else {
                btn2NA.backgroundColor = UIColor.white
                btn2NA.isUserInteractionEnabled = true

            }
            
            break
            
        case .longTerm : //LONG TERM
            guard let strHours = selectedHours else {
                return
            }
            
            if strHours == "" || strHours == "24"
            {
               if !btn2NA.isUserInteractionEnabled {
                btn2NA.makeRoundedBorderGray()
                }
            }
            else {
                btn2NA.disabledButton()
            }


            break
            
        case .shortTerm :
            

            break
            
        default:
            break
        }
    }
    
    
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- IBOUTLET_ACTIONS
    @IBAction func btnChangeMemberTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHoursTapped(_ sender: UIButton) {
        if sender.tag == 12 {
            sender.makeRoundedBorderGreen()
            btn14.makeRoundedBorderGray()
            selectedHours = "12"
            self.btn12.setTitle("12", for: .normal)
            //btnHours.setTitle("12", for: .normal)
        }
        else {
            sender.makeRoundedBorderGreen()
            btn12.makeRoundedBorderGray()
            selectedHours = "24"
            self.btn14.setTitle("24", for: .normal)
            //btnHours.setTitle("24", for: .normal)
        }
        //showHoursActionSheet(titleStr: "")
        
        checkAttendantConditions()
        calculatePrice()
    }
    
    //MARK:- DURATION CHANGED
    @IBAction func btnDurationTapped(_ sender: UIButton) {
        //showDurationActionSheet(titleStr: "")
        sender.makeRoundedBorderGreen()

        switch sender.tag {
        case 1: //Daily
            if selectedNursingType == NursingType.longTerm {
            btnWeekly.makeRoundedBorderGray()
            }
            btnMonthly.makeRoundedBorderGray()
            btnDuration.setTitle("Daily", for: .normal)
            stackDailyView.isHidden = false
            stackMonthly_MonthView.isHidden = true
            stackMonthlyDateRangeView.isHidden = true
            //selectedDatesStackview.isHidden = false
            selectedDurationType = .daily

            self.lblPerDayLabel.text = "Per Day Price"
            self.lblNoOfDays.text = "No. of Days :"
            self.lblTotalPrice.text = "(₹)"
            self.lblPerDayPrice.text = "(₹)"

            
        case 2://Weekly
            btnDaily.makeRoundedBorderGray()
            btnMonthly.makeRoundedBorderGray()
            btnDuration.setTitle("Weekly", for: .normal)
            stackDailyView.isHidden = true
            //heightForMonthlyStackView.constant = 0
            stackMonthly_MonthView.isHidden = true
            stackMonthlyDateRangeView.isHidden = false
            selectedDatesStackview.isHidden = true
            selectedDurationType = .weekly
            //stackDateTypeView.isHidden = true
            //isDateRange = true //accept dates from range selection
            
            self.lblPerDayLabel.text = "Per Week Price"
            self.lblNoOfDays.text = "No. of Weeks :"
            self.lblTotalPrice.text = "(₹)"
            self.lblPerDayPrice.text = "(₹)"


        case 3://Monthly
            btnDaily.makeRoundedBorderGray()
            if selectedNursingType == NursingType.longTerm {
            btnWeekly.makeRoundedBorderGray()
            }
            btnDuration.setTitle("Monthly", for: .normal)
            stackDailyView.isHidden = true
            stackMonthly_MonthView.isHidden = false
            isDateRange = true
            stackMonthlyDateRangeView.isHidden = true
            selectedDatesStackview.isHidden = true
            selectedDurationType = .monthly
            self.lblPerDayLabel.text = "Per Month Price"
            self.lblNoOfDays.text = "No. of Months :"
            self.lblTotalPrice.text = "(₹)"
            self.lblPerDayPrice.text = "(₹)"


        default:
            break
        }
        checkAttendantConditions()
        calculatePrice()
    }
    
    //This method will call only for TA & LT
    @IBAction func btnNursingCountTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            sender.makeRoundedBorderGreen()
            btn2NA.makeRoundedBorderGray()
            btnNursingCount.setTitle("1", for: .normal)
            self.btnNursingCount.setTitle("1", for: .normal)
        }
        else {
            sender.makeRoundedBorderGreen()
            btn1NA.makeRoundedBorderGray()
            btnNursingCount.setTitle("2", for: .normal)
            self.btnNursingCount.setTitle("2", for: .normal)
        }
        checkAttendantConditions()
        
        
        calculatePrice()
        //showNurseCountActionSheet(titleStr: "")
    }
    
    //moveToNext variable used for validation purpose.
    //If moveToNext is false then user will not redirect to next screen.
    @IBAction func btnReviewTapped(_ sender: Any) {
        var moveToNext = true
        print("btnReviewTapped: ",btnReviewTapped)
        switch selectedNursingType {
        case .longTerm:
            //Category
            if let txt = btnCategory.titleLabel?.text {
                if txt == "" {
                    moveToNext = false
                    self.displayActivityAlert(title: "Please select category")
                }
            }
            else {
                moveToNext = false
                self.displayActivityAlert(title: "Please select category")

            }
            
            //HOURS
            if let txt = selectedHours {
                if txt == "" {
                    moveToNext = false
                    self.displayActivityAlert(title: "Please select Hours")
                }
            }
            else {
                moveToNext = false
                self.displayActivityAlert(title: "Please select Hours")
            }
            
            //DURATION
            if let txt = btnDuration.titleLabel?.text {
                if txt == "" {
                    moveToNext = false
                    self.displayActivityAlert(title: "Please select Duration")
                }
            }
            else {
                moveToNext = false
                self.displayActivityAlert(title: "Please select Duration")
            }
            
            //NURSING COUNT
            if let txt = btnNursingCount.titleLabel?.text {
                if txt == "" {
                    moveToNext = false
                    self.displayActivityAlert(title: "Please select Nursing Attendant")
                }
            }
            else {
                moveToNext = false
                self.displayActivityAlert(title: "Please select Nursing Attendant")
            }
            
        case .shortTerm:
            if let txt = btnCategory.titleLabel?.text {
                if txt == "" {
                    moveToNext = false
                    
                    self.displayActivityAlert(title: "Please select category")
                }
            }
            else {
                moveToNext = false
                self.displayActivityAlert(title: "Please select category")
                
            }
            if txtDailyDate.text == ""{
                moveToNext = false
                self.displayActivityAlert(title: "Please select date")
            }
            case .trainedAttendants:
                if let txt = selectedHours {
                    if txt == "" {
                        moveToNext = false
                        self.displayActivityAlert(title: "Please select Hours")
                    }
                }
                else {
                    moveToNext = false
                    self.displayActivityAlert(title: "Please select Hours")
                }
                
                if let txt = btnDuration.titleLabel?.text {
                    if txt == "" {
                        moveToNext = false
                        self.displayActivityAlert(title: "Please select Duration")
                    }
                }
                else {
                    moveToNext = false
                    self.displayActivityAlert(title: "Please select Duration")
                }
                
                if let txt = btnNursingCount.titleLabel?.text {
                    if txt == "" {
                        moveToNext = false
                        self.displayActivityAlert(title: "Please select Nursing Attendant")
                    }
                }
                else {
                    moveToNext = false
                    self.displayActivityAlert(title: "Please select Nursing Attendant")
                }
                

            break
            
        case .postNatelCare,.physiotherapy:
            if let txt = btnCategory.titleLabel?.text {
                           if txt == "" {
                               moveToNext = false
                               self.displayActivityAlert(title: "Please select category")
                           }
                       }
                       else {
                           moveToNext = false
                           self.displayActivityAlert(title: "Please select category")

                       }
            

        case .doctorServices:
            print("btnReviewTapped in doctor service")
            break
            
        default:
            break
        }
        
        
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "NursingReviewVC_WN") as! NursingReviewVC_WN
       
        selectedPackageObj.HHC_NA_HOURS = selectedHours!
        selectedPackageObj.HHC_NA_DURATIONS = (btnDuration.titleLabel?.text) ?? ""
        selectedPackageObj.HHC_NA_NACOUNT = (btnNursingCount.titleLabel?.text) ?? ""
        print("selectedPackageObj: ",selectedPackageObj)
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
                self.selectedPackageObj.numberOfDaysMonths = Int(txtNumberOfMOnths.text!)!
            }
            else {
                self.displayActivityAlert(title: "Please Select Duration")
            }
        }
        
        //This string is for Daily Multiple Date selection string
        //"25/11/2020, 26/11/2020, 27/11/2020"
        selectedPackageObj.packageName = btnCategory.titleLabel?.text ?? ""
        print(self.selectedDateString)
        vc.selectedDateStr = self.selectedDateString
        vc.selectedTimePT = self.selectedDateTime
        print(self.selectedDateTime)
        
        
        vc.selectedPackageObj = self.selectedPackageObj
        vc.memberObject = self.selectedPersonObj//memberObject
        vc.fromDate = txtStartDate.text!
        vc.endDate = txtEndDate.text!
        vc.dateCondition = self.dateCondition
        vc.selectedNursingType = self.selectedNursingType
        vc.selectedCityObject = self.selectedCityObject
        vc.selectedDurationType = self.selectedDurationType
        vc.isDateRange = isDateRange
        vc.isReschedule = isReschedule
        vc.appointmentObject = self.appointmentObject
       
        
       

        self.navigationController?.pushViewController(vc, animated: true)
        
        
       // let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "SelectDurationVC_WN") as! SelectDurationVC_WN
//
//        if let txtDuration = btnDuration.titleLabel?.text {
//            if txtDuration.lowercased() == "daily" {
//                vc.selectedDurationType = .daily
//            }
//            else if txtDuration.lowercased() == "monthly"
//            {
//                vc.selectedDurationType = .monthly
//            }
//            else {
//                vc.selectedDurationType = .weekly
//            }
//        }
        
        
        
//        if (selectedNursingType == NursingType.shortTerm) || (selectedNursingType == NursingType.doctorServices) {
//            vc.selectedDurationType = .daily
//        }
//        else if selectedNursingType == NursingType.physiotherapy {
//            if btnCategory.titleLabel?.text == "10 Days" {
//                vc.selectedDurationType = .noOfDays
//                vc.noOfDays = 10
//            }
//            else {
//                vc.selectedDurationType = .daily
//            }
//        }
//        else if selectedNursingType == NursingType.postNatelCare {
//            if btnCategory.titleLabel?.text == "Per Day" {
//                vc.selectedDurationType = .daily
//            }
//            else if btnCategory.titleLabel?.text == "15 Days"  {
//                vc.selectedDurationType = .noOfDays
//                vc.noOfDays = 15
//            }
//            else {
//                vc.selectedDurationType = .noOfDays
//                vc.noOfDays = 30
//            }
//        }
//
//        selectedPackage.packageName = btnCategory.titleLabel?.text ?? ""
//        vc.selectedPackageObj = selectedPackage
//        vc.memberObject = self.selectedPersonObj
//        vc.selectedNursingType = self.selectedNursingType
//        vc.selectedCityObject = selectedCityObject
//        if moveToNext {
//        self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        
    }
    
    
    func calculatePricePT(){
        guard let duration = btnDuration.titleLabel?.text else
        {
            return
        }
        if duration != "" {
            
            let cityArray = self.nursingPackageModelArray.filter({($0.HHC_NA_CITY_MAPP == selectedCityObject.Srno)})
            print(cityArray.count)
            print(cityArray)
            
            let obj = cityArray.filter({($0.packageName == btnDuration.titleLabel?.text!.uppercased())})
            print("obj=\(obj)")
        }
    }
    
    //Calculate price for long Term & TA
    private func calculatePrice() {
        print("Calculate Price...")
        print(nursingPackageModelArray)
        guard let hours = selectedHours else//selectedHours else
        {
            return
        }
        guard let duration = btnDuration.titleLabel?.text else
        {
            return
        }
        
        guard let nursingCount = btnNursingCount.titleLabel?.text else
        {
            return
        }

        if selectedNursingType == NursingType.trainedAttendants {
            //TRAINEE ATTENDANTS
            if hours != "" && duration != "" && nursingCount != "" {
        
        let cityArray = self.nursingPackageModelArray.filter({($0.HHC_NA_CITY_MAPP == selectedCityObject.Srno) && ($0.HHC_NA_HOURS == selectedHours!)})
        print(cityArray.count)
        print(cityArray)
        
        let countArray = cityArray.filter({($0.HHC_NA_NACOUNT == btnNursingCount.titleLabel?.text!)})

        print("Count=\(countArray.count)")
        let obj = countArray.filter({($0.HHC_NA_DURATIONS == btnDuration.titleLabel?.text!.uppercased())})
        print("obj=\(obj)")
        if obj.count > 0 {
            print("Found...")
            self.btnReview.isUserInteractionEnabled = true
            //self.btnReview.makeHHCCircularButton()
            self.btnReview.makeHHCButton()


            selectedPackage = obj[0]
            selectedPackageObj = selectedPackage
           
            
            let price = obj[0].PKG_PRICE_MB
                let priceStr = price.currencyInputFormatting()
                if btnDuration.titleLabel?.text!.lowercased() == "daily" {
                    self.lblPerDayLabel.text = "Per Day Price"
                    self.lblNoOfDays.text = "No. of Days :"
                    self.lblTotalPrice.text = "(₹) \(priceStr)"
                    self.lblPerDayPrice.text = "(₹) \(priceStr)"

                }
                else {
                    self.lblPerDayLabel.text = "Per Month Price"
                    self.lblNoOfDays.text = "No. of Months :"
                    self.lblTotalPrice.text = "(₹) \(priceStr)"
                    self.lblPerDayPrice.text = "(₹) \(priceStr)"

                }
            selectedPackageObj.PKG_PRICE_MB = priceStr
            //setBottomPriceView()
            
            
        }
        else {
            print("Not Found...")
            //uncommenetd 3rd nov
           self.btnReview.disabledButton()
            self.btnReview.isUserInteractionEnabled = false
            self.btnReview.backgroundColor = UIColor.lightGray
        }
        }
        }
        
        else { //LONG TERM
            
            if hours != "" && duration != "" && nursingCount != "" && isPackageSelected != ""{
            print(nursingPackageModelArray)
                let cityArray = self.nursingPackageModelArray.filter({($0.HHC_NA_CITY_MAPP == selectedCityObject.Srno) && ($0.HHC_NA_HOURS == selectedHours!) && ($0.packageName.lowercased() == btnCategory.titleLabel?.text!.lowercased())})
            print(cityArray.count)
            print(cityArray)
            
                let countArray = cityArray.filter({($0.HHC_NA_NACOUNT == btnNursingCount.titleLabel?.text!)})

            print("Count=\(countArray.count)")
            let obj = countArray.filter({($0.HHC_NA_DURATIONS == btnDuration.titleLabel?.text!.uppercased())})
            
            if obj.count > 0 {
                print("Found...",obj[0])
                self.btnReview.isUserInteractionEnabled = true
                //self.btnReview.makeHHCCircularButton()
                self.btnReview.makeHHCButton()


                selectedPackage = obj[0]
                selectedPackageObj = obj[0]
                //print(selectedPackageObj)
                let price = obj[0].PKG_PRICE_MB
                print(price)
                    let priceStr = price.currencyInputFormatting()
                    if btnDuration.titleLabel?.text!.lowercased() == "daily" {
                        self.lblPerDayLabel.text = "Per Day Price"
                        self.lblNoOfDays.text = "No. of Days :"
                        self.lblTotalPrice.text = "(₹) \(priceStr)"
                        self.lblPerDayPrice.text = "(₹) \(priceStr)"
                    }
                    else if btnDuration.titleLabel?.text!.lowercased() == "weekly" {
                        self.lblPerDayLabel.text = "Per Week Price"
                        self.lblNoOfDays.text = "No. of Weeks :"
                        self.lblTotalPrice.text = "(₹) \(priceStr)"
                        self.lblPerDayPrice.text = "(₹) \(priceStr)"
                    }
                    else {
                        self.lblPerDayLabel.text = "Per Month Price"
                        self.lblNoOfDays.text = "No. of Months :"
                        self.lblTotalPrice.text = "(₹) \(priceStr)"
                        self.lblPerDayPrice.text = "(₹) \(priceStr)"
                    }
            }
            else {
                print("Not Found...LT")
                btnReview.disabledButton()
                
                //self.btnReview.isUserInteractionEnabled = false
                //self.btnReview.backgroundColor = UIColor.lightGray
            }
            }
            }
        
    }
    
    
    
    //MARK:- L/S TERM CATEGORY TAPPED
    @IBAction func btnCategoryTapped(_ sender: UIButton) {
        print(selectedNursingType)
    switch selectedNursingType {
    
    case .shortTerm:
        stackDailyView.isHidden = false
            switch sender.tag {
            case 1:
                btnCategory1.makeRoundedBorderGreen()
                btnCategory2.makeRoundedBorderGray()
                btnCategory3.makeRoundedBorderGray()
                self.btnCategory.setTitle("Specialized Nursing Procedures", for: .normal)
                isPackageSelected = "1"

            case 2:
                btnCategory2.makeRoundedBorderGreen()
                btnCategory1.makeRoundedBorderGray()
                btnCategory3.makeRoundedBorderGray()
                self.btnCategory.setTitle("Ascitic Tapping", for: .normal)
                isPackageSelected = "2"

            case 3:
                btnCategory3.makeRoundedBorderGreen()
                btnCategory2.makeRoundedBorderGray()
                btnCategory1.makeRoundedBorderGray()
                self.btnCategory.setTitle("Peritoneal Dialysis", for: .normal)
                isPackageSelected = "3"

            default:
                break
            }
        print(sender.tag)
            self.calculateShortTermPrice(packageId:sender.tag)

    case .longTerm:
        switch sender.tag {
        case 1:
            btnCategory1.makeRoundedBorderGreen()
            btnCategory3.makeRoundedBorderGray()
            self.btnCategory.setTitle("Classic", for: .normal)
            isPackageSelected = "1"

        case 2:
            break
            
        case 3:
            btnCategory3.makeRoundedBorderGreen()
            btnCategory1.makeRoundedBorderGray()
            self.btnCategory.setTitle("Specialized", for: .normal)
            isPackageSelected = "2"

        default:
            break
        }
        
    case .trainedAttendants:
        //No Category In UI
        break
        
    case .doctorServices:
        switch sender.tag {
        case 1:
          break

        case 2:
            btnCategory2.makeRoundedBorderGreen()
            self.btnCategory.setTitle("Physician/M.B.B.S.", for: .normal)
            isPackageSelected = "2"
            
            let filteredArray = self.nursingPackageModelArray.filter({$0.HHC_NA_CITY_MAPP ==  self.selectedCityObject.Srno!})
            if filteredArray.count > 0 {
                self.selectedPackage = filteredArray[0]
                calculateDoctorServicesPrice(packageId:selectedPackage.HHC_PKG_PRICING)
            }
            
            break
            
        case 3:
           break

        default:
            break
        }
    case .physiotherapy:
        
        switch sender.tag {
        case 1:
            btnCategory1.makeRoundedBorderGreen()
            btnCategory3.makeRoundedBorderGray()
            self.btnCategory.setTitle("Per Day", for: .normal)
            isPackageSelected = "1"
            isDateRange = false
            stackMonthly_MonthView.isHidden = true
            stackDateTypeView.isHidden = false
            stackDailyView.isHidden = false

        case 2:
            break
            
        case 3:
            btnCategory3.makeRoundedBorderGreen()
            btnCategory1.makeRoundedBorderGray()
            self.btnCategory.setTitle("10 Days", for: .normal)
            isPackageSelected = "2"
            isDateRange = true
            selectedDurationType = .noOfDays
            stackMonthly_MonthView.isHidden = false
            stackDateTypeView.isHidden = true
            
            heightLblDuration.constant = 0
            heightBtnNoOfMonth.constant = 0
            heightLblNoOfMonth.constant = 0
            heightTxtNoOfMonth.constant = 0
           HeightVewTxtStrtEndDate.constant = 140
            heightStackDateTypeVew.constant = 0
            heightStackMonthlyMonthVew.constant = 140
            stackDailyView.isHidden = true
            txtNumberOfMOnths.text = "10"
            selectedPackageObj.numberOfDaysMonths = 10
            calculateEndDate()

        default:
            break
        }
        
        let filteredArray = self.nursingPackageModelArray.filter({($0.HHC_NA_CITY_MAPP ==  self.selectedCityObject.Srno!)&&($0.packageName.lowercased() == (btnCategory.titleLabel?.text ?? "").lowercased())})
        if filteredArray.count > 0 {
            self.selectedPackage = filteredArray[0]
            calculateDoctorServicesPrice(packageId:selectedPackage.HHC_PKG_PRICING)
            let price = selectedPackage.PKG_PRICE_MB
            self.lblPerDayLabel.text = "Per Visit Price"
            self.lblNoOfDays.text = ""
            self.lblTotalPrice.text = "(₹) \(price.currencyInputFormatting())"
            self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"

            //btnReview.makeHHCCircularButton()
            self.btnReview.makeHHCButton()

        }
        else {
            //uncommenetd 3rd nov
            btnReview.disabledButton()
        }
        
        break
        
    case .postNatelCare :
        switch sender.tag {
        case 1:
            btnCategory1.makeRoundedBorderGreen()
            btnCategory2.makeRoundedBorderGray()
            btnCategory3.makeRoundedBorderGray()
            self.btnCategory.setTitle("Per Day", for: .normal)
            isPackageSelected = "1"
            isDateRange = false
            stackMonthly_MonthView.isHidden = true
            stackDateTypeView.isHidden = false
            stackDailyView.isHidden = false
            

        case 2:
            btnCategory2.makeRoundedBorderGreen()
            btnCategory1.makeRoundedBorderGray()
            btnCategory3.makeRoundedBorderGray()
            self.btnCategory.setTitle("15 Days", for: .normal)
            isPackageSelected = "2"
            isDateRange = true
            selectedDurationType = .noOfDays
            stackMonthly_MonthView.isHidden = false
            stackDateTypeView.isHidden = true
            stackDailyView.isHidden = true
            selectedDatesStackview.isHidden = true
            heightLblDuration.constant = 0
            heightBtnNoOfMonth.constant = 0
            heightLblNoOfMonth.constant = 0
            heightTxtNoOfMonth.constant = 0
            HeightVewTxtStrtEndDate.constant = 140
            heightStackDateTypeVew.constant = 0
            heightStackMonthlyMonthVew.constant = 140
            txtNumberOfMOnths.text = "15"
            selectedPackageObj.numberOfDaysMonths = 15
            calculateEndDate()


        case 3:
            btnCategory3.makeRoundedBorderGreen()
            btnCategory2.makeRoundedBorderGray()
            btnCategory1.makeRoundedBorderGray()
            self.btnCategory.setTitle("30 Days", for: .normal)
            isPackageSelected = "3"
            isDateRange = true
            selectedDurationType = .noOfDays
            stackMonthly_MonthView.isHidden = false
            stackDateTypeView.isHidden = true
            stackDailyView.isHidden = true
            selectedDatesStackview.isHidden = true
            heightLblDuration.constant = 0
            heightBtnNoOfMonth.constant = 0
            heightLblNoOfMonth.constant = 0
            heightTxtNoOfMonth.constant = 0
            HeightVewTxtStrtEndDate.constant = 140
            heightStackDateTypeVew.constant = 0
            heightStackMonthlyMonthVew.constant = 140
            txtNumberOfMOnths.text = "30"
            selectedPackageObj.numberOfDaysMonths = 30
            calculateEndDate()


        default:
            break
        }
        print(nursingPackageModelArray)
        print(selectedCityObject.Srno!)
        print(btnCategory.titleLabel?.text)
        let filteredArray = self.nursingPackageModelArray.filter({($0.HHC_NA_CITY_MAPP ==  self.selectedCityObject.Srno!)&&($0.packageName.lowercased() == (btnCategory.titleLabel?.text ?? "").lowercased())})
        //let filteredArray = self.nursingPackageModelArray.filter({($0.packageName.lowercased() == (btnCategory.titleLabel?.text ?? "").lowercased())})
        if filteredArray.count > 0 {
            self.selectedPackage = filteredArray[0]
            calculateDoctorServicesPrice(packageId:selectedPackage.HHC_PKG_PRICING)
            let price = selectedPackage.PKG_PRICE_MB
            self.lblPerDayLabel.text = "Per Visit Price"
            self.lblNoOfDays.text = ""
            self.lblTotalPrice.text = "(₹) \(price.currencyInputFormatting())"
            self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"
        }
        else {
            self.btnReview.disabledButton()
        }
        
        default:
            break
        }
                
    }

    //Set Long Term Price
    private func calculateShortTermPrice(packageId : Int) {
        let packageObjectArray = nursingPackageModelArray.filter({$0.HHC_PKG_PRICING == packageId.description})
        print(packageObjectArray)
        if packageObjectArray.count > 0 {
            self.btnReview.isUserInteractionEnabled = true
            //self.btnReview.makeHHCCircularButton()
            self.btnReview.makeHHCButton()

            let price = packageObjectArray[0].PKG_PRICE_MB
            
            selectedPackage = packageObjectArray[0]
            selectedPackageObj = packageObjectArray[0]
            self.lblPerDayLabel.text = "Per Visit Price"
            self.lblNoOfDays.text = ""
            self.lblTotalPrice.text = "(₹) \(price.currencyInputFormatting())"
            self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"
        }
    }
    
    private func calculateDoctorServicesPrice(packageId : String) {
           let packageObjectArray = nursingPackageModelArray.filter({$0.HHC_PKG_PRICING == packageId})
           if packageObjectArray.count > 0 {
               
               if txtDailyDate.text != "Select Date"{
                   self.btnReview.isUserInteractionEnabled = true
                   //self.btnReview.makeHHCCircularButton()
                    self.btnReview.makeHHCButton()

                   let price = packageObjectArray[0].PKG_PRICE_MB
                   
                   selectedPackage = packageObjectArray[0]
                   selectedPackageObj = packageObjectArray[0]
                   self.lblPerDayLabel.text = "Per Visit Price"
                   self.lblNoOfDays.text = ""
                   self.lblTotalPrice.text = "(₹) \(price.currencyInputFormatting())"
                   self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"
               }
               else{
                   stackDailyView.isHidden = false
                   
                   let price = packageObjectArray[0].PKG_PRICE_MB
                   selectedPackage = packageObjectArray[0]
                   selectedPackageObj = packageObjectArray[0]
                   self.lblPerDayLabel.text = "Per Visit Price"
                   self.lblNoOfDays.text = ""
                   self.lblTotalPrice.text = "(₹) \(price.currencyInputFormatting())"
                   self.lblPerDayPrice.text = "(₹) \(price.currencyInputFormatting())"
               }
           }
       }
    
}


//MARK:- Nursing Attendant API
extension SelectOptionsVC_WN {
    func getPackageListForNursingAttendant() {
        
        var url = ""
        switch selectedNursingType {
        case .trainedAttendants:
            url = APIEngine.shared.getNursingAttendantPackagesAPI()
        case .longTerm:
            url = APIEngine.shared.getLongTermPackagesAPI()
        case .shortTerm:
            url = APIEngine.shared.getShortTermPackagesAPI()
        case .doctorServices:
            url = APIEngine.shared.getDoctorServicesPackagesAPI()
        case .physiotherapy:
            url = APIEngine.shared.getPhysiotherapyPackagesAPI()
        case .postNatelCare:
            url = APIEngine.shared.getPostNatalCarePackagesAPI()

        default:
            return
        }
        
           print(url)
           ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
               
               if let messageDictionary = response?["message"].dictionary
               {
                   if let status = messageDictionary["Status"]?.bool
                   {
                       if status == true {
                           
                        self.nursingPackageModelArray.removeAll()
                        
                           if let packagesArray = response?["Packages"].arrayValue {
                               
                            if self.selectedNursingType == NursingType.trainedAttendants {
                            for package in packagesArray {
                                let obj = NusringPackageModel.init(HHC_PKG_PRICING: package["HHC_PKG_PRICING"].stringValue, HHC_NA_CITY_MAPP: package["HHC_NA_CITY_MAPP"].stringValue, HHC_NA_HOURS: package["HHC_NA_HOURS"].stringValue, HHC_NA_DURATIONS: package["HHC_NA_DURATIONS"].stringValue, HHC_NA_NACOUNT: package["HHC_NA_NACOUNT"].stringValue, PKG_PRICE_MB: package["PKG_PRICE_MB"].stringValue)
                                
                                self.nursingPackageModelArray.append(obj)
                            }
                                self.calculatePrice()

                            }//TA
                            else if self.selectedNursingType == NursingType.longTerm
                            {
                                for package in packagesArray {
                                    let obj = NusringPackageModel.init(HHC_PKG_PRICING: package["HHC_PKG_PRICING"].stringValue, HHC_NA_CITY_MAPP: package["HHC_LT_CITY_MAPP"].stringValue, HHC_NA_HOURS: package["HHC_LT_HOURS"].stringValue, HHC_NA_DURATIONS: package["HHC_LT_DURATIONS"].stringValue, HHC_NA_NACOUNT: package["HHC_LT_NACOUNT"].stringValue, PKG_PRICE_MB: package["PKG_PRICE_MB"].stringValue,packageName: package["HHC_LT_CATEGORY"].stringValue)
                                    
                                    self.nursingPackageModelArray.append(obj)
                                }
                            }
                            else if self.selectedNursingType == NursingType.doctorServices
                            {
                                for package in packagesArray {
                                    
                                    let obj = NusringPackageModel.init(HHC_PKG_PRICING: package["HHC_PKG_PRICING"].stringValue, HHC_NA_CITY_MAPP: package["HHC_CITY_MAPP_SR_NO"].stringValue, HHC_NA_HOURS: "", HHC_NA_DURATIONS: "", HHC_NA_NACOUNT: "", PKG_PRICE_MB: package["PKG_PRICE_MB"].stringValue, packageName:package["CATEGORY"].stringValue)
                                    
                                    self.nursingPackageModelArray.append(obj)
                                }
                            }
                                else if self.selectedNursingType == NursingType.physiotherapy
                                {
                                    for package in packagesArray {
                                        
                                        let obj = NusringPackageModel.init(HHC_PKG_PRICING: package["HHC_PKG_PRICING"].stringValue, HHC_NA_CITY_MAPP: package["HHC_CITY_MAPP_SR_NO"].stringValue, HHC_NA_HOURS: "", HHC_NA_DURATIONS: "", HHC_NA_NACOUNT: "", PKG_PRICE_MB: package["PKG_PRICE_MB"].stringValue, packageName:package["CATEGORY"].stringValue)
                                        
                                        self.nursingPackageModelArray.append(obj)
                                    }
                                   
                                }
                                else if self.selectedNursingType == NursingType.postNatelCare
                                {
                                    for package in packagesArray {

                                        let obj = NusringPackageModel.init(HHC_PKG_PRICING: package["HHC_PKG_PRICING"].stringValue, HHC_NA_CITY_MAPP: package["HHC_CITY_MAPP_SR_NO"].stringValue, HHC_NA_HOURS: "", HHC_NA_DURATIONS: "", HHC_NA_NACOUNT: "", PKG_PRICE_MB: package["PKG_PRICE_MB"].stringValue, packageName:package["CATEGORY"].stringValue)
                                        
                                        self.nursingPackageModelArray.append(obj)
                                    }
                                }

                            else {
                                for package in packagesArray {
                                    let obj = NusringPackageModel.init(HHC_PKG_PRICING: package["HHC_PKG_PRICING"].stringValue, HHC_NA_CITY_MAPP: package["HHC_LT_CITY_MAPP"].stringValue, HHC_NA_HOURS: package["HHC_LT_HOURS"].stringValue, HHC_NA_DURATIONS: package["HHC_LT_DURATIONS"].stringValue, HHC_NA_NACOUNT: package["HHC_LT_NACOUNT"].stringValue, PKG_PRICE_MB: package["PKG_PRICE_MB"].stringValue)
                                    self.nursingPackageModelArray.append(obj)
                                }
                                //self.calculateShortTermPrice(packageId: 1)
                            }
                            
                            
                           }
                       }
                       else {
                           self.displayActivityAlert(title: m_errorMsg )
                       }
                   }
               }
           }//msgDic
       }
}

//ACTIONSHEET COMMENTED CODE
/*
extension SelectOptionsVC_WN {
    
    private func showDurationActionSheet(titleStr:String) {
        let alert = UIAlertController(title: titleStr, message: "Please Select Duration", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Daily", style: .default , handler:{ (UIAlertAction)in
            self.btnDuration.setTitle("Daily", for: .normal)
            self.lblPerDayLabel.text = "Per Day Price"
            self.lblNoOfDays.text = "No. of Days :"
            self.calculatePrice()
        }))

        if selectedNursingType == NursingType.longTerm {
            alert.addAction(UIAlertAction(title: "Weekly", style: .default , handler:{ (UIAlertAction)in
                self.btnDuration.setTitle("Weekly", for: .normal)
                self.lblPerDayLabel.text = "Per Week Price"
                self.lblNoOfDays.text = "No. of Weeks :"
                self.calculatePrice()
            }))
        }
        
        
        alert.addAction(UIAlertAction(title: "Monthly", style: .default , handler:{ (UIAlertAction)in
            self.btnDuration.setTitle("Monthly", for: .normal)
            self.lblPerDayLabel.text = "Per Month Price"
            self.lblNoOfDays.text = "No. of Months :"
            self.calculatePrice()
        }))

        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))

        self.present(alert, animated: true, completion: {
        })

    }
    
    
    private func showHoursActionSheet(titleStr:String)
    {
        let alert = UIAlertController(title: titleStr, message: "Please Select Hours", preferredStyle: .actionSheet)

              alert.addAction(UIAlertAction(title: "12", style: .default , handler:{ (UIAlertAction)in
                  self.btnHours.setTitle("12", for: .normal)
                self.calculatePrice()
              }))

              alert.addAction(UIAlertAction(title: "24", style: .default , handler:{ (UIAlertAction)in
                  self.btnHours.setTitle("24", for: .normal)
                self.calculatePrice()

              }))


              alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
              }))

              self.present(alert, animated: true, completion: {
              })
    }
    
    private func showNurseCountActionSheet(titleStr:String) {
        let alert = UIAlertController(title: titleStr, message: "Please Select Nursing Attendant", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "1", style: .default , handler:{ (UIAlertAction)in
        self.btnNursingCount.setTitle("1", for: .normal)
            self.calculatePrice()

        }))
        
        alert.addAction(UIAlertAction(title: "2", style: .default , handler:{ (UIAlertAction)in
            if self.selectedHours != "12" && self.btnDuration.titleLabel?.text?.lowercased() != "daily" {
        self.btnNursingCount.setTitle("2", for: .normal)
            }
            else {
                self.btnNursingCount.setTitle("1", for: .normal)
            }
            self.calculatePrice()

        }))
        
        calculatePrice()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }

 private func showLongTermCategoryActionSheet(titleStr:String) {
     let alert = UIAlertController(title: titleStr, message: "Please Select Nursing Category", preferredStyle: .actionSheet)
     
     alert.addAction(UIAlertAction(title: "Classic", style: .default , handler:{ (UIAlertAction)in
     self.btnCategory.setTitle("Classic", for: .normal)

     }))
     
     alert.addAction(UIAlertAction(title: "Specialized", style: .default , handler:{ (UIAlertAction)in
     self.btnCategory.setTitle("Specialized", for: .normal)
     }))
     
     alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
     }))
     
     self.present(alert, animated: true, completion: {
     })
 }
 
 //END LONG TERM
 
 //MARK:- SHORT TERM EXTENSION
 private func shortTermCategoryActionSheet(titleStr:String) {
     let alert = UIAlertController(title: titleStr, message: "Please Select Nursing Category", preferredStyle: .actionSheet)
     
     alert.addAction(UIAlertAction(title: "Specialized Nursing Procedures", style: .default , handler:{ (UIAlertAction)in
     self.btnCategory.setTitle("Specialized Nursing Procedures", for: .normal)
         self.calculateShortTermPrice(packageId:1)
     }))
     
     alert.addAction(UIAlertAction(title: "Ascitic Tapping", style: .default , handler:{ (UIAlertAction)in
     self.btnCategory.setTitle("Ascitic Tapping", for: .normal)
         self.calculateShortTermPrice(packageId:2)

     }))
     
     alert.addAction(UIAlertAction(title: "Peritoneal Dialysis", style: .default , handler:{ (UIAlertAction)in
         self.btnCategory.setTitle("Peritoneal Dialysis", for: .normal)
         self.calculateShortTermPrice(packageId:3)

     }))
     
     alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
     }))
     
     self.present(alert, animated: true, completion: {
     })
 }
}
*/

struct NusringPackageModel {
    var HHC_PKG_PRICING = "" //
    var HHC_NA_CITY_MAPP = ""
    var HHC_NA_HOURS = ""
    var HHC_NA_DURATIONS = ""
    var HHC_NA_NACOUNT = ""
    var PKG_PRICE_MB = ""
    var totalPrice = 0.0
    var numberOfDaysMonths = 0
    
    var packageName = ""
    var cityName = ""
}


//MARK:- MONTHLY
extension SelectOptionsVC_WN : ToolbarPickerViewDelegate {
        
        func didTapDone() {
            if txtNumberOfMOnths.isFirstResponder {
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            self.txtNumberOfMOnths.text = self.monthArray[row]
            self.txtNumberOfMOnths.resignFirstResponder()
                selectedPackageObj.numberOfDaysMonths = Int(txtNumberOfMOnths.text!)!
                
            calculateEndDate()
            }
            else if txtDailyDate.isFirstResponder {
                self.isDateSelected = true
                let row = self.pickerView.selectedRow(inComponent: 0)
                let row1 = self.pickerView.selectedRow(inComponent: 1)
                
                self.pickerView.selectRow(row, inComponent: 0, animated: false)
                
                self.txtDailyDate.text = String(format: " %@ %@ ", self.country[row],self.timeArray[row1])
                
                self.selectedDateString = txtDailyDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)

                btnReview.isUserInteractionEnabled = true
                self.btnReview.backgroundColor = Color.buttonBackgroundGreen.value
                self.txtDailyDate.resignFirstResponder()

            }
    }
    
        func didTapCancel() {
            self.txtNumberOfMOnths.resignFirstResponder()
            self.txtDailyDate.resignFirstResponder()

        }
    }

extension SelectOptionsVC_WN: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtNumberOfMOnths.isFirstResponder {
        return self.monthArray.count
        }
        else {
            if component == 0 {
            return self.country.count
            }
            else {
                return self.timeArray.count
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if txtNumberOfMOnths.isFirstResponder {

        return 1
        }
        return 2

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtNumberOfMOnths.isFirstResponder {

        return self.monthArray[row]
        }
        else {
            if component == 0 {
            return self.country[row]
            }
            else {
                return self.timeArray[row]
            }
        }
    }
    
   

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // self.txtCigarette.text = self.cigratteArray[row]
    }
}

//SELECT START DATE - MONTHLY - SELECT RANGE
extension SelectOptionsVC_WN {
    
    //MARK:- DOB
    @objc func pickUpDate(_ textField : UITextField){
        print("Pickup Date..\(textField)")
        
        //createDatePicker()
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 190))
        self.datePicker.backgroundColor = UIColor.white
        
        
        if txtStartDate.isFirstResponder {
            print("Date")
            if selectedNursingType == NursingType.physiotherapy{
                self.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
            }else{
                self.datePicker.datePickerMode = UIDatePickerMode.date
            }
            //self.datePicker.datePickerStyle = .wheels
            if #available(iOS 13.4, *) {
                             self.datePicker.preferredDatePickerStyle = .wheels
                         } else {
                             // Fallback on earlier versions
                         }
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
            if selectedNursingType == NursingType.physiotherapy{
                dateFormatter1.dateFormat = "dd-MMM-yyyy hh:mm a"
                var selectdatetime = dateFormatter1.string(from: datePicker.date)
                var dateArr = selectdatetime.components(separatedBy: " ")
                txtStartDate.text = String(dateArr[0])
                selectedDateTime = String(format: "%@:%@", dateArr[1] as CVarArg,dateArr[2] as CVarArg)
                
            }else{
                dateFormatter1.dateFormat = "dd-MMM-yyyy"
                txtStartDate.text = dateFormatter1.string(from: datePicker.date)
            }
            
            

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
                if let noOfMonths = Int(txtNumberOfMOnths.text!.trimmingCharacters(in: .whitespaces)) {
                    let endDate = startDate?.addMonthFC(month: noOfMonths)
                    txtEndDate.text = dateFormatter1.string(from: endDate!)
                }
            case .weekly:
                if let noOfWeeks = Int(txtNumberOfMOnths.text!.trimmingCharacters(in: .whitespaces)) {
                    let endDate = startDate?.addWeek(noOfWeeks:noOfWeeks)
                    txtEndDate.text = dateFormatter1.string(from: endDate!)
                }
            case .daily:
                break
                
            case .noOfDays:
                if let noOfDays = Int(txtNumberOfMOnths.text!.trimmingCharacters(in: .whitespaces)) {
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
extension SelectOptionsVC_WN {
    @objc func pickUpDateTime(_ textField : UITextField) {
        //DISPLAY DATE AND TIME PICKER FOR SHORT TERM
        
        //DISPLAY MULTIPLE DATE PICKER FOR LONG AND NA
        
        if selectedNursingType == NursingType.postNatelCare || selectedNursingType == NursingType.longTerm || selectedNursingType == NursingType.trainedAttendants{
            self.view.endEditing(true)
            let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"MultipleDateSelectionCalendarVC") as! MultipleDateSelectionCalendarVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            vc.selectedDateArray = self.selectedDatesArray
            vc.multipleDateDelegateObj = self
            navigationController?.present(vc, animated: true, completion: nil)

        }
        else if selectedNursingType == NursingType.doctorServices{
            self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 190))
            self.datePicker.backgroundColor = UIColor.white

            if txtDailyDate.isFirstResponder {
                print("Date")
               
            }
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
extension SelectOptionsVC_WN : MonthYearProtocol,MultipleDateSelectionProtocol {
    //For Multiple Dates - Daily
    //stringSelectionArray is string with, comma for selected months
    //selectedDatesArray is Date Array for daily selection
    
    func datesSelected(selectedDatesArray: [Date], stringSelectionArray: [String]) {
        self.selectedDatesArray = selectedDatesArray
        isDateSelected = true

        if selectedDatesArray.count > 0 {
        self.selectedDatesStackview.isHidden = false
            self.stringSelectionArray = stringSelectionArray
        }
        else {
            self.selectedDatesStackview.isHidden = true
        }
        self.dateCollectionView.reloadData()
        self.view.layoutIfNeeded()
print(selectedDatesArray)
        self.heightForCollectionView.constant = self.dateCollectionView.contentSize.height + 45.0
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
        self.txtNumberOfMOnths.text = monthCount.description
        self.monthModelArray = monthModelArray
        if stringSelectionArray.count > 0 {
        self.selectedDatesStackview.isHidden = false
        }
        else {
            self.selectedDatesStackview.isHidden = true
        }
        self.stringSelectionArray = stringSelectionArray
        self.dateCollectionView.reloadData()
        setBottomPriceView()
        
        self.view.layoutIfNeeded()
        self.heightForCollectionView.constant = self.dateCollectionView.contentSize.height + 45.0
        
        self.selectedPackageObj.numberOfDaysMonths = monthCount
        
        //initialize for start date and end date parameter for custom multiple monthly picker
        self.firstDayAllMonthString = firstDayAllMonthString
        self.lastDayAllMonthString = lastDayAllMonthString
    }
}

////MARK:- TIME PICKER
//extension SelectDurationVC_WN {
//
//}

//MARK:- TableView Delegate Datasource
extension SelectOptionsVC_WN : UICollectionViewDelegate, UICollectionViewDataSource {

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


//class CellForDateSelection : UICollectionViewCell
//{
//
//    @IBOutlet weak var lblDate: UILabel!
//    
//   
//}

//extension Date {
//    static func dates(from fromDate: Date, to toDate: Date) -> [String] {
//        var dates: [String] = []
//        var date = fromDate
//
//        while date <= toDate {
//            //append date only dd/mm/yyyy format
//            if date.getDay() != "Sun" {
//                let simpleDate = date.getSimpleDateDD_MMM_yyyy()
//                dates.append(simpleDate)
//            }
//            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
//            date = newDate
//        }
//        return dates
//    }
//}
