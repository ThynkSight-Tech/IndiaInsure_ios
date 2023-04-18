//
//  SummaryModel.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 07/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import Foundation

struct PersonSummary {
    var Name : String?
    var Price : String?
    var Is_Date_Elasped : Int?
    var IsStrike : Int?
}

struct SummaryModel {
    var Total : String?
    var paid : String?
    var Youpay : String?
    var ShowConfirmButton :Bool = false
    
    var CompanySponsoredArray = [PersonSummary]()
    var SelfSponsoredArray = [PersonSummary]()

}
