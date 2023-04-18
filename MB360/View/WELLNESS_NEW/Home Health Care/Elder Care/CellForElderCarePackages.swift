//
//  CellForElderCarePackages.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 27/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForElderCarePackages: UITableViewCell {

    @IBOutlet weak var lblFeature: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

class CellForElderCareDetails: UITableViewCell {

    @IBOutlet weak var lblFeature: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

class CellForElderCarePriceCell: UITableViewCell {

    @IBOutlet weak var lblFeature: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

class CellForElderCarePriceSelectionCell: UITableViewCell {

    @IBOutlet weak var lblFeature: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var btnGetItNow: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnGetItNow.layer.cornerRadius = 6.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

class CellForSelectedMemberHHC: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    
    @IBOutlet weak var viewBack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //btnChange.makeHHCButton()
        //viewBack.setCornerRadius()
        
        //Lbl
        lblName.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h14))
        lblName.textColor = FontsConstant.shared.app_mediumGrayColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    
}
