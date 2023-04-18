//
//  StatsFitnessTVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 10/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class StatsFitnessTVC: UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var topFitnessCollectionView: UICollectionView!
    
    
    var featureArray = ["AKTIVO SCORE®","STEPS TAKEN","HEART RATE","SLEEP"]
    var selectedFeatureIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.red
//
//        return headerView
//
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 70
//    }
    
    
    //MARK:- CollectionView Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featureArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForTopFeatureStatsCollectionView", for: indexPath) as! CellForTopFeatureStatsCollectionView
        cell.lblName.text = featureArray[indexPath.row]
        
        if selectedFeatureIndex == indexPath.row {
            cell.backView.backgroundColor = UIColor.black
            cell.lblName.textColor = UIColor.white
        }
        else {
            cell.backView.backgroundColor = UIColor.white
            cell.lblName.textColor = UIColor.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedFeatureIndex = indexPath.row
        self.topFitnessCollectionView.reloadData()
    }
    
    
  
}

class CellForTopFeatureStatsCollectionView: UICollectionViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.layer.cornerRadius = self.backView.frame.height / 2
        
    }
}
