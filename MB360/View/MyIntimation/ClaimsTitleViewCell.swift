//
//  ClaimsTitleViewCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 08/08/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class ClaimsTitleViewCell: UITableViewCell {
    @IBOutlet weak var m_claimDateLbl: UILabel!
    @IBOutlet weak var m_claimNumber: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    @IBOutlet weak var m_expandButton: UIButton!

    @IBOutlet weak var backDetailsView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
