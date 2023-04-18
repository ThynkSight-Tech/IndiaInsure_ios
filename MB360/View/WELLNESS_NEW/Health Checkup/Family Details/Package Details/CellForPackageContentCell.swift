//
//  CellForPackageContentCell.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 31/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CellForPackageContentCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBOutlet weak var m_backGroundView: UIView!
    @IBOutlet weak var m_answerBackgroundView: UIView!
    @IBOutlet weak var m_questionBackgroundView: UIView!
    @IBOutlet weak var m_answerLbl: UILabel!
    @IBOutlet weak var m_expandButton: UIButton!
    @IBOutlet weak var m_questionLbl: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
//    func setContent(data:PackageModel)
//    {
//        self.m_questionLbl.text=data.Name
//
//        if(data.expanded)
//        {
//            let info = data.Detail
//            self.m_answerLbl.text = info
//            m_expandButton.setImage(UIImage(named: "minus"), for: .normal)
//            m_answerBackgroundView.isHidden=false
//        }
//        else
//        {
//            m_expandButton.setImage(UIImage(named: "plus"), for: .normal)
//            self.m_answerLbl.text = ""
//            m_answerBackgroundView.isHidden=true
//        }
//    }
    
}


