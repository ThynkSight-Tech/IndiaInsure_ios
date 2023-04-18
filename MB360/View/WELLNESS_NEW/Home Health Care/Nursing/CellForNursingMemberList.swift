//
//  CellForNursingMemberList.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 02/11/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForNursingMemberList: UITableViewCell {

    @IBOutlet weak var imgTickView: UIImageView!
    @IBOutlet weak var lblPersonName: UILabel!
        
    @IBOutlet weak var heightForViewDetails: NSLayoutConstraint!
    @IBOutlet weak var lblRelation: UILabel!
        @IBOutlet weak var lblViewDetails: UILabel!

        @IBOutlet weak var lblAge: UILabel!
        @IBOutlet weak var btnSelect: UIButton!
        
        @IBOutlet weak var cellForViewDetailsView: UIView!

        @IBOutlet weak var mainView: UIView!
        
      //  var shimmer = ShimmerButton()
        
        override func awakeFromNib() {
            super.awakeFromNib()
           // self.btnSelect.dropShadow()
            //self.btnSelect.makeHHCButton()
            //lblViewDetails.set(textColor: Color.buttonBackgroundGreen.value, range: nil)
            lblViewDetails.textColor = Color.buttonBackgroundGreen.value
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        
 

}
