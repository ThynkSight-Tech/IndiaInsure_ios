//
//  ImproveScoreVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 29/07/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import CenteredCollectionView

protocol ImproveScoreClosedProtocol {
    func closedWindow()
}

class ImproveScoreVC: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var innerCircularView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bottomCircularView: UIView!
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    var delegateObj : ImproveScoreClosedProtocol? = nil
    public var currentCenteredPage: Int? {
        guard let collectionView = collectionView else { return nil }
        let currentCenteredPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width/2, y: collectionView.contentOffset.y + collectionView.bounds.height/2)
        
        return collectionView.indexPathForItem(at: currentCenteredPoint)?.row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // Get the reference to the CenteredCollectionViewFlowLayout (REQURED)
         centeredCollectionViewFlowLayout = (collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)

         // Modify the collectionView's decelerationRate (REQURED)
         collectionView.decelerationRate = UIScrollViewDecelerationRateFast
         // Assign delegate and data source
         collectionView.delegate = self
         collectionView.dataSource = self
         
         centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: collectionView.bounds.size.width + 30.0,
             height: collectionView.bounds.height * 1
         )
         centeredCollectionViewFlowLayout.minimumLineSpacing = 24
        
        bottomCircularView.ShadowForView()
        innerCircularView.ShadowForView()
        pageControl?.currentPage = 0
        self.btnPrev.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        topView.addGestureRecognizer(tap)
        topView.isUserInteractionEnabled = true
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        bottomView.addGestureRecognizer(tap1)
        bottomView.isUserInteractionEnabled = true
        
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if delegateObj != nil {
            delegateObj?.closedWindow()
        }
        self.dismiss(animated: false, completion: nil)
        
    }
    @objc func handleTap1(_ sender: UITapGestureRecognizer) {
           if delegateObj != nil {
               delegateObj?.closedWindow()
           }
           self.dismiss(animated: false, completion: nil)
           
       }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let page = currentCenteredPage {
            if page < 3 {
                self.collectionView.scrollToItem(at:IndexPath(item: page + 1, section: 0), at: .right, animated: false)
                pageControl?.currentPage = page + 1
            }
        }
        
        if currentCenteredPage == 0 {
                   self.btnPrev.isHidden = true
                   self.btnNext.isHidden = false
               }
              else if currentCenteredPage == 3 {
                   self.btnPrev.isHidden = false
                   self.btnNext.isHidden = true
               }
               else {
                   self.btnPrev.isHidden = false
                   self.btnNext.isHidden = false
               }
    }
    
    @IBAction func prevTapped(_ sender: Any) {
        if let page = currentCenteredPage {
            if page > 0  {
                
                self.collectionView.scrollToItem(at:IndexPath(item: page - 1, section: 0), at: .left, animated: false)
                pageControl?.currentPage = page - 1
                
            }
        }
         if currentCenteredPage == 0 {
                   self.btnPrev.isHidden = true
                   self.btnNext.isHidden = false
               }
              else if currentCenteredPage == 3 {
                   self.btnPrev.isHidden = false
                   self.btnNext.isHidden = true
               }
               else {
                   self.btnPrev.isHidden = false
                   self.btnNext.isHidden = false
               }
    }
    
    
}
extension ImproveScoreVC : UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForImproveScore", for: indexPath)  as! CellForImproveScore
        
        switch indexPath.row {
        case 0: //EXERCISE
            cell.headerLbl.text = "Make time for exercise"
            cell.lblFirstInfo.text = "Exercise is any activity that requires physical effort such as a swim,jog, gym workout or bike ride. Exercise will improve your health and Aktivo Score®."
            cell.imgView.image = UIImage(named: "sedentary-expanded")
            cell.lblBottom.text = ""
            
        case 1: //SEDENTARY
            cell.headerLbl.text = "Avoid sedentary time"
            cell.lblFirstInfo.text = "Sedentary behaviour means sitting or lying down when awake and which little to no physical effort is made."
            cell.imgView.image = UIImage(named: "light-activity-expanded")
            cell.lblBottom.text = "A sedentary time of 8 hours or more can be detrimental and will bring down your Aktivo Score®."
            
        case 2: //LIGHT ACTIVITY
            cell.headerLbl.text = "Replace sedentary time with light activity"
            cell.lblFirstInfo.text = "Light activity is any activity such as walking or moving around with household chores that requires some but not intense physical effort."
            cell.imgView.image = UIImage(named: "exercise-expanded")
            cell.lblBottom.text = "Replacing sedentary time with light activity will improve your health and Aktivo Score®."

        case 3: //SLEEP
            cell.headerLbl.text = "Sleep right"
            cell.lblFirstInfo.text = "Sleeping between 7 and 9 hours is important for your health and can have beneficial effects on your heart."
            cell.imgView.image = UIImage(named: "sleep-expanded")
            cell.lblBottom.text = "A good night's sleep will improve your Aktivo Score®."

        default:
            break
        }
        return cell
    }
    
  
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("End = \(Int(scrollView.contentOffset.x) / Int(scrollView.frame.width))")
        //pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
        
        pageControl?.currentPage = currentCenteredPage ?? Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
        
        if currentCenteredPage == 0 {
            self.btnPrev.isHidden = true
            self.btnNext.isHidden = false
        }
       else if currentCenteredPage == 3 {
            self.btnPrev.isHidden = false
            self.btnNext.isHidden = true
        }
        else {
            self.btnPrev.isHidden = false
            self.btnNext.isHidden = false
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("Animation = \(Int(scrollView.contentOffset.x) / Int(scrollView.frame.width))")

       // pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
        pageControl?.currentPage = currentCenteredPage ?? Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1

        
    }
    
}
