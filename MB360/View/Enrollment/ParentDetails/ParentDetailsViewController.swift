//
//  ParentDetailsViewController.swift
//  MyBenefits
//
//  Created by Semantic on 27/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar

class ParentDetailsViewController: UIViewController,FlexibleSteppedProgressBarDelegate {

    @IBOutlet weak var m_topView: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.isNavigationBarHidden=false
        
        setupProgressBar()
    }
    
    func setupProgressBar()
    {
        let progressBar = FlexibleSteppedProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        m_topView.addSubview(progressBar)
        
        progressBar.selectedOuterCircleStrokeColor=UIColor.darkGray
        progressBar.accessibilityElementsHidden=true
        
        let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: m_topView.centerXAnchor)
        
        let verticalConstraint = progressBar.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 20
        )
        let widthC = progressBar.widthAnchor.constraint(greaterThanOrEqualToConstant: m_topView.frame.width-12)
        let heightConstraint = progressBar.heightAnchor.constraint(equalToConstant: 35)
        
        NSLayoutConstraint.activate([widthC,heightConstraint,verticalConstraint,horizontalConstraint])
        //        NSLayoutConstraint.activate([horizontalConstraint!, verticalConstraint!, widthC!, heightConstraint!])
        
        // Customise the progress bar here
        progressBar.numberOfPoints = 3
        progressBar.lineHeight = 3
        progressBar.radius = 25
        progressBar.progressRadius = 0
        progressBar.progressLineHeight = 3
        
        progressBar.currentSelectedCenterColor=hexStringToUIColor(hex: hightlightColor)
        //        progressBar.selectedOuterCircleStrokeColor=hexStringToUIColor(hex: "#1e89ea")
        progressBar.selectedBackgoundColor=hexStringToUIColor(hex: hightlightColor)
        //        progressBar.s
        progressBar.currentIndex=0
        progressBar.delegate = self
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int)
    {
        switch index {
            
        case 0:
            
           navigationController?.popViewController(animated: true)
            
            break
            
        case 1:
          
            break
            
        case 2: 
            break
        case 3: break
        case 4: break
        default: break
            
        }
    }
    
    private func progressBar(progressBar: FlexibleSteppedProgressBar,
                             willSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String
    {
        progressBar.currentSelectedTextColor=UIColor.blue
        progressBar.centerLayerTextColor=UIColor.white
        
        
        if position == FlexibleSteppedProgressBarTextLocation.center {
            switch index {
                
            case 0: return "1"
            case 1: return "2"
            case 2: return "3"
            case 3: return "4"
            case 4: return "5"
            default: return "Date"
                
            }
        }
        return ""
    }
    
}
