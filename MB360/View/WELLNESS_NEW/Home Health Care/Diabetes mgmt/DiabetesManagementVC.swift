//
//  DiabetesManagementVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 22/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

struct GetEmployeeDCPackages: Codable {
    let packages: [Package]
    let message: MessageDM

    enum CodingKeys: String, CodingKey {
        case packages = "Packages"
        case message
    }
}

// MARK: - Message
struct MessageDM: Codable {
    let message: String
    let status: Bool

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
    }
}

// MARK: - Package
struct Package: Codable {
    let pkgPriceMB: String

    enum CodingKeys: String, CodingKey {
        case pkgPriceMB = "PKG_PRICE_MB"
    }
}


class DiabetesManagementVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AppointmentConfirmedProtocol {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedPersonObj = FamilyDetailsModelHHC()
    //For Reschedule API
    var RejtApptSrNo = "-1"
    var RescSrNo = "0"
    var ISRescheduled = "0"
    
    //For Reschedule
    var isReschedule = false
    var appointmentObject = AppointmentHHCModel()

    var companyName = ""
    var pkg_Price_MB = ""
    var selectedCityObject = CityListModel()
    var selectedNursingType : NursingType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Diabetes Package"
        print("In \(navigationItem.title ?? "") DiabetesManagementVC")
        self.getPkgPriceDMFromServer()
        self.companyName = getGroupName()
        tableView.register(DiabetesCell.self, forCellReuseIdentifier: "DiabetesCell")
        tableView.register(UINib (nibName: "DiabetesCell", bundle: nil), forCellReuseIdentifier: "DiabetesCell")
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
    }
    
    func getGroupName() -> String {
        //Get Group Info
        var groupNameStr = ""
        let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
        if groupMasterArray.count > 0 {
            groupNameStr = groupMasterArray[0].groupName!
            return groupNameStr
        }
        return groupNameStr
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DiabetesManagementVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSelectedMemberHHC", for: indexPath) as! CellForSelectedMemberHHC
            //cell.lblName.text = selectedPersonObj.PersonName?.capitalizingFirstLetter() ?? ""
            var data = "\(self.selectedPersonObj.PersonName ?? "") \n\(self.selectedPersonObj.RelationName ?? "") (\(self.selectedPersonObj.AGE ?? "") years)"
            print("data: ",data)
            cell.lblName.text = data

            cell.btnChange.tag = indexPath.row - 1
            cell.btnChange.addTarget(self, action: #selector(changeDidTapped(_:)), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiabetesCell", for: indexPath) as! DiabetesCell
            
            cell.btnGetItNow.tag = indexPath.row - 1
            cell.btnGetItNow.addTarget(self, action: #selector(getItNowTapped(_:)), for: .touchUpInside)
            //let stringFull = "Price for \(companyName) clients 999/-"
            let stringFull = "Price for \(companyName) clients \(pkg_Price_MB)/-"
            let colorText = "Price for \(companyName) clients"
            cell.lblPriceCompany.attributedText = getColoredText(string_to_color: colorText, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), fullString: stringFull)
            return cell
        }
    }
    
//    func handleRuppeeText(customFontString: String, SystemFontString: String) -> NSAttributedString {
//        let poppinsFont = UIFont(name: "Poppins-Medium",
//        size: 14)
//
//        let attributedString = NSMutableAttributedString(string: customFontString,
//                                                         attributes: [NSAttributedString.Key.font: poppinsFont!])
//        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: poppinsFont!.pointSize)]
//        let range = (customFontString as NSString).range(of: SystemFontString)
//        attributedString.addAttributes(boldFontAttribute, range: range)
//        return attributedString
//    }

    //MARK:- Get Colored Text
      func getColoredText(string_to_color:String,color:UIColor,fullString:String) -> NSMutableAttributedString {
          
          let range = (string_to_color as NSString).range(of: string_to_color)
          let attribute = NSMutableAttributedString.init(string: fullString)
          attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
          
          return attribute
      }
    
    
    //MARK:- Change Tapped
    @objc func changeDidTapped(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func getItNowTapped(_ sender:UIButton) {
        //scheduleDiabetesManagementAPI()
       
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "NursingReviewVC_WN") as! NursingReviewVC_WN
        //vc.selectedPackageObj = selectedPackage
        vc.diabetsPackageAmt = pkg_Price_MB
        vc.memberObject = selectedPersonObj
        vc.fromDate = ""
        vc.endDate = ""
        vc.dateCondition = 0
        vc.selectedNursingType = self.selectedNursingType
        vc.selectedCityObject = self.selectedCityObject
        vc.selectedDurationType = DurationType.noOfDays
        vc.isDateRange = false
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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

}


extension DiabetesManagementVC {
    
    func sendHHCBookingData(stringURL:String) {
        
        print("Schedule Nurisng Info")
        
        ServerRequestManager.serverInstance.postDataToServer(url: stringURL, dictionary: NSDictionary(), view: self, onComplition: { (response, error) in
            
            if let msgDict = response?["message"].dictionary
            {
                guard let status = msgDict["Status"]?.bool else {
                    return
                }
                
                if status == true {
                    /*let msg = msgDict["Message"]?.stringValue
                     self.displayActivityAlert(title: msg ?? "")
                     
                     DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                     self.navigationController?.popToRootViewController(animated: true)
                     }*/
                    if let msgValue = msgDict["Message"]?.stringValue
                    {
                        print("msgValue: ",msgValue)
                        let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"AppointmentScheduledVC") as! AppointmentScheduledVC
                        vc.modalPresentationStyle = .custom
                        vc.modalTransitionStyle = .crossDissolve
                        vc.appointmentOkDelegate = self as AppointmentConfirmedProtocol
                        vc.responseMsg = msgValue
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
    
    private func getMemberID() -> String {
        var personSrNo = ""
        if isReschedule {
            if let personSrRes = appointmentObject.APPNT_PERSON_SR_NO {
                personSrNo = personSrRes
            }
        }
        else {
            if let personSr = selectedPersonObj.ExtPersonSRNo?.description {
                personSrNo = personSr
            }
        }
        return personSrNo
    }
    
    func getPkgPriceDMFromServer() {
        
        print("GetPkgPriceDM Info")
        
        let url = APIEngine.shared.getPkgPriceDMURL()
        print(url)
        
        
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        
                         if let packagesArray = response?["Packages"].arrayValue {
                            print("packagesArray: ",packagesArray)
                            for package in packagesArray {
                                print("package::::",package["PKG_PRICE_MB"])
                                var amount = package["PKG_PRICE_MB"].stringValue
                                if amount != ""{
                                    self.pkg_Price_MB = amount.currencyInputFormatting()
                                }
                                else{
                                    self.pkg_Price_MB = "0"
                                }
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
                else {
                    self.displayActivityAlert(title: m_errorMsg )
                }
            }
        }
    }
}
    
