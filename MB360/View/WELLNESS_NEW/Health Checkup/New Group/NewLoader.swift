//
//  NewLoader.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 21/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class NewLoader: UIView {

    let nibName = "NewLoader"
    var contentView: UIView?
    
   var imageView = UIImageView()
    
    @IBOutlet weak var centerView: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        imageView.frame = CGRect(x: 0 , y: 0, width: 70, height: 50)
        imageView.loadGif(name: "loading")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        
        self.centerView.addSubview(imageView)
        
        let centerX = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: centerView, attribute: .leading, multiplier: 1, constant: 8)
        
        let centerY = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: centerView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerX,centerY])
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70)
        
        imageView.addConstraints([heightConstraint, widthConstraint])
        
        centerView.layer.cornerRadius = 8.0
    }
    
    
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}




