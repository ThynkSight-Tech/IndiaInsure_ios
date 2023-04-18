//
//  CellForAddressListMDCell.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 15/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CellForAddressListMDCell: UITableViewCell {

    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var btnRadioButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var lblEmailId: UILabel!
    @IBOutlet weak var lblMobNo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
