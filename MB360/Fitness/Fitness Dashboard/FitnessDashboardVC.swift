//
//  FitnessDashboardVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 26/07/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class FitnessDashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

       // self.slideMenuController()?.removeRightGestures()

        let logo = UIImage(named: "mb360_white")
        let imageView = UIImageView(frame: CGRect(x: 0
            , y: 0, width: 10, height:10))
        imageView.image=logo
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])
        
      
        let rightBar = UIBarButtonItem(image: UIImage(named: "menu-1"), style: .done, target: self, action: #selector(menuTapped))
        self.navigationItem.rightBarButtonItem = rightBar
        
    }
    
    @objc private func menuTapped() {
        self.slideMenuController()?.openRight()
    }

   

}
