//
//  CellForHCCard.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 22/06/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForHCCard: UITableViewCell {
    
    @IBOutlet weak var lblPackName: UILabel!
    
    
    @IBOutlet weak var viewPackageIncludes: UIView!
    // @IBOutlet weak var btnViewDetails: UIButton!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var backContentView: UIView!
    
    @IBOutlet weak var selectPackageFor: UILabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    
    
    @IBOutlet weak var genderBackView: UIView!
    @IBOutlet weak var amountBackView: UIView!

    @IBOutlet weak var ht1: NSLayoutConstraint!
    @IBOutlet weak var ht2: NSLayoutConstraint!
    @IBOutlet weak var ht3: NSLayoutConstraint!
    @IBOutlet weak var ht4: NSLayoutConstraint!

    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!

    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        viewPackageIncludes.layer.borderColor = #colorLiteral(red: 0.2509803922, green: 0.8784313725, blue: 0.8156862745, alpha: 1)
        viewPackageIncludes.layer.borderWidth = 1.0
        viewPackageIncludes.layer.cornerRadius = 4.0
        
        amountBackView.backgroundColor = Color.buttonBackgroundGreen.value
        self.backContentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        

    }
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        amountBackView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 2.0)
//        genderBackView.roundCorners(corners: [.bottomRight, .topRight], radius: 2.0)
//
//      //  self.layoutIfNeeded()
//    }
    
    override func layoutIfNeeded() {
        let borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.layer.addBorder(edge: .top, color: borderColor, thickness: 1.0)
         self.layer.addBorder(edge: .left, color: borderColor, thickness: 1.0)
         self.layer.addBorder(edge: .right, color: borderColor, thickness: 1.0)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

