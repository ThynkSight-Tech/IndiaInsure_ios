//
//  FitnessHelperModel.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 07/11/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import Foundation
struct LeaderboardModel {
    var name:String?
    var _id :String?
    var score :Int?
    var rank :Int!
    var impact :Int?
}


struct ChallengesScoreModel {
    var _id : String?
    var title : String?
    var days : String?
    var challenge_type : String?
    var description : String?
    var scored_by : String?
    var category_name : String?
    var target : String?
    var imageUrl : String?
    var start_date : String?
    var end_date : String?
    var userPosition  : String?
    var numberOfParticipants  : Int?
    var leaderboardModelArray = [LeaderboardModel]()
}


//for network Score

struct NetworkScoreModel {
    var average : NetworkStatsScoreModel?
    var percentile10 : NetworkStatsScoreModel?
    var percentile90 : NetworkStatsScoreModel?

}

struct NetworkStatsScoreModel
    {
        var exercise : Int?
        var sleep : Int?
        var score : Int?
        var steps : Int?
        
    }
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
/*
// MARK: - Welcome
struct Welcome: Codable {
    let embedded: Embedded
    let data: DataClass
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let id, firstname, lastname, email: String
    let sex: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstname, lastname, email, sex
    }
}

// MARK: - Embedded
struct Embedded: Codable {
    let aktivoScore, exercise: [AktivoScore]
    let network: Network
    let sleep: [AktivoScore]
    let steps: [Step]
    let company: Company
    let departments, teams: [Department]
    let leaderboards: [EmbeddedLeaderboard]
}

// MARK: - AktivoScore
struct AktivoScore: Codable {
    let date: String
    let value: Int
    let goalHit: Bool
    let impact: Impact?
}

enum Impact: String, Codable {
    case negative = "negative"
    case positive = "positive"
}

// MARK: - Company
struct Company: Codable {
    let id, companyCode, title: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case companyCode = "company_code"
        case title
    }
}

// MARK: - Department
struct Department: Codable {
    let id, title, departmentDescription: String
    let teamCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case departmentDescription = "description"
        case teamCode = "team_code"
    }
}

// MARK: - EmbeddedLeaderboard
struct EmbeddedLeaderboard: Codable {
    let id, title: String
    let days: Int
    let challengeType, leaderboardDescription, scoredBy, categoryName: String
    let target: Int
    let imageURL: JSONNull?
    let startDate, endDate: String
    let leaderboard: [LeaderboardLeaderboard]
    let userPosition, numberOfParticipants: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, days
        case challengeType = "challenge_type"
        case leaderboardDescription = "description"
        case scoredBy = "scored_by"
        case categoryName = "category_name"
        case target
        case imageURL = "imageUrl"
        case startDate = "start_date"
        case endDate = "end_date"
        case leaderboard, userPosition, numberOfParticipants
    }
}

// MARK: - LeaderboardLeaderboard
struct LeaderboardLeaderboard: Codable {
    let name: String
    let id: String?
    let score: Int?
    let rank, impact: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case id = "_id"
        case score, rank, impact
    }
}

// MARK: - Network
struct Network: Codable {
    let average, percentile10, percentile90: Average
}

// MARK: - Average
struct Average: Codable {
    let exercise, sleep, score: Int
    let steps: Double
}

// MARK: - Step
struct Step: Codable {
    let date: String
    let steps: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
*/
