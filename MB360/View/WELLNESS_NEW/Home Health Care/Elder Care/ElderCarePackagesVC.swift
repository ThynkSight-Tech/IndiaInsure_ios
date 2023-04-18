//
//  ElderCarePackagesVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 27/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class ElderCarePackagesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    var isMetroCities = true
    var metroPackagesCount = 2
    var othersCityPackageCount = 1
    var selectedNursingType : NursingType?
    var selectedPersonObj = FamilyDetailsModelHHC()

    var firstOtherCityTitles = ["Features","Need assessment on call",
                                "Lab tests *71 parameters",
                                "Assessment/discussion on call with Doctor",
                                "Dedicated Health Manager 24x7 on call",
                                "Designated Doctor calls",
                                "Health Manager calls",
                                "Nutrition Tele Consultation",
                                "Unlimited Doctor Tele Consultation",
                                "Emergency Device/Glucometer",
                                "Hospital Information and Assistance",""]
    var firstOtherCityDetails = ["Portea Health Prime - Remote Locations", "","","","","6","12","4","","","","Starting from ₹ 5,000/-"]
    
    
    
    var firstMetroCityTitles = ["Features",
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
    var firstMetroCityDetails = ["Health Prime Plan (Annual)", "","","","4","6","","1","","","","","Starting from ₹ 15,000/-"]
    
    var secondMetroCityDetails = ["Health Prime Plus Plan (Annual)", "","","","12","12","","1","","","","","Starting from ₹ 20,000/-"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleSelected = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleNotSelected = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        segment.setTitleTextAttributes(titleNotSelected, for: .normal)
        segment.setTitleTextAttributes(titleSelected, for: .selected)
        
        //self.tableView.estimatedRowHeight = 100;
        //self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        //Remove Extra space on tablview Content inset
        //var frame = CGRect.zero
        //frame.size.height = .leastNormalMagnitude
        //tableView.tableHeaderView = UIView(frame: frame)
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        print("In \(navigationItem.title ?? "") ElderCarePackagesVC")

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
          self.dismiss(animated: true, completion: nil)
      }
    

    
}


extension ElderCarePackagesVC : UITableViewDelegate,UITableViewDataSource {
    
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
        if isMetroCities {
            return firstMetroCityTitles.count
        }
        return firstOtherCityTitles.count
        }
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSelectedMemberHHC", for: indexPath) as! CellForSelectedMemberHHC

            cell.lblName.text = self.selectedPersonObj.PersonName ?? ""
            
            cell.btnChange.addTarget(self, action: #selector(changeDidTapped(_:)), for: .touchUpInside)

            return cell
        }
        else
        {
            
            
            if indexPath.row == 0 { //For Blue Title
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForElderCarePackages", for: indexPath) as! CellForElderCarePackages
                
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
                if indexPath.row == rows - 1 { //Last
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForElderCarePriceCell", for: indexPath) as! CellForElderCarePriceCell
                    
                    if isMetroCities {
                        if indexPath.section == 1 { //Use First Array
                            cell.lblSecond.attributedText = handleRuppeeText(customFontString:firstMetroCityDetails[indexPath.row], SystemFontString: "₹")
                            
                        }
                        else { //Use Second Array
                            cell.lblSecond.attributedText = handleRuppeeText(customFontString:secondMetroCityDetails[indexPath.row], SystemFontString: "₹")
                        }
                    }
                    else {
                        cell.lblSecond.attributedText =   handleRuppeeText(customFontString:firstOtherCityDetails[indexPath.row], SystemFontString: "₹")
                    }
                    
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForElderCareDetails", for: indexPath) as! CellForElderCareDetails
                    
                    
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        }
        return UITableViewAutomaticDimension
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        view.backgroundColor = UIColor.clear
        return view

    }

    
    @objc func changeDidTapped(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
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

}
