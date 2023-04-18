//
//  SumInsuredTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 21/01/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class SumInsuredTableViewCell: UITableViewCell {
    @IBOutlet weak var topupLbl: UILabel!
    @IBOutlet weak var sumInsuredStackView: UIStackView!
    
    @IBOutlet weak var totalTitleLbl: UILabel!
    @IBOutlet weak var topupTitleLbl: UILabel!
    @IBOutlet weak var totalSiiew: UIView!
    @IBOutlet weak var bsiView: UIView!
    @IBOutlet weak var sumInsuredTitleView: UIView!
    @IBOutlet weak var sumInsuredView: UIView!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var bsiLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
