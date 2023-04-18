//
//  DoctorConsultationVC.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 06/01/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import Foundation
import UIKit

class DoctorConsultationVC: UIViewController,UIScrollViewDelegate{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    //Consult View
    @IBOutlet weak var consultView: UIView!
    @IBOutlet weak var headerLbl1: UILabel!
    @IBOutlet weak var valueLbl1: UILabel!
    
    //Feature View
    @IBOutlet weak var featureView: UIView!
    @IBOutlet weak var headerLbl2: UILabel!
    
    @IBOutlet weak var featureImg1: UIImageView!
    @IBOutlet weak var featureImg2: UIImageView!
    @IBOutlet weak var featureImg3: UIImageView!
    @IBOutlet weak var featureImg4: UIImageView!
    @IBOutlet weak var featureImg5: UIImageView!
    @IBOutlet weak var featureImg6: UIImageView!
    
    @IBOutlet weak var featureValueLbl1: UILabel!
    @IBOutlet weak var featureValueLbl2: UILabel!
    @IBOutlet weak var featureValueLbl3: UILabel!
    @IBOutlet weak var featureValueLbl4: UILabel!
    @IBOutlet weak var featureValueLbl5: UILabel!
    @IBOutlet weak var featureValueLbl6: UILabel!
    
    //Categories View
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var headerLbl3: UILabel!
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var explorePackageBtn: UIButton!
    
    let categoriesName : [String] = ["General Physician","Child Specialist","Gynaecologist","Dermatologist","Diabetologist","Sexologist","Dietician","Emotional Wellbeing","Homeopathy","Gastroenterologist","Critical Care","Autism Therapy","Allergy & Asthma","Child Allergy","Blood Disorders","Cardiologist","Physiotherapy","Orthopaedics","Oncologist","Urologist","Dentist","Ayurvedic"]
    
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true
        tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        //To set Nav bar color
        navigationController?.view.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)
        
        self.setupFontsUI()
        contentView.layer.cornerRadius = cornerRadiusForView//8
        scrollView.delegate = self
        contentView.ShadowForView()
        explorePackageBtn.layer.cornerRadius = cornerRadiusForView//8
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
                scrollView.contentOffset.x = 0
            }
    }
    
    func setupFontsUI(){
        
        headerLbl1.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h15))
        headerLbl1.textColor = FontsConstant.shared.app_BlueColor
        
        valueLbl1.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h13))
        valueLbl1.textColor = FontsConstant.shared.app_mediumGrayColor
        
        headerLbl2.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h15))
        headerLbl2.textColor = FontsConstant.shared.app_BlueColor
      
        featureValueLbl1.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h13))
        featureValueLbl1.textColor = FontsConstant.shared.app_mediumGrayColor
        
        featureValueLbl2.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h13))
        featureValueLbl2.textColor = FontsConstant.shared.app_mediumGrayColor
        
        featureValueLbl3.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h13))
        featureValueLbl3.textColor = FontsConstant.shared.app_mediumGrayColor
        
        featureValueLbl4.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h13))
        featureValueLbl4.textColor = FontsConstant.shared.app_mediumGrayColor
        
        featureValueLbl5.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h13))
        featureValueLbl5.textColor = FontsConstant.shared.app_mediumGrayColor
        
        featureValueLbl6.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h13))
        featureValueLbl6.textColor = FontsConstant.shared.app_mediumGrayColor
        
        headerLbl3.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h15))
        headerLbl3.textColor = FontsConstant.shared.app_BlueColor
      
        setupNavBarDetails()
      
    }
    
    func setupNavBarDetails()
    {
        menuButton.isHidden = true
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        //cartBottomView.backgroundColor = Color.bottomColor.value
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        
        lbNavTitle.text = "Online doctor consultation"
        self.navigationItem.titleView = lbNavTitle
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        //self.navigationItem.title = "Online doctor consultation"
        //self.navigationController?.navigationBar.changeFont()
    }
    
    
    @objc func backTapped() {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func explorePackageClicked(_ sender: Any) {
        let explorePackagesVC = UIStoryboard.init(name: "Wellness_New", bundle: nil).instantiateViewController(withIdentifier:"ExplorePackagesVC") as! ExplorePackagesVC

        self.navigationController?.pushViewController(explorePackagesVC, animated: true)
        
    }
    
    
}

extension DoctorConsultationVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("categoriesName.count",categoriesName.count)
        return categoriesName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! DoctorConsultationCollectionViewCell
        
        cell.bgView.layer.cornerRadius = 25
        cell.bgView.layer.borderColor = UIColor.black.cgColor
        cell.bgView.dropShadow()
        cell.contentLbl.text = categoriesName[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2   //number of column you want
           let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
           let totalSpace = flowLayout.sectionInset.left
               + flowLayout.sectionInset.right
               + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

           let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
           return CGSize(width: size, height: 60
           )
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
