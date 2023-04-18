//
//  TopupTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 14/03/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
class TopupCellContent
{
    var title : String?
    var otherInfo : String?
    var expanded : Bool
    
    init(title:String, otherInfo : String?, expanded: Bool)
    {
        self.title = title
        self.otherInfo = otherInfo
        self.expanded = expanded
    }
    
}
class TopupTableViewCell: UITableViewCell {

    
   
    
    @IBOutlet weak var m_addTopupSubViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_TopupbackGroundView: UIView!
    
    
    @IBOutlet weak var m_topUpTitlelbl: UILabel!
    @IBOutlet weak var m_BSIAmountLbl: UILabel!
    @IBOutlet weak var m_topupTitleView: UIView!
    
    @IBOutlet weak var m_optTopupSwitch: UISwitch!
    
    @IBOutlet weak var m_addTopupBackgrounView: UIView!
    
    @IBOutlet weak var m_topupOpetion1lbl: UILabel!
    
    
    @IBOutlet weak var m_topupOption2Lbl: UILabel!
    
    @IBOutlet weak var m_topupOption3Lbl: UILabel!
    
    
    @IBOutlet weak var m_premium1lbl: UILabel!
    
    @IBOutlet weak var m_premium2Lbl: UILabel!
    
    @IBOutlet weak var m_premium3Lbl: UILabel!
    
    @IBOutlet weak var m_topup1checkImageview: UIImageView!
    
    @IBOutlet weak var m_topup2CheckImgview: UIImageView!
    
    @IBOutlet weak var m_topup3CheckImgview: UIImageView!
    
    @IBOutlet weak var m_agreeTermsSwitch: UISwitch!
    
    func setTopupContent(data:TopupCellContent)
    {
        
        if(data.expanded)
        {
            m_optTopupSwitch.setOn(true, animated: true)
            m_addTopupBackgrounView.isHidden=false
            m_addTopupSubViewHeightConstraint.constant=208
            
        }
        else
        {
            m_optTopupSwitch.setOn(false, animated: true)
            m_addTopupBackgrounView.isHidden=true
            m_addTopupSubViewHeightConstraint.constant=0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
