//
//  HealthCheckupModel.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 27/04/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation

struct HealthCheckupModel {
    var PackageSrNo : String?
    var PackageName : String?
    var IsAgeRestricted : String?
    var AgeText : String?
    var MaxAge : String?
    var MinAge : String?
    var IsGenderRestricted : String?
    var GenderText : String?
    var Gender : String?
    var PackagePrice : String?
    var payment : String?
    var personModelArray = [PersonCheckupModel]()
    
}


struct PersonCheckupModel
{
    var PersonSRNo : Int?
    var FamilySrNo : String?
    var ExtPersonSRNo : String?
    var IsBooking : String?
    var PaymentConfFlag : String?
    var ApptSrInfoNo : String?
    var IsMobEmailConf : Int?
    var Price : String?
    var Amount : String?
    var BookingStatus : String?
    var CanBeDeletedFalg : Int?
    var SponserdBy : String?
    var SponserdByFlag : String?
    var PackageSrNo : String?
    var PackageName : String?
    var PersonName : String?
    var Age : String?
    var DateOfBirth : String?
    var EmailID : String?
    var CellPhoneNumber : String?
    var Gender : String?
    var RelationID : String?
    var RelationName : String?
    var IsBooked : String?
    var IsChbChecked : String?
    var IsDisabled : Bool?
    var AppointmentStatusBadge : String?
    var paidNotScheduled : String?
    var tooltip : String?
    var IsSelectedInWellness : String?
    var isSelectedByUser : Bool?
}
