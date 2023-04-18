//
//  MyClaimsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 16/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class MyClaimsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var m_totalClaimsCountButton: UIButton!
    @IBOutlet weak var m_totalClaimsLbl: UILabel!
    @IBOutlet weak var m_reimbursementNumberButton: UIButton!
    @IBOutlet weak var m_cashlessNumberButton: UIButton!
    @IBOutlet weak var claimNumberDetailsView: UIView!
    
    @IBOutlet weak var m_claimStatusLbl: UILabel!
    @IBOutlet weak var m_claimNumberLbl: UILabel!
    
    @IBOutlet weak var m_claimAmountTitleLbl: UILabel!
    @IBOutlet weak var m_claimDateTitleLbl: UILabel!
    @IBOutlet weak var m_claimTypeTitleLbl: UILabel!
    @IBOutlet weak var m_dataNotFoundView: UIView!
    @IBOutlet weak var m_claimTypeLbl: UILabel!
    @IBOutlet weak var m_typeButton: UIButton!
    @IBOutlet weak var m_liveStatusButton: UIButton!
    
    @IBOutlet weak var m_claimDateLbl: UILabel!
    @IBOutlet weak var m_claimAmountLbl: UILabel!
   
    @IBOutlet weak var m_statusLbl: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    @IBOutlet weak var m_backGroundView: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
