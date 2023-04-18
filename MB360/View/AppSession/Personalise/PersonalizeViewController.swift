//
//  PersonalizeViewController.swift
//  MyBenefits
//
//  Created by Semantic on 07/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class PersonalizeViewController: UIViewController {
    @IBOutlet weak var m_enrollPageTab: UILabel!
    
    @IBOutlet weak var m_managePageTab: UILabel!
    @IBOutlet weak var m_personalizePageTab: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }

    func setupData()
    {
        m_enrollPageTab.backgroundColor=UIColor.lightGray
        m_personalizePageTab.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        m_managePageTab.backgroundColor=UIColor.lightGray
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextPageButtonClicked(_ sender: Any)
    {
        let manageVC :ManageViewController = ManageViewController()
        navigationController?.pushViewController(manageVC, animated: true)
    }
    
    @IBAction func previousPageButtonClicked(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
