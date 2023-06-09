//
//  FontsConstant.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 13/11/22.
//  Copyright © 2022 Semantic. All rights reserved.

//Font channges for Insurence

import Foundation

class FontsConstant: NSObject {
    
    static let shared = FontsConstant()
    
    //
    let OpenSansRegular = "OpenSans-Regular"
    let OpenSansMedium = "OpenSans-Medium"
    let OpenSansBold = "OpenSans-Bold"
    let OpenSansLight = "OpenSans-Light"
    let OpenSansSemiBold = "OpenSans-SemiBold"
    
    let regular = "Poppins-Regular"
    let medium = "Poppins-Medium"
    let bold = "Poppins-Bold"
    let light = "Poppins-Light"
    let semiBold = "Poppins-SemiBold"
    
    
    
    let headerSize30 = 30
    let contentSize25 = 25
    let h20 = 20
    let h19 = 19
    let h18 = 18
    let h17 = 17
    let h15 = 15
    let h14 = 14
    let h13 = 13
    let h12 = 12
    let h10 = 10
    
    let app_BlueColor = UIColor(hexString: "#0171d5")
    let app_FontBlackColor = UIColor.black //Black
    let app_FontPrimaryColor = UIColor(hexString: "#456E72") //Green
    let app_FontSecondryColor = UIColor(hexString: "#5B5B5B") //Dark Grey
    
    let app_FontPincColor = UIColor(hexString: "#E2046E") //Pink Color
    let app_ViewBGColor = UIColor(hexString: "#D9D9D9") //Pink Color
    
    let app_mediumGrayColor = UIColor(hexString: "#969696") //MEDIUM gray
    
    let app_WhiteColor = UIColor(hexString: "#FFFFFF") //MEDIUM gray
    
    let app_FontMarronColor = UIColor(hexString: "#622140") //Marron
    
    let app_ButtonBGColor = UIColor(hexString: "#feb4d8") //light pink
    
    
    let app_ErrorColor = UIColor(hexString: "#e7505a") //red
    let app_FontCaribbeanGreen =  UIColor(hexString: "#00CC99")
}


extension String {

    var removeSpecialChars: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890._[]-,/")
        return self.filter {okayChars.contains($0) }
    }
    
    
}
