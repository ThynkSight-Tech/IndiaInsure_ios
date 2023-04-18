//
//  NewAptmntHistoryCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 06/05/21.
//  Copyright © 2021 Semantic. All rights reserved.
//

import UIKit

class NewAptmntHistoryCell: UITableViewCell {
    
    
    @IBOutlet weak var btnSponsored: UIButton!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblHospitalAddress: UILabel!
    
    @IBOutlet weak var lblDateName: UILabel!
    @IBOutlet weak var lblMiddleBottomLbl: UILabel!
    @IBOutlet weak var rescheduleView: UIView!
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var btnScheduleCircular: UIButton!
    @IBOutlet weak var btnSchedule: UIButton!
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var bottomBtnViews: UIView!
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblDateView: UILabel!
    @IBOutlet weak var btnbackImage: UIButton!
    @IBOutlet weak var bottomLastView: UIView!
    @IBOutlet weak var shimmerView: UIView!

    @IBOutlet weak var heightOflastView: NSLayoutConstraint!
    var shimmer = ShimmerButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setBottomShadow(view: background)
        
        //Add shimmer
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
        shimmerView.addSubview(shimmer)

        middleView.layer.cornerRadius = 10.0
        bottomLastView.layer.cornerRadius = 10.0
        
        rescheduleView.clipsToBounds = true
        cancelView.clipsToBounds = true
        
        self.btnScheduleCircular.layer.cornerRadius = btnScheduleCircular.frame.size.height / 2
        self.btnScheduleCircular.layer.masksToBounds = true
        bottomBtnViews.layer.cornerRadius = 10.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
    func setBottomShadow(view:UIView)
    {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
}
