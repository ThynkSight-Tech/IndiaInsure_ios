//
//  CellForHealthCheckupSelection.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/04/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForHealthCheckupSelection: UITableViewCell {

    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnBox: UIButton!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var topNameView: UIView!

    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var heightForScheduleView: NSLayoutConstraint!
    
    @IBOutlet weak var checkBoxImageView: UIButton!
    
    @IBOutlet weak var stackWidth: NSLayoutConstraint!
    @IBOutlet weak var lblScheduleNow: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    var isLast = false
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h14))
        lblName.textColor = FontsConstant.shared.app_FontBlackColor
        
        lblScheduleNow.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h14))
        lblScheduleNow.textColor = FontsConstant.shared.app_FontCaribbeanGreen
       
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        let borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

         self.layer.addBorder(edge: .left, color: borderColor, thickness: 1.0)
         self.layer.addBorder(edge: .right, color: borderColor, thickness: 1.0)
        
        self.needsUpdateConstraints()
        self.layoutSubviews()
        //self.reloadInputViews()
        //if isLast {
       // self.layer.addBorder(edge: .bottom, color: borderColor, thickness: 1.0)
        //}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
