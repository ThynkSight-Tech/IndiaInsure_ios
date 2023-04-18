//
//  CellForCovidInstructions.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 12/11/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForCovidInstructions: UITableViewCell {

    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblInstructions: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class CellForCovidContact: UITableViewCell {
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var phoneTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnDone.makeHHCButton()
        phoneTextView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            phoneTextView.textDragInteraction?.isEnabled = false
        }
        print("CellForCovidInstructions")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
