//
//  HealthPackageOptHelper.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/06/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation
import UIKit

extension HealthCheckupOptVC {
    //MARK:- Package Content Tapped
       @objc func viewPackageDidTapped(_ sender : UITapGestureRecognizer) {
        let tag = sender.view?.tag
           let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"PackageIncludesViewController") as! PackageIncludesViewController
           vc.packageSrNo = packageModelArray[tag!].PackageSrNo ?? ""
           vc.packageName = packageModelArray[tag!].PackageName ?? ""
           vc.packageValue = packageModelArray[tag!].PackagePrice ?? ""
           let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
           self.present(nav, animated: true)
       }
    
      func getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList:Bool) {
         
         guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") else {
             return
         }
         guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
             return
         }
         guard let orderMasterNo = UserDefaults.standard.value(forKey: "OrderMasterNo") else {
             return
         }
         
         
         var m_employeedict : EMPLOYEE_INFORMATION?
         let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
         m_employeedict=userArray[0]
         var empidNo = String()
         var groupChildSrNo = ""
         if let empID = m_employeedict?.empIDNo
         {
             empidNo=String(empID)
         }
         if let groupChlNo = m_employeedict?.groupChildSrNo
         {
             groupChildSrNo=String(groupChlNo)
         }
         print(empidNo)
         
         
         let url = APIEngine.shared.getHealthCheckupPackages(ExtGroupSrNo: groupSrNo as! String, GroupCode: getGroupCode(), EmpIdNo: empidNo)
          //let url = APIEngine.shared.getHealthCheckupPackages(ExtGroupSrNo: "17", GroupCode: "NAYASA1", EmpIdNo: "NAYASA02")
          
        print("GetFamilyMembers: ",url)
         ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
             
             print(response)
             if let messageDictionary = response?["message"].dictionary
             {
                 
                 if let status = messageDictionary["Status"]?.bool
                 {
                     if status == true {
                         self.packageModelArray.removeAll()
                         if let packageArray = response?["PackagesList"].array {
                             for package in packageArray {
                                 var personModelArray = [PersonCheckupModel]()

                                 //create person object
                                 if let personArray = package["Persons"].array {
                                     for person in personArray {
                                         let personModelObj = PersonCheckupModel.init(PersonSRNo: person["PersonSRNo"].int, FamilySrNo: person["FamilySrNo"].string, ExtPersonSRNo: person["ExtPersonSRNo"].string, IsBooking: person["IsBooking"].string, PaymentConfFlag: person["PaymentConfFlag"].string, ApptSrInfoNo: person["ApptSrInfoNo"].string, IsMobEmailConf: person["IsMobEmailConf"].int, Price: person["Price"].string, Amount: person["Amount"].string, BookingStatus: person["BookingStatus"].string, CanBeDeletedFalg: person["CanBeDeletedFalg"].int, SponserdBy: person["SponserdBy"].string, SponserdByFlag: person["SponserdByFlag"].string, PackageSrNo: person["PackageSrNo"].string, PackageName: person["PackageName"].string, PersonName: person["PersonName"].string, Age: person["Age"].string, DateOfBirth: person["DateOfBirth"].string, EmailID: person["EmailID"].string, CellPhoneNumber: person["CellPhoneNumber"].string, Gender: person["Gender"].string, RelationID: person["RelationID"].string, RelationName: person["RelationName"].string, IsBooked: person["IsBooked"].string, IsChbChecked: person["IsChbChecked"].string, IsDisabled: person["IsDisabled"].boolValue, AppointmentStatusBadge: person["AppointmentStatusBadge"].string, paidNotScheduled: person["paidNotScheduled"].string, tooltip: person["tooltip"].string, IsSelectedInWellness: person["IsSelectedInWellness"].string)
                                         
                                         let age = person["Age"].stringValue
                                         if let ageInt = Int(age)
                                         {
                                             if ageInt >= 18 {
                                                 personModelArray.append(personModelObj)

                                             }
                                         }
                                     
                                     } //inner for
                                 }
                                 
                                 if personModelArray.count > 0 {
                                 let packageObj = HealthCheckupModel.init(PackageSrNo: package["PackageSrNo"].string, PackageName: package["PackageName"].string, IsAgeRestricted: package["IsAgeRestricted"].string, AgeText: package["AgeText"].string, MaxAge: package["MaxAge"].string, MinAge: package["MinAge"].string, IsGenderRestricted: package["IsGenderRestricted"].string, GenderText: package["GenderText"].string, Gender: package["Gender"].string, PackagePrice: package["PackagePrice"].string, payment: package["payment"].string, personModelArray: personModelArray)
                                 
                                 self.packageModelArray.append(packageObj)
                                 }
                             }
                             self.tableView.reloadData()
                             isReloadFamilyDetails = 0
                            
                            if self.packageModelArray.count == 0 {
                                self.tableView.setEmptyView(title: "", message: "Applicable packages not found")
                            }
                            else {
                                self.tableView.restore()
                            }

                             if isMoveToHospitalList == false
                             {
                                // self.isLoaded = 1
                                // self.tableView.hideSkeleton()

                                // self.tableView.reloadData()
                               // self.scrollToFirstRow()
                             }
                             else {
                                // self.isLoaded = 1
                                // self.tableView.hideSkeleton()

                                // self.tableView.reloadData()
                                 let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HospitalsListViewController") as! HospitalsListViewController
                                 vc.isFromFamily = 1
                                 vc.memberDetailsModel = self.personDetailsModel
                                 vc.hcPackageDetailsModel = self.hcPackageDetailsModel
                                 self.navigationController?.pushViewController(vc, animated: true)
                             }
                             
                         }
                         
                     }
                 }
             }
         }
     }
    
//    func getGroupCode() -> String {
//        //Get Group Info
//        var groupNameStr = ""
//        let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
//        if groupMasterArray.count > 0 {
//            groupNameStr = groupMasterArray[0].groupCode!
//            return groupNameStr
//        }
//        return groupNameStr
//    }

    //MARK:- Delete Family Member
    func deleteFamilyMember(personSRNo:String) {
           print("Insert EMP Info")
           
           let url = APIEngine.shared.deleteFamilyMemberURL(personSRNo:personSRNo)
           print(url)
           
           ServerRequestManager.serverInstance.deleteDataToServer(url: url, view: self, onComplition: { (response, error) in
               
               if let status = response?["Status"].bool
               {
                   if status == true {
                    //self.packageModelArray[indexPath.section - 1].personModelArray.remove(at: indexPath.row - 1)
                       //self.tableView.reloadData()
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList: false)
                        self.displayActivityAlert(title: "Dependant Deleted successfully.")
                        
                    }
                        
                    }
                   
               }
          
       })
    }

    func setupMiddleButton()
    {

        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        
        var menuButtonFrame = menuButton.frame
        var yValue = CGFloat()
        var xValue = CGFloat()
        
        if(Device.IS_IPAD)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+15)
            xValue=(tabBarController?.view.bounds.width)!/2 - (menuButtonFrame.size.width/2)
        }
        else if(Device.IS_IPHONE_6)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        else if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - (menuButtonFrame.size.width/2)
        }
        else if(Device.IS_IPHONE_X)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+50)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
            
            //            m_bottomViewHeightConstraint.constant=70
        }
            
        else if(Device.IS_IPHONE_XsMax)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+50)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        else
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        
        menuButtonFrame.origin.y = yValue
        menuButtonFrame.origin.x = xValue
        menuButton.frame = menuButtonFrame
        menuButton.ShadowForView()
        menuButton.layer.masksToBounds=true
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.backgroundColor = hexStringToUIColor(hex: hightlightColor)
        menuButton.setImage(UIImage(named:"Home-2"), for: .normal)

        //menuButton.setBackgroundImage(UIImage(named: "blueEsclip"), for: .normal)
        menuButton.backgroundColor = Color.buttonBackgroundGreen.value
        
        menuButton.contentMode = .scaleAspectFill
        //        menuButton.setGradientBackground(colorTop: hexStringToUIColor(hex: "819ff6"), colorBottom: hexStringToUIColor(hex: "4b66ea"))
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
        
        //menuButton.layer.borderWidth = 0.7
        //menuButton.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        
        tabBarController?.view.addSubview(menuButton)
        //        view.layoutIfNeeded()
        
    }
    
    
}




extension HealthCheckupOptVC {
    
    func mekeMenuButtonGray() {
        let origImage = UIImage(named:"Home-2")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(tintedImage, for: .normal)
        menuButton.tintColor = UIColor.white

    }
    
      //MARK:- Tab bar delegate
        func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            print("Selected item")
            // item.badgeColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
            //tabBar.selectedItem?.badgeColor = UIColor.red
        }
        
        // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("In HealthCheckupOptVC helper")
//        print("Selected item")
//        
//        /* if tabBarController.selectedIndex == 0 { //Add member
//            if let canAdd = UserDefaults.standard.value(forKey: "canAddMember") as? Bool {
//                if canAdd == true {
//                    isAddMember = 1
//                    tabBarController.selectedIndex = 2
//                    mekeMenuButtonGray()
//                }
//                else {
//                    self.showAlert(message: "Add Family Member Functionality is not available for your Policy")
//                }
//            }
//            else {
//                self.showAlert(message: "Add Family Member Functionality is not available for your Policy")
//            }
//        }
//          */
//        
//        if tabBarController.selectedIndex == 0 { //Add member
//            isAddMember = 1
//            isReloadFamilyDetails = 1
//            //self.getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList: false)
//            tabBarController.selectedIndex = 2
//            mekeMenuButtonGray()
//        }
//        else if tabBarController.selectedIndex == 1 { //History
//            //displayActivityAlert(title: "Not Available")
//            
//            mekeMenuButtonGray()
//            
//        }
//            
//        else if tabBarController.selectedIndex == 3 { //Appointments
//            
//            mekeMenuButtonGray()
//            
//        }
//            
//        else if tabBarController.selectedIndex == 4 { //Profile
//            
//            //displayActivityAlert(title: "Not Available")
//            
//            mekeMenuButtonGray()
//            
//        }
//            
            
            
        }
}




