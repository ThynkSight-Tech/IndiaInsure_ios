//
//  BadgeContainer.swift
//  FitnessUIApp
//
//  Created by SemanticMAC MINI on 18/07/20.
//  Copyright © 2020 SemanticMAC MINI. All rights reserved.
//

import UIKit
import AktivoCoreSDK


class BadgeContainer: UIViewController {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var btnDailyBadge: UIButton!
    @IBOutlet weak var btnYourBadge: UIButton!
    
    var isSelected = 0
    
    var sleepTime = String()
    var exerciseTime = String()
    var sedentaryTime = String()
    var lpaTime = String()
    
    var dailyStepData = Dictionary<Date, AktivoDailyStep>()
    var dailySleepData = Dictionary<Date, AktivoDailySleep>()
    var dailyScoreData = Dictionary<Date, AktivoDailyScore>()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFitnessBackground()
        self.slideMenuController()?.removeRightGestures()

        let vc = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier: "DailyBadgesVC") as! DailyBadgesVC
        vc.dailyStepData = self.dailyStepData
                   vc.dailyScoreData = self.dailyScoreData
                   vc.dailySleepData = self.dailySleepData
        moveToPrevious(newVC: vc)
        
        btnDailyBadge.backgroundColor = UIColor.black
        btnDailyBadge.setTitleColor(UIColor.white, for: .normal)

        btnYourBadge.backgroundColor = UIColor.clear
        btnYourBadge.setTitleColor(UIColor.black, for: .normal)

        self.navigationController?.navigationBar.hideBackButton()

        btnYourBadge.makeCicular()
        btnDailyBadge.makeCicular()
        self.title = "Badges"
        display(contentController: vc, on: self.innerView)
        

           //hide back button
             let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
             navigationItem.leftBarButtonItem = btn

             
         }

        @objc func backTapped() {
            self.navigationController?.popViewController(animated: true)
        }

    

    
    @IBAction func dailyBadgeTapped(_ sender: Any) {
        if isSelected != 0 {
            isSelected = 0

        btnYourBadge.backgroundColor = UIColor.clear
        btnYourBadge.setTitleColor(UIColor.black, for: .normal)
        
        btnDailyBadge.backgroundColor = UIColor.black
        btnDailyBadge.setTitleColor(UIColor.white, for: .normal)

        
        let vc = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier: "DailyBadgesVC") as! DailyBadgesVC

            
            vc.dailyStepData = self.dailyStepData
            vc.dailyScoreData = self.dailyScoreData
            vc.dailySleepData = self.dailySleepData
            
            moveToPrevious(newVC: vc)
        }
    }
    
    
    @IBAction func yourBadgeTapped(_ sender: Any) {
        if isSelected != 1 {
            isSelected = 1
        btnYourBadge.backgroundColor = UIColor.black
        btnDailyBadge.backgroundColor = UIColor.clear

        btnYourBadge.setTitleColor(UIColor.white, for: .normal)
        btnDailyBadge.setTitleColor(UIColor.black, for: .normal)


        let vc = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier: "BadgeCalendarSummaryViewController") as! BadgeCalendarSummaryViewController
        moveToNext(newVC: vc)
        }
        
    }
    
    
    
    func moveToNext(newVC:UIViewController) {
        
        let transitionNew = CGAffineTransform(translationX: innerView.frame.origin.x - 200, y: 0 )
           
           UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
               self.innerView.transform = transitionNew
               self.innerView.alpha = 0

           }, completion: {
               (value: Bool) in
               
               self.display(contentController: newVC, on: self.innerView)
               let reset = CGAffineTransform(translationX: 0, y: 0)
               self.innerView.transform = reset
               
               UIView.animate(withDuration: 0.1, animations: {
                   
                   self.innerView.alpha = 1.0


               })
           })
    }
    
    
    func moveToPrevious(newVC:UIViewController) {
        //New
        let transitionNew = CGAffineTransform(translationX: innerView.frame.origin.x + 200, y: 0 )
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.innerView.transform = transitionNew
            self.innerView.alpha = 0

        }, completion: {
            (value: Bool) in
            
            self.display(contentController: newVC, on: self.innerView)
            let reset = CGAffineTransform(translationX: 0, y: 0)
            self.innerView.transform = reset
            
            UIView.animate(withDuration: 0.1, animations: {
                
                self.innerView.alpha = 1.0

            })
            
        })

    }
    
    //Add Container View OR Change Container on collectionView Cell Selection
    func display(contentController content: UIViewController, on view: UIView) {
        /*
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()

        view.addSubview(content.view)

        self.addChild(content)

        content.view.frame = view.bounds
        content.didMove(toParent: self)
        */
        
               content.willMove(toParentViewController: nil)
             content.view.removeFromSuperview()
             content.removeFromParentViewController()

             view.addSubview(content.view)

             self.addChildViewController(content)

             content.view.frame = view.bounds
             content.didMove(toParentViewController: self)
         
        
         
    }

    
}
