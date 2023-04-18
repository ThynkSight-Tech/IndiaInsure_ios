//
//  ChangeCityCell_W.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 12/09/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class ChangeCityCell_W: UITableViewCell {

    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var backView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //btnCity.makeRoundedBorderGreen()

        //let tintedImage = imgView.image?.withRenderingMode(.alwaysTemplate)
        //imgView.image = tintedImage
        //imgView.tintColor = Color.buttonBackgroundGreen.value
        
        let tintedImage1 = arrowImg.image?.withRenderingMode(.alwaysTemplate)
        arrowImg.image = tintedImage1
        arrowImg.tintColor = Color.buttonBackgroundGreen.value
        
        lblCityName.textColor = Color.buttonBackgroundGreen.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
