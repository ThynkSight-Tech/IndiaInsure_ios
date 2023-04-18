//
//  CellForExploreDetailsCardTableViewCell.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 08/01/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

protocol ExploreBtnDetailsDataProtocol{
    func sendBtnData(pkgPlanSrNo: String , position : Int)
}

class CellForExploreDetailsCardTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tickImg: UIImageView!
    @IBOutlet weak var contentLbl: UILabel!
    
    //ButtonView
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var btnBorderView: UIView!
    @IBOutlet weak var buyBtn: UIButton!
    //@IBOutlet weak var bottomBorder: UIView!
    @IBOutlet weak var buyBtnView: UIView!
    var index : Int = -1
    var pkg_Plan_Sr_No : String = ""
    var delegate : ExploreBtnDetailsDataProtocol? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buyBtnAction(_ sender: Any) {
        print("buyBtnAction : ",index," pkg_Plan_Sr_No: ",pkg_Plan_Sr_No)
        delegate?.sendBtnData(pkgPlanSrNo: pkg_Plan_Sr_No, position: index)
    }
    
    func getIndexPath(indexpath : Int,pkg_Plan_Sr_No : String)
    {
        index = indexpath
        self.pkg_Plan_Sr_No = pkg_Plan_Sr_No
        print("getIndexPath: ",index," pkg_Plan_Sr_No: ",pkg_Plan_Sr_No)
       
        
    }
}
