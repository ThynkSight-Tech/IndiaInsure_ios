//
//  LeftSideFitnessVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 01/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit



class LeftSideFitnessVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var m_profileImageView: UIImageView!

    @IBOutlet weak var m_tableView: UITableView!
    @IBOutlet weak var m_designationLbl: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    var titleArray = ["Edit Profile","Connected Apps","Improve Your Aktivo Score","Help","Privacy Policy","Logout"]
    
    //let imageArray = [#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyClaims"),#imageLiteral(resourceName: "IntimateClaim-1"),#imageLiteral(resourceName: "NetworkHospital-1"),#imageLiteral(resourceName: "faq-2"),#imageLiteral(resourceName: "PolicyFeature"),#imageLiteral(resourceName: "ClaimProcedure-1")]
    let imageArray = [#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyCoverage-1")]

    var m_personArray : [PERSON_INFORMATION]?
    var m_productCode = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        m_tableView.register(LeftSideTableViewCell.self, forCellReuseIdentifier: "cell")
        m_tableView.register(UINib (nibName: "LeftSideTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.singleLine
        m_tableView.separatorColor=hexStringToUIColor(hex: "EAEAEA")
        
        m_tableView.tableFooterView = UIView()
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
        m_personArray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:m_productCode, relationName: "EMPLOYEE")
        if((m_personArray?.count)!>0)
        {
            
            let profileDict = m_personArray![0]
            
            
            if(profileDict.gender?.lowercased() == "male")
            {
                m_profileImageView.image = UIImage(named: "avatar_male11")
                
            }
            else
            {
                m_profileImageView.image = UIImage(named: "avatar_female11")
            }
        }
        if(userArray.count>0)
        {
            let dict = userArray[0]
            if let designation = dict.designation
            {
                m_designationLbl.text=designation
            }
        }
        m_nameLbl.text=employeeName
        m_profileImageView.layer.masksToBounds=true
        m_profileImageView.layer.cornerRadius=m_profileImageView.frame.height/2
        m_profileImageView.layer.borderWidth=1
        m_profileImageView.layer.borderColor=UIColor.lightGray.cgColor
        
        
    }
    @IBAction func viewProfileButtonClicked(_ sender: Any)
    {
        
        let vc = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier: "ProfileFitnessTVC") as! ProfileFitnessTVC
        navigationController?.pushViewController(vc, animated: true)

    }
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=true
        //menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        //menuButton.isHidden=false
        
        //        menuButton.backgroundColor = UIColor.white
        //        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        //        menuButton.setImage(UIImage(named:"Home"), for: .normal)
    }
//    @objc private func homeButtonClicked(sender: UIButton)
//    {
//        //        navigationController?.popViewController(animated: true)
//        tabBarController!.selectedIndex = 2
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : LeftSideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeftSideTableViewCell
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        
        
        cell.m_titleLbl.text=titleArray[indexPath.row]
        cell.m_imageView.image=imageArray[indexPath.row]
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        switch indexPath.row
        {
        case 0:
            let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
           // navigationController?.pushViewController(myCoverages, animated: true)
            //            let backItem = UIBarButtonItem()
            //            backItem.title = ""
            //            navigationItem.backBarButtonItem = backItem
            
            
            return
        case 1:
            let myClaims:MyClaimsViewController = MyClaimsViewController()
            //navigationController?.pushViewController(myClaims, animated: true)
            
            return
        case 2:
            let intimation : MyIntimationViewController = MyIntimationViewController()
            //navigationController?.pushViewController(intimation, animated: true)
            return
        case 3:
            let networkHospitals : NetworkHospitalsViewController = NetworkHospitalsViewController()
           // navigationController?.pushViewController(networkHospitals, animated: true)
            return
            
        case 4:
            let myQueries : MyQueriesViewController = MyQueriesViewController()
           // navigationController?.pushViewController(myQueries, animated: true)
            
            return
        case 5:
            let policyFeatures : PolicyFeaturesViewController = PolicyFeaturesViewController()
           // navigationController?.pushViewController(policyFeatures, animated: true)
            
            return
            
        case 6:
            let claimProcedure : ClaimProcedureViewController = ClaimProcedureViewController()
           // navigationController?.pushViewController(claimProcedure, animated: true)
            return
            
        case 7:
            
            break
            
        case 8:
            let FAQVC : FAQViewController = FAQViewController()
           // navigationController?.pushViewController(FAQVC, animated: true)
            return
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 60
    }
    
    
    @IBAction func logOutButtonClicked(_ sender: Any)
//    {
//
//        let alertController = UIAlertController(title: "Do you want to logout?", message: "", preferredStyle: UIAlertControllerStyle.alert)
//
//        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
//        {
//            (result : UIAlertAction) -> Void in
//            print("Cancel")
//
//        }
//        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
//        {(result : UIAlertAction) -> Void in
//
//            let defaults = UserDefaults.standard
//            defaults.set(false, forKey: "isAlreadylogin")
//
//            menuButton.isHidden=true
//            menuButton.removeFromSuperview()
//
//            menuButtonF.isHidden=true
//            menuButtonF.removeFromSuperview()
//
//
//
//            let loginVC :LoginViewController = LoginViewController()
//
//            let appdelegate = UIApplication.shared.delegate as! AppDelegate
//            appdelegate.drawerContainer?.openDrawerGestureModeMask=MMOpenDrawerGestureMode.panningNavigationBar
//
//            //Added By Pranit for wellness
//            UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
//            UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
//            UserDefaults.standard.set("", forKey: "OrderMasterNo")
//            UserDefaults.standard.set("", forKey: "GroupChildSrNo")
//
//
//            self.navigationController?.pushViewController(loginVC, animated: true)
//            //        navigationController?.popToViewController(loginVC, animated: true)
//
//        }
//        alertController.addAction(cancelAction)
//        alertController.addAction(yesAction)
//
//        self.present(alertController, animated: true, completion: nil)
//
//
//
//    }
    {
        let alertController = UIAlertController(title: "Do you want to logout?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
            
        }
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        {(result : UIAlertAction) -> Void in
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isAlreadylogin")
            
            DispatchQueue.main.async()
                {
                    menuButton.isHidden=true
            }
            
            
            let loginVC :LoginViewController = LoginViewController()
            
            //Added By Pranit for wellness
            UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
            UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
            UserDefaults.standard.set("", forKey: "OrderMasterNo")
            UserDefaults.standard.set("", forKey: "GroupChildSrNo")
            UserDefaults.standard.set("", forKey: "emailid")
            
            UserDefaults.standard.set(false, forKey: "isInsurance")
            UserDefaults.standard.set(false, forKey: "isWellness")
            UserDefaults.standard.set(false, forKey: "isFitness")

            
            self.navigationController?.pushViewController(loginVC, animated: true)
            //        navigationController?.popToViewController(loginVC, animated: true)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
   
    
    
    
}
