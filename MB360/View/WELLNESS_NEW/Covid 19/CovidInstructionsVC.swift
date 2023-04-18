//
//  CovidInstructionsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 12/11/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CovidInstructionsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var segmentControlView: UISegmentedControl!
    //OFFLINE
    let sop2instructionArray = ["Employee who wish to undergo a COVID-19 Screening test for themselves or their families, need to call up the Helpline numbers mentioned below:","\u{2022}The Employee needs to provide their Name, Employee ID, DOB, Mobile number, Email ID, Complete residential address to our Executive \n\u{2022} For Dependants, the employee needs to provide Employee Name, Dependant Name, Employee ID, DOB, Mobile number, Email ID, Complete residential address to our Executive","\u{2022} Our Executive will enter the details in the system and generate a payment link (Only applicable for dependants). The Payment link will be sent to the employee on his email id and mobile number to process the payment","\u{2022} On successful payment receipt, our executive will coordinate with the Employee and nearest ICMR approved laboratory to schedule an appointment. If Home collection is available in the area of employee, the same will be arranged at no extra cost.","\u{2022} For employees whose appointment has been scheduled at the Diagnostic Center, they are required to visit the Centre on the scheduled date and time.","\u{2022} Report will be uploaded to the system and also sent to the Employee on his/her official email id within 24-48 working hours from the time of testing. \n\u{2022} For employees who test positive, the further course of action will be advised by the defined Govt. Bodies/ District Authority as per the guidelines from Ministry of Health & Family Welfare & Govt. of India. \n\u{2022} A copy of report will also be shared with the Govt. Bodies/ District Authorities as per guidelines of ICMR (The Indian Council of Medical Research) & Govt. of India."]
    
    //ONLINE
    let sop1instructionArray = ["The Employee needs to fill in their Name, DOB, Contact Number, Email ID, Complete Address, Valid Government ID Proof and click on Submit \n\u{2022} Our executive will coordinate with the Employee and ICMR approved laboratory to schedule an appointment.","\u{2022} After booking the appointment, Employee is required to visit the centre at scheduled time. \n\u{2022} Report will be uploaded to the system and also sent to the Employee on his/her official email id within 24-48 working hours from the time of testing.", "\u{2022} For employees who test positive, the further course of action will be advised by the defined Govt. Bodies/ District Authority as per the guidelines from Ministry of Health & Family Welfare & Govt. of India. \n\u{2022} A copy of report will also be shared with the Govt. Bodies/ District Authorities as per guidelines of ICMR (The Indian Council of Medical Research) & Govt. of India."]
    
    let sop1Text = "\n\u{2022} Level 1: +91 8657418082 - Mansi Vakharia \n\u{2022} Level 2: +91 7506228838 - Rahul Rajani \n\u{2022} Level 3: +91 9004326572 - Pooja Chavan"
   let sop2Text = "\n\u{2022} Level 1: +91 8657418082 - Mansi Vakharia \n\u{2022} Level 2: +91 7506228838 - Rahul Rajani \n\u{2022} Level 3: +91 9004326572 - Pooja Chavan"


    //online - sop1 - 3 steps
    //offline - sop2 - 6 steps
    var isSOP1 = false//isOnline
    var hideTopSegmentView = false
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        self.navigationItem.title = "SOP for COVID-19 testing"
        print("In \(navigationItem.title) CovidInstructionsVC")

        let titleSelected = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleNotSelected = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentControlView.setTitleTextAttributes(titleNotSelected, for: .normal)
        segmentControlView.setTitleTextAttributes(titleSelected, for: .selected)
        
        if hideTopSegmentView {
            self.segmentControlView.isHidden = true
            topConstraintTableView.constant = 12.0
        }
        else {
            self.segmentControlView.isHidden = false
            topConstraintTableView.constant = 60.0
        }
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        self.navigationController?.navigationBar.changeFont()
        self.navigationController?.navigationBar.isHidden = false
        
    }

            @objc func backTapped() {
              self.navigationController?.popViewController(animated: true)
               self.dismiss(animated: true, completion: nil)
            }

    
    @IBAction func segmentChanges(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isSOP1 = true
        }
        else {
            isSOP1 = false
        }
        self.tableView.reloadData()
    }

    
    
}


extension CovidInstructionsVC : UITableViewDelegate,UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSOP1 {
        return sop1instructionArray.count + 1
        }
        else {
            return sop2instructionArray.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == rows - 1 { //Last
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCovidContact", for: indexPath) as! CellForCovidContact
            
            cell.btnDone.addTarget(self, action: #selector(selectDidTapped(_:)), for: .touchUpInside)
            if isSOP1 {
                cell.btnDone.isHidden = true
            }
            else {
                cell.btnDone.isHidden = true
            }

        return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCovidInstructions", for: indexPath) as! CellForCovidInstructions
            cell.lblStep.text = "Step \(indexPath.row + 1)"
            if isSOP1 {
            cell.lblInstructions.text = sop1instructionArray[indexPath.row]
            }
            else {
            cell.lblInstructions.text = sop2instructionArray[indexPath.row]
            }
            return cell
        }
        
    }
    
    //MARK:- Select Tapped
    @objc func selectDidTapped(_ sender:UIButton) {
        let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"CovidTestBookingTVC") as! CovidTestBookingTVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
