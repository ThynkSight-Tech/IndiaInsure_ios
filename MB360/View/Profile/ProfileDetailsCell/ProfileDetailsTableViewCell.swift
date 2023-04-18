//
//  ProfileDetailsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 17/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
//class ExpandedCellContent
//{
//
//    var otherInfo : PERSON_INFORMATION?
//    var expanded : Bool
//
//    init(otherInfo : PERSON_INFORMATION)
//    {
//
//        self.otherInfo = otherInfo
//        self.expanded = false
//    }
//}

class ExpandedCellContent
{
   
    var otherInfo : [ProfileDetails]
    var expanded : Bool
    
    init(otherInfo : [ProfileDetails])
    {
        
        self.otherInfo = otherInfo
        self.expanded = false
    }
}


class ProfileDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var m_backgroundView: UIView!
    @IBOutlet weak var m_iconImageview: UIImageView!
    @IBOutlet weak var m_titleLbl: UILabel!
    @IBOutlet weak var m_detailsButton: UIButton!
    @IBOutlet weak var m_titleBackgroundView: UIView!
    @IBOutlet weak var m_cancelButton: UIButton!
    @IBOutlet weak var m_detilsBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var m_saveChangesButton: UIButton!
    @IBOutlet weak var m_addressTxtField: UITextField!
    @IBOutlet weak var m_genderTxtField: UITextField!
    @IBOutlet weak var contactNumberTxtField: UITextField!
    @IBOutlet weak var m_emailIDTxtField: UITextField!
    @IBOutlet weak var m_mobileNumberTxtField: UITextField!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(data:ExpandedCellContent)
    {
       
        
        if(data.expanded)
        {
//            let dict = data.otherInfo
//            self.m_claimDateLbl.text=dict?.claimIntimationDate
//            self.m_hospitalNameLbl.text=dict?.claimHospital
//            self.m_dateofAdmissionLbl.text=dict?.dateOfAdmission
//            self.m_claimAmountLbl.text=dict?.claimAmount
//            m_claimNumber.text="Medical Claim"
//            m_iconImageview.transform = ImageView.transform.rotated(by: CGFloat(180))
          
        }
        else
        {
            
            m_detilsBackgroundView.isHidden=true
            m_detilsBackgroundView.isHidden=false
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.m_detailsButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            
        }
    }
}
