//
//  DentalPackagesVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 25/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class DentalPackagesVC: UIViewController {
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblSummaryPrice: UILabel!
    var PackageNames = [
        "CLEANING AND POLISHING WITH DENTAL CHECKUP",
        "CLEANING AND FILLING WITH DENTAL CHECKUP",
        "CLEANING AND WHITENING WITH DENTAL CHECKUP",
        "ROOT CANAL & CROWN WITH DENTAL CHECKUP"
    ]
    
    var PackageAmount = ["499","1,999","3,999","4,999"]
    
    var DentalPackageId = [
        "11","12","13","14"
    ]
    
    var m_productCode = String()
    var selectedDentalPackages = [HealthPackage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("#VDL-Dental")

        navigationController?.isNavigationBarHidden=false
        self.navigationItem.leftBarButtonItem = getBackButtonHideTabBar()
        self.title = "Dental Packages"
        
        tableView.register(CellForNextButtonBottom.self, forCellReuseIdentifier: "CellForNextButtonBottom")
        tableView.register(UINib(nibName: "CellForNextButtonBottom", bundle: nil), forCellReuseIdentifier: "CellForNextButtonBottom")

        
        getPersonDetails()
    }
    
    
    @objc private func viewDetailsTapped(_ sender : UIButton) {
        
    }
    
    @objc private func packageIncludesTapped(_ sender : UIButton) {
        
    }
    var maleArray = Array<PERSON_INFORMATION>()
    
    func getPersonDetails()
    {
        maleArray=[]
        // m_membersRelationIdArray=[]
        //  m_membersArray=[]
        m_productCode="GMC"
        
        let array = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: m_spouse)
        if(array.count>0)
        {
            maleArray.append(array[0])
        }
        
        let arrayOFSelf = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "EMPLOYEE")
        if(arrayOFSelf.count>0)
        {
            if arrayOFSelf[0].gender?.lowercased() == "male" {
                maleArray.append(arrayOFSelf[0])
            }
            else {
                maleArray.append(arrayOFSelf[0])
            }
        }
        
        
        let arrayofSon = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "SON")
        if(arrayofSon.count>0)
        {
            
            if(arrayofSon.count==2)
            {
                maleArray.append(arrayofSon[0])
                maleArray.append(arrayofSon[1])
            }
            else if(arrayofSon.count==3)
            {
                maleArray.append(arrayofSon[0])
                maleArray.append(arrayofSon[1])
                maleArray.append(arrayofSon[2])
            }
            else
            {
                maleArray.append(arrayofSon[0])
            }
        }
        
        
        let arrayofDaughter = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "DAUGHTER")
        if(arrayofDaughter.count>0)
        {
            if(arrayofDaughter.count==2)
            {
                maleArray.append(arrayofDaughter[0])
                maleArray.append(arrayofDaughter[1])
            }
            else if(arrayofDaughter.count==3)
            {
                maleArray.append(arrayofDaughter[0])
                maleArray.append(arrayofDaughter[1])
                maleArray.append(arrayofDaughter[2])
            }
            else
            {
                maleArray.append(arrayofDaughter[0])
            }
        }
        
        let fatherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER")
        if(fatherarray.count>0)
        {
            maleArray.append(fatherarray[0])
        }
        let motherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER")
        if(motherarray.count>0)
        {
            maleArray.append(motherarray[0])
        }
        let fatherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER-IN-LAW")
        if(fatherInLawarray.count>0)
        {
            maleArray.append(fatherInLawarray[0])
        }
        let motherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER-IN-LAW")
        if(motherInLawarray.count>0)
        {
            maleArray.append(motherInLawarray[0])
        }
        
        self.tableView.reloadData()
        print(maleArray)
        // getRelationsfromServer()
        
        
    }
}


extension DentalPackagesVC : UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.PackageNames.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let secCount = tableView.numberOfSections
        if section != secCount - 1 { //not last
            return maleArray.count + 1
        }
        else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let secCount = tableView.numberOfSections
        if indexPath.section != secCount - 1 { //not last
            if indexPath.row == 0 {
                return 200
            }
            else {
                return 35
            }
        }
        else {
            return 60
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let secCount = tableView.numberOfSections
        if indexPath.section != secCount - 1 { //not last
            if indexPath.row == 0 { //
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForDentalPackages", for: indexPath) as! CellForDentalPackages
                //shadowForCell(view: cell.backView)
                
                cell.btnViewDetails.tag = indexPath.row
                cell.btnViewDetails.addTarget(self, action: #selector(self.viewDetailsTapped(_:)), for: .touchUpInside)
                
                cell.lblPackName.text = PackageNames[indexPath.section]
                cell.lblPrice.text = "₹" + PackageAmount[indexPath.section]
                cell.btnPackageIncludes.tag = indexPath.row
                cell.btnPackageIncludes.addTarget(self, action: #selector(self.packageIncludesTapped(_:)), for: .touchUpInside)
                
                return cell
            }
            else { //name cell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForFlexPremium", for: indexPath) as! CellForFlexPremium
                cell.lblPremiumAmount.text = ""
                //                shadowForCell(view: cell.backView)
                
                //designCardBox(view: cell.viewBox)
                
                cell.lblRelation.text = maleArray[indexPath.row - 1].personName
                let userId = Int(maleArray[indexPath.row - 1].personSrNo)
                let packId = DentalPackageId[indexPath.section]
                
                let filtered = selectedDentalPackages.filter({$0.packId == packId && $0.userId == userId})
                if filtered.count == 0 {
                    cell.imgView.image = UIImage(named: "unchecked") //unchecked
                }
                else {
                    cell.imgView.image = UIImage(named: "checked")
                }

                return cell
            }
        }
            else { //
//                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForBtnAddParentCell", for: indexPath) as! CellForBtnAddParentCell
//                cell.btnAddParent.tag = indexPath.row
//                cell.btnAddParent.addTarget(self, action: #selector(moveToNext(_:)), for: .touchUpInside)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForNextButtonBottom", for: indexPath) as! CellForNextButtonBottom
                               cell.btnNext.tag = indexPath.row
                              cell.btnNext.addTarget(self, action: #selector(moveToNext(_:)), for: .touchUpInside)
                             cell.isUserInteractionEnabled = true
            cell.btnNext.isHidden = false

                
                return cell
            }
        }
        
    //MARK:- Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            let packId = DentalPackageId[indexPath.section]
            var userId = 0
            let priceAmount = PackageAmount[indexPath.section]

            
            //for male
                userId = Int(maleArray[indexPath.row - 1].personSrNo)
                let filtered = selectedDentalPackages.filter({$0.packId == packId && $0.userId == userId})
                if filtered.count == 0 {
                    let obj = HealthPackage.init(packId: packId, userName: "", userId: userId,price: Int(priceAmount))
                    self.selectedDentalPackages.append(obj)
                }
                else { //remove form array
                    self.selectedDentalPackages = selectedDentalPackages.filter ({$0.userId != userId || $0.packId != packId})
                   // self.tableView.reloadData()
                }

            //var total = selectedDentalPackages.reduce(0, $0.price! + $1.price!)
            
            if selectedDentalPackages.count > 0 {
            var totalSum = selectedDentalPackages.map({$0.price ?? 0}).reduce(0, +)
            self.lblSummaryPrice.text = String(totalSum)
            }
            else {
                self.lblSummaryPrice.text = ""
            }
            print(selectedDentalPackages)
            self.tableView.reloadData()
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
            return footerView
        }

        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 5
        }
        
    }
        
        
        /*
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let totalRows = tableView.numberOfRows(inSection: indexPath.section)
         if indexPath.row != totalRows - 1 {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "CellForDentalPackages", for: indexPath) as! CellForDentalPackages
         shadowForCell(view: cell.backView)
         
         cell.btnViewDetails.tag = indexPath.row
         cell.btnViewDetails.addTarget(self, action: #selector(self.viewDetailsTapped(_:)), for: .touchUpInside)
         
         
         cell.btnPackageIncludes.tag = indexPath.row
         cell.btnPackageIncludes.addTarget(self, action: #selector(self.packageIncludesTapped(_:)), for: .touchUpInside)
         
         return cell
         }
         else { //
         let cell = tableView.dequeueReusableCell(withIdentifier: "CellForBtnAddParentCell", for: indexPath) as! CellForBtnAddParentCell
         cell.btnAddParent.tag = indexPath.row
         cell.btnAddParent.addTarget(self, action: #selector(moveToNext(_:)), for: .touchUpInside)
         
         return cell
         }
         }
         */
        @objc private func moveToNext(_ sender : UIButton) {
            let summaryVC : EnrollmentSummaryViewController = EnrollmentSummaryViewController()
            summaryVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            summaryVC.m_windowPeriodEndDate=m_windowPeriodEndDate
            self.navigationController?.pushViewController(summaryVC, animated: true)
        }
        
}
