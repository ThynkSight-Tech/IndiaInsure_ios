//
//  SchduledHHCAppointmentsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

struct AppointmentHHCModel {
    var APPT_INFO_SR_NO : String?
    var REMARKS : String?
    var APPT_NA_REF_NO : String?
    var APPNT_PERSON : String?
    var APPNT_PERSON_AGE : String?
    var APPNT_PERSON_SR_NO : String?
    var APPT_LOCATION : String?
    var APPT_LOCATION_IS_METRO : String?
    var HOURS : String?
    var DURATIONS : String?
    var Nursing_COUNT : String?
    var status : String?
    var NO_OF_DAYS : String?
    var DATE_CONDITION : String?
    var DATE_PREFERENCE : String?
    var FROM_DATE : String?
    var TO_DATE : String?
    var PKG_PRICE : String?
    var TOTAL_PRICE : String?
    var SCHEDULED_ON : String?
    var NO_OF_MONTHS : String?
    
    var NO_OF_WEEKS : String?
    var CATEGORY : String?
    var SELECTED_PKG_SR_NO : String?
}

class SchduledHHCAppointmentsVC: UIViewController, HHCCancelAppointmentPopUpProtocol {
    
    var appointmentModelArray = [AppointmentHHCModel]()
    var selectedNursingType : NursingType?
    
    // Empty state
    @IBOutlet weak var emptyState: UIView!
    @IBOutlet weak var emptyStateImg: UIImageView!
    @IBOutlet weak var emptyStateTextView: UIView!
    @IBOutlet weak var emptyStateHeaderText: UILabel!
    @IBOutlet weak var emptyStatedescriptionText: UILabel!
    @IBOutlet weak var emptyStateScheduleNow: UIButton!
    
    
    var whiteLightGray = UIColor(hexFromString: "EDEDED")
    var greenLightBack = UIColor(hexFromString: "e3fef7")

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.estimatedRowHeight = 200.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyState.isHidden = true
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        self.navigationItem.title = "Ongoing Appointments"
        self.navigationController?.navigationBar.changeFont()
        print("In \(navigationItem.title ?? "") SchduledHHCAppointmentsVC")
        print("selectedNursingType : \(selectedNursingType)")
        //To set Nav bar color
        navigationController?.view.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        menuButton.isHidden = false
        super.viewWillAppear(true)
        getDataFromServer()
    }
    

    @IBAction func scheduleNowBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //MARK:- Custom Protocol Methods
    func cancelToRescheduleAppointmentHHC(selectedAppointment:AppointmentHHCModel)
    {
        moveToScheduleScreen(selectedApptObj:selectedAppointment)
    }
    
    func cancelAppointmentHHC(selectedAppointment:AppointmentHHCModel)
    {
        if let appointId = selectedAppointment.APPT_INFO_SR_NO {
            if appointId != "" {
                self.cancelScheduleAppointment(apptId: appointId)
            }
        }
    }
    
}

extension SchduledHHCAppointmentsVC : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
        return appointmentModelArray.count
       }
       
       //MARK:- WITH FONT LABEL
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "CellForHHCAppointments", for: indexPath) as! CellForHHCAppointments
        cell.lblPersonName.text = appointmentModelArray[indexPath.row].APPNT_PERSON
        //cell.lblRelation.text = appointmentModelArray[indexPath.row].APPNT_PERSON_AGE ?? "" + "Years"
        
        //Set circular button string
        let ageStr = String(format: "%@ Years",self.appointmentModelArray[indexPath.row].APPNT_PERSON_AGE ?? "")
        //cell.lblHospitalName.text = appointmentModelArray[indexPath.row].APPT_LOCATION
        //Append \n and Relation
        cell.lblRelation.text = ageStr + ""
        let refStr = String(format: "Booking ID - %@" ,appointmentModelArray[indexPath.row].APPT_NA_REF_NO ?? "")
        cell.lblReferenceNo.attributedText = getColoredText(string_to_color: "Booking ID -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: refStr)
        
        cell.colorView.backgroundColor = UIColor(hexFromString: "#3F78B9")
        //cell.lbl1.text = appointmentModelArray[indexPath.row].CATEGORY
        
        if var datePref = appointmentModelArray[indexPath.row].DATE_PREFERENCE {
            if datePref != "" {
                datePref = datePref.replacingOccurrences(of: ",", with: ", ")
                cell.lblDateName.text = String(format: "Date Preference : %@",datePref)
            }
            else {
               cell.lblDateName.text = "Date Preference :"
            }
        }
        else {
            cell.lblDateName.text = """
             
             """
        }
        
        //Scheduled On
        let appointmentDateStr = String(format: "Scheduled On - %@", appointmentModelArray[indexPath.row].SCHEDULED_ON!)
        cell.lbl1.attributedText = getColoredText(string_to_color: "Scheduled On -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: appointmentDateStr)
        
        //Remarks
        if let remarks = appointmentModelArray[indexPath.row].REMARKS {
            if remarks != "" {
                let remarksStr = String(format: "Remarks - %@",remarks)
                cell.lblRemarks.attributedText = getColoredText(string_to_color: "Remarks -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: remarksStr)
            }
            else {
                cell.lblRemarks.text = "Remarks -"
            }
        }
        else {
            cell.lblRemarks.text = ""
        }

        //Set Category
        if let categoryName = appointmentModelArray[indexPath.row].CATEGORY {
            if categoryName != "" {
                cell.lblDateView.text = String(format:"Selected Package - %@",categoryName)
            }
            else {
                if selectedNursingType == NursingType.trainedAttendants{
                    cell.lblDateView.isHidden = true
                }else{
                    cell.lblDateView.text = "Selected Package -"
                }
            }
        }
        else {
            cell.lblDateView.text = ""
        }
        
        //Set Duration Type - Daily, Monthwise, Weekwise
        if let dateCondition = appointmentModelArray[indexPath.row].DURATIONS {
            if dateCondition != "" {
                cell.lbl2.text = String(format:"Duration - %@",dateCondition)
            }
            else {
                if selectedNursingType == NursingType.trainedAttendants{
                    cell.lbl2.text = "Duration -"
                }else{
                    cell.lbl2.isHidden = true
                }
            }
        }
        else {
            cell.lbl2.text = ""
        }
        
        if appointmentModelArray[indexPath.row].TOTAL_PRICE?.count ?? 0 > 0 {
            
            let packgePriceStr = String(format:"Package Price - ₹ %@", appointmentModelArray[indexPath.row].PKG_PRICE?.currencyInputFormatting() ?? "Package Price -" as CVarArg)
            let attributedPackPrice = handleRuppeeText(customFontString:packgePriceStr, SystemFontString: "₹")
            
            //attributedPackPrice += attributedPackPrice
            let stringPrice = String(format:"\nTotal Price - ₹ %@", appointmentModelArray[indexPath.row].TOTAL_PRICE?.currencyInputFormatting() ?? "Total Price -" as CVarArg)
            
            let totalPriceAttr = handleRuppeeText(customFontString:stringPrice, SystemFontString: "₹")
            
            let mergeStr = add(left: attributedPackPrice, right: totalPriceAttr)
            
            cell.lbl3.attributedText = mergeStr

       // cell.lbl3.text = "Total Price - ₹ \(appointmentModelArray[indexPath.row].TOTAL_PRICE?.currencyInputFormatting() ?? "")"
        }else{
            let packgePriceStr = "Package Price -"
            let stringPrice = "\nTotal Price -"
            cell.lbl3.text = "\(packgePriceStr)\(stringPrice)"
        }
        cell.middleView.backgroundColor = whiteLightGray//greenLightBack
        cell.bottomLastView.backgroundColor = whiteLightGray
        
        //Add Gesture
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.rescheduleDidTapped (_:)))
        cell.rescheduleView.tag = indexPath.row
        cell.rescheduleView.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.cancelDidTapped (_:)))
        cell.cancelView.tag = indexPath.row
        cell.cancelView.addGestureRecognizer(gesture2)

        if selectedNursingType == NursingType.elderCare {
            cell.lblDateName.isHidden = true
        }
        else {
            cell.lblDateName.isHidden = false
        }
        
        //Hide Reschedule View
        if selectedNursingType == NursingType.diabetesManagement || selectedNursingType == NursingType.elderCare || selectedNursingType == NursingType.postNatelCare {
            cell.rescheduleView.isHidden = true
            cell.middleSeparator.isHidden = true
        }
        else {
            cell.rescheduleView.isHidden = false
            cell.middleSeparator.isHidden = false
        }
        
        if appointmentModelArray[indexPath.row].DURATIONS?.lowercased() == "monthly"
        {
            if appointmentModelArray[indexPath.row].DATE_CONDITION?.lowercased() == "monthwise" {
            if appointmentModelArray[indexPath.row].FROM_DATE?.count ?? 0 > 0 {
                cell.lblDateName.text = String(format: "Month Preference : %@",getMonthFormat(monthString: appointmentModelArray[indexPath.row].FROM_DATE ?? ""))
            }
            else {
                cell.lblDateName.text = ""
            }
            }
            else {
                cell.lblDateName.text = String(format: "Month Preference : %@ to %@", appointmentModelArray[indexPath.row].FROM_DATE ?? "",appointmentModelArray[indexPath.row].TO_DATE ?? "")
            }
        }
        else if appointmentModelArray[indexPath.row].DURATIONS?.lowercased() == "weekly" {
            cell.lblDateName.text = String(format: "Month Preference : %@ to %@", appointmentModelArray[indexPath.row].FROM_DATE ?? "",appointmentModelArray[indexPath.row].TO_DATE ?? "")

        }
        else if  selectedNursingType == NursingType.postNatelCare || selectedNursingType == NursingType.physiotherapy {
            if appointmentModelArray[indexPath.row].CATEGORY?.lowercased() != "per day" {
            cell.lblDateName.text = String(format: "Date Preference : %@ to %@", appointmentModelArray[indexPath.row].FROM_DATE ?? "",appointmentModelArray[indexPath.row].TO_DATE ?? "")
            }
            else {
                cell.lblDateName.text = String(format: "Date Preference : %@", appointmentModelArray[indexPath.row].DATE_PREFERENCE ?? "")
            }
            cell.lbl2.text = ""
        }
        return cell
    }
    
     func add(left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }

    
    func handleRuppeeText(customFontString: String, SystemFontString: String) -> NSAttributedString {
        let poppinsFont = UIFont(name: "Poppins-Regular",
        size: 14)

        let attributedString = NSMutableAttributedString(string: customFontString,
                                                         attributes: [NSAttributedString.Key.font: poppinsFont!])
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: poppinsFont!.pointSize)]
        let range = (customFontString as NSString).range(of: SystemFontString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    //MARK:- Cancel Tapped
      @objc func cancelDidTapped(_ sender: UITapGestureRecognizer) {
         
          print(sender.view?.tag ?? 0)
          guard let index = sender.view?.tag else { return  }
          
          /*
          let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"HHCCancelRescheduleAppointmentVC") as! HHCCancelRescheduleAppointmentVC
          vc.yesNoDelegate = self
          vc.selectedAppointmentModel = appointmentModelArray[index]
          vc.modalPresentationStyle = .custom
          vc.modalTransitionStyle = .crossDissolve
          navigationController?.present(vc, animated: true, completion: nil)
          vc.isReschedule = false
           */
          let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"CancelHHCAppointmentVC") as! CancelHHCAppointmentVC
          vc.appointmentCancelProtocolDelegate = self
          vc.selectedAppointmentModel = appointmentModelArray[index]
          vc.modalPresentationStyle = .custom
          vc.modalTransitionStyle = .crossDissolve
          navigationController?.present(vc, animated: true, completion: nil)
          //vc.isReschedule = false
      }
    
    //MARK:- Reschedule Tapped
    @objc func rescheduleDidTapped(_ sender: UITapGestureRecognizer) {
        
        print(sender.view?.tag ?? 0)
        guard let index = sender.view?.tag else { return  }
        
        let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"HHCCancelRescheduleAppointmentVC") as! HHCCancelRescheduleAppointmentVC
        vc.yesNoDelegate = self
        vc.selectedAppointmentModel = appointmentModelArray[index]
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.isReschedule = true
        navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
     func moveToScheduleScreen(selectedApptObj:AppointmentHHCModel) {
             
             if selectedNursingType != NursingType.diabetesManagement {
             
            // guard let index = sender.view?.tag else { return  }
                 let obj = selectedApptObj
             let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "SelectDurationVC_WN") as! SelectDurationVC_WN
             vc.isReschedule = true
             vc.appointmentObject = obj
             if obj.DURATIONS?.lowercased() == "daily"
             {
                 vc.selectedDurationType = .daily
             }
             else if obj.DURATIONS?.lowercased() == "weekly"
             {
                 vc.selectedDurationType = .weekly
             }
             else if obj.DURATIONS?.lowercased() == "monthly"
             {
                 vc.selectedDurationType = .monthly
             }
             else {
                 vc.selectedDurationType = .noOfDays
             }
             
             vc.selectedNursingType = self.selectedNursingType
             
             //Start
             if (selectedNursingType == NursingType.shortTerm) || (selectedNursingType == NursingType.doctorServices) {
                 vc.selectedDurationType = .daily
             }
             else if selectedNursingType == NursingType.physiotherapy {
                 if obj.CATEGORY?.lowercased() == "10 days" {
                     vc.selectedDurationType = .noOfDays
                     vc.noOfDays = 10
                 }
                 else {
                     vc.selectedDurationType = .daily
                 }
             }
             else if selectedNursingType == NursingType.postNatelCare {
                 if obj.CATEGORY?.lowercased() == "per day" {
                     vc.selectedDurationType = .daily
                 }
                 else if obj.CATEGORY?.lowercased() == "15 days"  {
                     vc.selectedDurationType = .noOfDays
                     vc.noOfDays = 15
                 }
                 else {
                     vc.selectedDurationType = .noOfDays
                     vc.noOfDays = 30
                 }
             }
             //END
        
             self.navigationController?.pushViewController(vc, animated: true)
             }
    }
  
    
    //MARK:- Get Colored Text
    func getColoredText(string_to_color:String,color:UIColor,fullString:String) -> NSMutableAttributedString {
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: fullString)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        
        return attribute
    }
    
}

extension SchduledHHCAppointmentsVC {
    
   private func getDataFromServer() {

    guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
        return
    }
    
    let url = APIEngine.shared.getScheduledHHCAppointmentsURL(type: selectedNursingType!, familySrNo: (familySrNo as? String)!)
    
       print(url)
    if url != "" {
       ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in

           if let messageDictionary = response?["message"].dictionary
           {
               if let status = messageDictionary["Status"]?.bool
               {
                   if status == true {


                       if let summaryArray = response?["ScheduledSummary"].arrayValue {
                        self.appointmentModelArray.removeAll()
                        for obj in summaryArray {
                            
                            switch self.selectedNursingType {
                            case .trainedAttendants: //NA
                                
                                let modelObj = AppointmentHHCModel.init(APPT_INFO_SR_NO: obj["HHC_APPT_INFO_SR_NO"].stringValue, REMARKS: obj["HHC_NA_REMARKS"].stringValue, APPT_NA_REF_NO: obj["HHC_APPT_NA_REF_NO"].stringValue, APPNT_PERSON: obj["APPNT_PERSON"].stringValue, APPNT_PERSON_AGE: obj["APPNT_PERSON_AGE"].stringValue, APPNT_PERSON_SR_NO: obj["APPNT_PERSON_SR_NO"].stringValue, APPT_LOCATION: obj["APPT_LOCATION"].stringValue, APPT_LOCATION_IS_METRO: obj["APPT_LOCATION_IS_METRO"].stringValue, HOURS: obj["NA_HOURS"].stringValue, DURATIONS: obj["NA_DURATIONS"].stringValue, Nursing_COUNT: obj["NA_NACOUNT"].stringValue, status: obj["APPT_STATUS"].stringValue, NO_OF_DAYS: obj["NO_OF_DAYS"].stringValue, DATE_CONDITION: obj["DATE_CONDITION"].stringValue, DATE_PREFERENCE: obj["DATE_PREFERENCE"].stringValue, FROM_DATE: obj["FROM_DATE"].stringValue, TO_DATE: obj["TO_DATE"].stringValue, PKG_PRICE: obj["PKG_PRICE"].stringValue, TOTAL_PRICE: obj["TOTAL_PRICE"].stringValue, SCHEDULED_ON: obj["SCHEDULED_ON"].stringValue, NO_OF_MONTHS: obj["NO_OF_MONTHS"].stringValue,NO_OF_WEEKS:obj["NO_OF_WEEKS"].stringValue, CATEGORY:obj["NA_CATEGORY"].stringValue,SELECTED_PKG_SR_NO: obj["SELECTED_PKG_SR_NO"].stringValue)
                                self.appointmentModelArray.append(modelObj)

                            case .longTerm: 
                                let modelObj = AppointmentHHCModel.init(APPT_INFO_SR_NO: obj["HHC_LT_APPT_INFO_SR_NO"].stringValue, REMARKS: obj["HHC_LT_REMARKS"].stringValue, APPT_NA_REF_NO: obj["HHC_APPT_LT_REF_NO"].stringValue, APPNT_PERSON: obj["APPNT_PERSON"].stringValue, APPNT_PERSON_AGE: obj["APPNT_PERSON_AGE"].stringValue, APPNT_PERSON_SR_NO: obj["APPNT_PERSON_SR_NO"].stringValue, APPT_LOCATION: obj["APPT_LOCATION"].stringValue, APPT_LOCATION_IS_METRO: obj["APPT_LOCATION_IS_METRO"].stringValue, HOURS: obj["LT_HOURS"].stringValue, DURATIONS: obj["LT_DURATIONS"].stringValue, Nursing_COUNT: obj["LT_NACOUNT"].stringValue, status: obj["APPT_STATUS"].stringValue, NO_OF_DAYS: obj["NO_OF_DAYS"].stringValue, DATE_CONDITION: obj["DATE_CONDITION"].stringValue, DATE_PREFERENCE: obj["DATE_PREFERENCE"].stringValue, FROM_DATE: obj["FROM_DATE"].stringValue, TO_DATE: obj["TO_DATE"].stringValue, PKG_PRICE: obj["PKG_PRICE"].stringValue, TOTAL_PRICE: obj["TOTAL_PRICE"].stringValue, SCHEDULED_ON: obj["SCHEDULED_ON"].stringValue, NO_OF_MONTHS: obj["NO_OF_MONTHS"].stringValue,NO_OF_WEEKS:obj["NO_OF_WEEKS"].stringValue, CATEGORY:obj["LT_CATEGORY"].stringValue,SELECTED_PKG_SR_NO: obj["SELECTED_PKG_SR_NO"].stringValue)
                                self.appointmentModelArray.append(modelObj)

                            case .shortTerm:
                                let time = obj["TIME_PREFERENCE"].stringValue
                                let date = obj["DATE_PREFERENCE"].stringValue
                                let dateTime = date + " " + time

                                let modelObj = AppointmentHHCModel.init(APPT_INFO_SR_NO: obj["HHC_ST_APPT_INFO_SR_NO"].stringValue, REMARKS: obj["HHC_ST_REMARKS"].stringValue, APPT_NA_REF_NO: obj["HHC_APPT_ST_REF_NO"].stringValue, APPNT_PERSON: obj["APPNT_PERSON"].stringValue, APPNT_PERSON_AGE: obj["APPNT_PERSON_AGE"].stringValue, APPNT_PERSON_SR_NO: obj["APPNT_PERSON_SR_NO"].stringValue, APPT_LOCATION: obj["APPT_LOCATION"].stringValue, APPT_LOCATION_IS_METRO: obj["APPT_LOCATION_IS_METRO"].stringValue, HOURS: obj["ST_HOURS"].stringValue, DURATIONS: obj["ST_DURATIONS"].stringValue, Nursing_COUNT: obj["ST_NACOUNT"].stringValue, status: obj["APPT_STATUS"].stringValue, NO_OF_DAYS: obj["NO_OF_DAYS"].stringValue, DATE_CONDITION: obj["DATE_CONDITION"].stringValue, DATE_PREFERENCE: dateTime, FROM_DATE: obj["FROM_DATE"].stringValue, TO_DATE: obj["TO_DATE"].stringValue, PKG_PRICE: obj["PKG_PRICE"].stringValue, TOTAL_PRICE: obj["PKG_PRICE"].stringValue, SCHEDULED_ON: obj["SCHEDULED_ON"].stringValue, NO_OF_MONTHS: obj["NO_OF_MONTHS"].stringValue,NO_OF_WEEKS:obj["NO_OF_WEEKS"].stringValue, CATEGORY:obj["ST_CATEGORY"].stringValue,SELECTED_PKG_SR_NO: obj["SELECTED_PKG_SR_NO"].stringValue)
                                self.appointmentModelArray.append(modelObj)

                            case .doctorServices:
                               
                                let time = obj["TIME_PREFERENCE"].stringValue
                                let date = obj["DATE_PREFERENCE"].stringValue
                                let dateTime = date + " " + time
                                let obj = AppointmentHHCModel.init(APPT_INFO_SR_NO: obj["HHC_DS_APPT_INFO_SR_NO"].stringValue, REMARKS: obj["HHC_DS_REMARKS"].stringValue, APPT_NA_REF_NO: obj["HHC_APPT_DS_REF_NO"].stringValue, APPNT_PERSON: obj["APPNT_PERSON"].stringValue, APPNT_PERSON_AGE: obj["APPNT_PERSON_AGE"].stringValue, APPNT_PERSON_SR_NO: obj["APPNT_PERSON_SR_NO"].stringValue, APPT_LOCATION: obj["APPT_LOCATION"].stringValue, APPT_LOCATION_IS_METRO: obj[""].stringValue, HOURS: obj[""].stringValue, DURATIONS: obj[""].stringValue, Nursing_COUNT: obj[""].stringValue, status: obj["APPT_STATUS"].stringValue, NO_OF_DAYS: obj[""].stringValue, DATE_CONDITION: obj[""].stringValue, DATE_PREFERENCE: dateTime, FROM_DATE: obj[""].stringValue, TO_DATE: obj[""].stringValue, PKG_PRICE: obj["PKG_PRICE"].stringValue, TOTAL_PRICE: obj["PKG_PRICE"].stringValue, SCHEDULED_ON: obj["SCHEDULED_ON"].stringValue, NO_OF_MONTHS: obj[""].stringValue, NO_OF_WEEKS: obj[""].stringValue, CATEGORY: obj["DS_CATEGORY"].stringValue, SELECTED_PKG_SR_NO: obj["SELECTED_PKG_SR_NO"].stringValue)
                                self.appointmentModelArray.append(obj)
                                
                                break

                            case .physiotherapy:
                    let time = obj["TIME_PREFERENCE"].stringValue
                    let date = obj["DATE_PREFERENCE"].stringValue
                    let dateTime = date + " " + time

                                let modelObj = AppointmentHHCModel.init(APPT_INFO_SR_NO: obj["HHC_PT_APPT_INFO_SR_NO"].stringValue, REMARKS: obj["HHC_PT_REMARKS"].stringValue, APPT_NA_REF_NO: obj["HHC_APPT_PT_REF_NO"].stringValue, APPNT_PERSON: obj["APPNT_PERSON"].stringValue, APPNT_PERSON_AGE: obj["APPNT_PERSON_AGE"].stringValue, APPNT_PERSON_SR_NO: obj["APPNT_PERSON_SR_NO"].stringValue, APPT_LOCATION: obj["APPT_LOCATION"].stringValue, APPT_LOCATION_IS_METRO: obj["APPT_LOCATION_IS_METRO"].stringValue, HOURS: obj["ST_HOURS"].stringValue, DURATIONS: obj["ST_DURATIONS"].stringValue, Nursing_COUNT: obj["ST_NACOUNT"].stringValue, status: obj["APPT_STATUS"].stringValue, NO_OF_DAYS: obj["NO_OF_DAYS"].stringValue, DATE_CONDITION: obj["DATE_CONDITION"].stringValue, DATE_PREFERENCE: dateTime, FROM_DATE: obj["FROM_DATE"].stringValue, TO_DATE: obj["TO_DATE"].stringValue, PKG_PRICE: obj["PKG_PRICE"].stringValue, TOTAL_PRICE: obj["PKG_PRICE"].stringValue, SCHEDULED_ON: obj["SCHEDULED_ON"].stringValue, NO_OF_MONTHS: obj["NO_OF_MONTHS"].stringValue,NO_OF_WEEKS:obj["NO_OF_WEEKS"].stringValue, CATEGORY:obj["PT_CATEGORY"].stringValue,SELECTED_PKG_SR_NO: obj["SELECTED_PKG_SR_NO"].stringValue)

                                self.appointmentModelArray.append(modelObj)

                                break

                            case .diabetesManagement:
                                
                                let dbObj = AppointmentHHCModel.init(APPT_INFO_SR_NO: obj["HHC_DM_APPT_INFO_SR_NO"].stringValue, REMARKS: obj["HHC_DM_REMARKS"].stringValue, APPT_NA_REF_NO: obj["HHC_APPT_DM_REF_NO"].stringValue, APPNT_PERSON: obj["APPNT_PERSON"].stringValue, APPNT_PERSON_AGE: obj["APPNT_PERSON_AGE"].stringValue, APPNT_PERSON_SR_NO: obj["APPNT_PERSON_SR_NO"].stringValue, APPT_LOCATION: obj["APPT_LOCATION"].stringValue, APPT_LOCATION_IS_METRO: obj["APPT_LOCATION_IS_METRO"].stringValue, HOURS: obj["HOURS"].stringValue, DURATIONS: obj["DURATIONS"].stringValue, Nursing_COUNT: obj["Nursing_COUNT"].stringValue, status: obj["APPT_STATUS"].stringValue, NO_OF_DAYS: obj["NO_OF_DAYS"].stringValue, DATE_CONDITION: obj["DATE_CONDITION"].stringValue, DATE_PREFERENCE: obj["DATE_PREFERENCE"].stringValue, FROM_DATE: obj["FROM_DATE"].stringValue, TO_DATE: obj["TO_DATE"].stringValue, PKG_PRICE: obj["PKG_PRICE"].stringValue, TOTAL_PRICE: obj["PKG_PRICE"].stringValue, SCHEDULED_ON: obj["SCHEDULED_ON"].stringValue, NO_OF_MONTHS: obj["NO_OF_MONTHS"].stringValue, NO_OF_WEEKS: obj["NO_OF_WEEKS"].stringValue, CATEGORY: obj["DM_CATEGORY"].stringValue,SELECTED_PKG_SR_NO: obj["SELECTED_PKG_SR_NO"].stringValue)
                                 
                                self.appointmentModelArray.append(dbObj)
                                break

                            case .postNatelCare:
                                
                                let obj = AppointmentHHCModel.init(APPT_INFO_SR_NO: obj["HHC_NC_APPT_INFO_SR_NO"].stringValue, REMARKS: obj["HHC_NC_REMARKS"].stringValue, APPT_NA_REF_NO: obj["HHC_APPT_NC_REF_NO"].stringValue, APPNT_PERSON: obj["APPNT_PERSON"].stringValue, APPNT_PERSON_AGE: obj["APPNT_PERSON_AGE"].stringValue, APPNT_PERSON_SR_NO: obj["APPNT_PERSON_SR_NO"].stringValue, APPT_LOCATION: obj["APPT_LOCATION"].stringValue, APPT_LOCATION_IS_METRO: obj[""].stringValue, HOURS: obj[""].stringValue, DURATIONS: obj[""].stringValue, Nursing_COUNT: obj[""].stringValue, status: obj["APPT_STATUS"].stringValue, NO_OF_DAYS: obj["NO_OF_DAYS"].stringValue, DATE_CONDITION: obj["DATE_CONDITION"].stringValue, DATE_PREFERENCE: obj["DATE_PREFERENCE"].stringValue, FROM_DATE: obj["FROM_DATE"].stringValue, TO_DATE: obj["TO_DATE"].stringValue, PKG_PRICE: obj["PKG_PRICE"].stringValue, TOTAL_PRICE: obj["TOTAL_PRICE"].stringValue, SCHEDULED_ON: obj["SCHEDULED_ON"].stringValue, NO_OF_MONTHS: obj[""].stringValue, NO_OF_WEEKS: obj[""].stringValue, CATEGORY: obj["NC_CATEGORY"].stringValue, SELECTED_PKG_SR_NO: obj["SELECTED_PKG_SR_NO"].stringValue)
                                self.appointmentModelArray.append(obj)
                                break

                            case .elderCare:

                                    let modelObj = AppointmentHHCModel.init(APPT_INFO_SR_NO: obj["HHC_EC_APPT_INFO_SR_NO"].stringValue, REMARKS: obj["HHC_EC_REMARKS"].stringValue, APPT_NA_REF_NO: obj["HHC_APPT_EC_REF_NO"].stringValue, APPNT_PERSON: obj["APPNT_PERSON"].stringValue, APPNT_PERSON_AGE: obj["APPNT_PERSON_AGE"].stringValue, APPNT_PERSON_SR_NO: obj["APPNT_PERSON_SR_NO"].stringValue, APPT_LOCATION: obj["APPT_LOCATION"].stringValue, APPT_LOCATION_IS_METRO: obj["APPT_LOCATION_IS_METRO"].stringValue, HOURS: obj["ST_HOURS"].stringValue, DURATIONS: obj["ST_DURATIONS"].stringValue, Nursing_COUNT: obj["ST_NACOUNT"].stringValue, status: obj["APPT_STATUS"].stringValue, NO_OF_DAYS: obj["NO_OF_DAYS"].stringValue, DATE_CONDITION: obj["DATE_CONDITION"].stringValue, DATE_PREFERENCE: obj["DATE_PREFERENCE"].stringValue, FROM_DATE: obj["FROM_DATE"].stringValue, TO_DATE: obj["TO_DATE"].stringValue, PKG_PRICE: obj["PKG_PRICE"].stringValue, TOTAL_PRICE: obj["PKG_PRICE"].stringValue, SCHEDULED_ON: obj["SCHEDULED_ON"].stringValue, NO_OF_MONTHS: obj["NO_OF_MONTHS"].stringValue,NO_OF_WEEKS:obj["NO_OF_WEEKS"].stringValue, CATEGORY:obj["EC_CATEGORY"].stringValue,SELECTED_PKG_SR_NO: obj["SELECTED_PKG_SR_NO"].stringValue)
                                    self.appointmentModelArray.append(modelObj)

                            default:
                                break
                            }
                            
                            
                            
                            
                        }
                        
                        if self.appointmentModelArray.count > 0 {
                        self.tableView.restore()
                        self.tableView.reloadData()
                        }
                        else {
                            self.tableView.reloadData()
                            //self.tableView.setEmptyView(title: "Appointment not scheduled", message: "")
                            self.emptyState.isHidden = false
                            self.tableView.isHidden = true
                            self.emptyStateImg.image = UIImage(named: "no_History")
                            self.emptyStateHeaderText.text = "Appointment not scheduled!"
                            self.emptyStatedescriptionText.textColor = Color.dark_grey.value
                            self.emptyStateScheduleNow.makeHHCCircularButton()
                        }
                       }
                   }
                   else {
                       //let msg = messageDictionary["Message"]?.stringValue
                      // self.displayActivityAlert(title: "Scheduled appointments data not available")
                    //self.tableView.setEmptyView(title: "Appointment not found", message: "")
                       
                       self.emptyState.isHidden = false
                       self.tableView.isHidden = true
                       self.emptyStateImg.image = UIImage(named: "no_History")
                       self.emptyStateHeaderText.text = "Appointment not found!"
                       self.emptyStatedescriptionText.textColor = Color.dark_grey.value
                       self.emptyStateScheduleNow.makeHHCCircularButton()

                   }

               }

           }
           else {
            
        }
       }//msgDic
        }//url != ""

   }
    
    //MARK:- Cancel Appointment
    private func cancelScheduleAppointment(apptId:String) {
        let strUrl = APIEngine.shared.cancelScheduledHHCAppointmentURL(type: selectedNursingType!, appointmentSrNo:apptId)
        
        ServerRequestManager.serverInstance.postDataToServer(url: strUrl, dictionary: NSDictionary(), view: self, onComplition: { (response, error) in
            
            if let msgDict = response?["message"].dictionary
            {
                guard let status = msgDict["Status"]?.bool else {
                    return
                }
                
                if status == true {
                    
                    self.getDataFromServer()
                    
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
    
}

extension SchduledHHCAppointmentsVC {
    //      "FROM_DATE" : "01-NOV-20,01-DEC-20,01-JAN-21",

    func getMonthFormat(monthString:String) -> String {
        var finalString = ""
        var finalStringArray = [String]()
        if monthString != "" {
            let commaBasedArray = monthString.split(separator: ",")
            for date in commaBasedArray {
                let dateArray = date.split(separator: "-")
                if dateArray.count >= 2 {
                    let formatedDate = "\(dateArray[1])-\(dateArray[2])"

                   // let formatedDate = String(format: "%@-%@", dateArray[1]!,dateArray[2]!)
                    finalStringArray.append(formatedDate)
                }
            } //for
            
            finalString = (finalStringArray.map{String($0.description)}).joined(separator: ", ")

            return finalString
        }
        else {
            return monthString
        }
    }
    
    
}


/*
 
 let obj = AppointmentHHCModel.init(APPT_INFO_SR_NO: obj[""].stringValue, REMARKS: obj[""].stringValue, APPT_NA_REF_NO: obj[""].stringValue, APPNT_PERSON: obj[""].stringValue, APPNT_PERSON_AGE: obj[""].stringValue, APPNT_PERSON_SR_NO: obj[""].stringValue, APPT_LOCATION: obj[""].stringValue, APPT_LOCATION_IS_METRO: obj[""].stringValue, HOURS: obj[""].stringValue, DURATIONS: obj[""].stringValue, Nursing_COUNT: obj[""].stringValue, status: obj[""].stringValue, NO_OF_DAYS: obj[""].stringValue, DATE_CONDITION: obj[""].stringValue, DATE_PREFERENCE: obj[""].stringValue, FROM_DATE: obj[""].stringValue, TO_DATE: obj[""].stringValue, PKG_PRICE: obj[""].stringValue, TOTAL_PRICE: obj[""].stringValue, SCHEDULED_ON: obj[""].stringValue, NO_OF_MONTHS: obj[""].stringValue, NO_OF_WEEKS: obj[""].stringValue, CATEGORY: obj[""].stringValue, SELECTED_PKG_SR_NO: obj[""].stringValue)

 
 */
