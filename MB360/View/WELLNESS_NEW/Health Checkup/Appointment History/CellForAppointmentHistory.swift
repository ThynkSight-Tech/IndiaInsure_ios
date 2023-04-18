//
//  CellForAppointmentHistory.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 02/07/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
//import Shimmer

class CellForAppointmentHistory: UITableViewCell {

    @IBOutlet weak var lblPersonName: UILabel!
    
    @IBOutlet weak var lblRelation: UILabel!
    
    @IBOutlet weak var btnViewDetails: UIButton!
    @IBOutlet weak var btnViewPackage: UIButton!
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnSponsored: UIButton!
    
    @IBOutlet weak var shimmerView: UIView!
    var shimmer = ShimmerButton()
    
    // var shimmer = ShimmerButton()
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.btnScheduleNow.clipsToBounds = true
        // self.btnScheduleNow.plainView.setGradientBackgroundNew(colorTop: ConstantContent.sharedInstance.hexStringToUIColor(hex: "3ed9b1"), colorBottom:ConstantContent.sharedInstance.hexStringToUIColor(hex: "40e0d0"))
        
        self.btnViewDetails.layer.cornerRadius = btnViewDetails.frame.size.height / 2
        self.btnViewDetails.backgroundColor = UIColor.white
        self.btnViewPackage.setTitleColor(Color.fontColor.value, for: .normal)
        
        self.btnViewDetails.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.btnViewDetails.layer.borderWidth = 1.7
        
        
        //Add shimmer
        //shimmer = ShimmerButton(frame: CGRect(x: self.frame.width - 35, y: 2, width: 70, height: 30))
        shimmer = ShimmerButton(frame: CGRect(x: 5, y: 0, width: 70, height: 25))
        shimmer.backgroundColor = UIColor.clear
        shimmer.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 13.0)
        shimmer.setTitle(" Sponsored", for: .normal)
        shimmer.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        shimmer.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        shimmer.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        shimmer.gradientTint = UIColor.lightText
        shimmer.gradientHighlight = UIColor.white
        shimmer.sizeToFit()
        self.shimmerView.addSubview(shimmer)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
