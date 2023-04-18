//
//  FitnessSlidemenuVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 25/07/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol RightMenuChangedProtocol {
    func menuChangedMoveTo(screenIndex:Int)
}
class FitnessSlidemenuVC: UIViewController, UpdatedConnectionProtocol,ImproveScoreClosedProtocol {
 
    
    @IBOutlet weak var tableView: UITableView!
    var rightMenuDelegate : RightMenuChangedProtocol? = nil
    //var titleArray = ["Connected Apps","Improve Your Aktivo Score","Help","Privacy Policy"]
    //let imageArray = [#imageLiteral(resourceName: "wearableWatch"),#imageLiteral(resourceName: "aktivoScoreimg"),#imageLiteral(resourceName: "questionmark"),#imageLiteral(resourceName: "privacyLock")]
    
    var titleArray = ["Connected Apps","Improve Your Aktivo Score","Help","Privacy Policy"]
   let imageArray = [#imageLiteral(resourceName: "wearableWatch"),#imageLiteral(resourceName: "aktivoScoreimg"),#imageLiteral(resourceName: "NewQuesSketch"),#imageLiteral(resourceName: "privacyLock")]

    //age(resourceName: "questionmark"),UIImage(resourceName: "privacyLock"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        tableView.tableFooterView = UIView()
        //hide back button
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
    }
    
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Delegate
       func connectionUpdated() {
            print("Slidemenu -> connectionUpdated...")
        NotificationCenter.default.post(name: Notification.Name("notificationDashboard"), object: nil)
        slideMenuController()?.closeRight()
        slideMenuController()?.closeLeft()

        }
    
        func backTappedDelegate() {
            slideMenuController()?.closeRight()
            slideMenuController()?.closeLeft()

        }
    
    func closedWindow() {
        slideMenuController()?.closeRight()
        slideMenuController()?.closeLeft()

    }
    
    
//    @IBAction func openFitbit(_ sender: Any) {
//
//        let vc = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier: "ConnectWearablesVC") as! ConnectWearablesVC
//
//        self.present(vc, animated: true, completion: nil)
//
////        if rightMenuDelegate != nil {
////            rightMenuDelegate?.menuChangedMoveTo(screenIndex: 1)
////        }
//
//
//    }
    
}

extension FitnessSlidemenuVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : LeftSideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeftSideTableViewCell") as! LeftSideTableViewCell
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        
        
        cell.m_titleLbl.text=titleArray[indexPath.row]
        cell.m_imageView.image=imageArray[indexPath.row]
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Did Select")
        switch indexPath.row
        {
        case 0:
            
            let vc = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier: "ConnectWearablesVC") as! ConnectWearablesVC
            vc.delegateObj = self
            let nav1:UINavigationController = UINavigationController.init(rootViewController: vc)
            nav1.modalPresentationStyle = .fullScreen
            self.present(nav1, animated: true, completion: nil)
            
            
            //            let vc = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier: "LoginFitnessProfile") as! LoginFitnessProfile
            //            //vc.delegateObj = self
            //            let nav1:UINavigationController = UINavigationController.init(rootViewController: vc)
            //            nav1.modalPresentationStyle = .fullScreen
            //
            //            self.present(nav1, animated: true, completion: nil)
            
            return
            
        case 1 :
            let vc = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier:"ImproveScoreVC") as! ImproveScoreVC
            
            // vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            vc.delegateObj = self
            self.present(vc, animated: true, completion: {
                
                self.slideMenuController()?.closeRight()
                self.slideMenuController()?.closeLeft()
            })
            
            
        case 3 :
            let vc = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier: "FitnessPrivacyPolicyVC") as! FitnessPrivacyPolicyVC
            vc.titleString = "Privacy Policy"
            let nav1:UINavigationController = UINavigationController.init(rootViewController: vc)
            nav1.modalPresentationStyle = .fullScreen
            self.present(nav1, animated: true, completion: nil)
            
        case 2 :
            let vc = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier: "FitnessPrivacyPolicyVC") as! FitnessPrivacyPolicyVC
            vc.titleString = "Help"
            let nav1:UINavigationController = UINavigationController.init(rootViewController: vc)
            nav1.modalPresentationStyle = .fullScreen
            self.present(nav1, animated: true, completion: nil)
            
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 60
    }
}
