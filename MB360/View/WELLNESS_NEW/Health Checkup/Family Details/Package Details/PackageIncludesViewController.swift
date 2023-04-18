//
//  PackageIncludesViewController.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 31/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import SkeletonView


struct PackageModel {
    var Name: String?
    var Detail: String?
    var expanded : Bool
}

class PackageCell: UITableViewCell {
    
    @IBOutlet weak var m_answerLbl: UILabel!
    @IBOutlet weak var m_expandButton: UIButton!
    @IBOutlet weak var m_questionLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

class PackageIncludesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.estimatedRowHeight = 130.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var backgroundBorderView: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblPackageTitle: UILabel!

    var packageSrNo = ""
    var packageName = ""
    var packageValue = ""
    var packageArray = [PackageModel]()
    var selectedRowIndex = -1
    var isLoaded = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        self.title = "Package Includes"
        print("In PackageIncludesViewController")
        self.lblHeaderTitle.text = packageName
        self.lblPackageTitle.text = "Package Price: \(packageValue)"
        self.lblPackageTitle.isHidden = true
        
        tableView.isSkeletonable = true
        let nibName = UINib(nibName: "shimeerDefaultCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "shimeerDefaultCell")

    
    
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
self.navigationController?.navigationBar.backgroundColor = UIColor.white
        //Add Bar Button
        let btn =  UIBarButtonItem(image:UIImage(named: "close1") , style: .plain, target: self, action: #selector(backTapped))
        btn.tintColor =  #colorLiteral(red: 0.5843137255, green: 0.5803921569, blue: 0.5803921569, alpha: 1)
        navigationItem.leftBarButtonItem = btn
        
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
    //nav?.tintColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5843137255, green: 0.5803921569, blue: 0.5803921569, alpha: 1)]
        
        
        //Add corner radius to view
        self.backgroundBorderView.layer.cornerRadius = 10.0
        self.backgroundBorderView.clipsToBounds = true

    
//        let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
//        if statusBar?.responds(to: #selector(setter: UIView.backgroundColor)) ?? false {
//            statusBar?.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
//        }
        
        
        //getPackageDetailsFromServer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VDA..")
        
        self.tableView.showShimmer()
        getPackageDetailsFromServer()

    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Table View Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageCell") as! PackageCell
        
        let data = packageArray[indexPath.row]
        cell.m_questionLbl.text = data.Name
        
        if selectedRowIndex == indexPath.row
        {
            let info = data.Detail
            cell.m_answerLbl.text = info
            cell.m_expandButton.setImage(UIImage(named: "minus"), for: .normal)
        }
        else
        {
            cell.m_expandButton.setImage(UIImage(named: "plus"), for: .normal)
            cell.self.m_answerLbl.text = ""
        }
        
        cell.m_expandButton.tag = indexPath.row
        cell.m_expandButton.addTarget(self, action: #selector(expandButtonClicked), for: .touchUpInside)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isLoaded == 0 {
        return 120
        }
        else {
        
        if indexPath.row == selectedRowIndex
        {
            return UITableViewAutomaticDimension
        }
        else {
            return UITableViewAutomaticDimension
        }
        }
    }
    
    @objc func expandButtonClicked(sender:UIButton)
    {

        let indexPath = IndexPath(row:sender.tag, section:0)
        tableView(tableView, didSelectRowAt: indexPath)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Did select Tapped...")

        if indexPath.row == selectedRowIndex {
            self.selectedRowIndex = -1
            self.tableView.reloadData()
        }
        else {
            self.selectedRowIndex = indexPath.row
            self.tableView.reloadData()

        }
    }
    
    //MARK:- Get Data from Server
    private func getPackageDetailsFromServer() {
        let url = APIEngine.shared.getPackageDetailsURL(packageSrNo: self.packageSrNo)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        if let packageDicArray = response?["SpecificationList"].arrayValue {
                            self.packageArray.removeAll()
                            
                            for package in packageDicArray {
                                let obj = PackageModel.init(Name: package["Name"].stringValue, Detail: package["Detail"].stringValue, expanded: false)
                                self.packageArray.append(obj)
                            }
                            
                            self.isLoaded = 1
                            self.tableView.hideShimmer()
                            self.tableView.reloadData()
                        }
                    }
                    else {
                        //package record not found
                    }
                }
            }//msgDic
        }
    }
}

extension PackageIncludesViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        // return "CellForFamilyDetailsCell1"
        return "shimeerDefaultCell"
        
}
}

