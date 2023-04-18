//
//  CustomLoaderView.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 21/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CustomLoaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var centerBoxView: UIView!
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
        commonInit()
       // self.backgroundColor = UIColor.red
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)

    }
    
   
    static func instantiate() -> CustomLoaderView {
        let view: CustomLoaderView = initFromNib()
        view.centerBoxView.backgroundColor = UIColor.blue
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
       // fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        //showCustomLoader()
       // Bundle.main.loadNibNamed("CustomLoaderView", owner: self, options: nil)
        //addSubview(contentView)
        //contentView.frame = self.bounds
        //contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        //contentView.backgroundColor = UIColor.gray

    }
    
    
    
}

extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}

extension CustomLoaderView {
    

    func showCustomLoader() {
        //let blurLoader = CustomLoaderView(frame: UIScreen.main.bounds)
        //self.addSubview(blurLoader)
        
        //imageView.frame = CGRect(x: 0 , y: 0, width: 70, height: 50)
        imageView.loadGif(name: "loading")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.red
        
      
        
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        self.isOpaque = false
        
        self.addSubview(imageView)
        
        let centerX = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerX,centerY])
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70)
        
        imageView.addConstraints([heightConstraint, widthConstraint])
        
        self.centerBoxView.backgroundColor = UIColor.blue
    }
    
    func hideCustomLoader() {
        if let blurLoader = subviews.first(where: { $0 is CustomLoaderView }) {
            blurLoader.removeFromSuperview()
        }
        
        imageView.removeFromSuperview()
//        if let imageView = subviews.first(where: { $0 is UIImageView }) {
//            imageView.removeFromSuperview()
//        }
    }
}
