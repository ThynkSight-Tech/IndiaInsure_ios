//
//  LeftSideTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 22/01/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class LeftSideTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var m_titleLbl: UILabel!
    
    @IBOutlet weak var m_imageView: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
