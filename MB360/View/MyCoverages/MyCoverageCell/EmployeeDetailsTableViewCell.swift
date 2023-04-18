//
//  EmployeeDetailsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 21/01/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class EmployeeDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var empNameLbl: UILabel!
    
    @IBOutlet weak var relationLbl: UILabel!
    
    @IBOutlet weak var employeeDetailsTitleView: UIView!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var empDetailsView: UIView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
