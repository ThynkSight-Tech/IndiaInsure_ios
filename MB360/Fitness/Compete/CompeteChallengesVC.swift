//
//  CompeteChallengesVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 09/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import SDWebImage

class CompeteChallengesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var btnOver: UIButton!
    @IBOutlet weak var btnOngoing: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var flag = 0
    var challengesModelArray = [ChallengesScoreModel]()
    var overChallengesModelArray = [ChallengesScoreModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFitnessBackground()
        //self.slideMenuController()?.removeRightGestures()

        self.navigationItem.title = "Aktivo Compete"
        self.navigationController?.navigationBar.changeFont()
        self.navigationController?.navigationBar.applyFitnessGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        
        //hide back button
        self.navigationController?.navigationBar.hideBackButton()
        self.navigationController?.navigationBar.backItem?.title = ""
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])
        
        

        btnOver.layer.cornerRadius = btnOver.frame.height / 2
        btnOngoing.layer.cornerRadius = btnOver.frame.height / 2
        
        setBlackButton(btn: btnOngoing)
        setWhiteButton(btn: btnOver)
        
        //if let emailID = UserDefaults.standard.value(forKey: "emailid") as? String {
           self.getChallengesDataFromServer()
        //}
       
        
        let rightBar = UIBarButtonItem(image: UIImage(named: "menu-1"), style: .done, target: self, action: #selector(menuTapped))
        self.navigationItem.rightBarButtonItem = rightBar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.getChallengesDataFromServer()
    }
    
    @objc private func menuTapped() {
        self.slideMenuController()?.openRight()
    }
    
    private func getChallengesDataFromServer() {
        print("----Get User ID API")
        let dateStrStart = String(format: "01-01-\(String(Date().year - 1))")
        let dateStrStartDate = dateStrStart.getDate()
        
        let dateStrEnd = String(format: "31-12-\(String(Date().year))")
        let dateStrEndDate = dateStrEnd.getDate()
        
        let startDate = dateStrStartDate.getSimpleDate()
        let endDate = dateStrEndDate.getSimpleDate()
        
        let memberId = UserDefaults.standard.value(forKey: "MEMBER_ID") as! String

        
       // let strURL = String(format: "https://api.aktivolabs.com/api/users?email=%@&include=leaderboards&startDate=%@&endDate=%@",email,startDate,endDate)
        
        let strURL = String(format: "https://api.aktivolabs.com/api/users/%@?include=leaderboards&startDate=%@&endDate=%@",memberId,startDate,endDate)
//https://api.aktivolabs.com/api/users/5fb3c5ee0f0fee0013c6a34b?include=leaderboards&startDate=2020-01-01&endDate=2020-12-31
        
        let url = strURL
        print(url)
        
        let token = UserDefaults.standard.value(forKey: "tokenAktivo") as! String
        let tokenType = UserDefaults.standard.value(forKey: "tokenType") as! String
        
        let tokenStr = String(format: "%@ %@",tokenType,token)
        print(tokenStr)
        ServerRequestManager.serverInstance.getDataToServerWithHeaderLoader(url: url, view: self,token: tokenStr, onComplition: { (response, error, rawData) in
            self.hidePleaseWait()
            print(response)
            
//            if let dataDict = response?["data"].dictionary {
//
//                if let id = dataDict["_id"]?.string {
//                   // UserDefaults.standard.setValue(id, forKey: "userAktivoId")
//
//                   // self.authenticUser()
//                }
//            }
            
            self.overChallengesModelArray.removeAll()
            self.challengesModelArray.removeAll()
            
              if let embedded = response?["_embedded"].dictionaryValue {
                if let leaderboardsArray = embedded["leaderboards"]?.arrayValue {
                    
                    if leaderboardsArray.count > 0 {
                        
                        for outerObj in leaderboardsArray {
                          //  if outerObj["category_name"] == "Aktivo Score Challange" && outerObj["challenge_type"] == "Individual" {
                            
                            var nameModelArray = [LeaderboardModel]()
                            
                                if let nameDictArray = outerObj["leaderboard"].array
                                {
                                    for nameObj in nameDictArray {
                                        //print(nameObj["name"].string)
                                        let obj = LeaderboardModel.init(name: nameObj["name"].string, _id: nameObj["_id"].string, score: nameObj["score"].int, rank: nameObj["rank"].intValue, impact: nameObj["impact"].int)
                                        
                                        print(nameObj["name"].string)
                                        nameModelArray.append(obj)
                                        
                                    }
                                }
                            
                            let challengeObj = ChallengesScoreModel.init(_id: outerObj["_id"].string ?? "", title: outerObj["title"].string  ?? "", days: outerObj["days"].string  ?? "", challenge_type: outerObj["challenge_type"].string  ?? "", description: outerObj["description"].string  ?? "", scored_by: outerObj["scored_by"].string  ?? "", category_name: outerObj["category_name"].string  ?? "", target: outerObj["target"].string  ?? "", imageUrl: outerObj["imageUrl"].string  ?? "",  start_date: outerObj["start_date"].string  ?? "", end_date: outerObj["end_date"].string  ?? "", userPosition: outerObj["userPosition"].string  ?? "",numberOfParticipants: outerObj["numberOfParticipants"].int  ?? 0, leaderboardModelArray: nameModelArray)
                            
                            let endDate = challengeObj.end_date?.getDateYMD()
                            let todayDate = Date().getSimpleDate().getDateYMD()
                            if endDate ?? todayDate >= todayDate {
                                self.challengesModelArray.append(challengeObj)

                            }
                            else {
                                self.overChallengesModelArray.append(challengeObj)

                            }
                        
                            
                          //  }
                        } //for
                        
                        if self.flag == 0 && self.challengesModelArray.count == 0 {
                            self.tableView.setEmptyView(title: "Challenges not found", message: "")
                        }
                        else if self.flag == 1 && self.overChallengesModelArray.count == 0 {
                            self.tableView.setEmptyView(title: "Challenges not found", message: "")
                        }
                        else {
                            self.tableView.setEmptyView(title: "", message: "")
                            self.tableView.restore()
                        }
                        
                        self.tableView.reloadData()
                    }//.count
                }
            }
            
            if self.flag == 0 && self.challengesModelArray.count == 0 {
                self.tableView.setEmptyView(title: "Challenges not found", message: "")
            }
            else if self.flag == 1 && self.overChallengesModelArray.count == 0 {
                self.tableView.setEmptyView(title: "Challenges not found", message: "")
            }
            else {
                self.tableView.setEmptyView(title: "", message: "")
                self.tableView.restore()
            }
        })
        self.hidePleaseWait()

    }

    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag == 0 {
        return challengesModelArray.count
        }
        return overChallengesModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if flag == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForOngoingCompeteCell", for: indexPath) as! CellForOngoingCompeteCell
        
            
            let obj = self.challengesModelArray[indexPath.row]
            cell.lblBoldLabel.text = obj.title
            cell.lblCount.text = String(obj.leaderboardModelArray.count)
            //cell.lblDate.text = String(format: "%@ - %@", obj.start_date ?? "",obj.end_date ?? "")
            cell.lblDate.text = String(format: "%@ - %@", obj.start_date?.getDateYMD().getMMMddYYYYDateFC() ?? "",obj.end_date?.getDateYMD().getMMMddYYYYDateFC() ?? "")


            
            cell.lblIsIndividual.text = obj.challenge_type
            if obj.imageUrl != nil && obj.imageUrl != "" {
                cell.imgView.sd_setImage(with: URL(string: obj.imageUrl ?? ""), placeholderImage: UIImage(named: "placeholderAktivo"))
                cell.imageHeight.constant = 130
            }
            else {
                cell.imgView.image = UIImage()
                cell.imageHeight.constant = 0
            }
            
        return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForOverCompeteCell", for: indexPath) as! CellForOverCompeteCell
            let obj = self.overChallengesModelArray[indexPath.row]

            cell.lblBoldLabel.text = overChallengesModelArray[indexPath.row].title
            cell.lblIsIndividual.text = overChallengesModelArray[indexPath.row].challenge_type
        
            cell.lblDate.text = String(format: "%@ - %@", obj.start_date?.getDateYMD().getMMMddYYYYDateFC() ?? "",obj.end_date?.getDateYMD().getMMMddYYYYDateFC() ?? "")


            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if flag == 0 {
       // return 270
            return UITableViewAutomaticDimension
        }
        else {
            //return 110
            return UITableViewAutomaticDimension

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if flag == 0 {
        let competeView  = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"CompeteDetailsVC") as! CompeteDetailsVC
            competeView.challengesModelObj = challengesModelArray[indexPath.row]
        self.navigationController?.pushViewController(competeView, animated: true)
        }
        else {
            let competeView  = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"CompeteDetailsOverVC") as! CompeteDetailsOverVC
            competeView.challengesModelObj = overChallengesModelArray[indexPath.row]

            self.navigationController?.pushViewController(competeView, animated: true)
        }
    }
    
    

    

    //MARK:- Top Button Tap Event
    @IBAction func ongoingTapped(_ sender: Any) {
        setBlackButton(btn: btnOngoing)
        setWhiteButton(btn: btnOver)
        flag = 0
        self.tableView.reloadData()

        if challengesModelArray.count > 0 {
            self.tableView.restore()
        self.tableView.scrollToTop(animated: true)
        }
        else {
            self.tableView.setEmptyView(title: "Challenges not found", message: "")
        }
    }
    
    @IBAction func overTapped(_ sender: Any) {
        setBlackButton(btn: btnOver)
        setWhiteButton(btn: btnOngoing)
        flag = 1
        self.tableView.reloadData()

        if overChallengesModelArray.count > 0 {
            self.tableView.restore()
        self.tableView.scrollToTop(animated: true)
        }
        else {
            self.tableView.setEmptyView(title: "Challenges not found", message: "")
        }
    }
    
    private func setBlackButton(btn:UIButton) {
        btn.backgroundColor = UIColor.black
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
    }
    
    private func setWhiteButton(btn:UIButton) {
        btn.backgroundColor = UIColor.clear
        //btn.layer.borderWidth = 1.0
        //btn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
    }
    
}


//MAR:- Cell Classes
class CellForOngoingCompeteCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblIsIndividual: UILabel!
    @IBOutlet weak var lblBoldLabel: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblEnrolledStatus: UILabel!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var backview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBottomShadow(view: backview)
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

class CellForOverCompeteCell: UITableViewCell {
    
    @IBOutlet weak var lblIsIndividual: UILabel!
    @IBOutlet weak var lblBoldLabel: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var backview: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBottomShadow(view: backview)
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

