//
//  DentalMemberListVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 01/01/21.
//  Copyright © 2021 Semantic. All rights reserved.
//

import UIKit

class DentalMemberListVC: UIViewController,MobileEmailVerifyProtocol,MobileNumberVerifyDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var personDetailsArray = [FamilyDetailsModelHHC]()
    var selectedMemberIndex = -1
    var selectedPackage : DentalPackageModel?
    override func viewDidLoad() {
        menuButton.isHidden = true
        tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        
        
        getFamilyDetailsFromServer()
        
        print("In \(navigationItem.title ?? "") DentalMemberListVC")
    }
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Get Data From Server
    private func getFamilyDetailsFromServer() {
        
        guard let orderMasterNo = UserDefaults.standard.value(forKey: "OrderMasterNo") else {
            return
        }
        
        var m_employeedict : EMPLOYEE_INFORMATION?
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_employeedict=userArray[0]
        var empidNo = String()
        
        if let empID = m_employeedict?.empIDNo
        {
            empidNo=String(empID)
        }
        
        print(empidNo)
        
        //Change Service ID on API Integrations
        let serviceId = "10"
        let url = APIEngine.shared.getFamilyMembersHHC_API(empId: empidNo, groupCode:self.getGroupCode(), WellSrNo: serviceId)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        if let personArray = response?["FamilyMembers"].arrayValue {
                            self.personDetailsArray.removeAll()
                            
                            for person in personArray {
                                
                                let modelObj = FamilyDetailsModelHHC.init(PersonName: person["PERSON_NAME"].stringValue.capitalized, DateOfBirth: person["DOB"].stringValue, Gender: person["GENDER"].stringValue, RelationID: person["RELATIONID"].stringValue, RelationName: person["RELATION_NAME"].stringValue.capitalized, EXT_EMPLOYEE_SR_NO: person["EXT_EMPLOYEE_SR_NO"].stringValue, ExtPersonSRNo: person["EXT_PERSON_SR_NO"].stringValue, CellPhoneNumber: person["CELLPHONE_NUMBER"].stringValue, EmailID: person["EMAIL_ID"].stringValue, IS_ADDRESS_SAVED: person["IS_ADDRESS_SAVED"].stringValue,AGE:person["AGE"].stringValue)
                                
                                
                                //let age = person["Age"].stringValue
                                // if let ageInt = Int(age)
                                //{
                                // if ageInt >= 18 {
                                self.personDetailsArray.append(modelObj)
                                //  }
                                // }
                                
                                 
                            }
                            self.tableView.reloadData()
                            
                        }
                         
                    }
                    else {
                        //employee record not found
                        self.view.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                        //let msg = messageDictionary["Message"]?.string
                        self.displayActivityAlert(title: m_errorMsg )
                    }
                }
            }//msgDic
        }
    }
    
    func mobileNumberVerified() {
        let vc = UIStoryboard.init(name: "Dental", bundle: nil).instantiateViewController(withIdentifier:"DentalClinicVC") as! DentalClinicVC
        vc.isFromFamily = 1
        vc.personDetailsModel = FamilyDetailsModel()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension DentalMemberListVC : UITableViewDelegate,UITableViewDataSource
{
    //MARK:- TableView Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return personDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSelectedMemberHHC", for: indexPath) as! CellForSelectedMemberHHC
            cell.lblName.text = selectedPackage?.packageName ?? ""
            
            return cell
        }
        else {
            
            let familyInfoCell = tableView.dequeueReusableCell(withIdentifier: "CellForNursingMemberList", for: indexPath) as! CellForNursingMemberList
            
            familyInfoCell.lblPersonName.text = personDetailsArray[indexPath.row].PersonName?.capitalized
            familyInfoCell.lblRelation.text = personDetailsArray[indexPath.row].RelationName?.capitalized
            
            //Set Age
            if let age = personDetailsArray[indexPath.row].AGE {
                if age != "" {
                    if age == "0" || age == "1" {
                        familyInfoCell.lblAge.text = String(format: "%@ Year",personDetailsArray[indexPath.row].AGE ?? "")
                    }
                    else {
                        familyInfoCell.lblAge.text = String(format: "%@ Years",personDetailsArray[indexPath.row].AGE ?? "")
                    }
                }
                else {
                    familyInfoCell.lblAge.text = ""
                    
                }
            }
            
            
            familyInfoCell.btnSelect.tag = indexPath.row
            //familyInfoCell.btnSelect.addTarget(self, action: #selector(selectDidTapped(_:)), for: .touchUpInside)
            
            if indexPath.row == selectedMemberIndex {
                //familyInfoCell.cellForViewDetailsView.isHidden = false
                familyInfoCell.imgTickView.isHidden = false
                //familyInfoCell.heightForViewDetails.constant = 50
                if personDetailsArray[indexPath.row].IS_ADDRESS_SAVED == "0" {
                    familyInfoCell.lblViewDetails.text = "Add Address"
                }
                else {
                    familyInfoCell.lblViewDetails.text = "Get Package"
                }
            }
            else
            {
                // familyInfoCell.cellForViewDetailsView.isHidden = true
                familyInfoCell.imgTickView.isHidden = true
                // familyInfoCell.heightForViewDetails.constant = 0
                familyInfoCell.lblViewDetails.text = "Select Member"
                
            }
            
            return familyInfoCell
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"VerifyMobileNoViewController") as! VerifyMobileNoViewController
            vc.modalPresentationStyle = .custom
            vc.mobileNumberDelegate = self
            
            vc.isTemp = true
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func isMobileEmailVerified(isSuccess: Bool, selectedPersonObj: FamilyDetailsModelHHC) {
        print("Verified. . . . . ")
        let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HospitalsListViewController") as! HospitalsListViewController
        vc.isFromFamily = 1
        //vc.personDetailsModel = self.personDetailsModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
