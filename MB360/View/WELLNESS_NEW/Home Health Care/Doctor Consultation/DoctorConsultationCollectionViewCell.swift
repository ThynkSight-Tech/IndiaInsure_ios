//
//  DoctorConsultationCollectionViewCell.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 06/01/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

class DoctorConsultationCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var contentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupFontsUI()
    }
    
    func setupFontsUI(){
        
        contentLbl.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h14))
        contentLbl.textColor = FontsConstant.shared.app_FontSecondryColor
    }
}
