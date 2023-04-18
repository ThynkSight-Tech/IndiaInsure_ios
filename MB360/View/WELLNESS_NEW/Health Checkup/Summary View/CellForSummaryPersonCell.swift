//
//  CellForSummaryPersonCell.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 07/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CellForSummaryPersonCell: UITableViewCell {
    
    @IBOutlet weak var lblPersonAmount: UILabel!
    @IBOutlet weak var lblPersonName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class CellForSummarySelfTopCell: UITableViewCell {
    
    @IBOutlet weak var lblPersonAmount: UILabel!
    @IBOutlet weak var lblPersonName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class CellForSummaryEmpPaid: UITableViewCell {
    
    @IBOutlet weak var lblEmpPaid: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class CellForBottomPaymentCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lblTotalAmt: UILabel!
    
    @IBOutlet weak var lblYouPayAmt: UILabel!
    @IBOutlet weak var lblPaidAmt: UILabel!
    
    @IBOutlet weak var gstView: UIView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var lblGst: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnConfirm.dropShadow()
        btnConfirm.layer.cornerRadius = btnConfirm.frame.height / 2
        btnConfirm.backgroundColor = Color.buttonBackgroundGreen.value
        gstView.layer.cornerRadius = 6.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
