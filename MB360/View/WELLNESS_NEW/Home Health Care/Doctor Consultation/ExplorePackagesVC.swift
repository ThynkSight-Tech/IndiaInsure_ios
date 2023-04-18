//
//  ExplorePackagesVC.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 08/01/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ExplorePackagesVC: UIViewController,passDataProtocol{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //Variables declaration
    var m_employeeDict : EMPLOYEE_INFORMATION?
    var explorePackageDataModelArray = [DatumModel]()
    var explorePackageDataDetailModelArray = [DetailModel]()
    var bannerImageArray = ["Group 12488","Group 12489","Group 12490","Group 12491","Group 12492"]
    var tickImageArray = ["Group 736","Group 737","Group 738","Group 739","Group 740"]
    //var btnImageArray = ["greenBtn","purpleBtn","pinkBtn","orangeBtn","blueBtn"]
    var btnImageArray = ["Rectangle 163","Rectangle 163-1","Rectangle 163-2","Rectangle 163-3","Rectangle 163-4"]
    var maxCellCount = 0
    var pressed_pkgPlanSrNo = ""
    var btnPressedPosition = -1
    var Well_Ext_Emp_SrNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarDetails()
        getEmployeeDCPackages()
        
    }
    
    func setupNavBarDetails()
    {
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        //cartBottomView.backgroundColor = Color.bottomColor.value
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        
        lbNavTitle.text = "Available packs"
        self.navigationItem.titleView = lbNavTitle
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        //self.navigationItem.title = "Available packs"
        //self.navigationController?.navigationBar.changeFont()
    }
    
    
    @objc func backTapped() {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func btnTapped(_ sender : UITapGestureRecognizer) {
        // print("Btn Tapped",btnPressedPosition)
        
       // getIsDCTermsAgreed()
     }
    
    func pass(_ type: String) {
        if type.lowercased() == "dismiss"{
                                    let buyDCPackageVC = UIStoryboard.init(name: "Wellness_New", bundle: nil).instantiateViewController(withIdentifier:"BuyDCPackageVC") as! BuyDCPackageVC
            
                                    self.navigationController?.pushViewController(buyDCPackageVC, animated: true)
        }
    }
 
}

extension ExplorePackagesVC: UITableViewDelegate,UITableViewDataSource,ExploreBtnDetailsDataProtocol{
    func sendBtnData(pkgPlanSrNo passValue: String, position: Int) {
        print("ExploreBtnDetailsData: ",passValue," : ",position)
        
        btnPressedPosition = position
        getIsDCTermsAgreed()
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("maxCellCount maxCellCount maxCellCount: ",maxCellCount)
        
        if indexPath.row == 0{
            return UITableViewAutomaticDimension
        }
        else if indexPath.row == indexPath.last{
            return UITableViewAutomaticDimension
        }
        else{
            return 40
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("explorePackageDataModelArray.count +1 : ",explorePackageDataModelArray.count+1)
        return explorePackageDataModelArray.count+1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        print("explorePackageDataModelArray[section-1].details.count +1  : ",explorePackageDataModelArray[section-1].details.count+1)
        maxCellCount = explorePackageDataModelArray[section-1].details.count + 1
        print("maxCellCount : ",maxCellCount)
        return maxCellCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("maxCellCount : ",maxCellCount,"Index path ",indexPath.row)
        if indexPath.row == 0 { //  price cell
            let cell =
            tableView.dequeueReusableCell(withIdentifier: "CellForExploreHCCardTableViewCell", for: indexPath) as! CellForExploreHCCardTableViewCell
            print("indexPath.section: ",indexPath.section)
            
            cell.view.clipsToBounds = true
            cell.view.layer.cornerRadius = cornerRadiusForView//8
            cell.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            cell.bgImg.image = UIImage(named: bannerImageArray[indexPath.section - 1])
            
            cell.planName.text = explorePackageDataModelArray[indexPath.section-1].pkgName
            cell.duration.text = explorePackageDataModelArray[indexPath.section-1].dcPkgPrice //change duration
            cell.planAmountWithGst.text = explorePackageDataModelArray[indexPath.section-1].dcPkgPrice
            cell.gstMsg.text = "Per user inclusive of GST"
            
            return cell
        }
        else { //name cell
            print("maxCellCount : ",maxCellCount,"Index path ",indexPath.row)
            let cell =
            tableView.dequeueReusableCell(withIdentifier: "CellForExploreDetailsCardTableViewCell", for: indexPath) as! CellForExploreDetailsCardTableViewCell
            
            
            print("indexPath.row: ",indexPath.row-1,": Section:: ",indexPath.section-1)
            var data = explorePackageDataModelArray[indexPath.section-1].details[indexPath.row-1]
            
            var index = indexPath.row-1
            var maxindex = explorePackageDataModelArray[indexPath.section-1].details.count-1
            print("maxindex:::",maxindex," :index: ",index)
            
            if data.catogary != nil || data.calls != nil{
                
                
                cell.btnView.isHidden = true
                cell.bgView.isHidden = false
               
                //Tick Image
                cell.tickImg.image = UIImage(named: tickImageArray[indexPath.section - 1])
                //cell.bgView.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
                //cell.bgView.layer.addBorder(edge: .right, color: .lightGray, thickness: 1)
               
                if index == 0{
                    cell.bgView.backgroundColor = .clear
                    //cell.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
                    //cell.layer.addBorder(edge: .right, color: .lightGray, thickness: 1)
                   
                    cell.contentLbl.text = "\(data.calls!) calls per user."
                }
                else if index == maxindex-1{
                    cell.bgView.backgroundColor = .clear
                    //cell.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
                    //cell.layer.addBorder(edge: .right, color: .lightGray, thickness: 1)
                   
                    cell.contentLbl.text = "Covers 1 user + \(data.dependent!) dependents."
                }
                else{
                    cell.bgView.backgroundColor = .clear
                    //cell.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
                    //cell.layer.addBorder(edge: .right, color: .lightGray, thickness: 1)
                   
                    cell.contentLbl.text = data.catogary
                }
            }
            else{
                
                cell.btnView.isHidden = false
                cell.bgView.isHidden = true
                
                //cell.btnBorderView.clipsToBounds = true
                //cell.btnBorderView.layer.cornerRadius = 8
                //cell.btnBorderView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                
                //cell.btnBorderView.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
                //cell.btnBorderView.layer.addBorder(edge: .right, color: .lightGray, thickness: 1)
                
                //cell.bottomBorder.backgroundColor = .clear
                cell.buyBtnView.backgroundColor = UIColor(patternImage: UIImage(named:btnImageArray[indexPath.section-1])!)
            
                //cell.buyBtn.setBackgroundImage(UIImage(named:btnImageArray[indexPath.section-1]), for: .normal)
                //cell.buyBtnView.setImage(UIImage(named:btnImageArray[indexPath.section-1]), for: .normal)
                cell.buyBtnView.layer.cornerRadius = 20
                pressed_pkgPlanSrNo = explorePackageDataModelArray[indexPath.section-1].pkgPlanSrNo ?? "0"
                
                cell.delegate = self
                cell.getIndexPath(indexpath: indexPath.section, pkg_Plan_Sr_No: pressed_pkgPlanSrNo)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(btnTapped(_:)))
                cell.buyBtnView.isUserInteractionEnabled = true
                cell.buyBtnView.addGestureRecognizer(tap)
            }
            return cell
            
        } //else END
    }

}


//API Call
extension ExplorePackagesVC{
    
    func getEmployeeDCPackages(){
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
        m_employeeDict=userArray[0]
        
        guard let Wellness_Ext_Employee_Sr_No = UserDefaults.standard.value(forKey: "Wellness_Ext_Employee_Sr_No") else {
            return
        }
        Well_Ext_Emp_SrNo = Wellness_Ext_Employee_Sr_No as! String
       
        let url = APIEngine.shared.getEmployeeDCPackages(EmployeeSrNo: Well_Ext_Emp_SrNo, VendorSrNo: "1")
        
        print("getEmployeeDCPackages: ",url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            do{
                if let status = response?["Status"].bool
                {
                    if status == true {
                        self.explorePackageDataModelArray.removeAll()
                        
                        if let datum = response?["Data"].array{
                            
                            for data in datum{
                                var exploreDetailArray = [DetailModel]()
                                
                                if let detailArray = data["details"].array{
                                    for detail in detailArray{
                                        let detailsModelObj = DetailModel.init(
                                            packagePlanSrNo: detail["PACKAGE_PLAN_SR_NO"].int,
                                            pkgName: detail["PKG_NAME"].string,
                                            experiance: detail["EXPERIANCE"].string,
                                            catogary: detail["CATOGARY"].string,
                                            dcPkgPrice: detail["DC_PKG_PRICE"].string,
                                            includeGst: detail["INCLUDE_GST"].string,
                                            calls: detail["CALLS"].string,
                                            validityMonth: detail["VALIDITY_MONTH"].string,
                                            dependent: detail["DEPENDENT"].string)
                                        
                                        print("detailsModelObj: ",detailsModelObj)
                                        exploreDetailArray.append(detailsModelObj)
                                        
                                    }
                                    
                                    self.explorePackageDataDetailModelArray = exploreDetailArray
                                    if exploreDetailArray.count > 0{
                                        let detailsModelObj1 = DetailModel.init(
                                            packagePlanSrNo: exploreDetailArray[0].packagePlanSrNo,
                                            pkgName: exploreDetailArray[0].pkgName,
                                            experiance: exploreDetailArray[0].experiance,
                                            catogary: exploreDetailArray[0].catogary,
                                            dcPkgPrice: exploreDetailArray[0].dcPkgPrice,
                                            includeGst: exploreDetailArray[0].includeGst,
                                            calls: exploreDetailArray[0].calls,
                                            validityMonth: exploreDetailArray[0].validityMonth,
                                            dependent: exploreDetailArray[0].dependent)
                                        
                                        self.explorePackageDataDetailModelArray.insert(detailsModelObj1, at: 0)
                                        
                                        let detailsModelObj2 = DetailModel.init(
                                            packagePlanSrNo: exploreDetailArray[0].packagePlanSrNo,
                                            pkgName: exploreDetailArray[0].pkgName,
                                            experiance: exploreDetailArray[0].experiance,
                                            catogary: exploreDetailArray[0].catogary,
                                            dcPkgPrice: exploreDetailArray[0].dcPkgPrice,
                                            includeGst: exploreDetailArray[0].includeGst,
                                            calls: exploreDetailArray[0].calls,
                                            validityMonth: exploreDetailArray[0].validityMonth,
                                            dependent: exploreDetailArray[0].dependent)
                                        
                                        self.explorePackageDataDetailModelArray.insert(detailsModelObj2, at: self.explorePackageDataDetailModelArray.count)
                                        
                                  
                                        let detailsModelObj3 = DetailModel.init(
                                            packagePlanSrNo: nil,
                                            pkgName: nil,
                                            experiance: nil,
                                            catogary: nil,
                                            dcPkgPrice: nil,
                                            includeGst: nil,
                                            calls: nil,
                                            validityMonth: nil,
                                            dependent: nil)
                                        
                                        self.explorePackageDataDetailModelArray.insert(detailsModelObj3, at: self.explorePackageDataDetailModelArray.count)
                                  
                                    }
                                    
                                    print("explorePackageDataDetailModelArray: ",self.explorePackageDataDetailModelArray.count)
                                }
                                let dataModelObj2 = DatumModel.init(
                                                                   packagePlanSrNo: data["PACKAGE_PLAN_SR_NO"].string,
                                                                   pkgName: data["PKG_NAME"].string,
                                                                   dcPkgPrice:  data["DC_PKG_PRICE"].string,
                                                                   includeGst: data["INCLUDE_GST"].string,
                                                                   pkgEmpMappSrNo: data["PKG_EMP_MAPP_SR_NO"].string,
                                                                   pkgPlanSrNo: data["PKG_PLAN_SR_NO"].string,
                                                                   extEmployeeSrNo: data["EXT_EMPLOYEE_SR_NO"].string,
                                                                   uniqueid: data["UNIQUEID"].string,
                                                                   extPerSrNo: data["EXT_PER_SR_NO"].string,
                                                                   personName: data["PERSON_NAME"].string,
                                                                   relationid: data["RELATIONID"].string,
                                                                   cellphoneNumber: data["CELLPHONE_NUMBER"].string,
                                                                   movementDoneOn: data["MOVEMENT_DONE_ON"].string,
                                                                   status: data["STATUS"].string,
                                                                   details: self.explorePackageDataDetailModelArray)
                                                               
                                                               print("dataModelObj2: ",dataModelObj2)
                                                               self.explorePackageDataModelArray.append(dataModelObj2)
                                
                                
                               
                            }
                            print("explorePackageDataModelArray: ",self.explorePackageDataModelArray)
                            print("explorePackageDataDetailModelArray: ",self.explorePackageDataDetailModelArray)
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }
            catch{
                print("In catch block",error)
            }
        }
        
    }
    
    func getIsDCTermsAgreed(){
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
        
        guard let Wellness_Ext_Employee_Sr_No = UserDefaults.standard.value(forKey: "Wellness_Ext_Employee_Sr_No") else {
            return
        }
        Well_Ext_Emp_SrNo = Wellness_Ext_Employee_Sr_No as! String
       
        let url = APIEngine.shared.getIsDCTermsAgreed(EmployeeSrNo: Well_Ext_Emp_SrNo, VendorSrNo: "1")
         
        
        print("getEmployeeDCPackages: ",url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            do{
                if let status = response?["IsDCAgree"].bool
                {
                    if status == true {
                        // skip verify page
                        print("status true: ",status)
                        let buyDCPackageVC = UIStoryboard.init(name: "Wellness_New", bundle: nil).instantiateViewController(withIdentifier:"BuyDCPackageVC") as! BuyDCPackageVC
                        buyDCPackageVC.pkgSelected = self.btnPressedPosition
                        buyDCPackageVC.selectedPersonSrNo = self.pressed_pkgPlanSrNo
                        self.navigationController?.pushViewController(buyDCPackageVC, animated: true)
                        
                    }
                    else{
                        //show verify page
                        print("status false: ",status)
                        let verifyPage = UIStoryboard.init(name: "Wellness_New", bundle: nil).instantiateViewController(withIdentifier:"VerifyAgreeTermsConditionViewController") as!   VerifyAgreeTermsConditionViewController
                        verifyPage.modalPresentationStyle = .custom
                        verifyPage.delegate = self
                        self.navigationController?.present(verifyPage, animated: true, completion: nil)
                       print("Back from VerifyAgreeTermsConditionViewController")
                    }
                }
            }
            catch{
                print("Error ",error)
            }
        }
      
    }
}

