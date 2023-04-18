//
//  ProgressView.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 31/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit


class ProgressView: UIView {
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var progressView: UIView!
    override func awakeFromNib() {
        circleView.layer.cornerRadius = circleView.frame.size.width/2
        circleView.clipsToBounds = true

    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ProgressView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
