//
//  CellForHealthCheckupCell.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 28/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CellForHealthCheckupCell: UITableViewCell {
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var lblImageView: UIImageView!
    @IBOutlet weak var btnBookAppointment: UIButton!
    
    @IBOutlet weak var lblCities: UILabel!
    @IBOutlet weak var backgroundBorderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setBottomShadow(view: backgroundBorderView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setBottomShadow(view:UIView)
    {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }

}

class CellForMedicineCell: UITableViewCell {
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnAvailability: UIButton!
    
    @IBOutlet weak var lblCities: UILabel!
    @IBOutlet weak var backgroundBorderView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBottomShadow(view: backgroundBorderView)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setBottomShadow(view:UIView)
    {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
    
}


