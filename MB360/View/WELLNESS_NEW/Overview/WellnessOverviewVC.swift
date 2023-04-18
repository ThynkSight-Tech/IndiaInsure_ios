//
//  WellnessOverviewVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 21/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import WebKit

class WellnessOverviewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var heightForWebView: NSLayoutConstraint!
    @IBOutlet weak var viewForWebView: UIView!
    @IBOutlet weak var backViewPackage: UIView?
    @IBOutlet weak var viewForPackage: UIView?

    @IBOutlet weak var circularView: UIView!

    @IBOutlet weak var btnClose: UIButton!
    var m_webView: WKWebView!
    var selectedNursingType : NursingType?
    
    
    var strhtml = ""
    var isOverview = true //send false from TermsOfUse
    var isPackagePrice = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Overview"
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
      
            lbNavTitle.text = "Overview"
        
        self.navigationItem.titleView = lbNavTitle
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

        btnClose.makeHHCCircularButton()

        m_webView = WKWebView()
        m_webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        m_webView.frame = CGRect(origin: CGPoint.zero, size: viewForWebView.frame.size)

        m_webView.uiDelegate = self as WKUIDelegate
        m_webView.navigationDelegate = self as WKNavigationDelegate
        
        viewForWebView.addSubview(m_webView)
       
        m_webView.translatesAutoresizingMaskIntoConstraints = false
        m_webView.clipsToBounds = false
        m_webView.backgroundColor = UIColor.clear
        m_webView.isUserInteractionEnabled = false
       // self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            // m_webView.sizeToFit()
        m_webView.scrollView.zoomScale = 2.0
        
        backViewPackage?.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            backViewPackage?.layer.borderColor = UIColor.separator.cgColor
        } else {
            // Fallback on earlier versions
            backViewPackage?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if isOverview { //Overview & PackagePrice
            if isPackagePrice {
                circularView.isHidden = true
                viewForWebView.isHidden = true
                viewForPackage?.isHidden = false
                backViewPackage?.isHidden = false
                
//                let serviceId = getServiceId()
//                //let url = APIEngine.shared.getHHCOverviewText(WellSrNo: serviceId)
//                    let url = "http://mybenefits360.in/images/app/packageRatesTrainedAttendants.txt"
//                    self.getDataFromServer(url: url, type: 2)
                   // self.title = "Package Rates"
                lbNavTitle.text = "Package Rates"
            }
            else {
                circularView.isHidden = false
                viewForWebView.isHidden = false
                viewForPackage?.isHidden = true
                backViewPackage?.isHidden = true
                
                let serviceId = getServiceId()
                let url = APIEngine.shared.getHHCOverviewText(WellSrNo: serviceId)
                self.getDataFromServer(url: url, type: 1)
            }
        }
        else {
            circularView.isHidden = false
            viewForWebView.isHidden = false
            viewForPackage?.isHidden = true
            backViewPackage?.isHidden = true
             
            m_webView.isUserInteractionEnabled = true
            if let url = Bundle.main.url(forResource: "source", withExtension: "htm"){
                let request = NSURLRequest(url: url)
                m_webView.load(request as URLRequest)
            }
        }
       // setHtmlPage()
        
        print("In \(navigationItem.title ?? "") WellnessOverviewVC")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden = true
    }
    @IBAction func closeTapped(_ sender: UIButton) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
//    private func setHtmlPage() {
//
//        switch selectedNursingType {
//        case .trainedAttendants:
//            self.setHtml(fileName: "ElderCare")
//
//        case .longTerm:
//            self.setHtml(fileName: "ElderCare")
//
//        case .shortTerm:
//            self.setHtml(fileName: "ElderCare")
//
//        case .doctorServices:
//            self.setHtml(fileName: "ElderCare")
//
//        case .physiotherapy:
//            self.setHtml(fileName: "ElderCare")
//
//        case .diabetesManagement:
//            self.setHtml(fileName: "Diabetes")
//
//        case .postNatelCare:
//            self.setHtml(fileName: "ElderCare")
//
//        case .elderCare:
//            self.setHtml(fileName: "ElderCare")
//        default:
//            break
//        }
//
//    }
    
    private func getServiceId() -> String {
        /*
         10                NURSING ATTENDANT=
         11                LONG TERM NURSING=
         12                SHORT TERM NURSING
         13                DOCTOR SERVICES
         14                PHYSIOTHERAPY
         15                DIABETESE MANAGEMENT
         16                ELDER CARE
         17                POST NATAL CARE
         */
        switch selectedNursingType {
        case .trainedAttendants:
            return "10"
            
        case .longTerm:
            return "11"
            
        case .shortTerm:
            return "12"
            
        case .doctorServices:
            return "13"
            
        case .physiotherapy:
            return "14"
            
        case .diabetesManagement:
            return "15"
            
        case .elderCare:
            return "17"
            
        case .postNatelCare:
            return "16"
            
        default:
            return ""
            break
        }
        
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }

    
        private func convertHtmlCss(htmlText:String) -> String {
           let cssText = "<head><style>.clearfix{font-size:22px!important}@font-face { font-family:MyFont; src:url(Poppins-Regular.ttf);} .main-container{ text-align: justify; font-size:22px; font-family:MyFont; color:#696969;} ul.pretests { padding-left: 0px; }ul li{ color:#696969; line-height: 1.5;font-size : 22px; font-family:MyFont; text-align: justify; margin: 0px 0px 10px; }.main-container .text-center {text-align: center;}.main-container ul.pretests { padding-left:20px; }span.clearfix { color:#696969; font-size:16px; font-size:16px; font-family:MyFont;}.h1 {font-size: 22px;}.main-container h2.sbold {font-size: larger;}.sbold { font-weight: 400!important; }.main-container h2,.text-primary,.text-info { color: #0096d6; }.h1, .h2, .h3, h1, h2, h3 {margin-top: 20px;margin-bottom: 10px; } </style></head>";

            
            print(htmlText)
        //let cssText = "<head><style>@font-face { font-family: 'Poppins-Regular'; src:url(Poppins-Regular.ttf);} .main-container { text-align: justify; font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);color:#696969;}ul.pretests { padding-left: 0px; }ul.pretests li{ color:#696969; line-height: 1;font-size : 13px;font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf); text-align: justify; margin: 0 10px 10px; }.main-container .text-center {text-align: center;}.main-container ul { padding-left:20px; }span.clearfix { color:#696969; font-size:13px; font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);}.h1 {font-size: 24px;}.main-container h2.sbold {font-size: larger;}.sbold { font-weight: 400!important; }.main-container h2,.text-primary,.text-info { color: #0096d6; }.h1, .h2, .h3, h1, h2, h3 {margin-top: 20px;margin-bottom: 10px; }</style></head>"
            
            //let cssText = "<head><style>@font-face { font-family:MyFont; src:url(Poppins-Regular.ttf);} .main-container { text-align: justify; font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);color:#696969;}ul.pretests { padding-left: 0px; }ul.pretests li{ color:#696969; line-height: 1;font-size : 13px;font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf); text-align: justify; margin: 0 10px 10px; }.main-container .text-center {text-align: center;}.main-container ul { padding-left:20px; }span.clearfix { color:#696969; font-size:13px; font-family: 'Poppins-Regular'}.h1 {font-size: 24px;}.main-container h2.sbold {font-size: larger;}.sbold { font-weight: 400!important; }.main-container h2,.text-primary,.text-info { color: #0096d6; }.h1, .h2, .h3, h1, h2, h3 {margin-top: 20px;margin-bottom: 10px; }</style></head>"
            

            let finalString = String(format: "%@%@", htmlText,cssText)
            
            print("Converted Text =\(finalString) ")
            return finalString
    }

//    func setHtml(fileName:String) {
//
//                if let url = Bundle.main.url(forResource: fileName, withExtension: "html")
//                {
//                    let request = NSURLRequest(url: url)
//                    m_webView.load(request as URLRequest)
//                }
//               // self.webView.loadHTMLString(aktivoScore, baseURL: nil)
//
//        }
    
    private func getDataFromServer(url:String,type:Int) {
        if type == 1 {
            print(url)
            ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
                
                if let resDictArray = response?["Overview"].array
                {
                    if resDictArray.count > 0 {
                        let dict = resDictArray[0].dictionary
                        if let overviewStr = dict?["Overview"]?.string {
                            let bundlePath = Bundle.main.bundlePath
                            let bundleUrl = URL(fileURLWithPath: bundlePath)
                            
                           // let fontName =  "Poppins-Regular"
                           // let fontSize = 20
                            
                            //let fontSetting = "<span style=\"font-family: \(fontName);font-size: \(fontSize)\"</span>"
                            
                            self.m_webView.loadHTMLString(self.convertHtmlCss(htmlText:  overviewStr), baseURL: bundleUrl)
                            self.m_webView.scrollView.zoomScale = 2.0
                            self.m_webView.scrollView.setZoomScale(4.0, animated: true)
                            
                            // self.setHtml(fileName: "ElderCare")
                        }
                    }
                    
                }
            }
        }
        else if type == 2 {
            let url = URL(string:url)!
            let task = URLSession.shared.dataTask(with:url) { (data, response, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    if let textFile = String(data: data!, encoding: .utf8) {
                        print(textFile)
                        if textFile != "" {
                            DispatchQueue.main.async {
                                self.m_webView.loadHTMLString(self.convertHtmlCss(htmlText:  textFile), baseURL: nil)
                                self.m_webView.isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
extension WellnessOverviewVC {
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
//        self.m_webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
//            if complete != nil {
//
//                self.m_webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//                    self.heightForWebView.constant = height as! CGFloat
//                })
//            }
//
//            })
       // let textSize: Int = 300
       // m_webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
        
       
    }

    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}

