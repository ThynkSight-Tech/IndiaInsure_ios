//
//  PolicyDetailsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 13/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class PolicyDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var m_headerView: UIView!
    
    @IBOutlet weak var m_polocyDateLbl: UILabel!
    @IBOutlet weak var m_tpaLbl: UILabel!
    @IBOutlet weak var m_insurerLbl: UILabel!
    @IBOutlet weak var m_brokerLbl: UILabel!
    @IBOutlet weak var m_policyLbl: UILabel!
    @IBOutlet weak var m_headerTitleLbl: UILabel!
    @IBOutlet weak var m_groupNameLbl: UILabel!
    @IBOutlet weak var m_tpaNameLbl: UILabel!
    @IBOutlet weak var m_insurerNameLbl: UILabel!
    @IBOutlet weak var m_brokerNameLbl: UILabel!
    @IBOutlet weak var m_backgroundView: UIView!
   
    @IBOutlet weak var m_tpavalueBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_tpaTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_tpaTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        sizeToFit()
        layoutIfNeeded()
    }

    @IBOutlet weak var m_bottomVerticalConstraint: NSLayoutConstraint!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
