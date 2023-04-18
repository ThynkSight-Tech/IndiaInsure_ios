//
//  DiabetesCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 22/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class DiabetesCell: UITableViewCell {
    @IBOutlet weak var lblPriceCompany: UILabel!

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMRP: UILabel!
    @IBOutlet weak var btnGetItNow: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnGetItNow.layer.cornerRadius = 8.0
        
        //MARK CROSS LINE
        let attDates1 = NSMutableAttributedString.init(string: lblMRP.text!)

        attDates1.addAttributes([
            NSAttributedStringKey.strikethroughStyle:NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.strikethroughColor:UIColor(hexFromString: "#DF1C22")],
                                range: NSMakeRange(0, attDates1.length))
        let str = ""
        let attributedQuote = NSMutableAttributedString(string: str)
        let combina = NSMutableAttributedString()
        combina.append(attributedQuote)
        combina.append(attDates1)
        lblMRP.attributedText = combina
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
