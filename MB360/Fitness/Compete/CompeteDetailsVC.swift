//
//  CompeteDetailsVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 13/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class CompeteDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selfRank: UILabel!
    @IBOutlet weak var selfScore: UILabel!
    @IBOutlet weak var selfImpact: UILabel!
    @IBOutlet weak var selfName: UILabel!
    
    
    var challengesModelObj = ChallengesScoreModel()

    var userIdToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideMenuController()?.removeRightGestures()

        //self.navigationController?.navigationBar.hideBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationItem.title = "Details"
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])
        
        
        if challengesModelObj.challenge_type?.lowercased() == "team" {
            setfirstRankDetails()
        }
        else {
            
        if let userId = UserDefaults.standard.value(forKey: "userAktivoId") as? String {
            userIdToken = userId
        let userObj = challengesModelObj.leaderboardModelArray.filter{($0._id == userId)}
        
            if userObj.count > 0 {
                
                if let rankInt = userObj[0].rank as? Int {
                    if rankInt <= 9 {
                        self.selfRank.text = String(format: "0%@", rankInt.description)
                    }
                    else {
                        selfRank.text = String(format: "%@", rankInt.description)
                    }
                }
                else {
                    
                }
                
            selfName.text = userObj[0].name?.description
                selfScore.text = userObj[0].score?.description

                if let impact = userObj[0].impact {
                    if impact > 0 {
                        selfImpact.text = "▲"
                    }
                    else if impact < 0 {
                        selfImpact.text = "▼"
                    }
                    else {
                        selfImpact.text = "-"
                    }
                }
                else {
                    selfImpact.text = "-"
                    
                }

                
            }
            else {
                selfScore.text =  ""
                selfRank.text = ""
                selfName.text = ""
                selfImpact.text = "-"

            }
            }
        }
        
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- TableViewDelegate & Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return challengesModelObj.leaderboardModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCompeteDetailsTopView", for: indexPath) as! CellForCompeteDetailsTopView
            
            cell.lblBoldLabel.text = challengesModelObj.title
            cell.lblCount.text = String(challengesModelObj.numberOfParticipants ?? 0)
            
            cell.lblDate.text = String(format: "%@ - %@", challengesModelObj.start_date?.getDateYMD().getMMMddYYYYDateFC() ?? "",challengesModelObj.end_date?.getDateYMD().getMMMddYYYYDateFC() ?? "")

            
            cell.lblIsIndividual.text = challengesModelObj.description
            
            if challengesModelObj.imageUrl != nil && challengesModelObj.imageUrl != "" {
                cell.imgView.sd_setImage(with: URL(string: challengesModelObj.imageUrl ?? ""), placeholderImage: UIImage(named: "placeholderAktivo"))
                cell.imgHeight.constant = 240
            }
            else {
                cell.imgView.image = UIImage()
                cell.imgHeight.constant = 0
            }

        return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCompeteNameView", for: indexPath) as! CellForCompeteNameView
            
            let nameModelArray = challengesModelObj.leaderboardModelArray
            
            if let rankInt = nameModelArray[indexPath.row].rank as? Int {
                if rankInt <= 9 {
                    cell.lblRank.text = String(format: "0%@", nameModelArray[indexPath.row].rank.description)
                }
                else {
                    cell.lblRank.text = String(format: "%@", nameModelArray[indexPath.row].rank.description)

                }
            }
            else {
                cell.lblRank.text = String(format: "%@", nameModelArray[indexPath.row].rank.description)
            }
            cell.lblName.text = nameModelArray[indexPath.row].name

            if nameModelArray[indexPath.row].score != nil {
                cell.lblScore.text = nameModelArray[indexPath.row].score?.description
            }
            else {
                cell.lblScore.text = "-"
            }
            
            //set rank1 image
            if nameModelArray[indexPath.row].rank == 1 {
            cell.imgViewRank1.isHidden = false
                cell.lblRank.isHidden = true
            }
            else {
                cell.imgViewRank1.isHidden = true
                cell.lblRank.isHidden = false

            }
            
            
            if let impact = nameModelArray[indexPath.row].impact {
                if impact > 0 {
                    cell.lblUporDown.text = "▲"
                }
                else if impact < 0 {
                    cell.lblUporDown.text = "▼"
                }
                else {
                    cell.lblUporDown.text = "-"
                }
            }
            else {
                cell.lblUporDown.text = "-"

            }
            
            if userIdToken == nameModelArray[indexPath.row]._id {
                cell.lblName.font = UIFont(name:"Poppins-SemiBold", size: 12.0)
                cell.lblRank.font = UIFont(name:"Poppins-SemiBold", size: 12.0)
                cell.lblScore.font = UIFont(name:"Poppins-SemiBold", size: 12.0)
            }
            else {
                cell.lblName.font = UIFont(name:"Poppins-Regular", size: 12.0)
                cell.lblRank.font = UIFont(name:"Poppins-Regular", size: 12.0)
                cell.lblScore.font = UIFont(name:"Poppins-Regular", size: 12.0)
            }
            

            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 35))
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 3, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "   Leaderboard"

            label.font = UIFont(name: "Poppins-Medium",
                                size: 16.0)

            headerView.backgroundColor = UIColor.white

            headerView.addSubview(label)
            return headerView
            
        }
        else {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
            return headerView
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 35
    }
    
    func setfirstRankDetails() {
        let userObj = challengesModelObj.leaderboardModelArray.filter{($0.rank == 1)}
        
        if userObj.count > 0 {
            selfScore.text = userObj[0].score?.description
            selfRank.text = userObj[0].rank?.description
            selfName.text = userObj[0].name?.description
            
            if let impact = userObj[0].impact {
                if impact > 0 {
                    selfImpact.text = "▲"
                }
                else if impact < 0 {
                    selfImpact.text = "▼"
                }
                else {
                    selfImpact.text = "-"
                }
            }
            else {
                selfImpact.text = "-"
                
            }
            
            
        }
        else {
            selfScore.text =  ""
            selfRank.text = ""
            selfName.text = ""
            selfImpact.text = "-"
            
        }
    }

}

class CellForCompeteDetailsTopView: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblIsIndividual: UILabel!
    @IBOutlet weak var lblBoldLabel: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblEnrolledStatus: UILabel!
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var backview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // setBottomShadow(view: backview)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setBottomShadow(view:UIView)
    {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = 4
    }
    
}


class CellForCompeteNameView: UITableViewCell {
    
    
    // @IBOutlet weak var imgView: UIImageView!
    // @IBOutlet weak var lblIsIndividual: UILabel!
    //@IBOutlet weak var lblBoldLabel: UILabel!
    // @IBOutlet weak var lblDate: UILabel!
    // @IBOutlet weak var lblCount: UILabel!
    //@IBOutlet weak var lblEnrolledStatus: UILabel!
    
    //@IBOutlet weak var backview: UIView!
    
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblUporDown: UILabel!
    
    @IBOutlet weak var imgViewRank1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // setBottomShadow(view: backview)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setBottomShadow(view:UIView)
    {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = 4
    }
    
}
