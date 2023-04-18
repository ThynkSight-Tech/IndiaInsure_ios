//
//  CellForDashboardRootCell.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 28/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit


protocol DashboardCollectionViewProtocol {
    func changeDashboardTapped(dashboard:Int)
}

//COLLECTION VIEW....
class CellForDashboardRootCell1: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
  
    
    @IBOutlet weak var backgroundView1: UIView!
    @IBOutlet weak var lblName: UILabel!

    var dashboarCollectionViewdDelegate : DashboardCollectionViewProtocol? = nil
    var servicesArray = ["Insurance"]

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellForWellness", for: indexPath) as! CollectionViewCellForWellness
//
//        if indexPath.row == 0 {
//            cell.lblname.text = "My Insurance"
//            cell.imgView.image = UIImage(named: "insuranceg")
//            cell.backgroundview.layer.cornerRadius = 6.0
//            cell.backgroundview.setGradientBackground1(colorTop: hexStringToUIColor(hex: "0171d5"), colorBottom:hexStringToUIColor(hex: "5eb1fd"))
//            cell.backgroundview.clipsToBounds = true
//        }
//        else if indexPath.row == 1 {
//            cell.lblname.text = "My Wellness"
//            cell.imgView.image = UIImage(named: "wellnessg")
//            cell.backgroundview.clipsToBounds = true
//            cell.backgroundview.layer.cornerRadius = 6.0
//            cell.backgroundview.setGradientBackground1(colorTop: Color.greenTop.value, colorBottom:Color.greenBottom.value)
//        }
//        else {
//            cell.lblname.text = "My Fitness"
//            cell.imgView.image = UIImage(named: "fitnessg")
//            cell.backgroundview.clipsToBounds = true
//
//            cell.backgroundview.layer.cornerRadius = 6.0
//            cell.backgroundview.setGradientBackground1(colorTop: Color.redBottom.value, colorBottom:Color.redTop.value)
//
//        }
//
//        return cell
//    }
    
        //MARK:- CollectionView Delegate
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.servicesArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellForWellness", for: indexPath) as! CollectionViewCellForWellness
            
            let serviceName = servicesArray[indexPath.row]
            
            switch serviceName {
            case "Insurance":
                cell.lblname.text = "My Insurance"
                cell.imgView.image = UIImage(named: "insuranceg")
                cell.backgroundview.layer.cornerRadius = 6.0
                //cell.backgroundview.setGradientBackground1(colorTop: hexStringToUIColor(hex: "0171d5"), colorBottom:hexStringToUIColor(hex: "5eb1fd"))
                cell.backgroundview.backgroundColor = hexStringToUIColor(hex: gradiantColor2)
                cell.backgroundview.clipsToBounds = true
                
            case "Wellness":
                cell.lblname.text = "My Wellness"
                cell.imgView.image = UIImage(named: "wellnessg")
                cell.backgroundview.clipsToBounds = true
                cell.backgroundview.layer.cornerRadius = 6.0
                cell.backgroundview.setGradientBackground1(colorTop: Color.greenTop.value, colorBottom:Color.greenBottom.value)
                
            case "Fitness":
                cell.lblname.text = "My Fitness"
                cell.imgView.image = UIImage(named: "fitnessg")
                cell.backgroundview.clipsToBounds = true
                cell.backgroundview.layer.cornerRadius = 6.0
                cell.backgroundview.setGradientBackground1(colorTop: Color.redBottom.value, colorBottom:Color.redTop.value)
                
            default:
                break
            }
            
            return cell
        }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            print("Insurance Tapped")
//        }
//        else if indexPath.row == 1 {
//            print("Wellness Tapped")
//
//        }
//        else {
//            print("Fitness Tapped")
//        }
        
        if servicesArray[indexPath.row] == "Insurance" {
            if dashboarCollectionViewdDelegate != nil {
                dashboarCollectionViewdDelegate?.changeDashboardTapped(dashboard: 0)
            }

        }
        else  if servicesArray[indexPath.row] == "Wellness" {
            if dashboarCollectionViewdDelegate != nil {
                dashboarCollectionViewdDelegate?.changeDashboardTapped(dashboard: 1)
            }

        }
        else {
            if dashboarCollectionViewdDelegate != nil {
                dashboarCollectionViewdDelegate?.changeDashboardTapped(dashboard: 2)
            }
        }
    
    }
    
    func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
    }
}






class CellForDashboardRootCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var backgroundBorderView: UIView!

    @IBOutlet weak var view_Insurance: UIView!
    @IBOutlet weak var view_Wellness: UIView!
    @IBOutlet weak var viewFitness: UIView!
    
    @IBOutlet weak var gradient_InsuranceView: UIView!
    @IBOutlet weak var gradient_WellnessView: UIView!
    @IBOutlet weak var gradient_FitnessView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.gradient_InsuranceView.setGradientBackground(colorTop: hexStringToUIColor(hex: "0171d5"), colorBottom:hexStringToUIColor(hex: "5eb1fd"))
        self.gradient_WellnessView.setGradientBackground(colorTop: hexStringToUIColor(hex: "3ed9b1"), colorBottom:hexStringToUIColor(hex: "40e0d0"))
        self.gradient_FitnessView.setGradientBackground(colorTop: hexStringToUIColor(hex: "ff8f26"), colorBottom: hexStringToUIColor(hex: "ffbb3d"))
       
        makeCircularView(viewImage: gradient_InsuranceView)
        makeCircularView(viewImage: gradient_WellnessView)
        makeCircularView(viewImage: gradient_FitnessView)
        
        backgroundBorderView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        backgroundBorderView.layer.cornerRadius = 10.0
        backgroundBorderView.layer.borderWidth = 0.5
        
    }
    
    func hideView(view:UIView) {
        view.isHidden = true
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
    }
    
    
    private func makeCircularView(viewImage:UIView) {
        
        viewImage.layer.cornerRadius = viewImage.frame.size.height / 2
        viewImage.layer.masksToBounds=true
       // viewImage.layer.borderColor = UIColor.white.cgColor
      //  viewImage.layer.borderWidth = 5.0
   
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
