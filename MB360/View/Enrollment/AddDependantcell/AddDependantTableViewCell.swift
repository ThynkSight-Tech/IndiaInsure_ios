//
//  AddDependantTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 27/06/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

protocol AddDependantTableViewCellDelegate: AnyObject
{
    func btnCloseTapped(cell: AddDependantTableViewCell)
    func deleteButtonClicked(cell: AddDependantTableViewCell)
    func saveButtonClicked(cell: AddDependantTableViewCell)
}


class AddDependantTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        m_editButton.makeCicular()
        m_deleteButton.makeCicular()
        
        m_editButton.layer.masksToBounds=true
        m_deleteButton.layer.masksToBounds=true
    }
    
    @IBOutlet weak var m_premiumStatementLbl: UILabel!
    @IBOutlet weak var m_relationTitleView: UIView!
    @IBOutlet weak var m_conditionsView: UIView!
    @IBOutlet weak var m_dateOfMarrigeTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var m_titleLbl: UILabel!
    @IBOutlet weak var m_backGroundView: UIView!
    
    @IBOutlet weak var m_nameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var m_dobTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var m_ageTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var m_saveButton: UIButton!
    
    @IBOutlet weak var m_deleteButton: UIButton!
    
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var m_parentalPremiumAmountLbl: UILabel!
    
    @IBOutlet weak var m_acceptConditionsButton: UIButton!
    
    
    @IBOutlet weak var heightBtnConstant: NSLayoutConstraint!
    
    
    @IBAction func deleteButtonClicked(_ sender: Any)
    {
        
    }
    var isEdit = Bool()
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    weak var delegate: AddDependantTableViewCellDelegate?
    @IBAction func editButtonTapped(_ sender: Any)
    {
        delegate?.btnCloseTapped(cell: self)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any)
    {
        delegate?.deleteButtonClicked(cell: self)
    }
    
    @IBOutlet weak var m_editButton: UIButton!
    
    @IBAction func saveButtonTapped(_ sender: Any)
    {
        delegate?.saveButtonClicked(cell: self)
    }
    
}
