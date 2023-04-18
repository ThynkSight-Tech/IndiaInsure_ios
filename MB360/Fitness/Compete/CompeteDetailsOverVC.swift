//
//  CompeteDetailsOverVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 14/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CompeteDetailsOverVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selfRank: UILabel!
    @IBOutlet weak var selfScore: UILabel!
    @IBOutlet weak var selfImpact: UILabel!
    @IBOutlet weak var selfName: UILabel!
    
    var challengesModelObj = ChallengesScoreModel()
    var userIdToken = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details"

        self.navigationController?.navigationBar.hideBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])
        
        //hide back button
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn


        if challengesModelObj.challenge_type?.lowercased() == "team" {
            setfirstRankDetails()
        }
        else {
        
        if let userId = UserDefaults.standard.value(forKey: "userAktivoId") as? String {
            userIdToken = userId
            let userObj = challengesModelObj.leaderboardModelArray.filter{($0._id == userId)}
            
            if userObj.count > 0 {
                selfScore.text = userObj[0].score?.description
                //selfRank.text = userObj[0].rank?.description
                selfName.text = userObj[0].name?.description
                
                
                //Rank Start
                if let rankInt = userObj[0].rank {
                    if rankInt <= 9 {
                        selfRank.text = String(format: "0%@", userObj[0].rank.description)
                    }
                    else {
                        selfRank.text = String(format: "%@", userObj[0].rank.description)
                    }
                }
                else {
                    selfRank.text = String(format: "%@", userObj[0].rank.description)
                }

                //Rank End
                
                //Impact
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
                selfImpact.text = ""
                
            }
        }
        }

    }
    
    func setfirstRankDetails() {
        let userObj = challengesModelObj.leaderboardModelArray.filter{($0.rank == 1)}
        
        if userObj.count > 0 {
            selfScore.text = (userObj[0].score?.description) ?? ""
            selfRank.text = (userObj[0].rank?.description) ?? ""
            selfName.text = (userObj[0].name?.description) ?? ""
            
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
            cell.lblCount.text = String(challengesModelObj.leaderboardModelArray.count)
            //cell.lblDate.text = String(format: "%@ - %@", challengesModelObj.start_date ?? "",challengesModelObj.end_date ?? "")
            cell.lblDate.text = String(format: "%@ - %@", challengesModelObj.start_date?.getDateYMD().getMMMddYYYYDateFC() ?? "",challengesModelObj.end_date?.getDateYMD().getMMMddYYYYDateFC() ?? "")

            
            cell.lblIsIndividual.text = challengesModelObj.description
            
            

//            if challengesModelObj.imageUrl != nil && challengesModelObj.imageUrl != "" {
//                cell.imgView.sd_setImage(with: URL(string: challengesModelObj.imageUrl ?? ""), placeholderImage: UIImage(named: ""))
//            }
//            else {
//                cell.imgView.image = UIImage(named: "")
//            }
            
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCompeteNameView", for: indexPath) as! CellForCompeteNameView
            
           let obj = self.challengesModelObj.leaderboardModelArray[indexPath.row]
                //cell.lblRank.text = String(format: "%@",String(self.challengesModelObj.leaderboardModelArray[indexPath.row].rank))
            
            if let rankInt = self.challengesModelObj.leaderboardModelArray[indexPath.row].rank {
                if rankInt <= 9 {
                    cell.lblRank.text = String(format: "0%@", self.challengesModelObj.leaderboardModelArray[indexPath.row].rank.description)
                }
                else {
                    cell.lblRank.text = String(format: "%@", self.challengesModelObj.leaderboardModelArray[indexPath.row].rank.description)
                    
                }
            }
            else {
                cell.lblRank.text = String(format: "%@", self.challengesModelObj.leaderboardModelArray[indexPath.row].rank.description)
            }
            
                cell.lblName.text = obj.name
            if obj.score != nil {
                cell.lblScore.text = String(obj.score?.description ?? "-")
            }
            else {
                cell.lblScore.text = "-"
            }
            if indexPath.row % 2 == 0 {
                cell.lblUporDown.text = "▲"
            }
            else {
                cell.lblUporDown.text = "▼"

            }
            
            //set rank1 image
            if self.challengesModelObj.leaderboardModelArray[indexPath.row].rank == 1 {
                cell.imgViewRank1.isHidden = false
                cell.lblRank.isHidden = true
            }
            else {
                cell.imgViewRank1.isHidden = true
                cell.lblRank.isHidden = false
                
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
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "   Leaderboard"
            //            label.font = UIFont().futuraPTMediumFont(16) // my custom font
            // label.textColor = UIColor.charcolBlackColour() // my custom colour
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
    
}

extension CompeteDetailsOverVC {
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if (cell.responds(to: #selector(getter: UIView.tintColor))){
            if tableView == self.tableView {
                let cornerRadius: CGFloat = 12.0
                cell.backgroundColor = .clear
                let layer: CAShapeLayer = CAShapeLayer()
                let path: CGMutablePath = CGMutablePath()
                let bounds: CGRect = cell.bounds
                bounds.insetBy(dx: 25.0, dy: 0.0)
                var addLine: Bool = false

                if indexPath.row == 0 && indexPath.row == ( tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)

                } else if indexPath.row == 0 {
                    path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))

                } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))

                } else {
                    path.addRect(bounds)
                    addLine = true
                }

                layer.path = path
                layer.fillColor = UIColor.white.withAlphaComponent(0.8).cgColor

                if addLine {
                    let lineLayer: CALayer = CALayer()
                    let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
                    lineLayer.frame = CGRect(x: bounds.minX + 10.0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
                    lineLayer.backgroundColor = tableView.separatorColor?.cgColor
                    layer.addSublayer(lineLayer)
                }

                let testView: UIView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, at: 0)
                testView.backgroundColor = .clear
                cell.backgroundView = testView
            }
        }
    }

}
