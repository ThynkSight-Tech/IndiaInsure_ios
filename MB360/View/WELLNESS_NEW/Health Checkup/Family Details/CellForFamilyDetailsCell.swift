//
//  CellForFamilyDetailsCell.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 30/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
//import Shimmer

class CellForFamilyDetailsCell: UITableViewCell {

    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblRelation: UILabel!
    
    @IBOutlet weak var btnScheduleNow: UIButton!
    @IBOutlet weak var btnViewPackage: UIButton!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnSponsored: UIButton!
    
    @IBOutlet weak var shimmerView: UIView!
    var shimmer = ShimmerButton()
    
   // var shimmer = ShimmerButton()
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.btnScheduleNow.clipsToBounds = true
       // self.btnScheduleNow.plainView.setGradientBackgroundNew(colorTop: ConstantContent.sharedInstance.hexStringToUIColor(hex: "3ed9b1"), colorBottom:ConstantContent.sharedInstance.hexStringToUIColor(hex: "40e0d0"))

        self.lblAmount.textColor = Color.textDarkGreen.value

        self.btnScheduleNow.dropShadow()
        self.btnScheduleNow.layer.cornerRadius = btnScheduleNow.frame.size.height / 2
        self.btnScheduleNow.backgroundColor = Color.buttonBackgroundGreen.value
        self.btnViewPackage.setTitleColor(Color.fontColor.value, for: .normal)

        //Add shimmer
        //shimmer = ShimmerButton(frame: CGRect(x: self.frame.width - 35, y: 2, width: 70, height: 30))
        shimmer = ShimmerButton(frame: CGRect(x: 5, y: 0, width: 70, height: 25))
        shimmer.backgroundColor = UIColor.clear
        shimmer.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 13.0)
        shimmer.setTitle(" Sponsored", for: .normal)
        shimmer.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        shimmer.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        shimmer.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        shimmer.gradientTint = UIColor.lightText
        shimmer.gradientHighlight = UIColor.white
        shimmer.sizeToFit()
        self.shimmerView.addSubview(shimmer)

        /*
         shimmer = ShimmerButton(frame: CGRect(x: mainView.frame.width - 40, y: 8, width: 70, height: 30))
       // let imgView = UIImageView(frame: CGRect(x: mainView.bounds.width - 40, y: 8, width: 95, height: 30))
        
        shimmer.backgroundColor = UIColor.lightGray
       // imgView.backgroundColor = UIColor.yellow

        //imgView.image = UIImage(named: "sponsored")
        //imgView.contentMode = .scaleAspectFit
        shimmer.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 13.0)
        shimmer.setTitle("Sponsored", for: .normal)
//        shimmer.titleLabel?.textAlignment = .right
        shimmer.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        
        shimmer.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        shimmer.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)


        //shimmer.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightHeavy)
        shimmer.gradientTint = UIColor.darkGray
        shimmer.gradientHighlight = UIColor.white
        shimmer.sizeToFit()
        
        //shimmer.setBackgroundImage(UIImage(named: "sponsored"), for: .normal)
        //self.mainView.addSubview(imgView)
        
        self.mainView.addSubview(shimmer)

*/
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
