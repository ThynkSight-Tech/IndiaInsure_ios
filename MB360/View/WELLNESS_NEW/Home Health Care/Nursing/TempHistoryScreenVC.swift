//
//  TempHistoryScreenVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class TempHistoryScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.applyGradient()
              self.navigationController?.navigationBar.navBarDropShadow()
              self.navigationItem.title = "History"
              self.navigationController?.navigationBar.changeFont()
        print("In \(navigationItem.title ?? "History") TempHistoryScreenVC")
        //To set Nav bar color
        navigationController?.view.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)

    }
    

}
