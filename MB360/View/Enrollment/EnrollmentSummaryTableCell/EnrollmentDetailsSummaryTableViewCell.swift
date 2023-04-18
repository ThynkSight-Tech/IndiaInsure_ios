//
//  EnrollmentDetailsSummaryTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 16/08/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class EnrollmentDetailsSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var m_backgroundView: UIView!
    
    @IBOutlet weak var m_imageview: UIImageView!
    
    @IBOutlet weak var m_countLbl: UILabel!
    @IBOutlet weak var m_titleLbl: UILabel!
    
    @IBOutlet weak var m_title1Lbl: UILabel!
    @IBOutlet weak var m_title2Lbl: UILabel!
    @IBOutlet weak var m_title3Lbl: UILabel!
    @IBOutlet weak var m_title4Lbl: UILabel!
    
    @IBOutlet weak var m_valueLbl1: UILabel!
    
    @IBOutlet weak var m_value2Lbl: UILabel!
    
    @IBOutlet weak var m_value3Lbl: UILabel!
    
    @IBOutlet weak var m_value4Lbl: UILabel!
    
    @IBOutlet weak var m_titleBackgroundView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
