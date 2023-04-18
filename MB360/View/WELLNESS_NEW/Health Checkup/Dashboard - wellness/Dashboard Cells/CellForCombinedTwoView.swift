//
//  CellForCombinedTwoView.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 28/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CellForCombinedTwoView: UITableViewCell {
    
    @IBOutlet weak var lblHeading1: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var lblCities1: UILabel!
    @IBOutlet weak var backgroundBorderView1: UIView!
    
    @IBOutlet weak var lblHeading2: UILabel!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var lblCities2: UILabel!
    @IBOutlet weak var backgroundBorderView2: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    setBottomShadow(view: backgroundBorderView1)
    setBottomShadow(view: backgroundBorderView2)
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setBottomShadow(view:UIView)
    {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3)
        view.layer.shadowRadius = 0
        view.layer.cornerRadius = 10.0
        
        view.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        view.layer.borderWidth = 0.7

    }
}


extension UIView {
    func addshadowNew(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
}
}
