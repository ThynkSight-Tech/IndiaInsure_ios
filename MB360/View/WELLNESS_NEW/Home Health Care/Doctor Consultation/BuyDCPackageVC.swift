//
//  BuyDCPackageVC.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 12/01/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import Foundation
import UIKit

class BuyDCPackageVC: UIViewController,UIWebViewDelegate{
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var webView: UIWebView!
    //Variables declaration
    var m_employeeDict : EMPLOYEE_INFORMATION?
    var Well_Ext_Emp_SrNo = ""
    var Well_Ext_Person_Sr_No = ""
    var pkgSelected = 0
    var selectedPersonSrNo = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Inside BuyDCPackageVC")
        
        print("Selected Values: ",selectedPersonSrNo," : pkgSelected ",pkgSelected)
        setupNavBarDetails()
        getBuyDCPackage()
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
        
        lbNavTitle.text = "Doctor 24x7"
        self.navigationItem.titleView = lbNavTitle
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        //self.navigationItem.title = "Doctor 24x7"
        //self.navigationController?.navigationBar.changeFont()
    }
    
    @objc func backTapped() {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        showPleaseWait(msg: "")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hidePleaseWait()
    }
    
}


//API Call
extension BuyDCPackageVC{
    
    func getBuyDCPackage(){
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
        m_employeeDict=userArray[0]
        
        guard let Wellness_Ext_Employee_Sr_No = UserDefaults.standard.value(forKey: "Wellness_Ext_Employee_Sr_No") else {
            return
        }
        
        guard let Wellness_Ext_Person_Sr_No = UserDefaults.standard.value(forKey: "Wellness_Ext_Person_Sr_No") else {
            return
        }
        
        Well_Ext_Emp_SrNo = Wellness_Ext_Employee_Sr_No as! String
       
        if selectedPersonSrNo == "" || selectedPersonSrNo.isEmpty{
            Well_Ext_Person_Sr_No = Wellness_Ext_Person_Sr_No as! String
        }
        else{
            Well_Ext_Person_Sr_No = selectedPersonSrNo
        }
        
        print("Parameters : Well_Ext_Person_Sr_No",Well_Ext_Person_Sr_No," : Well_Ext_Emp_SrNo",Well_Ext_Emp_SrNo," : pkgSelected: ",pkgSelected )
        
        
        let url = APIEngine.shared.getBuyDCPackageURL(PersonSrNo: Well_Ext_Person_Sr_No, EmployeeSrNo: Well_Ext_Emp_SrNo, PackageSrNo: "\(pkgSelected)")
        
        
        print("getBuyDCPackage: ",url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            do{
                if let status = response?["Status"].bool
                {
                    print("status: ",status)
                 
                    if status == true{
                        
                        if let url = response?["Url"].string{
                            
                            let link = URL(string: url)
                            let requestObj = URLRequest(url: link!)
                            self.webView.loadRequest(requestObj)
                        }
                    }
                    else{
                        if let msg = response?["Message"].string{
                            self.displayActivityAlert(title: msg)
                        }
                    }
//
//                    let url = URL (string: "https://portal.mybenefits360.com/")
//                    let requestObj = URLRequest(url: url!)
//                    self.webView.loadRequest(requestObj)
                }
            }
            catch{
                print("Error ",error)
            }
        }
      
    }
    
}
