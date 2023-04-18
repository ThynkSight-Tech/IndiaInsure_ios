//
//  DeleteConfirmationPopupVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 30/11/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol DeleteMemberConfirmationProtocol {
    func deleteMemberTapped(memberId:String)
    func dontDeleteMemberTapped()
}

class DeleteConfirmationPopupVC: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblBottomLabel: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    //@IBOutlet weak var viewBorder: UIView!
    
    var yesNoDelegate : DeleteMemberConfirmationProtocol? = nil
    var memberId = String()
    
    var isReschedule = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.makeTransparentBackground()
        print("In DeleteConfirmationPopupVC")
        setColor()
    }
    
    func setColor() {
        self.btnYes.layer.cornerRadius = btnYes.bounds.height / 2
        self.btnYes.backgroundColor = Color.buttonBackgroundGreen.value
        self.btnNo.setTitleColor(Color.fontColor.value, for: .normal)
        lblHeader.textColor = Color.fontColor.value
        btnYes.dropShadow()
        
        btnNo.dropShadow()
        
    }
    
    @IBAction func yesTapped(_ sender: Any) {
        if yesNoDelegate != nil {
            yesNoDelegate?.deleteMemberTapped(memberId: memberId)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
