//
//  NursingReviewVC_WN.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 13/09/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class NursingReviewVC_WN: UIViewController,RemarkSavedProtocol, AppointmentConfirmedProtocol {
    
    
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblHrs: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblDur: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblNursingAttendants: UILabel!
    
    @IBOutlet weak var NursingAttendants: UILabel!
    @IBOutlet weak var lblSelectedDurationLbl: UILabel!
    
    @IBOutlet weak var lblMemberName: UILabel!
    
    @IBOutlet weak var lblMemerRelation: UILabel!
    @IBOutlet weak var lblSelectedDuration: UILabel!
    
    @IBOutlet weak var lblSelectedCategory: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblNoOfMonth: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblNoOfMonthLbl: UILabel!
    
    @IBOutlet weak var lblNrs: UILabel!
    @IBOutlet weak var btnAddRemarks: UIButton!
    @IBOutlet weak var btnSchedule: UIButton!
    
    @IBOutlet weak var stackTrainesAttendant: UIStackView!
    @IBOutlet weak var termStackView: UIStackView!
    @IBOutlet weak var stackBackView: UIView!
    @IBOutlet weak var traineeAttendantStackView: UIStackView!
    @IBOutlet weak var lblTermPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var backViewCity: UIView!
    
    //BackView
    @IBOutlet weak var backView1: UIView!
    @IBOutlet weak var backView2: UIView!
    @IBOutlet weak var backView3: UIView!
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var termPackBackView: UIView!
    
    @IBOutlet weak var txtAddRemarks: UITextField!
    
    @IBOutlet weak var vewMain: UIView!
    
    @IBOutlet weak var heightLblHrs: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblHours: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblDur: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblDuration: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblNursingLbl: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblNursing: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblmnths: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblMonths: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblCategory: NSLayoutConstraint!
    
    @IBOutlet weak var heightLblSelectedCategory: NSLayoutConstraint!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    //heightConstraints
    @IBOutlet weak var BottomConstraintPackageLbl: NSLayoutConstraint!

    @IBOutlet weak var BottomConstraintCategoryLbl: NSLayoutConstraint!

    @IBOutlet weak var BottomConstraintHoursLbl: NSLayoutConstraint!
    
    @IBOutlet weak var BottomConstraintDurationLbl: NSLayoutConstraint!
    
    @IBOutlet weak var TopConstraintNursingAttLbl: NSLayoutConstraint!
    
    @IBOutlet weak var BottomConstraintNursingAttLbl: NSLayoutConstraint!
   
    @IBOutlet weak var heightVewMain: NSLayoutConstraint!
    
    @IBOutlet weak var pkgRateBottomBorder: UIView!
    @IBOutlet weak var noOfDaysBottomBorder: UIView!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var vewEmpty: UIView!
    
    @IBOutlet weak var btnBookNow: UIButton!
    
    var selectedPackageObj = NusringPackageModel()
    var memberObject : FamilyDetailsModelHHC?
    var selectedCityObject = CityListModel()
    var selectedDurationType : DurationType?
    
    var selectedNursingType : NursingType?
    
    var selectedDateStr = ""
    var remarks = ""
    var dateCondition = 0 //0 for month year
    var fromDate = ""
    var endDate = ""
    //Selected month array for long term 'Monthly' multiple month selection
    var selectedMonthArray = [String]()
    var isDateRange = false //set true if user has selected dateRange from to toDate.
    var hideCitySelection = false
    
    //For Reschedule API
    var RejtApptSrNo = "-1" //not used pass every time -1
    var RescSrNo = "0" //
    var ISRescheduled = "0" //0-schedule, 1-reschedule
    
    //For Reschedule
    var isReschedule = false
    var appointmentObject = AppointmentHHCModel()
    var diabetsPackageAmt = ""
    var isDataPresent : Bool = true
    var selectedTimePT : String = ""

    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true
        super.viewDidLoad()
        //btnConfirm.layer.cornerRadius = 10.0
        if isDataPresent{
            vewMain.alpha = 1
            vewEmpty.alpha = 0
        }else{
            vewMain.alpha = 0
            vewEmpty.alpha = 1
            btnBookNow.backgroundColor = Color.buttonBackgroundGreen.value
            btnBookNow.makeHHCCircularButton()
        }
        btnConfirm.makeHHCCircularButton()
        self.btnConfirm.disabledButton()
        txtAddRemarks.layer.borderColor = UIColor.gray.cgColor
        txtAddRemarks.layer.borderWidth = 0.5
        if isReschedule {
            ISRescheduled = "1"
            RescSrNo = appointmentObject.APPT_INFO_SR_NO ?? ""
            self.selectedPackageObj.HHC_PKG_PRICING = appointmentObject.SELECTED_PKG_SR_NO ?? ""
        }
        
        btnSchedule.makeHHCButton()
        btnAddRemarks.makeHHCButton()
        self.navigationItem.title = "Summary"
        print("In \(navigationItem.title ?? "") NursingReviewVC_WN")

        //backView1.layer.cornerRadius = 10.0
        //backView2.layer.cornerRadius = 10.0
        //backView3.layer.cornerRadius = 10.0
        //termPackBackView.layer.cornerRadius = 10.0
        //backViewCity.layer.cornerRadius = 10.0
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
       
            lbNavTitle.text = "Summary"
       
        self.navigationItem.titleView = lbNavTitle
        
        vewMain.customDropShadow()

        
        setData()
        print(memberObject)
        var yearsStr = ""
        if let years = self.memberObject?.AGE {
            if years == "" || years == "0" {
                yearsStr = " (0 Year)"
                lblMemberName.text = (self.memberObject?.PersonName?.capitalized ?? "") //+ yearsStr
                lblMemerRelation.text = (self.memberObject?.RelationName?.capitalized ?? "") + yearsStr
                lblAddress.text = "Address:\(self.memberObject?.IS_ADDRESS_SAVED)"
            }
            else {
                let yearsStr = " (" + (self.memberObject?.AGE ?? "0") + " Years)"
                lblMemberName.text = (self.memberObject?.PersonName?.capitalized ?? "") //+ yearsStr
                lblMemerRelation.text = (self.memberObject?.RelationName?.capitalized ?? "") + yearsStr
                lblAddress.text = "Address:\(self.memberObject?.IS_ADDRESS_SAVED)"
            }
        }

    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Remark delegate
    func remarkSaved(remarkStr:String)
    {
        self.remarks = remarkStr
    }
    
    private func setData() {
        if isReschedule {
            cityName.text = appointmentObject.APPT_LOCATION ?? ""
            lblMemberName.text = appointmentObject.APPNT_PERSON ?? ""
        }
        else {
            cityName.text = selectedCityObject.City ?? ""
            lblMemberName.text = memberObject?.PersonName?.capitalized ?? ""
        }
        
        lblRate.text = "₹\(selectedPackageObj.PKG_PRICE_MB.currencyInputFormatting())"
        lblNoOfMonth.text = selectedPackageObj.numberOfDaysMonths.description
        lblTotal.text = "₹\(selectedPackageObj.totalPrice.description)"//.currencyInputFormatting()
        print(lblTotal.text)
        
        //        if lblDuration.text == "Daily" {
        //            lblNoOfMonthLbl.text = "No. of Days"
        //        }
        //        else {
        //            lblNoOfMonthLbl.text = "No. of Months"
        //        }
        
        switch selectedDurationType {
        case .daily:
            lblNoOfMonthLbl.text = "No. of Days"
            break
        case .monthly:
            lblNoOfMonthLbl.text = "No. of Month"
            
            break
        case .weekly:
            lblNoOfMonthLbl.text = "No. of Week"
            break
            
        default:
            break
        }
        
        
        print(selectedDateStr)
        self.lblSelectedDuration.text = selectedDateStr
        
        switch selectedNursingType  {
        case .trainedAttendants:
            heightVewMain.constant = 680
            stackTrainesAttendant.isHidden = false
            
            self.lblCategory.isHidden = true
            self.lblSelectedCategory.isHidden = true
            self.lblCategory.text = ""
            self.lblSelectedCategory.text = ""
            if isReschedule {
                lblHours.text = appointmentObject.HOURS ?? ""
                lblDuration.text = appointmentObject.DURATIONS?.capitalizingFirstLetter()
                lblNursingAttendants.text = appointmentObject.Nursing_COUNT ?? ""
            }
            else {
            lblHours.text = selectedPackageObj.HHC_NA_HOURS
            lblDuration.text = selectedPackageObj.HHC_NA_DURATIONS.capitalizingFirstLetter()
            lblNursingAttendants.text = selectedPackageObj.HHC_NA_NACOUNT
            }
            
            self.lblHrs.text = "Hours:"
            // self.lblCategory.text = ""
            self.lblDur.text = "Duration:"
            self.lblNrs.text = "Nursing Attendants:"
            
            self.lblHrs.isHidden = false
            self.lblHours.isHidden = false
            self.lblDur.isHidden = false
            self.lblDuration.isHidden = false
            self.lblNrs.isHidden = false
            self.lblNursingAttendants.isHidden = false
            
            self.termStackView.isHidden = true
            self.traineeAttendantStackView.isHidden = false
            heightLblCategory.constant = 0
            heightLblSelectedCategory.constant = 0
            
            lblTotal.text = "₹\(selectedPackageObj.totalPrice.description)"//.currencyInputFormatting()
            print(lblTotal.text)
            if lblHours.text != "" && lblDuration.text != "" && lblNursingAttendants.text != "" && lblSelectedDuration.text != ""{
                self.btnConfirm.isUserInteractionEnabled = true
                self.btnConfirm.backgroundColor = Color.buttonBackgroundGreen.value
            }
            
            
        case .longTerm:
            heightVewMain.constant = 630
            stackTrainesAttendant.isHidden = true
            self.lblCategory.isHidden = false
            self.lblSelectedCategory.isHidden = false
            self.lblCategory.text = "Category"
            
            if isReschedule {
                self.lblSelectedCategory.text = self.appointmentObject.CATEGORY ?? ""
            }
            else {
                self.lblSelectedCategory.text = self.selectedPackageObj.packageName
            }
            
            lblHours.text = selectedPackageObj.HHC_NA_HOURS
            lblDuration.text = selectedPackageObj.HHC_NA_DURATIONS.capitalizingFirstLetter()
            lblNursingAttendants.text = selectedPackageObj.HHC_NA_NACOUNT
            
            self.termStackView.isHidden = false
            self.traineeAttendantStackView.isHidden = true
            
            lblTermPrice.text = selectedPackageObj.PKG_PRICE_MB.currencyInputFormatting()
            lblNoOfMonth.text = selectedPackageObj.numberOfDaysMonths.description
            lblTotal.text = "₹\(selectedPackageObj.totalPrice.description)"//.currencyInputFormatting()
            if lblSelectedCategory.text != "" && lblHours.text != "" && lblDuration.text != "" && lblNursingAttendants.text != "" && lblTermPrice.text != "" && lblNoOfMonth.text != "" && lblSelectedDuration.text != ""{
                self.btnConfirm.isUserInteractionEnabled = true
                self.btnConfirm.backgroundColor = Color.buttonBackgroundGreen.value
            }
            
        case .shortTerm,.doctorServices,.physiotherapy,.postNatelCare:
            heightVewMain.constant = 600
            stackTrainesAttendant.isHidden = true
            print(selectedPackageObj)
            self.lblCategory.isHidden = false
            self.lblSelectedCategory.isHidden = false
            //self.NursingAttendants.text = "Category:"
            //self.lblNursingAttendants.text = self.selectedPackageObj.packageName
            
            if isReschedule {
                self.lblSelectedCategory.text = self.appointmentObject.CATEGORY ?? ""
            }
            else {
                self.lblSelectedCategory.text = self.selectedPackageObj.packageName
            }
            
            self.lblHrs.isHidden = true
            self.lblHours.isHidden = true
            lblNursingAttendants.isHidden = true
            NursingAttendants.isHidden = true
            self.lblNoOfMonth.isHidden = true
            self.lblNoOfMonthLbl.isHidden = true
            self.noOfDaysBottomBorder.isHidden = true
            
            heightLblHrs.constant = 0
            heightLblHours.constant = 0
        
            heightLblDur.constant = 0
            heightLblDuration.constant = 0
            heightLblmnths.constant = 0
            heightLblMonths.constant = 0
            
          
            BottomConstraintPackageLbl.constant = 30
            BottomConstraintCategoryLbl.constant = 0
            BottomConstraintHoursLbl.constant = 0
            BottomConstraintDurationLbl.constant = 0
            TopConstraintNursingAttLbl.constant = 0
            BottomConstraintNursingAttLbl.constant = 0
            self.lblDur.isHidden = true
            self.lblDuration.isHidden = true
            self.lblNrs.isHidden = true
            self.lblNursingAttendants.isHidden = true
            self.termStackView.isHidden = false
            self.traineeAttendantStackView.isHidden = true
            
            lblTermPrice.text = selectedPackageObj.PKG_PRICE_MB.currencyInputFormatting()
            if selectedNursingType == .physiotherapy{
                lblTotal.text = "₹\(selectedPackageObj.totalPrice.description)"
            }else{
                lblTotal.text = "₹\(selectedPackageObj.PKG_PRICE_MB.currencyInputFormatting())"
            }
            
            
            lblHours.text = selectedPackageObj.HHC_NA_HOURS
            lblDuration.text = selectedPackageObj.HHC_NA_DURATIONS.capitalizingFirstLetter()
           // lblNursingAttendants.text = selectedPackageObj.HHC_NA_NACOUNT//commented for short term
            if lblTermPrice.text != "" && lblSelectedCategory.text != "" && lblSelectedDuration.text != ""{
                self.btnConfirm.isUserInteractionEnabled = true
                self.btnConfirm.backgroundColor = Color.buttonBackgroundGreen.value
            }
            
        case .elderCare :
            heightVewMain.constant = 620
            stackTrainesAttendant.isHidden = true
            
            self.lblCategory.isHidden = false
            self.lblSelectedCategory.isHidden = false
            self.lblCategory.text = "Category:"
            
            if isReschedule {
                self.lblSelectedCategory.text = self.appointmentObject.CATEGORY ?? ""
            }
            else {
                self.lblSelectedCategory.text = self.selectedPackageObj.packageName
            }
            
            //self.backView2.ishi
            self.lblHrs.isHidden = true
            self.lblHours.isHidden = true
            self.lblDur.isHidden = true
            self.lblDuration.isHidden = true
            self.lblNrs.isHidden = true
            self.lblNursingAttendants.isHidden = true
            self.NursingAttendants.isHidden = true
            self.termStackView.isHidden = false
            self.traineeAttendantStackView.isHidden = true
            lblSelectedDurationLbl.isHidden = true
            
            BottomConstraintPackageLbl.constant = 30
            BottomConstraintCategoryLbl.constant = 0
            BottomConstraintHoursLbl.constant = 0
            BottomConstraintDurationLbl.constant = 0
            TopConstraintNursingAttLbl.constant = 0
            BottomConstraintNursingAttLbl.constant = 0
            heightLblHrs.constant = 0
            heightLblHours.constant = 0
        
            heightLblDur.constant = 0
            heightLblDuration.constant = 0
            heightLblmnths.constant = 0
            heightLblMonths.constant = 0
            
            lblTermPrice.text = selectedPackageObj.PKG_PRICE_MB.currencyInputFormatting()
            lblTotal.text = "₹\(selectedPackageObj.PKG_PRICE_MB.currencyInputFormatting())"
           
                self.btnConfirm.isUserInteractionEnabled = true
                self.btnConfirm.backgroundColor = Color.buttonBackgroundGreen.value
            
            
        case .diabetesManagement:
            heightVewMain.constant = 550
            stackTrainesAttendant.isHidden = true
            
            self.lblCategory.isHidden = true
            self.lblSelectedCategory.isHidden = false
            self.lblCategory.text = "Category:"
            
            if isReschedule {
                self.lblSelectedCategory.text = self.appointmentObject.CATEGORY ?? ""
            }
            else {
                self.lblSelectedCategory.text = self.selectedPackageObj.packageName
            }
            
            //self.backView2.ishi
            self.lblHrs.isHidden = true
            self.lblHours.isHidden = true
            self.lblDur.isHidden = true
            self.lblDuration.isHidden = true
            self.lblNrs.isHidden = true
            self.lblNursingAttendants.isHidden = true
            self.NursingAttendants.isHidden = true
            self.termStackView.isHidden = false
            self.traineeAttendantStackView.isHidden = true
            
            print("mainViewHeightConstraint ",mainViewHeightConstraint.accessibilityFrame.height)
            mainViewHeightConstraint.constant = mainViewHeightConstraint.accessibilityFrame.height - 200
            
            lblSelectedDurationLbl.isHidden = false
            lblSelectedDuration.isHidden = false
            
            heightLblCategory.constant = 0
            heightLblSelectedCategory.constant = 0
            
            heightLblHours.constant = 0
            heightLblHrs.constant = 0
            
            heightLblDur.constant = 0
            heightLblDuration.constant = 0
            
            heightLblNursingLbl.constant = 0
            heightLblNursing.constant = 0
            
            
            lblTermPrice.text = diabetsPackageAmt
            lblTotal.text = "₹\(diabetsPackageAmt)"
            lblRate.text = "₹\(diabetsPackageAmt)"
            lblNoOfMonth.isHidden = true
            lblNoOfMonthLbl.isHidden = true
            heightLblmnths.constant = 0
            
            pkgRateBottomBorder.isHidden = true
            
            //constrains for top and bottom
            BottomConstraintPackageLbl.constant = 10
            BottomConstraintCategoryLbl.constant = 0
            BottomConstraintHoursLbl.constant = 0
            BottomConstraintDurationLbl.constant = 0
            TopConstraintNursingAttLbl.constant = 0
            BottomConstraintNursingAttLbl.constant = 0
            
                self.btnConfirm.isUserInteractionEnabled = true
                self.btnConfirm.backgroundColor = Color.buttonBackgroundGreen.value
            
            
        default:
            break
        }
        
    }
    
    
    @IBAction func btnBookNowAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Action
    @IBAction func btnAddRemarkTapped(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "EnterRemarksVC") as! EnterRemarksVC
        vc.delegateObject = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.remarkText = remarks
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnScheduleTapped(_ sender: UIButton) {
        
        switch selectedNursingType {
        case .trainedAttendants:
            scheduleNursingAttendant()
            break
        case .shortTerm:
            scheduleShortTermNursing()
            break
        case .longTerm:
            scheduleLongTermNursingAttendant()
            break
        case .physiotherapy:
            schedulePhysiotherapy()
            break
        case .doctorServices:
            scheduleDoctorServices()
            break
            
        case .postNatelCare:
            schedulePostNatalServices()
            
        case .elderCare:
            scheduleElderCareServicesAPI()
            
        case .diabetesManagement:
            scheduleDiabetesManagementAPI()
            break
        default:
            self.displayActivityAlert(title: "Failed to schedule")
            break
        }
        
        
    }
    
    private func getMemberID() -> String {
        var personSrNo = ""
        
        if isReschedule {
            if let personSrRes = appointmentObject.APPNT_PERSON_SR_NO {
                personSrNo = personSrRes
            }

        }
        else {
            if let personSr = memberObject?.ExtPersonSRNo?.description {
                personSrNo = personSr
            }
        }
        
        return personSrNo
    }
    
    //MARK:- NURSING ATTENDANT
    private func scheduleNursingAttendant() {
        let personSrNo = getMemberID()
        if personSrNo == "" {
            return
        }
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        
        
        var datePref = ""
        //var fromDate = ""
        //var toDate = ""
        
        switch selectedDurationType {
        case .daily:
            dateCondition = 1
            fromDate = "01-01-1990"
            endDate = "01-01-1990"
            datePref = selectedDateStr.removeWhitespace()
            break
        case .monthly:
            if isDateRange {
                dateCondition = 3 //set start & end date
                datePref = "01-01-1990"
            }
            else { //Set Data for monthly custom month picker
                datePref = "01-01-1990"
                dateCondition = 2 //set dates
            }
            break
        case .weekly:
            dateCondition = 4
            datePref = "01-01-1990"
            
            break
            
        default:
            break
        }
        
        
        
        let url = APIEngine.shared.scheduleNursingAttendant(PersonSrNo: personSrNo, FamilySrNo: familySrNo as? String ?? "", ISRescheduled: ISRescheduled, RejtApptSrNo: RejtApptSrNo, PkgPriceSrNo: selectedPackageObj.HHC_PKG_PRICING, Date_Condition: dateCondition.description, Date_pref: datePref, From_date: fromDate, To_date: endDate, RescSrNo: RescSrNo, Remarks: txtAddRemarks.text ?? "")
        print(url)
        sendHHCBookingData(stringURL: url)
        
        
    }
    
}

//MARK:- LONG TERM NURSING
extension NursingReviewVC_WN {
    //MARK:- NURSING ATTENDANT
    private func scheduleLongTermNursingAttendant() {
//        guard let personSrNo = memberObject?.ExtPersonSRNo?.description else {
//            return
//        }
        let personSrNo = getMemberID()
        if personSrNo == "" {
            return
        }

        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        var datePref = ""
        //var fromDate = ""
        //var toDate = ""
        
        switch selectedDurationType {
        case .daily:
            dateCondition = 1
            fromDate = "01-01-1990"
            endDate = "01-01-1990"
            datePref = selectedDateStr.removeWhitespace()
            break
        case .monthly:
            if isDateRange {
                dateCondition = 3 //set start & end date
                datePref = "01-01-1990"
            }
            else { //Set Data for monthly custom month picker
                datePref = "01-01-1990"
                dateCondition = 2 //set dates
            }
            break
        case .weekly:
            dateCondition = 4
            datePref = "01-01-1990"
            
            break
            
        default:
            break
        }
        
        let url = APIEngine.shared.scheduleLongTermNursingAttendant(PersonSrNo: personSrNo, FamilySrNo: familySrNo as? String ?? "", ISRescheduled: ISRescheduled, RejtApptSrNo: RejtApptSrNo, PkgPriceSrNo: selectedPackageObj.HHC_PKG_PRICING, Date_Condition: dateCondition.description, Date_pref: datePref, From_date: fromDate, To_date: endDate, RescSrNo: RescSrNo, Remarks: txtAddRemarks.text ?? "")
        //print(url)
        sendHHCBookingData(stringURL: url)
        
    }
}


//MARK:- API Nursing Attendant
extension NursingReviewVC_WN {
    
    func sendHHCBookingData(stringURL:String) {
        
        print("Schedule Nurisng Info")
        
        ServerRequestManager.serverInstance.postDataToServer(url: stringURL, dictionary: NSDictionary(), view: self, onComplition: { (response, error) in
            
            if let msgDict = response?["message"].dictionary
            {
                guard let status = msgDict["Status"]?.bool else {
                    return
                }
                
                if status == true {
//                    let msg = msgDict["Message"]?.stringValue
//                    self.displayActivityAlert(title: msg ?? "")
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                        self.navigationController?.popToRootViewController(animated: true)
//                    }
                    
                    if let msgValue = msgDict["Message"]?.stringValue
                    {
                        print("msgValue: ",msgValue)
                        let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"AppointmentScheduledVC") as! AppointmentScheduledVC
                        vc.modalPresentationStyle = .custom
                        vc.modalTransitionStyle = .crossDissolve
                        vc.appointmentOkDelegate = self as AppointmentConfirmedProtocol
                        vc.responseMsg = "Appointment confirmed.Our team will get back to you within 24 to 48 hours."//msgValue
                        self.navigationController?.present(vc, animated: true, completion: nil)
                        
                    }
                }
                else {
                    //Failed to send member info
                    if let msg = msgDict["Message"]?.stringValue {
                        self.displayActivityAlert(title: msg )
                    }
                }
            }
        })
    }
    
    //MARK:- PHYSIOTHERAPY
    func schedulePhysiotherapy() {
        
//        guard let personSrNo = memberObject?.ExtPersonSRNo?.description else {
//            return
//        }
        
        let personSrNo = getMemberID()
        if personSrNo == "" {
            return
        }

        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        
        
        var dateStr = ""
        var timeStr = ""
        
        if !isDateRange {
            fromDate = "01-01-1990"
            endDate = "01-01-1990"
            dateCondition = 1
            print(selectedDateStr)
        let splitArray = selectedDateStr.split(separator: " ")
        if splitArray.count > 0 {
            dateStr = String(splitArray[0])
            timeStr = String(format: "%@:%@", splitArray[1] as CVarArg,splitArray[2] as CVarArg)
        }
        }
        else {
            dateStr = "01-01-1990"
            timeStr = selectedTimePT//"11:00:AM"
            dateCondition = 2
        }
        
        
        let url = APIEngine.shared.schedulePhysiotherapy(PersonSrNo: personSrNo, FamilySrNo: familySrNo as? String ?? "", ISRescheduled: ISRescheduled, RejtApptSrNo: RejtApptSrNo, PkgPriceSrNo: selectedPackageObj.HHC_PKG_PRICING, Date_pref: dateStr, Time_pref: timeStr, RescSrNo: RescSrNo, Remarks: txtAddRemarks.text ?? "",From_date:fromDate,To_date:endDate,Date_Condition:dateCondition.description)
        
        //print(url)
        sendHHCBookingData(stringURL: url)
        
    }
    
    //MARK:- SHORT TERM
    func scheduleShortTermNursing() {
        
//        guard let personSrNo = memberObject?.ExtPersonSRNo?.description else {
//            return
//        }
        let personSrNo = getMemberID()
        if personSrNo == "" {
            return
        }

        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        
        var dateStr = ""
        var timeStr = ""
        print(selectedDateStr)
        let splitArray = selectedDateStr.split(separator: " ")
        if splitArray.count > 0 {
            dateStr = String(splitArray[0])
            timeStr = String(format: "%@:%@", splitArray[1] as CVarArg,splitArray[2] as CVarArg)
        }
        
        
        
        let url = APIEngine.shared.scheduleShortTermNursing(PersonSrNo: personSrNo, FamilySrNo: familySrNo as? String ?? "", ISRescheduled: ISRescheduled, RejtApptSrNo: RejtApptSrNo, PkgPriceSrNo: selectedPackageObj.HHC_PKG_PRICING, Date_pref: dateStr, Time_pref: timeStr, RescSrNo: RescSrNo, Remarks: txtAddRemarks.text ?? "", DateCond: "1", from_date: "01-01-1990", to_date: "01-01-1990")
     
   
        sendHHCBookingData(stringURL: url)
        
        // displayActivityAlert(title: "Successfully scheduled.")
        // DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //   self.navigationController?.popToRootViewController(animated: true)
        //}
    }
    
    //MARK:- Doctor Services
    func scheduleDoctorServices() {
        
//        guard let personSrNo = memberObject?.ExtPersonSRNo?.description else {
//            return
//        }
        let personSrNo = getMemberID()
        if personSrNo == "" {
            return
        }

        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        
        var dateStr = ""
        var timeStr = ""
        let splitArray = selectedDateStr.split(separator: " ")
        if splitArray.count > 0 {
            dateStr = String(splitArray[0])
            timeStr = String(format: "%@:%@", splitArray[1] as CVarArg,splitArray[2] as CVarArg)
        }
        
        
        
        let url = APIEngine.shared.scheduleDoctorServices(PersonSrNo: personSrNo, FamilySrNo: familySrNo as? String ?? "", ISRescheduled: ISRescheduled, RejtApptSrNo: RejtApptSrNo, PkgPriceSrNo: selectedPackageObj.HHC_PKG_PRICING, Date_pref: dateStr, Time_pref: timeStr, RescSrNo: RescSrNo, Remarks: txtAddRemarks.text ?? "")
        
        print(url)
        sendHHCBookingData(stringURL: url)
        
    }
    
    //MARK:- Post Natal Care
    func schedulePostNatalServices() {
        
        let personSrNo = getMemberID()
        if personSrNo == "" {
            return
        }
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        var datePref = "01-01-1990"
        
        if isDateRange {
            //pass from date to end date
            datePref = "01-01-1990"
            dateCondition = 2
        }
        else {
            //pass all selected dates
            fromDate = "01-01-1990"
            endDate = "01-01-1990"
            datePref = selectedDateStr.removeWhitespace()
            dateCondition = 1
            
        }
        
        let url = APIEngine.shared.schedulePostNatalCareAttendant(PersonSrNo: personSrNo, FamilySrNo: familySrNo as! String, ISRescheduled: ISRescheduled, RejtApptSrNo: RejtApptSrNo, PkgPriceSrNo: selectedPackageObj.HHC_PKG_PRICING, Date_Condition: dateCondition.description, Date_pref: datePref, From_date: fromDate, To_date:endDate, RescSrNo: RescSrNo, Remarks: txtAddRemarks.text ?? "")
        print(url)
        sendHHCBookingData(stringURL: url)
        
    }
    
    //MARK:- Elder Care
    func scheduleElderCareServicesAPI() {
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentEC?PersonSrNo=26562&FamilySrNo=5822&PkgPriceSrNo=1&RescSrNo=0&Remarks=Test
        
//        guard let personSrNo = memberObject?.ExtPersonSRNo?.description else {
//            return
//        }
        
        let personSrNo = getMemberID()
        if personSrNo == "" {
            return
        }

        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        let url = APIEngine.shared.scheduleElderCareHHC_API(PersonSrNo: personSrNo, FamilySrNo: familySrNo as? String ?? "", PkgPriceSrNo: selectedPackageObj.HHC_PKG_PRICING, RescSrNo: RescSrNo, Remarks: txtAddRemarks.text ?? "")
        
        print(url)
        sendHHCBookingData(stringURL: url)
        
    }
    
    
    //MARK:- Diabetes Management
    func scheduleDiabetesManagementAPI() {
        let personSrNo = getMemberID()
        if personSrNo == "" {
            return
        }
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentDM?PersonSrNo=26557&FamilySrNo=5822&PkgPriceSrNo=1&RescSrNo=0&Remarks=Test
        
        let packageSrNo = "1"
        
        if personSrNo != "" {
            let url = APIEngine.shared.scheduleDiabetes_API(PersonSrNo: personSrNo, FamilySrNo: familySrNo as? String ?? "" , PkgPriceSrNo: packageSrNo, RescSrNo: RescSrNo, Remarks: "")
            sendHHCBookingData(stringURL: url)
        }
    }
    
    //MARK:- Delegate Method
    func okTapped() {
       // self.navigationController?.popViewController(animated: true)
        
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
    
}
