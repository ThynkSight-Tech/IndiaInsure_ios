//
//  SelectPolicyTableViewCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 02/05/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class SelectPolicyTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPolicyType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class PolicyHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
