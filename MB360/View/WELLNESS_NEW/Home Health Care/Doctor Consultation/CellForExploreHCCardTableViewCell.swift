//
//  CellForExploreHCCardTableViewCell.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 08/01/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

class CellForExploreHCCardTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var gstMsg: UILabel!
    @IBOutlet weak var planAmountWithGst: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
