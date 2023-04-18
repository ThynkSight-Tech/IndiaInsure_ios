//
//  CellForHealthPackages.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 25/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForHealthPackages: UITableViewCell {
    
    @IBOutlet weak var lblPackName: UILabel!
    
    
    @IBOutlet weak var viewPackageIncludes: UIView!
    // @IBOutlet weak var btnViewDetails: UIButton!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var backContentView: UIView!
    
    
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

        viewPackageIncludes.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        viewPackageIncludes.layer.borderWidth = 1.0
        viewPackageIncludes.layer.cornerRadius = 4.0
        

        self.backContentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        amountBackView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 6.0)
        genderBackView.roundCorners(corners: [.bottomRight, .topRight], radius: 6.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
