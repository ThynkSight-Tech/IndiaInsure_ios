//
//  CellForDentalPackageW.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 01/01/21.
//  Copyright © 2021 Semantic. All rights reserved.
//

import UIKit

class CellForDentalPackageW: UITableViewCell {

    @IBOutlet weak var lblStartingPrice: UILabel!
    @IBOutlet weak var btnViewDetails: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblPackage: UILabel!
    @IBOutlet weak var imgTickView: UIImageView!
    
    @IBOutlet weak var lblSelectPackage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSelectPackage.textColor = Color.buttonBackgroundGreen.value
        btnViewDetails.setTitleColor(Color.buttonBackgroundGreen.value, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
