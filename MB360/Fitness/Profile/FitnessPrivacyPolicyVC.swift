//
//  FitnessPrivacyPolicyVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 07/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import WebKit

class FitnessPrivacyPolicyVC: UIViewController , WKUIDelegate, WKNavigationDelegate {
    
     var webView: WKWebView!
     var titleString = ""
     var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBtn()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])
        navigationController?.navigationBar.dropShadow()

        
        self.showPleaseWait(msg: "")
        
        let webconfig = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), configuration: webconfig)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if titleString == "Privacy Policy" {
            self.navigationItem.title="Privacy Policy"
            self.urlString = "https://www.aktivolabs.com/privacy-policy"
        }
        else { //Help
            self.navigationItem.title = "Help"
            self.urlString = "https://www.aktivolabs.com/faq"
        }
        
        let request = URLRequest(url: URL(string: urlString)!)
                self.webView.load(request)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }
   
    func webViewDidFinishLoad(webView : UIWebView) {
        print("finish")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!)
    {
        print("---Hitted URL--->") // here you are getting URL
        self.view = self.webView
        self.hidePleaseWait()

        
    }
   
    func getBtn() -> UIBarButtonItem {
    let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backClicked))
    
    return button1
}
    
@objc func backClicked()
{
    print ("backButtonClicked")
    self.dismiss(animated: true, completion: nil)
    //navigationController?.popViewController(animated: true)
}

    
}




