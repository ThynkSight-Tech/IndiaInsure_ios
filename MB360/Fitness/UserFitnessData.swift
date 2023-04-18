//
//  UserFitnessData.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 09/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import Foundation

struct AktivoScoreModel { //[]
    let date : String?
    let score : String?
}

struct CaloriesModel { //[]
    let date : String?
    let calories : String?
}

struct ChallengesModel { //[]
    var title : String?
    var days : String?
    var challenge : String?
    var category : String?
    var target : String?
    var startDate : String?
    var endDate : String?
    var rank : String?
    var numberOfParticipants : String?
}

struct CompanyModel {
    var id : String?
    var company_code : String?
    var title : String?
}

struct DepartmentsModel { //[]
    var _id : String?
    var title : String?
    var description : String?
}

struct sleepModel //[]
{
var date : String?
var sleep_minutes : String?
}

struct stepsModel
{
    var date : String?
    var steps : String?
}

struct teams { //[]
    var _id : String?
    var team_code : String?
    var title : String?
    var description : String?
}


struct data {
    var _id : String?
    var firstname : String?
    var lastname : String?
    var email : String?
    var sex : String?
}
