//
//  DentalPackagesNewViewController.swift
//  MyBenefits360
//
//  Created by ThynkSight on 01/02/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit
import SVGKit

class DentalPackagesNewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var tblVew: UITableView!
    
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var vew: UIView!
    var arrListName = ["CLEANING AND POLISHING WITH DENTAL CHECKUP","CLEANING AND FILLING WITH DENTAL CHECKUP","CLEANING AND WHITENING WITH DENTAL CHECKUP","ROOT CANAL AND CROWN WITH DENTAL CHECKUP","WISDOM TOOTH EXTRACTION","DENTAL IMPLANT WITH CERAMIC CROWN(KOREAN)","DENTAL IMPLANT WITH CERAMIC CROWN(SWISS)","DENTAL IMPLANT WITH CERAMIC CROWN(GERMAN)","SMILE DESIGNING","SINGLE ARCH REHAB","DOUBLE ARCH REHAB"]
    
    var arrImages = ["https://wellness.mybenefits360.com/images/dentalPackages/cleaning.svg","https://wellness.mybenefits360.com/images/dentalPackages/cavityfilling.svg","https://wellness.mybenefits360.com/images/dentalPackages/teethwhitening.svg","https://wellness.mybenefits360.com/images/dentalPackages/rootcanal.svg","https://wellness.mybenefits360.com/images/dentalPackages/toothextraction.svg","https://wellness.mybenefits360.com/images/dentalPackages/korean.svg","https://wellness.mybenefits360.com/images/dentalPackages/swiss.svg","https://wellness.mybenefits360.com/images/dentalPackages/german.svg","https://wellness.mybenefits360.com/images/dentalPackages/smiledesign.svg","https://wellness.mybenefits360.com/images/dentalPackages/singlearch.svg","https://wellness.mybenefits360.com/images/dentalPackages/doublearch.svg"]
    
    var arrPrice = ["499","1999","3,999","4,999","4,499","17,999","27,999","37,999","76,999","1,09,999","2,09,999"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVew.reloadData()
        // Do any additional setup after loading the view.
        
        //To set Nav bar color
        navigationController?.view.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

        
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        lbNavTitle.text = "Select package"
        self.navigationItem.titleView = lbNavTitle
        vew.layer.borderWidth = 0.5
        vew.layer.borderColor = UIColor.green.cgColor
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DentalPackagesNewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DentalPackagesNewTableViewCell", for: indexPath) as! DentalPackagesNewTableViewCell
        cell.lblName.text = arrListName[indexPath.row]
        let price = arrPrice[indexPath.row]
        cell.lblPrice.text = "Starting from \(price)"
        let url = arrImages[indexPath.row]
        let svg = URL(string: url)!
        let data = try? Data(contentsOf: svg)
        let receivedimage: SVGKImage = SVGKImage(data: data)
        cell.img.image = receivedimage.uiImage
        cell.btnViewDetails.layer.borderColor = UIColor(hexString: "#e5e5e5").cgColor//UIColor.gray.cgColor
        cell.btnViewDetails.layer.borderWidth = 1.0
        cell.btnPackageIncludes.layer.borderColor = UIColor(hexString: "#e5e5e5").cgColor//UIColor.gray.cgColor
        cell.btnPackageIncludes.layer.borderWidth = 1.0
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


class DentalPackagesNewTableViewCell : UITableViewCell{
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var btnPackageIncludes: UIButton!
    
    @IBOutlet weak var btnViewDetails: UIButton!
    
    @IBOutlet weak var VewMain: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBottomShadow(view: VewMain)
        VewMain.layer.borderWidth = 0.5
        VewMain.layer.borderColor = UIColor.gray.cgColor
    }
    
    
    func setBottomShadow(view:UIView)
    {
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
    
  
}
