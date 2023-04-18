//
//  VerifyAgreeTermsConditionViewController.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 11/01/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import Foundation
import UIKit


protocol passDataProtocol{
    func pass(_ type : String)
}

class VerifyAgreeTermsConditionViewController: UIViewController{
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var termsCheckbox: UIButton!
    @IBOutlet weak var agreeLbl: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    
    @IBOutlet weak var btnVerify: UIButton!
    
    var isTermsAccepted = 0
    var isKeyboardAppear = false
    var isTemp = false
    
    var m_employeeDict : EMPLOYEE_INFORMATION?
    var Well_Ext_Emp_SrNo = ""
    var delegate : passDataProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.clear
        print("Inside VerifyAgreeTermsConditionViewController")
        
        self.btnTerms.underline()
        
        btnTerms.setTitleColor(Color.fontColor.value, for: .normal)
        btnVerify.backgroundColor = Color.buttonBackgroundGreen.value
        
        self.navigationController?.navigationBar.changeFont()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func termsDidTapped(_ sender: Any) {
        //Show Web Page
        let url = URL(string: "http://mybenefits360.com/wellness/termsOfUse.aspx")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func termsCheckboxTapped(_ sender: Any) {
        if isTermsAccepted == 0 {
            termsCheckbox.setImage(UIImage(named: "checked1"), for: .normal)
            
            isTermsAccepted = 1
        }
        else {
            termsCheckbox.setImage(UIImage(named: "checkbox"), for: .normal)
            
            isTermsAccepted = 0
        }
    }
    
    @IBAction func verifyBtnDidTapped(_ sender: Any) {
        
        if isTermsAccepted == 0 {
            displayActivityAlert(title: "Please accept Terms of Use")
        }
            
        else {
            if isTemp {
                self.dismiss(animated: true)
            }
            else{
                let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
                m_employeeDict=userArray[0]
                
                var groupChildSrNo = String()
                
                if let groupChlNo = m_employeeDict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                
                print(groupChildSrNo)
                
                guard let Wellness_Ext_Employee_Sr_No = UserDefaults.standard.value(forKey: "Wellness_Ext_Employee_Sr_No") else {
                    return
                }
                Well_Ext_Emp_SrNo = Wellness_Ext_Employee_Sr_No as! String
                
                let dictionary = ["groupChildSrNo":"\(groupChildSrNo)","groupCode":"\(getGroupCode())","extEmpSrNo":"\(Well_Ext_Emp_SrNo)","vendorSrNo":"1"]
                print("dictionary Data: ",dictionary)
                acceptInsertDCTermsAgree(parameter: dictionary as NSDictionary)
            }
        }
    }
    
    func acceptInsertDCTermsAgree(parameter:NSDictionary) {
        print("Accepted terms condition")
        
        let url = APIEngine.shared.acceptInsertDCTermsAgreeURL()
        print(url)
        
        
        ServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    self.dismiss(animated: true,completion: {
                        self.delegate?.pass("dismiss")
                    })
//                    self.dismiss(animated: true, completion: {
//                       
//                    })
//                    DispatchQueue.main.async {
//                        let buyDCPackageVC = UIStoryboard.init(name: "Wellness_New", bundle: nil).instantiateViewController(withIdentifier:"BuyDCPackageVC") as! BuyDCPackageVC
//
//                        self.navigationController?.pushViewController(buyDCPackageVC, animated: true)
//                        
//                    }
                    
                }
            }
            else {
                //Failed to send member info
            }
        })
    }
}
