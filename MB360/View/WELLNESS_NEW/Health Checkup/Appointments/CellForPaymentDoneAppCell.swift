//
//  CellForPaymentDoneAppCell.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 11/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
//import Shimmer

class CellForPaymentDoneAppCell: UITableViewCell {

    
    @IBOutlet weak var webView2height: NSLayoutConstraint!
    @IBOutlet weak var btnSponsored: UIButton!
    
    @IBOutlet weak var lblPersonName: UILabel!
    
    @IBOutlet weak var lblHospitalName: UILabel!
    
    @IBOutlet weak var lblHospitalAddress: UILabel!
    
    @IBOutlet weak var rescheduleView: UIView!
    
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var webView1: UIWebView!
    
    @IBOutlet weak var btnScheduleCircular: UIButton!
    @IBOutlet weak var webView2: UIWebView!
    
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var bottomBtnViews: UIView!
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()

        webView2.scrollView.bounces = false
        webView2.scrollView.isScrollEnabled = false
        
       // webView2height.constant = webView2.scrollView.frame.height
      setBottomShadow(view: background)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        rescheduleView.clipsToBounds = true
        cancelView.clipsToBounds = true
        
        
        self.btnScheduleCircular.layer.cornerRadius = btnScheduleCircular.frame.size.height / 2
        self.btnScheduleCircular.layer.masksToBounds = true
    }

    func setBottomShadow(view:UIView)
    {
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
}



class CellForPaymentNotDoneAppCell: UITableViewCell {
    
    
    @IBOutlet weak var btnSponsored: UIButton!
    
    @IBOutlet weak var lblPersonName: UILabel!
    
    @IBOutlet weak var lblHospitalName: UILabel!
    
    @IBOutlet weak var lblHospitalAddress: UILabel!
    
    @IBOutlet weak var rescheduleView: UIView!
    
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var webView1: UIWebView!
    
    @IBOutlet weak var btnScheduleCircular: UIButton!
    @IBOutlet weak var webView2: UIWebView!
    
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var webview3: UIWebView!
    @IBOutlet weak var bottomBtnViews: UIView!

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setBottomShadow(view: background)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        rescheduleView.clipsToBounds = true
        cancelView.clipsToBounds = true
        
        
        self.btnScheduleCircular.layer.cornerRadius = btnScheduleCircular.frame.size.height / 2
        self.btnScheduleCircular.layer.masksToBounds = true
    }
    
    func setBottomShadow(view:UIView)
    {
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
}


class CellForConfirmedCell: UITableViewCell {
    
    
    @IBOutlet weak var btnSponsored: UIButton!
    
    @IBOutlet weak var heightView2: NSLayoutConstraint!
    @IBOutlet weak var lblPersonName: UILabel!
    
    @IBOutlet weak var heightView1: NSLayoutConstraint!
    @IBOutlet weak var lblHospitalName: UILabel!
    
    @IBOutlet weak var lblHospitalAddress: UILabel!
    
    @IBOutlet weak var rescheduleView: UIView!
    
    @IBOutlet weak var cancelView: UIView!
    
    
    @IBOutlet weak var btnScheduleCircular: UIButton!
    @IBOutlet weak var webView2: UIWebView!
    
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var webview3: UIWebView!
    @IBOutlet weak var bottomBtnViews: UIView!
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //setBottomShadow(view: background)
        
        background.dropShadow()
        background.layer.cornerRadius=25
        

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        rescheduleView.clipsToBounds = true
        cancelView.clipsToBounds = true
        
        
        self.btnScheduleCircular.layer.cornerRadius = btnScheduleCircular.frame.size.height / 2
        self.btnScheduleCircular.layer.masksToBounds = true
    }
    
    func setBottomShadow(view:UIView)
    {
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
}


class CellForTextAppointmentCell: UITableViewCell {
    
    
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
        // Initialization code
        
        setBottomShadow(view: background)
        
        //Add shimmer
     // shimmer = ShimmerButton(frame: CGRect(x: background.frame.width - 35, y: 6, width: 70, height: 30))
        shimmer = ShimmerButton(frame: CGRect(x: 5, y: 0, width: 70, height: 25))

       // shimmer = ShimmerButton(frame: CGRect(x: btnbackImage.frame.origin.x + 10, y: btnbackImage.frame.origin.y - 2, width: 70, height: 30))

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
        //middleView.clipsToBounds = true
        
        bottomLastView.layer.cornerRadius = 10.0
        //bottomLastView.clipsToBounds = true
        
        rescheduleView.clipsToBounds = true
        cancelView.clipsToBounds = true
        
       // bottomBtnViews.clipsToBounds = true
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


