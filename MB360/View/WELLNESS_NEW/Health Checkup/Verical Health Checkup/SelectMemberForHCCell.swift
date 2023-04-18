//
//  SelectMemberForHCCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/06/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class SelectMemberForHCCell: UITableViewCell {

        @IBOutlet weak var lblName: UILabel!
        @IBOutlet weak var btnBox: UIButton!
        @IBOutlet weak var scheduleView: UIView!
        @IBOutlet weak var topNameView: UIView!

        @IBOutlet weak var heightForScheduleView: NSLayoutConstraint!
        
        @IBOutlet weak var checkBoxImageView: UIButton!
        
        @IBOutlet weak var btnDelete: UIButton!
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
    }
