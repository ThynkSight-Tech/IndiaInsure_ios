//
//  SummaryViewController.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 07/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import Razorpay
import SkeletonView


//Payment Summary with Payment Gateway
//API - 1 Get Summary Data
//API - 2 Fetch Payment Details (When user tap on confirm payment button) order Id
//API - 3 After Payment success UpdatePaymentDetails API.

class SummaryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,YesNoProtocol,AppointmentConfirmedProtocol
{
    
   
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundBorderView: UIView!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.estimatedRowHeight = 130.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    // Empty state
    @IBOutlet weak var emptyState: UIView!
    @IBOutlet weak var emptyStateImg: UIImageView!
    @IBOutlet weak var emptyStateHeaderText: UILabel!
    @IBOutlet weak var emptyStatedescriptionText: UILabel!
    @IBOutlet weak var emptyStateScheduleNow: UIButton!
    
    var summaryModelObject = SummaryModel()
   // var razorpay : RazorpayCheckout? = nil
    var youPayAmount = 0.0
    var paymentDetails = PaymentDetailsModel()
    var isLoaded = 0
    
    override func viewDidLoad() {
        //self.tableView.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true
        self.emptyState.isHidden = true
        super.viewDidLoad()
        self.navigationController?.navigationBar.changeFont()
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()

        //tableView.isSkeletonable = true
        let nibName = UINib(nibName: "shimeerDefaultCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "shimeerDefaultCell")
    
        //self.title = "Summary"
        print("In SummaryViewController")
        self.tableView.layer.cornerRadius = 10.0
        self.tableView.clipsToBounds = true
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        
        lbNavTitle.text = "Summary"
        self.navigationItem.titleView = lbNavTitle
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        
        //razorpay = Razorpay.initWithKey("rzp_test_P85Qujlx0rs3IX", andDelegateWithData: self)
        //razorpay = RazorpayCheckout.initWithKey("rzp_test_P85Qujlx0rs3IX", andDelegateWithData: self)
        //razorpay = RazorpayCheckout.initWithKey("rzp_test_P85Qujlx0rs3IX", andDelegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isLoaded = 0
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VDA..")

    //self.view.showShimmer()
        getSummaryDataFromServer()

    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
        menuButton.isHidden = false

    }
    
    //MARK:- Delegate Method
    func okTapped() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FamilyDetailsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func yesTapped() {
        confirmSummaryData()
    }
    
    func noTapped() {
        print("No Tapped")
    }
    
    
    //MARK:- Tabbar setup
    func setupWellnessTabbar()
    {
        
        let tabBarController = UITabBarController()
        
        let tabViewController1 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"FamilyDetailsViewController") as! FamilyDetailsViewController
        tabViewController1.isAddMember = 1
        
        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"AppointmentsViewController") as! AppointmentsViewController
        isRefreshAppointment = 1

        let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"FamilyDetailsViewController") as! FamilyDetailsViewController
        let tabViewController4 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"AppointmentsViewController") as! AppointmentsViewController
        
        let tabViewController5 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"AppointmentsViewController") as! AppointmentsViewController
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Add Member",
            image: UIImage(named: "adduser"),
            tag: 1)
        nav2.tabBarItem = UITabBarItem(
            title: "History",
            image:UIImage(named: "history") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Appointments",
            image:UIImage(named: "appointment") ,
            tag:2)
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile-1") ,
            tag:2)
        tabBarController.selectedIndex=2
        
        self.present(tabBarController, animated: true)
        
        //self.navigationController?.pushViewController(tabBarController, animated: true)
        
        let nav = UINavigationController(rootViewController: tabBarController)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate

        appdelegate.window!.rootViewController = nav

    }
    
    override func viewWillLayoutSubviews()
    {
        
        //tblHeightConstraint.constant = self.tableView.contentSize.height
        
    }
    
    @IBAction func bookNowTapped(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    

    //MARK:- Tableview Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoaded == 2 {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return (self.summaryModelObject.SelfSponsoredArray.count) + 1
        }
        else {
            return 1
        }
        }
        else {
            //For Summary Not Available
            return 0
        }
    }
    
   /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TOP
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSummarySelfTopCell", for: indexPath) as! CellForSummarySelfTopCell
            if summaryModelObject.CompanySponsoredArray.count > 0 {
                cell.lblPersonName.text = summaryModelObject.CompanySponsoredArray[0].Name
                //cell.lblPersonAmount.text = String(format: "₹ %@",summaryModelObject.CompanySponsoredArray[0].Price!)
                let amtText = summaryModelObject.CompanySponsoredArray[0].Price!
                cell.lblPersonAmount.text = getFormattedCurrency(amount: amtText)
                
            }
            return cell
        }
        
        //EMP PAID Cell
       else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSummaryEmpPaid", for: indexPath) as! CellForSummaryEmpPaid
                return cell

            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSummaryPersonCell", for: indexPath) as! CellForSummaryPersonCell
                
                if indexPath.row - 1 <= self.summaryModelObject.SelfSponsoredArray.count {
                    cell.lblPersonName.text = summaryModelObject.SelfSponsoredArray[indexPath.row - 1].Name
                    //cell.lblPersonAmount.text = String(format: "₹ %@",summaryModelObject.SelfSponsoredArray[indexPath.row - 1].Price!)
                    
                    let amtText = summaryModelObject.SelfSponsoredArray[indexPath.row - 1].Price!
                    cell.lblPersonAmount.text = getFormattedCurrency(amount: amtText)

                    
                }
                return cell
            }
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForBottomPaymentCell", for: indexPath) as! CellForBottomPaymentCell
            
//            cell.lblTotalAmt.text = String(format: "₹ %@",summaryModelObject.Total ?? "")
//            cell.lblPaidAmt.text = String(format: "₹ %@",summaryModelObject.paid ?? "")
//            cell.lblYouPayAmt.text = String(format: "₹ %@",summaryModelObject.Youpay ?? "")
//
            
            cell.lblTotalAmt.text = getFormattedCurrency(amount: summaryModelObject.Total ?? "")
            cell.lblPaidAmt.text = getFormattedCurrency(amount: summaryModelObject.paid ?? "")
            cell.lblYouPayAmt.text = getFormattedCurrency(amount: summaryModelObject.Youpay ?? "")
            
            
            if summaryModelObject.ShowConfirmButton {
                cell.btnConfirm.isHidden = false
            }
            else {
                cell.btnConfirm.isHidden = true
            }
            
            cell.btnConfirm.tag = indexPath.row
            cell.btnConfirm.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
            return cell

        }
        
      
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            //TOP
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSummarySelfTopCell", for: indexPath) as! CellForSummarySelfTopCell
                if summaryModelObject.CompanySponsoredArray.count > 0 {
                    cell.lblPersonName.text = summaryModelObject.CompanySponsoredArray[0].Name
                    //cell.lblPersonAmount.text = String(format: "₹ %@",summaryModelObject.CompanySponsoredArray[0].Price!)
                    let amtText = summaryModelObject.CompanySponsoredArray[0].Price!
                    cell.lblPersonAmount.text = getFormattedCurrency(amount: amtText)
                    
                }
                return cell
            }
            
            //EMP PAID Cell
           else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSummaryEmpPaid", for: indexPath) as! CellForSummaryEmpPaid
                    
                    let array = self.summaryModelObject.SelfSponsoredArray.filter({$0.IsStrike == 1})
                    if array.count > 0 {
                        cell.btnInfo.isHidden = false
                    }
                    else {
                        cell.btnInfo.isHidden = true
                    }
                    
                    cell.btnInfo.addTarget(self, action: #selector(infoTapped(_:)), for: .touchUpInside)
                    
                    return cell

                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSummaryPersonCell", for: indexPath) as! CellForSummaryPersonCell
                    
                    if indexPath.row - 1 <= self.summaryModelObject.SelfSponsoredArray.count {
                        //cell.lblPersonAmount.text = String(format: "₹ %@",summaryModelObject.SelfSponsoredArray[indexPath.row - 1].Price!)
                        

                        if summaryModelObject.SelfSponsoredArray[indexPath.row - 1].IsStrike == 1 {
                             
                            let attribute = NSMutableAttributedString.init(string: summaryModelObject.SelfSponsoredArray[indexPath.row - 1].Name ?? "")
                            attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: attribute.length))
                            attribute.addAttributes([
                            NSAttributedStringKey.strikethroughStyle:NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.strikethroughColor:UIColor.darkGray],range: NSMakeRange(0, attribute.length))
                            cell.lblPersonName.attributedText = attribute

                            let amtText = summaryModelObject.SelfSponsoredArray[indexPath.row - 1].Price!
                                let amtFora = getFormattedCurrency(amount: amtText)
                            let attribute2 = NSMutableAttributedString.init(string: amtFora)
                            attribute2.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: attribute2.length))
                            attribute2.addAttributes([
                                NSAttributedStringKey.strikethroughStyle:NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.strikethroughColor:UIColor.darkGray],range: NSMakeRange(0, attribute2.length))
                            cell.lblPersonAmount.attributedText = attribute2

                            //make strike
                        }
                        else {
                            //no strike
                            cell.lblPersonName.text = summaryModelObject.SelfSponsoredArray[indexPath.row - 1].Name
                            let amtText = summaryModelObject.SelfSponsoredArray[indexPath.row - 1].Price!
                            cell.lblPersonAmount.text = getFormattedCurrency(amount: amtText)

                            
                            
                        }
                        
                    }
                    return cell
                }
            }
                
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForBottomPaymentCell", for: indexPath) as! CellForBottomPaymentCell
                
    //            cell.lblTotalAmt.text = String(format: "₹ %@",summaryModelObject.Total ?? "")
    //            cell.lblPaidAmt.text = String(format: "₹ %@",summaryModelObject.paid ?? "")
    //            cell.lblYouPayAmt.text = String(format: "₹ %@",summaryModelObject.Youpay ?? "")
    //
                
                cell.lblTotalAmt.text = getFormattedCurrency(amount: summaryModelObject.Total ?? "")
                cell.lblPaidAmt.text = getFormattedCurrency(amount: summaryModelObject.paid ?? "")
                cell.lblYouPayAmt.text = getFormattedCurrency(amount: summaryModelObject.Youpay ?? "")
                
                
                if summaryModelObject.ShowConfirmButton {
                    cell.btnConfirm.isHidden = false
                }
                else {
                    cell.btnConfirm.isHidden = true
                }
                
                cell.btnConfirm.tag = indexPath.row
                cell.btnConfirm.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
                return cell

            }
            
          
        }
    
    @objc private func infoTapped(_ sender : UIButton) {
           self.showAlert(message: "Due to non confirmation of your appointment request, the requested dates have lapsed. Please reschedule your appointment.")
       }
    
    //MARK:- Currency Converter
    private func getFormattedCurrency(amount:String) -> String {
        
        if amount == "" {
            return ""
        }
        
        let myDouble = Double(amount)!
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = ""
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        var priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
        print(priceString)
        priceString = priceString.replacingOccurrences(of: ".00", with: "")
        priceString = priceString.replacingOccurrences(of: " ", with: "")

        let formatedString =  String(format: "₹%@",priceString)
        
      //  let str = "₹ 3700"

        return formatedString.removeWhitespace()
    }
   
   
    //MARK:- Get Summary Data From Server
    private func getSummaryDataFromServer() {
        //http://mybenefits360.in/mbapi/api/v1/HealthCheckup/GetSummary?FamilySrNo=5560

            guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
                return
            }
            
        let url = APIEngine.shared.getSummaryDetailsURL(familySRNo: familySrNo as! String, groupCode: self.getGroupCode())
        //let url = APIEngine.shared.getSummaryDetailsURL(familySRNo: "17878", groupCode: "NAYASA1")
            print("SummaryViewController: ",url)
            ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
                
                if let messageDictionary = response?["message"].dictionary
                {
                    
                    if let status = messageDictionary["Status"]?.bool
                    {
                            if status == true {
                                
                                if let summaryDict = response?["Summary"].dictionary {
                                    
                                    var companySponsoredArray = [PersonSummary]()
                                    var selfSponsoredArray = [PersonSummary]()

                                    //Company Sponsored Array
                                    if let companyArray = summaryDict["CompanySponseredPerson"]?.arrayValue {
                                        for company in companyArray {
                                            let obj = PersonSummary.init(Name: company["Name"].stringValue, Price: company["Price"].stringValue)
                                            companySponsoredArray.append(obj)
                                        }//for
                                    }//companyArray
                                    
                                    if let selfArray = summaryDict["SelfSponseredPerson"]?.arrayValue {
                                        for person in selfArray {
                                            //let obj = PersonSummary.init(Name: person["Name"].stringValue, Price: person["Price"].stringValue)
                                            
                                            let obj = PersonSummary.init(Name: person["Name"].stringValue, Price: person["Price"].stringValue,Is_Date_Elasped:person["Is_Date_Elasped"].intValue,IsStrike:person["IsStrike"].intValue)

                                            
                                            selfSponsoredArray.append(obj)
                                        }//for
                                    }//selfArray
                                   
                                    
                                    let total = summaryDict["Total"]?.stringValue
                                    let paid = summaryDict["paid"]?.stringValue
                                    let youpay = summaryDict["Youpay"]?.stringValue
                                    let confirmbutton = summaryDict["ShowConfirmButton"]?.boolValue
                                    
                                    if let payAmt = summaryDict["Youpay"]?.string {
                                        self.youPayAmount = Double(payAmt) as! Double
                                    }
                                    
                                    
                                    self.summaryModelObject = SummaryModel.init(Total: total, paid: paid, Youpay: youpay, ShowConfirmButton: confirmbutton ?? true, CompanySponsoredArray: companySponsoredArray, SelfSponsoredArray: selfSponsoredArray)
                                    
                                    //self.view.hideShimmer()
                                    self.isLoaded = 2
                                    self.tableView.isHidden = false

                                    self.tableView.restore()

                                    self.tableView.reloadData()
                                    
                                }
                                
                                
                            }//true
                        else {
                           // self.tableView.isHidden = true
                            //Summary record not found
                            self.tableView.reloadData()
                            self.emptyState.isHidden = false
                            self.tableView.isHidden = true
                            self.emptyStateImg.image = UIImage(named: "noData")
                            self.emptyStateHeaderText.text = "Your cart is empty!"
                            self.emptyStatedescriptionText.text = "Add item to it now."
                            self.emptyStatedescriptionText.textColor = Color.dark_grey.value
                            self.emptyStateScheduleNow.makeHHCCircularButton()
                            //self.tableView.setEmptyView(title: "Summary not available", message: "")
                            
                        }
                    }
                    else{
                        self.tableView.reloadData()
                        self.emptyState.isHidden = false
                        self.tableView.isHidden = true
                        self.emptyStateImg.image = UIImage(named: "noData")
                        self.emptyStateHeaderText.text = "Your cart is empty!"
                        self.emptyStatedescriptionText.text = "Add item to it now."
                        self.emptyStatedescriptionText.textColor = Color.dark_grey.value
                        self.emptyStateScheduleNow.makeHHCCircularButton()
                    }
                }//msgDic
            }
        }
    
    
    //MARK:- Get Order ID
    private func confirmSummaryData() {
        print("Get ORDER ID")
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") as? String else {
            return
        }
        
        
        guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") as? String else {
            return
        }
        
        
        guard let empID = UserDefaults.standard.value(forKey: "EmpID") as? String else {
            return
        }
        let strPayment = summaryModelObject.Youpay
        
        let url = APIEngine.shared.fetchPaymentDetailsURL(familySrNo: familySrNo, ExtGroupSrNo: groupSrNo, EmpIdNo: empID,TotalPayment:strPayment ?? "", groupCode: self.getGroupCode())
        
        //let url = APIEngine.shared.fetchPaymentDetailsURL(familySrNo: "17878", ExtGroupSrNo: "17", EmpIdNo: "NAYASA02",TotalPayment:strPayment ?? "", groupCode: "NAYASA1")
        
        
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            //let messageDictionary = ["Message":"Appointment scheduled found",
                                     //"Status": true] as [String : Any]
            
            if let messageDictionary = response?["message"].dictionary
            {
                
                //if let status = messageDictionary["Status"] as? String
                if let status = messageDictionary["Status"]?.bool
                {
                    /*
                     "PaymentDetails": {
                         "GoToPayment": true,
                         "OrderMasterSrNo": "1299",
                         "OrderReferenceNumber": "149373",
                         "AppointmentRecieptNumber": "ORD14937321042021110714",
                         "RazorPayOrderId": "order_H1SSaQXRywXWDk"
                     }
                     */
                    
                    if status == true {
                        if let paymentDict = response?["PaymentDetails"].dictionary {
                            self.paymentDetails = PaymentDetailsModel.init(GoToPayment: paymentDict["GoToPayment"]?.boolValue, OrderMasterSrNo: paymentDict["OrderMasterSrNo"]?.stringValue, OrderReferenceNumber: paymentDict["OrderReferenceNumber"]?.stringValue, AppointmentRecieptNumber: paymentDict["AppointmentRecieptNumber"]?.stringValue, RazorPayOrderId: paymentDict["RazorPayOrderId"]?.stringValue)
                            
                            //self.paymentDetails = PaymentDetailsModel.init(GoToPayment: true, OrderMasterSrNo: "1299", OrderReferenceNumber: "149373", AppointmentRecieptNumber: "ORD14937321042021110714", RazorPayOrderId: "order_H1SSaQXRywXWDk")
                            
                                if self.paymentDetails.GoToPayment == true {
                                    self.showPaymentForm()
                                }
                                else {
                                    //Display popup
                                    let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"AppointmentConfirmedVC") as! AppointmentConfirmedVC
                                    vc.amount = self.summaryModelObject.Youpay ?? ""
                                    vc.orderNo = self.paymentDetails.OrderReferenceNumber ?? ""
                                    vc.paymentId = ""
                                    vc.confirmAppointmentDelegate = self
                                    vc.isPaymentDone = 0
                                    vc.modalPresentationStyle = .custom
                                    vc.modalTransitionStyle = .crossDissolve
                                    self.navigationController?.present(vc, animated: true, completion: nil)
                                    
                                    //on ok button tap move to family details
    //                                for controller in self.navigationController!.viewControllers as Array {
    //                                    if controller.isKind(of: FamilyDetailsViewController.self) {
    //                                        self.navigationController!.popToViewController(controller, animated: true)
    //                                        break
    //                                    }
    //                                }
                                }//else
                        }
                        else{ //Extra Fake Payment test
                            self.paymentDetails = PaymentDetailsModel.init(GoToPayment: true, OrderMasterSrNo: "1299", OrderReferenceNumber: "149373", AppointmentRecieptNumber: "ORD14937321042021110714", RazorPayOrderId: "order_H1SSaQXRywXWDk")
                            
                            if self.paymentDetails.GoToPayment == true {
                                self.showPaymentForm()
                            }
                            else {
                                //Display popup
                                let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"AppointmentConfirmedVC") as! AppointmentConfirmedVC
                                vc.amount = self.summaryModelObject.Youpay ?? ""
                                vc.orderNo = self.paymentDetails.OrderReferenceNumber ?? ""
                                vc.paymentId = ""
                                vc.confirmAppointmentDelegate = self
                                vc.isPaymentDone = 0
                                vc.modalPresentationStyle = .custom
                                vc.modalTransitionStyle = .crossDissolve
                                self.navigationController?.present(vc, animated: true, completion: nil)
                                
                                //on ok button tap move to family details
                                //                                for controller in self.navigationController!.viewControllers as Array {
                                //                                    if controller.isKind(of: FamilyDetailsViewController.self) {
                                //                                        self.navigationController!.popToViewController(controller, animated: true)
                                //                                        break
                                //                                    }
                                //                                }
                            }
                        }
                    }//true
                        
                        
                    else {
                        //Summary record not found
                        //let msg = messageDictionary["Message"]?.string
                        self.displayActivityAlert(title: m_errorMsg )
                    }
                }
            }//msgDic
        }
        }
    
    
    //MARK:- Confirm Tapped
    @objc func confirmButtonTapped(_ sender : UIButton) {
        let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"ConfirmPaymentVC") as! ConfirmPaymentVC
        vc.yesNoDelegate = self
        vc.summaryModelObject = self.summaryModelObject
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve

        navigationController?.present(vc, animated: true, completion: nil)


       // confirmSummaryData()
    }
    
    //MARK:- Payment Gateway
    internal func showPaymentForm(){
        guard let orderId = paymentDetails.RazorPayOrderId else {
            return
        }
        
        var description = ""
        guard let receiptNO = paymentDetails.AppointmentRecieptNumber else {
            return
        }
        
        guard let empName = UserDefaults.standard.value(forKey: "name") as? String else {
            return
        }
        guard let mobileNo = UserDefaults.standard.value(forKey: "mobileNo") as? String else {
            return
        }
        guard let emailID = UserDefaults.standard.value(forKey: "emailID") as? String else {
            return
        }
        
        print("orderId: ",orderId," receiptNO: ",receiptNO," empName: ",empName," mobileNo: ",mobileNo," emailID: ",emailID)
        
        description = "Your order id : \(receiptNO)"
        
        let options: [String:Any] = [
            "name": "MyBenefits",
            "description": description,
            "image": ConstantContent.sharedInstance.imageForPaymentGateway,
            "currency": "INR",
            "order_id" : orderId,
            "amount" : (self.youPayAmount * 100),
            "prefill": [
                "name" : empName,
                "Support": mobileNo,
                "email": emailID
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        
        print("razorpay option: ",options)
        
       //self.razorpay?.open(options, displayController: self)
        
//        if let rzp = self.razorpay {
//            rzp.open(options)
//        } else {
//            print("Unable to initialize")
//        }
        

    }
    
    //MARK:- Failed Payment..
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        
        print("#Failed Payment...")
        print(response)
        
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }


    /*
     {"PaymentId":"3243432","Signature":"32432432432","OrderId":"1342132432","OrderReferenceNumber":"4435345435","FamilySrNo":"3454543","ExtGroupSrNo":"4234324","EmpIdNo":"767567"}

     */
    
    //MARK:- Success Payment..

    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("#onPaymentSuccess")
        print(response)
    
       // var signatureStr = ""
       // var orderIdStr = ""
        
        guard let signature = response?["razorpay_signature"] as? String  else {
//            print(signature)
  //          signatureStr = signature
            return
        }
        
        guard let order_id = response?["razorpay_order_id"] as? String else {
           // print(order_id)
           // orderIdStr = order_id
            return
        }
        
        print(payment_id)
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") as? String else {
            return
        }
        guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") as? String else {
            return
        }
        guard let empID = UserDefaults.standard.value(forKey: "EmpID") as? String else {
            return
        }
        guard let refNo = paymentDetails.OrderReferenceNumber else {
            return
        }
        
        let param = ["PaymentId":payment_id,"Signature":signature,"OrderId":order_id,"OrderReferenceNumber":refNo,"FamilySrNo":familySrNo,"ExtGroupSrNo":groupSrNo,"EmpIdNo":empID]
        
//        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: UIAlertController.Style.alert)
//        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (_) in
//            self.updatePaymentDetails(parameter: param as NSDictionary)
//        }
//        alertController.addAction(cancelAction)
//        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        let alert = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            self.updatePaymentDetails(parameter: param as NSDictionary)
        }))

        self.present(alert, animated: true)
        
    }
    
    
    /*
     Optional([AnyHashable("razorpay_signature"): 8bf4fc04059e38dca3de9c4989b037ad1f2bba4454d6b4726a1591e5314b1ccf, AnyHashable("razorpay_payment_id"): pay_Cg4J5LDGevXViB, AnyHashable("razorpay_order_id"): order_Cg4J0XHRUgYfY1])

     */
    
    //MARK:- API 3
    //Send data to server
    private func updatePaymentDetails(parameter:NSDictionary) {
        print("Update Payment details Info")
        
        let url = APIEngine.shared.updatePaymentDetailsURL()
        print(url)
        ServerRequestManager.serverInstance.putDataToServer(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
            
            if let msgDict = response?["message"].dictionary {
            
                if let status = msgDict["Status"]?.bool
            {
                if status == true {
                    print("Successfully updated.....")
                    self.getSummaryDataFromServer()
                    
                    //Display popup
                    let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"AppointmentConfirmedVC") as! AppointmentConfirmedVC
                    vc.amount = self.summaryModelObject.Youpay ?? ""
                    vc.orderNo = parameter["OrderId"] as! String
                    vc.paymentId = parameter["PaymentId"] as! String
                    vc.confirmAppointmentDelegate = self
                    vc.modalPresentationStyle = .custom
                    vc.modalTransitionStyle = .crossDissolve

                    vc.isPaymentDone = 1
                    self.navigationController?.present(vc, animated: true, completion: nil)
                    
                    
//                    let msgValue = msgDict["Message"]?.stringValue
//
//                    let alert = UIAlertController(title: "", message: msgValue, preferredStyle: UIAlertController.Style.alert)
//
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: FamilyDetailsViewController.self) {
//                                self.navigationController!.popToViewController(controller, animated: true)
//                                break
//                            }
//                        }
//                    }))
//
//                    self.present(alert, animated: true, completion: nil)
                }
                }
            }//msgDict
            else {
                //Failed to send member info
            }
        })
        
    }

}

extension SummaryViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        // return "CellForFamilyDetailsCell1"
        return "shimeerDefaultCell"
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       if isLoaded == 0 {
            return 120
        }
        else {
        if indexPath.section == 0 {
            if summaryModelObject.CompanySponsoredArray.count == 0 {
                return 0
            }
            return 82
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 45
            }
            return UITableViewAutomaticDimension
        }
            
        else if indexPath.section == 2 {
            return 225
        }
        
        return 0
        
        }
    }
}
