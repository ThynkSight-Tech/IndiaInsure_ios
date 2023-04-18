//
//  CellForDentalPackages.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 25/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForDentalPackages: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPackName: UILabel!
    @IBOutlet weak var imgView: UIImage!

    
    @IBOutlet weak var btnPackageIncludes: UIButton!
    @IBOutlet weak var btnViewDetails: UIButton!

    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var backView: UIView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
