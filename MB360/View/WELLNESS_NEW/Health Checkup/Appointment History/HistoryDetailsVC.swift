//
//  HistoryDetailsVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 02/07/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class HistoryDetailsVC: UIViewController {

    var historyModelObject = AppointmentHistoryModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Appointment History"
        print("In \(navigationItem.title ?? "") HistoryDetailsVC")
    }
    



}
