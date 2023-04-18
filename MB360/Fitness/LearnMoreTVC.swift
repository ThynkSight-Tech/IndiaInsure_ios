//
//  LearnMoreTVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 11/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class LearnMoreTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "What is the Aktivo Score®?"

        
        self.navigationController?.navigationBar.hideBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])
        
        //hide back button
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

        
    }

   @objc func backTapped() {
       self.navigationController?.popViewController(animated: true)
   }
}

