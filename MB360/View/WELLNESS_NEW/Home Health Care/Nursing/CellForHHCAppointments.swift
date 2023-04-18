//
//  CellForHHCAppointments.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 26/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit


    class CellForHHCAppointments: UITableViewCell {
        
        
        @IBOutlet weak var lblRelation: UILabel!
        @IBOutlet weak var lbl1: UILabel!
        @IBOutlet weak var lbl2: UILabel!
        @IBOutlet weak var lbl3: UILabel!
        
        @IBOutlet weak var middleSeparator: UIView!
        @IBOutlet weak var lblPersonName: UILabel!
        @IBOutlet weak var lblReferenceNo: UILabel!
        @IBOutlet weak var lblRemarks: UILabel!
        
        @IBOutlet weak var lblDateName: UILabel!
        @IBOutlet weak var lblMiddleBottomLbl: UILabel!
        @IBOutlet weak var rescheduleView: UIView!
        @IBOutlet weak var cancelView: UIView!
                
        @IBOutlet weak var background: UIView!
        @IBOutlet weak var bottomBtnViews: UIView!
        @IBOutlet weak var colorView: UIView!
        
        @IBOutlet weak var middleView: UIView!
        @IBOutlet weak var bottomHeight: NSLayoutConstraint!
        
        @IBOutlet weak var lblDateView: UILabel!
        @IBOutlet weak var bottomLastView: UIView!

        @IBOutlet weak var heightOflastView: NSLayoutConstraint!
        var shimmer = ShimmerButton()
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            
            setBottomShadow(view: background)
            

            middleView.layer.cornerRadius = 10.0
            //middleView.clipsToBounds = true
            
            bottomLastView.layer.cornerRadius = 10.0
            //bottomLastView.clipsToBounds = true
            
           // rescheduleView.clipsToBounds = true
            cancelView.clipsToBounds = true
            
           // bottomBtnViews.clipsToBounds = true
            //self.btnScheduleCircular.layer.cornerRadius = btnScheduleCircular.frame.size.height / 2
 //           self.btnScheduleCircular.layer.masksToBounds = true
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
            view.layer.cornerRadius = 8
        }
    }


class CellForOverviewHHC: UITableViewCell
{
    @IBOutlet weak var btnOverview: UIButton!
    @IBOutlet weak var btnRates: UIButton!
    @IBOutlet weak var btnRef: UIButton!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //btnRef.makeHHCCircularButton()
        btnRates.makeHHCCircularButton()
        btnOverview.makeHHCCircularButton()
        
    }
}


