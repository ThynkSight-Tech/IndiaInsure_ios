//
//  NewAppointmentHistory.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 06/05/21.
//  Copyright © 2021 Semantic. All rights reserved.
//

import UIKit
import SkeletonView

class NewAppointmentHistory: UIViewController,UITableViewDataSource,UITableViewDelegate,SkeletonTableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.estimatedRowHeight = 200.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var appointmentModelArray = [AppointmentModel]()
    let myAttribute = [NSAttributedStringKey.font: UIFont(name: "Poppins-Regular", size: 14.0)!]

    var paymentDetails = PaymentDetailsModel()
    var selectedAppointmentModel = AppointmentModel()
    
    var youPayAmount = 0.0

    var whiteLightDate = UIColor(hexFromString: "f7f7f7")
    var greenLightBack = UIColor(hexFromString: "e3fef7")
    var fontcolor = #colorLiteral(red: 0.5843137255, green: 0.5803921569, blue: 0.5803921569, alpha: 1)
    var datePref = "Date Preferences :"
    var constantHeight:CGFloat = 0.0
    
    var isLoaded = 0
    
    // Empty state
    @IBOutlet weak var emptyState: UIView!
    @IBOutlet weak var emptyStateImg: UIImageView!
    @IBOutlet weak var emptyStateTextView: UIView!
    @IBOutlet weak var emptyStateHeaderText: UILabel!
    @IBOutlet weak var emptyStatedescriptionText: UILabel!
    @IBOutlet weak var emptyStateScheduleNow: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
         isRefreshAppointment = 1
        self.emptyState.isHidden = true
        //self.navigationItem.title = "Appointment History"
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        
        lbNavTitle.text = "Appointment History"
        self.navigationItem.titleView = lbNavTitle
        print("In \(lbNavTitle.text!) NewAppointmentHistory")

        self.navigationController?.navigationBar.changeFont()
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()

        self.tableView.isSkeletonable = false
        let nibName = UINib(nibName: "shimeerDefaultCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "shimeerDefaultCell")

        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        //To set Nav bar color
        navigationController?.view.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)
        //let cartBtn =  UIBarButtonItem(image:UIImage(named: "cartW") , style: .plain, target: self, action: #selector(cartTapped))
        //navigationItem.rightBarButtonItem  = cartBtn
        
        
        
    }
    
    //MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        if isRefreshAppointment == 1 {
            isLoaded = 0
        }
        self.tabBarController?.tabBar.isHidden = false
        menuButton.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isRefreshAppointment == 1 {
            //comment by geeta
            isLoaded = 1
            
            //self.displayActivityAlert(title: "No Appointments Available")
        //getAppointmentsListFromServer()
            self.tableView.reloadData()
            self.emptyState.isHidden = false
            self.tableView.isHidden = true
            self.emptyStateImg.image = UIImage(named: "no_History")
            self.emptyStateHeaderText.text = "No appointment history available!"
            self.emptyStatedescriptionText.textColor = Color.dark_grey.value
            self.emptyStateScheduleNow.makeHHCCircularButton()
        }
    }
    
    @IBAction func scheduleNowBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func cartTapped() {
        let summaryVC : SummaryViewController = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"SummaryViewController") as! SummaryViewController
        
        menuButton.isHidden = true
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(summaryVC, animated: true)

    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        //self.tableHeight?.constant = self.table.contentSize.height
    }
    
    
    
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- TableView Delegate and Datasource
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.appointmentModelArray.count <= 0{
//            return 2
//        }
            return self.appointmentModelArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //let obj = self.appointmentModelArray[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewAptmntHistoryCell", for: indexPath) as! NewAptmntHistoryCell
        if self.appointmentModelArray.count > 0{

            let obj = self.appointmentModelArray[indexPath.row]
            
        //Constant Data
        cell.lblPersonName.text = self.appointmentModelArray[indexPath.row].Name
        cell.lblHospitalName.text = self.appointmentModelArray[indexPath.row].DaignosticCenterName
        cell.lblHospitalAddress.text = self.appointmentModelArray[indexPath.row].DaignosticCenterAddress
        
        
        //Sponsored By Btn
        if self.appointmentModelArray[indexPath.row].SponserdBy?.lowercased() == "COMPANY SPONSORED".lowercased() {
            cell.btnSponsored.isHidden = false
            cell.shimmer.isHidden = false
            cell.shimmerView.isHidden = false
            cell.shimmer.addShimmerAnimation()
        }
        else {
            cell.btnSponsored.isHidden = true
            cell.shimmer.isHidden = true
            cell.shimmerView.isHidden = true

        }
        
        
        //Set circular button string
        let notDoneString = String(format: "  %@  ",self.appointmentModelArray[indexPath.row].Status?.capitalizingFirstLetter() ?? "")
        cell.btnScheduleCircular.setTitle(notDoneString, for: UIControlState.normal)
        
        switch obj.Status {
        //MARK:- SCHEDULED
        case "SCHEDULED" :
            cell.colorView.backgroundColor = UIColor(hexFromString: "#9A5BB1")
            cell.btnScheduleCircular.backgroundColor = UIColor(hexFromString: "#F7ECFC")
            cell.btnScheduleCircular.setTitleColor(UIColor(hexFromString: "#9A5BB1"), for: .normal)
            
            if obj.PaymentFlag == "0" {
                
                //SC ON
                let schStr = self.appointmentModelArray[indexPath.row].Remark?.htmlToString.replacingOccurrences(of: "\n", with: "")
                
                cell.lbl1.attributedText = getColoredText(string_to_color: "Scheduled On -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: schStr ?? "")
                
                
                //SC DATE
                var newString = self.appointmentModelArray[indexPath.row].ScheduleDates?.replacingOccurrences(of: "<OL>", with: "")
                newString = newString?.replacingOccurrences(of: "</OL>", with: "")
                //newString = newString?.replacingOccurrences(of: "<hr />", with: "")

                //let scDates = String(format: "Date Preferrences - \n%@", newString?.htmlToString ?? "")
                
                //cell.lbl2.attributedText = getColoredText(string_to_color:"Date Preferrences - ", color: UIColor.red, fullString: scDates)
                
                cell.lblDateView.text = newString?.htmlToString.replacingLastOccurrenceOfString("\n", with: "")
                cell.lblDateName.text = datePref
                cell.middleView.backgroundColor = whiteLightDate
                
                //cell.lbl2.attributedText = getFormattedString(stringType: scDates.htmlToString)
                
                
                if obj.SponserdBy != "COMPANY SPONSORED" {
                    //Visible Payment not done
                    cell.lbl3.attributedText = getFormattedString(stringType: self.appointmentModelArray[indexPath.row].OrderInfo?.htmlToString ?? "")
                    cell.lbl3.isHidden = false
                    
                    cell.bottomLastView.backgroundColor = UIColor(hexFromString: "#FCEDED")
                    cell.lbl3.textColor = UIColor(hexFromString: "#DF1C22")
                    cell.lbl2.text = ""
                    cell.bottomLastView.isHidden = false
                }
                else {
                    cell.lbl2.text = ""
                    cell.lbl3.text = ""
                    cell.lbl3.isHidden = true
                    cell.heightOflastView.constant = constantHeight
                    cell.bottomLastView.isHidden = true

                }
                
                //SET COLOR
                cell.lbl1.backgroundColor = UIColor.white
                //cell.lbl2.backgroundColor = self.whiteLightDate
                
            }//End
            else {
                // cell.lbl1.attributedText = NSAttributedString(string: self.appointmentModelArray[indexPath.row].Remark?.htmlToString ?? "", attributes: myAttribute)
                let schStr = self.appointmentModelArray[indexPath.row].Remark?.htmlToString.replacingOccurrences(of: "\n", with: "")
                
                // cell.lbl1.attributedText = getFormattedString(stringType: schStr?.htmlToString ?? "")
                cell.lbl1.attributedText = getColoredText(string_to_color: "Scheduled On -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: schStr?.htmlToString ?? "")
                var newString = self.appointmentModelArray[indexPath.row].ScheduleDates?.replacingOccurrences(of: "<OL>", with: "")
                newString = newString?.replacingOccurrences(of: "</OL>", with: "")
                
                //let scDates = String(format: "Date Preferrences - \n%@", newString?.htmlToString ?? "")
                
                cell.lblDateName.text = datePref
                cell.lblDateView.attributedText = getFormattedString(stringType: newString?.htmlToString.replacingLastOccurrenceOfString("\n", with: "") ?? "")
                
                cell.bottomLastView.isHidden = true
                
                let attrb2 = self.getFullColorText(string_to_color: self.appointmentModelArray[indexPath.row].OrderInfo?.htmlToString ?? "", color: fontcolor)
                
                cell.lbl2.attributedText = attrb2
                cell.lbl2.isHidden = false

                
                //SET COLOR
                cell.lbl1.backgroundColor = UIColor.white
                cell.lbl3.text = ""
                cell.heightOflastView.constant = constantHeight

                cell.bottomLastView.isHidden = true
                cell.middleView.backgroundColor = self.whiteLightDate

            }
            
            cell.bottomBtnViews.isHidden = false
            cell.bottomHeight.constant = 40
            
            break
            
        //MARK:- REJECTED
        case "REJECTED" :
            cell.colorView.backgroundColor = UIColor(hexFromString: "#DF1C22")
            cell.btnScheduleCircular.backgroundColor = UIColor(hexFromString: "#FCEDED")
            cell.btnScheduleCircular.setTitleColor(UIColor(hexFromString: "#DF1C22"), for: .normal)
            
            cell.bottomBtnViews.isHidden = false
            cell.bottomHeight.constant = 40
            
            //REASON
            //cell.lbl1.attributedText = getFormattedString(stringType: self.appointmentModelArray[indexPath.row].Remark?.htmlToString ?? "")
            
            //SET REMARK
            let remarkStr = self.appointmentModelArray[indexPath.row].Remark?.replacingOccurrences(of: "<hr />", with: "")
            cell.lbl1.attributedText = getColoredText(string_to_color:"Rejection Reasons -", color: UIColor(hexFromString: "#DF1C22"), fullString: remarkStr?.htmlToString ?? "")
            
            //SET Date
            var newString1 = self.appointmentModelArray[indexPath.row].ScheduleDates
            newString1 = newString1?.replacingOccurrences(of: "<OL>", with: "")
            newString1 = newString1?.replacingOccurrences(of: "</OL>", with: "")
            newString1 = newString1?.replacingOccurrences(of: "<hr />", with: "")
            
            newString1 = newString1?.replacingLastOccurrenceOfString("\n", with: "")

            let attDates1 = self.getFullColorText(string_to_color:newString1?.htmlToString.replacingLastOccurrenceOfString("\n", with: "") ?? "", color: UIColor(hexFromString: "#DF1C22"))
            
            let attrb2 = self.getFullColorText(string_to_color: self.appointmentModelArray[indexPath.row].OrderInfo?.htmlToString ?? "", color: fontcolor)
            
            //MARK CROSS LINE
            attDates1.addAttributes([
                NSAttributedStringKey.strikethroughStyle:NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.strikethroughColor:UIColor(hexFromString: "#DF1C22")],
                                    range: NSMakeRange(0, attDates1.length))
            
            let str = ""
            let attributedQuote = NSMutableAttributedString(string: str)
            let combina = NSMutableAttributedString()
            combina.append(attributedQuote)
            combina.append(attDates1)
            //combina.append(attrb2)
            
            cell.lblDateName.text = "Date Preferences :"
            cell.lblDateView.attributedText = combina

            cell.lbl2.attributedText = attrb2
            cell.lbl3.text = ""
            cell.lbl3.isHidden = true
            cell.heightOflastView.constant = constantHeight
            cell.bottomLastView.isHidden = true

            
            //SET COLOR
            cell.lbl1.backgroundColor = UIColor.white
            cell.middleView.backgroundColor = self.whiteLightDate
            
            cell.bottomLastView.isHidden = true
            
            break
            
        //MARK:- Appointment DONE
        case "APPOINTMENT DONE", "APPOINTMENT COMPLETED" :
            cell.colorView.backgroundColor = UIColor(hexFromString: "#00C084")
            cell.btnScheduleCircular.backgroundColor = UIColor(hexFromString: "#E4FAF3")
            cell.btnScheduleCircular.setTitleColor(UIColor(hexFromString: "#00C084"), for: .normal)
            
            cell.bottomBtnViews.isHidden = true
            cell.bottomHeight.constant = 0
            
            cell.btnScheduleCircular.setTitle("Completed", for: UIControlState.normal)

            
            //REMARK - REF No
            //cell.lbl1.attributedText = getFormattedString(stringType: self.appointmentModelArray[indexPath.row].Remark?.htmlToString.replacingOccurrences(of: "\n", with: "") ?? "")
            
            let strrefno = getColoredText(string_to_color:"Appointment Reference No -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: self.appointmentModelArray[indexPath.row].Remark?.htmlToString ?? "")
            cell.lbl1.attributedText = strrefno
            
            
            //APPT DATE + ORDERINFO
            
           let removedStr = removeHtmlTags(htmlStr: self.appointmentModelArray[indexPath.row].ScheduleDates ?? "").htmlToString
            
            let appointmentDateStr = String(format: "Appointment Date - %@",removedStr)
            let orderInfoStr = self.appointmentModelArray[indexPath.row].OrderInfo?.htmlToString ?? ""
            
            let attr1 = getFullColorText(string_to_color:appointmentDateStr , color: Color.fontColor.value)
            //                getColoredText(string_to_color: "Appointment Date -", color: UIColor.blue, fullString: appointmentDateStr)
            
            let attr2 = getFullColorText(string_to_color: orderInfoStr, color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
            
            let combination = NSMutableAttributedString()
            combination.append(attr1)
            combination.append(attr2)
            
            //cell.lbl2.attributedText = combination
            //cell.lbl2.attributedText = getFormattedString(stringType:  self.appointmentModelArray[indexPath.row].OrderInfo?.htmlToString ?? "")
            
            //Scheduled On
            var str = String(format: "Scheduled On - %@", self.appointmentModelArray[indexPath.row].ScheduleDates ?? "")
            str = str.replacingOccurrences(of: "\n", with: "")
            var newString = str.replacingOccurrences(of: "<OL>", with: "")
            //newString = newString?.replacingOccurrences(of: "<LI>", with: "")
            //newString = newString?.replacingOccurrences(of: "</LI>", with: "")
            newString = newString.replacingOccurrences(of: "</OL>", with: "")
            newString = newString.replacingOccurrences(of: "<hr />", with: "")

            // cell.lbl3.attributedText = getFormattedString(stringType: newString.htmlToString)
            
            
           // cell.lbl3.attributedText = getColoredText(string_to_color: "Scheduled On -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: newString.htmlToString)
            cell.lbl3.text = ""
            cell.lbl3.isHidden = true
            cell.heightOflastView.constant = constantHeight

            cell.lblDateName.text = ""
            cell.lblDateView.text = ""
            cell.lbl2.isHidden = false
            cell.lbl2.attributedText = combination
            cell.bottomLastView.isHidden = false
            
            //SET COLOR
            cell.lbl1.backgroundColor = UIColor.white
            cell.middleView.backgroundColor = self.greenLightBack
            cell.bottomLastView.backgroundColor = UIColor.white
            
            var strtemp = self.appointmentModelArray[indexPath.row].Remark
            strtemp = strtemp?.replacingOccurrences(of: "<hr />", with: "")

            let strMerged = strtemp?.htmlToString
            
            
            let splitArray = strMerged?.components(separatedBy: "Remarks -")
            if splitArray?.count == 2 {
                let split1 = splitArray?[0] ?? ""
                
                
                var split2 = String(format: "Remarks -%@", splitArray?[1] ?? "")
                split2 = split2.replacingOccurrences(of: "<hr />", with: "")

                
                let spAttr = getSplitColoredText(string_to_color: "Appointment Reference No -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: split1)
                let spAttr2 = getSplitColoredText(string_to_color: "Remarks -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: split2)
                
                let combinedSplit = NSMutableAttributedString()
                combinedSplit.append(spAttr)
                combinedSplit.append(spAttr2)
                cell.lbl1.attributedText = combinedSplit
            }
            
            
            break
            
        //MARK:- CONFIRMED
        case  "CONFIRMED" :
            cell.colorView.backgroundColor = UIColor(hexFromString: "#3F78B9")
            cell.btnScheduleCircular.backgroundColor = UIColor(hexFromString: "#E2EEFC")
            cell.btnScheduleCircular.setTitleColor(UIColor(hexFromString: "#3F78B9"), for: .normal)
            
            //Hide/unhide bottom buttons
            if obj.PaymentFlag == "1" {
                if obj.CanCancel == true {
                    cell.bottomBtnViews.isHidden = false
                    cell.bottomHeight.constant = 40
                }
                else {
                    cell.bottomBtnViews.isHidden = true
                    cell.bottomHeight.constant = 0
                }
            }
            
     
            if self.appointmentModelArray[indexPath.row].Remark != "" {
                cell.lbl1.attributedText =  getColoredText(string_to_color:"Appointment Reference No -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: self.appointmentModelArray[indexPath.row].Remark?.htmlToString ?? "")
            }else{
                cell.lbl1.text = ""
            }

            //APPT DATE + ORDERINFO
            var appointmentDateStr = ""
            if self.appointmentModelArray[indexPath.row].ScheduleDates != ""{
                 appointmentDateStr = String(format: "Appointment Date - %@", removeHtmlTags(htmlStr: self.appointmentModelArray[indexPath.row].ScheduleDates ?? "").htmlToString)
            
            }
            let orderInfoStr = self.appointmentModelArray[indexPath.row].OrderInfo?.htmlToString ?? ""
            
            let attr1 = getFullColorText(string_to_color:appointmentDateStr , color: Color.fontColor.value)
            //                getColoredText(string_to_color: "Appointment Date -", color: UIColor.blue, fullString: appointmentDateStr)
            
           // let attr2 = getColoredText(string_to_color: "Order No:", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: orderInfoStr)
            let attr2 = getFullColorText(string_to_color: orderInfoStr, color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
            let combination = NSMutableAttributedString()
            combination.append(attr1)
            combination.append(attr2)
            
            cell.lbl2.attributedText = combination
            cell.lblDateView.text = ""
            cell.lblDateName.text = ""
            cell.lbl2.isHidden = false
            
            // var newString = str.replacingOccurrences(of: "<OL>", with: "")
            //newString = newString?.replacingOccurrences(of: "<LI>", with: "")
            //newString = newString?.replacingOccurrences(of: "</LI>", with: "")
            //newString = newString.replacingOccurrences(of: "</OL>", with: "")
            
            // let formStr = getFormattedString(stringType: str.htmlToString)
            //cell.lbl2.attributedText = formStr
            
            cell.lbl3.text = ""
            cell.bottomLastView.isHidden = true
            cell.heightOflastView.constant = constantHeight

            
            //SET COLOR
            cell.lbl1.backgroundColor = UIColor.white
            cell.middleView.backgroundColor = self.greenLightBack
            
            let remarkStrC = self.appointmentModelArray[indexPath.row].Remark?.replacingOccurrences(of: "<hr />", with: "")
            let strMerged = remarkStrC?.htmlToString.replacingLastOccurrenceOfString("\n", with: "")
            let splitArray = strMerged?.components(separatedBy: "Remarks -")
            if splitArray?.count == 2 {
                let split1 = splitArray?[0] ?? ""
                let split2 = String(format: "Remarks -%@", splitArray?[1] ?? "")
                
                let spAttr = getSplitColoredText(string_to_color: "Appointment Reference No -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: split1)
                let spAttr2 = getSplitColoredText(string_to_color: "Remarks -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: split2)
                
                let combinedSplit = NSMutableAttributedString()
                combinedSplit.append(spAttr)
                combinedSplit.append(spAttr2)
                cell.lbl1.attributedText = combinedSplit
            }
            
            break
            
        //MARK:- APPOINTMENT NOT DONE
        case "APPOINTMENT NOT DONE" :
            cell.colorView.backgroundColor = UIColor(hexFromString: "#EE7B27")
            cell.btnScheduleCircular.backgroundColor = UIColor(hexFromString: "#FCF0E7")
            cell.btnScheduleCircular.setTitleColor(UIColor(hexFromString: "#EE7B27"), for: .normal)
            cell.bottomBtnViews.isHidden = false
            cell.bottomHeight.constant = 40
       
            cell.btnScheduleCircular.setTitle("No Show", for: UIControlState.normal)

           // var remarkStr = self.appointmentModelArray[indexPath.row].Remark
           // remarkStr = remarkStr?.replacingOccurrences(of: "<hr />", with: "")
            
            let remarkStr = self.appointmentModelArray[indexPath.row].Remark?.replacingOccurrences(of: "<hr />", with: "")
            let attri1 = getColoredText(string_to_color: "Remarks -", color: UIColor(hexFromString: "#DF1C22"), fullString:remarkStr?.htmlToString ?? "")
            
           // let attri2 = getColoredText(string_to_color: "Scheduled On -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString:self.appointmentModelArray[indexPath.row].ScheduleDates?.htmlToString ?? "")

            let combination = NSMutableAttributedString()
            combination.append(attri1)
            //combination.append(attri2)
            
           
            cell.lbl1.attributedText = combination
            
            
            var newString1 = self.appointmentModelArray[indexPath.row].ScheduleDates
            newString1 = newString1?.replacingOccurrences(of: "<OL>", with: "")
            newString1 = newString1?.replacingOccurrences(of: "</OL>", with: "")
            newString1 = newString1?.replacingOccurrences(of: "<hr />", with: "")

            cell.lblDateName.text = datePref

            let attDates1 = self.getFullColorText(string_to_color:newString1?.htmlToString.replacingLastOccurrenceOfString("\n", with: "") ?? "", color: fontcolor)
            
            attDates1.addAttributes([
                NSAttributedStringKey.strikethroughStyle:NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.strikethroughColor:fontcolor],
                                    range: NSMakeRange(0, attDates1.length))
            cell.lblDateView.attributedText =  attDates1
            cell.lbl3.text = ""
            cell.lbl3.isHidden = true
            cell.bottomLastView.isHidden = true

                
                 cell.lbl2.attributedText = getFullColorText(string_to_color: self.appointmentModelArray[indexPath.row].OrderInfo?.htmlToString ?? "", color: fontcolor)
            
            cell.lbl2.isHidden = false

            //SET COLOR
            cell.lbl1.backgroundColor = UIColor.white
            cell.middleView.backgroundColor = self.whiteLightDate
            
            break
        case .none:
            break
        case .some(_):
            break
        }
        
//        //Add Gesture
//        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.rescheduleDidTapped (_:)))
//        cell.rescheduleView.tag = indexPath.row
//        cell.rescheduleView.addGestureRecognizer(gesture1)
//
//        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.cancelDidTapped (_:)))
//        cell.cancelView.tag = indexPath.row
//        cell.cancelView.addGestureRecognizer(gesture2)
        
    }
        cell.lblPersonName.text = "Patient Name"
        cell.lblHospitalName.text = "Aditya Birla Hospital"
        cell.lblHospitalAddress.text = "Aditya Birla Hospital Marg, Thergaon, Pune, Maharashtra - 411033"
        let vc = "COMPANY SPONSORED"
        if vc.lowercased() == "COMPANY SPONSORED".lowercased() {
            cell.btnSponsored.isHidden = false
            cell.shimmer.isHidden = false
            cell.shimmerView.isHidden = false
            cell.shimmer.addShimmerAnimation()
        }
        cell.btnScheduleCircular.setTitle("Payment not made yet", for: UIControlState.normal)
        cell.colorView.backgroundColor = UIColor(hexFromString: "#9A5BB1")
        cell.btnScheduleCircular.backgroundColor = UIColor(hexFromString: "#F7ECFC")
        cell.btnScheduleCircular.setTitleColor(UIColor(hexFromString: "#9A5BB1"), for: .normal)
        
            //SC ON
            let remark = "Scheduled On - 11/05/2021"
            let schStr = remark.htmlToString.replacingOccurrences(of: "\n", with: "")
            cell.lbl1.attributedText = getColoredText(string_to_color: "Scheduled On -", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), fullString: schStr)
            
            //SC DATE
            let scDate = "15/05/2021"
            var newString = scDate.replacingOccurrences(of: "<OL>", with: "")
            newString = newString.replacingOccurrences(of: "</OL>", with: "")
           
            cell.lblDateView.text = newString.htmlToString.replacingLastOccurrenceOfString("\n", with: "")
            cell.lblDateName.text = datePref
            cell.middleView.backgroundColor = whiteLightDate
            
                //Visible Payment not done
                let orderInf = "#345234OLD"
                cell.lbl3.attributedText = getFormattedString(stringType: orderInf.htmlToString)
                cell.lbl3.isHidden = false
                cell.bottomLastView.backgroundColor = UIColor(hexFromString: "#FCEDED")
                cell.lbl3.textColor = UIColor(hexFromString: "#DF1C22")
                cell.lbl2.text = ""
                cell.bottomLastView.isHidden = false
            
            cell.lbl1.backgroundColor = UIColor.white
            cell.bottomBtnViews.isHidden = false
            cell.bottomHeight.constant = 40
        

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoaded == 0 {
            return 120
        }
        else {
          return UITableViewAutomaticDimension
        }
    }
    
    //MARK:- Get Colored Text
    func getColoredText(string_to_color:String,color:UIColor,fullString:String) -> NSMutableAttributedString {
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: fullString)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        
        return attribute
    }

    func getSplitColoredText(string_to_color:String,color:UIColor,fullString:String) -> NSMutableAttributedString {
        
        if fullString.contains(string_to_color) {
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: fullString)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        
        return attribute
        }
        else {
            let range = (string_to_color as NSString).range(of: string_to_color)
            let attribute = NSMutableAttributedString.init(string: fullString)
            attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: fontcolor, range: range)
            return attribute
        }
    }



    //MARK:- Get Full Color
    func getFullColorText(string_to_color:String,color:UIColor) -> NSMutableAttributedString {
        let newString = string_to_color

        let attribute = NSMutableAttributedString.init(string: newString)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSRange(location: 0, length: attribute.length))
        return attribute
    }

    func getFormattedString(stringType:String) -> NSAttributedString {
        
      let str = NSAttributedString(string: stringType, attributes: myAttribute)
        return str
    }
    
    func removeHtmlTags(htmlStr:String) -> String {
        var strNew = htmlStr
        strNew = strNew.replacingOccurrences(of: "<OL>", with: "")
        strNew = strNew.replacingOccurrences(of: "</OL>", with: "")
        return strNew
    
    }
    

    
    func removeAllHtmlTags(htmlStr:String) -> String {
        var strNew = htmlStr
        strNew = strNew.replacingOccurrences(of: "<OL>", with: "")
        strNew = strNew.replacingOccurrences(of: "<LI>", with: "")
        strNew = strNew.replacingOccurrences(of: "</LI>", with: "")
        strNew = strNew.replacingOccurrences(of: "</OL>", with: "")
        strNew = strNew.replacingOccurrences(of: "<i>", with: "")
        strNew = strNew.replacingOccurrences(of: "</i>", with: "")
        strNew = strNew.replacingOccurrences(of: "<i class='icon-calendar font-blue'>", with: "")
        strNew = strNew.replacingOccurrences(of: "<i class='icon-clock font-blue'>", with: "")
        
        return strNew
        
    }
    
    //MARK:- Text To HTML
    private func convertHtmlCss(htmlText:String) -> String {
        print(htmlText)
        let cssText = "<style> .main-container { text-align: justify; font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);color:#696969;}ul.pretests { padding-left: 0px; }ul.pretests li{ color:#696969; line-height: 1;font-size : 13px;font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf); text-align: justify; margin: 0 10px 10px; }.main-container .text-center {text-align: center;}.main-container ul { padding-left:20px; }span.clearfix { color:#696969; font-size:13px; font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);}.h1 {font-size: 24px;}.main-container h2.sbold {font-size: larger;}.sbold { font-weight: 400!important; }.main-container h2,.text-primary,.text-info { color: #0096d6; }.h1, .h2, .h3, h1, h2, h3 {margin-top: 20px;margin-bottom: 10px; }</style>"
        
        
        let finalString = String(format: "%@%@", htmlText,cssText)
        print("Converted Text =\(finalString) ")
        return finalString
    }
    
    
    //MARK:- Get Data From Server
    private func getAppointmentsListFromServer() {
        isReloadFamilyDetails = 1
        //self.tableView.showShimmer()

        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") as? String else {
            return
        }
        guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") as? String else {
            return
        }
        guard let empID = UserDefaults.standard.value(forKey: "EmpID") as? String else {
            return
        }
        
        
        let url = APIEngine.shared.getAppointmentListURL(FamilySrNo: familySrNo, ExtGroupSrNo: groupSrNo, EmpIdNo: empID, groupCode: self.getGroupCode())
        
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            self.appointmentModelArray.removeAll()

            if let messageDictionary = response?["message"].dictionary
            {
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        
                        if let appointmentArray = response?["AppointmentList"].arrayValue {
                            for obj in appointmentArray {
                                let modelObj = AppointmentModel.init(Name: obj["Name"].stringValue, PaymentStatus: obj["PaymentStatus"].stringValue, DaignosticCenterName: obj["DaignosticCenterName"].stringValue, DaignosticCenterCity: obj["DaignosticCenterCity"].stringValue, DaignosticCenterAddress: obj["DaignosticCenterAddress"].stringValue, Remark: obj["Remark"].stringValue, ScheduleDates: obj["ScheduleDates"].stringValue, OrderInfo: obj["OrderInfo"].stringValue, Status: obj["Status"].stringValue, PackageSrNo: obj["PackageSrNo"].stringValue, PackageName: obj["PackageName"].stringValue, PersonSrNo: obj["PersonSrNo"].stringValue, Price: obj["Price"].stringValue, CanCancel: obj["CanCancel"].boolValue, ApptSrNo: obj["ApptSrNo"].stringValue, RejApptSrNo: obj["RejApptSrNo"].stringValue, ApptReschPaymentDone: obj["ApptReschPaymentDone"].stringValue, ApptFreeReschFlag: obj["ApptFreeReschFlag"].stringValue, PaymentFlag: obj["PaymentFlag"].stringValue, SponserdBy: obj["SponserdBy"].stringValue, RelationId: obj["RelationId"].stringValue, RelationName: obj["RelationName"].stringValue, CancelationCharge: obj["CancelationCharge"].stringValue, RefundAmount: obj["RefundAmount"].stringValue, RescheduleCharge: obj["RescheduleCharge"].stringValue)
                                
                                self.appointmentModelArray.append(modelObj)
                                
                                if modelObj.Status?.lowercased() == "confirmed" {
                                    if let confirmedDate = modelObj.ScheduleDates {
                                        if confirmedDate != "" {
                                        let appointmentDateStr = self.removeAllHtmlTags(htmlStr: confirmedDate)
                                            print("APPOINTMENT CONFIRMED = \(appointmentDateStr)" )
                                            
                                            let array = appointmentDateStr.split(separator: " ")
                                            
                                            if array.count > 0 {
                                                print("Date = '\(array[0])'")
                                                if let getDate = array[0] as? String{
                                                    print(getDate.removeWhitespace().getDatefromddMMyyyy())
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }

                            //self.tableView.hideShimmer()
                            self.isLoaded = 1
                            self.tableView.reloadData()

                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
//
//
//                                self.tableView.scrollToRow(at: IndexPath(row: self.appointmentModelArray.count - 1, section: 0), at: .bottom, animated: true)
//                                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//                                //self.tableView.scrollToTop(animated: true)
//                            })
//                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
//                                let indexPath1 = IndexPath(row: 0, section: 0)
//                                let indexPath2 = IndexPath(row: 1, section: 0)
//                                self.tableView.reloadSections([0], with: UITableVie wRowAnimation.none)

                               // self.tableView.reloadRows(at: [indexPath1,indexPath2], with: .none)
                            //})
                            
                        }
                    }
                    else {
                       // self.view.stopSkeletonAnimation()
                        //self.view.hideSkeleton()
                        //self.tableView.hideShimmer()
                        //let msg = messageDictionary["Message"]?.stringValue
                        self.tableView.reloadData()
                        self.emptyState.isHidden = false
                        self.tableView.isHidden = true
                        self.emptyStateImg.image = UIImage(named: "no_History")
                        self.emptyStateHeaderText.text = "No appointment history available!"
                        self.emptyStatedescriptionText.textColor = Color.dark_grey.value
                        self.emptyStateScheduleNow.makeHHCCircularButton()
                        //self.displayActivityAlert(title: "No Appointments Available")
                        
                    }
                    
                }
                else{
                    self.tableView.reloadData()
                    //self.tableView.setEmptyView(title: "Appointment not scheduled", message: "")
                    self.emptyState.isHidden = false
                    self.tableView.isHidden = true
                    self.emptyStateImg.image = UIImage(named: "no_History")
                    self.emptyStateHeaderText.text = "No appointment history available!"
                    self.emptyStatedescriptionText.textColor = Color.dark_grey.value
                    self.emptyStateScheduleNow.makeHHCCircularButton()
                }
                
            }
        }//msgDic
    }
    
    func setLocalNotifications(onDate:Date) {
            // Swift
            
             print("Date Array-")
            print(onDate)
            
            //Initialize notification
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["HCAppointmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["HCAppointmentLocalNotification"])

             
            let date = onDate.getDateStrdd_mmm_yy()

            let content = UNMutableNotificationContent()
            content.title = "Health Checkup"
            content.body = "Your Health Checkup scheduled on \(date)."
            content.sound = UNNotificationSound.default()

            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    // Notifications not allowed
                }
            }
            
           // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                    let gregorian = Calendar(identifier: .gregorian)

                    var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: onDate)
                    dateComponents.hour = 7
                    dateComponents.minute = 0
                    dateComponents.second = 0
                    
                    let identifier = "HCAppointmentLocalNotification"
                    print(dateComponents)
                    
                    let datepp = gregorian.date(from: dateComponents)!

                    let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: datepp)

                    let trigger =  UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                    

           // let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print(error)
                    // Something went wrong
                }
            })
        
        }
    
    private func checkIsDateElapsed(modelObj:AppointmentModel)
    {
        let firstDate = modelObj.ScheduleDates
    }

    
}

//extension UIColor {
//    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
//        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
//
//        if (cString.hasPrefix("#")) {
//            cString.remove(at: cString.startIndex)
//        }
//
//        if ((cString.count) == 6) {
//            Scanner(string: cString).scanHexInt32(&rgbValue)
//        }
//
//        self.init(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: alpha
//        )
//    }
//}

//extension UITableView {
//
//    func reloadWithoutAnimation() {
//        let lastScrollOffset = contentOffset
//        reloadData()
//        layoutIfNeeded()
//        setContentOffset(lastScrollOffset, animated: false)
//    }
//}


//extension NSAttributedString {
//    public convenience init?(HTMLString html: String, font: UIFont? = nil) throws {
//        let options : [NSAttributedString.DocumentReadingOptionKey : Any] =
//            [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
//             NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
//
//        guard let data = html.data(using: .utf8, allowLossyConversion: true) else {
//            throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
//        }
//
//        if let font = font {
//            guard let attr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
//                throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
//            }
//            var attrs = attr.attributes(at: 0, effectiveRange: nil)
//            attrs[NSAttributedStringKey.font] = font
//            attr.setAttributes(attrs, range: NSRange(location: 0, length: attr.length))
//            self.init(attributedString: attr)
//
//        } else {
//            try? self.init(data: data, options: options, documentAttributes: nil)
//        }
//    }
//}


//extension StringProtocol { // for Swift 4.x syntax you will needed also to constrain the collection Index to String Index - `extension StringProtocol where Index == String.Index`
//    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
//        return range(of: string, options: options)?.lowerBound
//    }
//    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
//        return range(of: string, options: options)?.upperBound
//    }
//    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
//        var result: [Index] = []
//        var startIndex = self.startIndex
//        while startIndex < endIndex,
//            let range = self[startIndex...].range(of: string, options: options) {
//                result.append(range.lowerBound)
//                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
//                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
//        }
//        return result
//    }
//    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
//        var result: [Range<Index>] = []
//        var startIndex = self.startIndex
//        while startIndex < endIndex,
//            let range = self[startIndex...].range(of: string, options: options) {
//                result.append(range)
//                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
//                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
//        }
//        return result
//    }
//}

extension NewAppointmentHistory: SkeletonTableViewDataSource {

    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "shimeerDefaultCell"
    }
 
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isLoaded == 0 {
            return 6
        }
        else {
            return 0
        }
    }

}


