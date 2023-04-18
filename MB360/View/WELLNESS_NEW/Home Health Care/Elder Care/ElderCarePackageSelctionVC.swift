//
//  ElderCarePackageSelctionVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 27/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class ElderCarePackageSeletionVC:UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // @IBOutlet weak var segment: UISegmentedControl!
    
    var isMetroCities = true
    
    var metroPackagesCount = 2
    var othersCityPackageCount = 1
    var selectedNursingType : NursingType?
    var selectedPersonObj = FamilyDetailsModelHHC()
    var expanded = -1
    var selectedCityObject = CityListModel()
    var nursingPackageModelArray = [NusringPackageModel]()

    var firstOtherCityTitles = ["","Need assessment on call",
                                "Lab tests *71 parameters",
                                "Assessment/discussion on call with Doctor",
                                "Dedicated Health Manager 24x7 on call",
                                "Designated Doctor calls",
                                "Health Manager calls",
                                "Nutrition Tele Consultation",
                                "Unlimited Doctor Tele Consultation",
                                "Emergency Device/Glucometer",
                                "Hospital Information and Assistance",""]
        //var firstOtherCityDetails = ["Portea Health Prime - Remote Locations", "","","","","6","12","4","","","","Price starting from ₹ 5/-"]
    //HEALTH PRIME PLUS PLAN (ANNUAL)
    var firstOtherCityDetails = ["Portea Health Prime (Annual)", "","","","","6","12","4","","","","Price starting from ₹ /-"]

    var firstMetroCityTitles = ["",
                                "Comprehensive Geriatric Assessment@ home",
                                "Comprehensive health check (71+parameters)",
                                "Dedicated Health Manager 24x7 on call",
                                "Doctor Visits",
                                "Health Manager Visits",
                                "Physiotherapy Visits",
                                "Nutrition Tele Consultation",
                                "Unlimited Doctor Tele consultation",
                                "Glucometer with 20 strips",
                                "Hospital Information and Assistance",
                                "Social Engagement",
                                ""]
    var firstMetroCityDetails = ["Health Prime Plan (Annual)", "","","","4","6","4","1","","","","","Price starting from ₹ /-"]
    
    var secondMetroCityDetails = ["Health Prime Plus Plan (Annual)", "","","","12","12","","1","","","","","Price starting from ₹ /-"]
    
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true
        setupNavBarDetails()
        super.viewDidLoad()
        //let titleSelected = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //let titleNotSelected = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        //segment.setTitleTextAttributes(titleNotSelected, for: .normal)
       // segment.setTitleTextAttributes(titleSelected, for: .selected)
        
        //self.tableView.estimatedRowHeight = 100;
        //self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        //Remove Extra space on tablview Content inset
        //var frame = CGRect.zero
        //frame.size.height = .leastNormalMagnitude
        //tableView.tableHeaderView = UIView(frame: frame)
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        
        let customFont = UIFont(name: "Poppins-Medium",
        size: 16)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: customFont!], for: .normal)
        let rightBtn = UIBarButtonItem(title: "Packages", style: .plain, target: self, action: #selector(viewPackagesTapped))

        //navigationItem.rightBarButtonItem = rightBtn

        tableView.tableFooterView = UIView()
        getPackageListForElderCare()
        
        print("In \(navigationItem.title ?? "") ElderCarePackageSeletionVC")
    }
    
    
    func setupNavBarDetails()
    {
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        
        lbNavTitle.text = "Elder Care"
        self.navigationItem.titleView = lbNavTitle
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
    }
    
    @objc func viewPackagesTapped(_ sender : UIBarButtonItem) {
        let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"ElderCarePackagesVC") as! ElderCarePackagesVC
        //let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"ElderCarePackageSeletionVC") as! ElderCarePackageSeletionVC
        
        vc.selectedPersonObj = selectedPersonObj
        vc.selectedNursingType = self.selectedNursingType

        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    @IBAction func segmentChanges(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isMetroCities = true
        }
        else {
            isMetroCities = false
        }
        self.tableView.reloadData()
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
      }
    
}


extension ElderCarePackageSeletionVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        if isMetroCities {
            return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            if expanded == section {
                if isMetroCities {
                    return firstMetroCityTitles.count
                }
                return firstOtherCityTitles.count
                
            }
            else {
                return 2
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { //SelectedMember
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSelectedMemberHHC", for: indexPath) as! CellForSelectedMemberHHC

            //cell.lblName.text = self.selectedPersonObj.PersonName ?? ""

            var data = "\(self.selectedPersonObj.PersonName ?? "") \n\(self.selectedPersonObj.RelationName ?? "") (\(self.selectedPersonObj.AGE ?? "") years)"
            print("data: ",data)
            cell.lblName.text = data
            
            cell.btnChange.addTarget(self, action: #selector(changeDidTapped(_:)), for: .touchUpInside)

            return cell
        }
        else
        {
            
            if indexPath.row == 0 { //For Blue Title
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForElderCarePackages", for: indexPath) as! CellForElderCarePackages
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)

                if isMetroCities {
                    if indexPath.section == 1 {
                        cell.lblFeature.text = firstMetroCityTitles[indexPath.row]
                        cell.lblSecond.text = firstMetroCityDetails[indexPath.row]
                    }
                    else {
                        cell.lblFeature.text = firstMetroCityTitles[indexPath.row]
                        cell.lblSecond.text = secondMetroCityDetails[indexPath.row]
                    }
                }
                else {
                    cell.lblFeature.text = firstOtherCityTitles[indexPath.row]
                    cell.lblSecond.text = firstOtherCityDetails[indexPath.row]
                }
                return cell
            }
            else {
                
                let rows = tableView.numberOfRows(inSection: indexPath.section)
                if indexPath.row == rows - 1 { //Last Price Cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForElderCarePriceSelectionCell", for: indexPath) as! CellForElderCarePriceSelectionCell
                    let poppinsFont = UIFont(name: "Poppins-Medium",
                    size: 14)
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                    
                    if isMetroCities {
                        if indexPath.section == 1 { //Use First Array
                            
                            let price = getPackagePrice(cityId: selectedCityObject.Srno ?? "0", packageString: firstMetroCityDetails.first ?? "")
                            let stringPrice = String(format:"Price starting from ₹ %@",price.0)

                            cell.lblSecond.attributedText = handleRuppeeText(customFontString:stringPrice, SystemFontString: "₹")
                            cell.btnGetItNow.tag = price.1

                        }
                        else { //Use Second Array
                            //cell.lblSecond.text = secondMetroCityDetails[indexPath.row]
                            
                            let price = getPackagePrice(cityId: selectedCityObject.Srno ?? "0", packageString: secondMetroCityDetails.first ?? "")
                            let stringPrice = String(format:"Price starting from ₹ %@",price.0)
                            cell.lblSecond.attributedText = handleRuppeeText(customFontString:stringPrice, SystemFontString: "₹")
                            cell.btnGetItNow.tag = price.1

                        }
                    }
                    else {
                        //cell.lblSecond.text = firstOtherCityDetails[indexPath.row]
                        
                        let price = getPackagePrice(cityId: selectedCityObject.Srno ?? "0", packageString: firstOtherCityDetails.first ?? "")
                        let stringPrice = String(format:"Price starting from ₹ %@",price.0)
                        cell.lblSecond.attributedText = handleRuppeeText(customFontString:stringPrice, SystemFontString: "₹")
                        cell.btnGetItNow.tag = Int(price.1)

                    }
                    
                   
                    cell.btnGetItNow.addTarget(self, action: #selector(selectDidTapped(_:)), for: .touchUpInside)

                    
                    return cell
                }
                else { //Detail info or
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForElderCareDetails", for: indexPath) as! CellForElderCareDetails
                    
                    cell.separatorInset = UIEdgeInsetsMake(0, cell.layoutMargins.left, 0, 0)

                    if isMetroCities {
                        if indexPath.section == 1 { //Use First Array
                            cell.lblFeature.text = firstMetroCityTitles[indexPath.row]
                            if firstMetroCityDetails[indexPath.row] == "" {
                                cell.lblSecond.text = "\u{2713}"
                            }
                            else {
                                cell.lblSecond.text = firstMetroCityDetails[indexPath.row]
                            }
                        }
                        else { //Use Second Array
                            cell.lblFeature.text = firstMetroCityTitles[indexPath.row]
                            if secondMetroCityDetails[indexPath.row] == "" {
                                cell.lblSecond.text = "\u{2713}"
                            }
                            else {
                                cell.lblSecond.text = secondMetroCityDetails[indexPath.row]
                            }
                        }
                    }
                    else {
                        cell.lblFeature.text = firstOtherCityTitles[indexPath.row]
                        
                        if firstOtherCityDetails[indexPath.row] == "" {
                            cell.lblSecond.text = "\u{2713}"
                        }
                        else {
                            cell.lblSecond.text = firstOtherCityDetails[indexPath.row]
                        }
                        
                    }
                    
                    return cell
                }
            }
        }
    }
    
    @objc func selectDidTapped(_ sender:UIButton) {
        
        let filteredArray = self.nursingPackageModelArray.filter({($0.HHC_PKG_PRICING == sender.tag.description)})
        if filteredArray.count > 0 {
            let selectedPackage  = filteredArray[0]
        
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "NursingReviewVC_WN") as! NursingReviewVC_WN
        vc.selectedPackageObj = selectedPackage
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
    }
    
    private func getPackagePrice(cityId:String,packageString:String) -> (String,Int) {
        var price = "0"
        var packageId = 0
        let filteredArray = self.nursingPackageModelArray.filter({($0.HHC_NA_CITY_MAPP == cityId)&&($0.packageName.lowercased() == packageString.lowercased())})
        if filteredArray.count > 0 {
            let selectedPackage  = filteredArray[0]
             price = selectedPackage.PKG_PRICE_MB
            packageId = Int(selectedPackage.HHC_PKG_PRICING) ?? 0
        }
        
        return (price.currencyInputFormatting(),packageId)
    }
    

    func handleRuppeeText(customFontString: String, SystemFontString: String) -> NSAttributedString {
        let poppinsFont = UIFont(name: "Poppins-Medium",
        size: 14)

        let attributedString = NSMutableAttributedString(string: customFontString,
                                                         attributes: [NSAttributedString.Key.font: poppinsFont!])
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: poppinsFont!.pointSize)]
        let range = (customFontString as NSString).range(of: SystemFontString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
      {
        if indexPath.section != 0 {
        print(indexPath)
        if expanded == indexPath.section {
            expanded = -1
        }
        else {
        expanded = indexPath.section
        }
        self.tableView.reloadData()
        }
      }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 0 {
        return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        view.backgroundColor = UIColor.clear
        return view

    }

    
    @objc func changeDidTapped(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- Elder Care API
extension ElderCarePackageSeletionVC {
    func getPackageListForElderCare() {
        
        var url = APIEngine.shared.getElderCarePackagesAPI()
        
           print(url)
           ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
               
               if let messageDictionary = response?["message"].dictionary
               {
                   if let status = messageDictionary["Status"]?.bool
                   {
                       if status == true {
                           
                        self.nursingPackageModelArray.removeAll()
                        
                           if let packagesArray = response?["Packages"].arrayValue {
                               
                                    for package in packagesArray {
                                        //                                                   "HHC_EC_PKG_PRICING_SR_NO": "1",
                                        //                                                   "HHC_NA_CITY_MAPP_SR_NO": "1",
                                        //                                                   "CATEGORY": "HEALTH PRIME PLAN (ANNUAL)",
                                        //                                                   "PKG_PRICE_MB": "15000"
                                        
                                        let obj = NusringPackageModel.init(HHC_PKG_PRICING: package["HHC_EC_PKG_PRICING_SR_NO"].stringValue, HHC_NA_CITY_MAPP: package["HHC_NA_CITY_MAPP_SR_NO"].stringValue, HHC_NA_HOURS: "", HHC_NA_DURATIONS: "", HHC_NA_NACOUNT: "", PKG_PRICE_MB: package["PKG_PRICE_MB"].stringValue, packageName:package["CATEGORY"].stringValue)
                                        
                                        self.nursingPackageModelArray.append(obj)
                                    }
                            self.tableView.reloadData()
                           }
                       }
                       else {
                           //let msg = messageDictionary["Message"]?.stringValue
                           self.displayActivityAlert(title: m_errorMsg)
                       }
                   }
               }
           }//msgDic
       }
}
