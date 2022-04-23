//
//  ArtObjectDetailsResponses.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 20.04.2021.
//

import Foundation

struct ArtObjectDetailsResponse: Codable {
    let elapsedMilliseconds: Int
    let artObject: ArtObjectDetails?
    
    enum CodingKeys: String, CodingKey {
        case elapsedMilliseconds
        case artObject
    }
}

struct ArtObjectDetails: Codable, Equatable {
    
    let links: Links
    let id: String
    let priref: String?
    let objectNumber: String?
    let language: String?
    let title: String?
    let copyrightHolder: String?
    let webImage: ArtImage?
    let titles: [String]?
    let description: String?
    let labelText: String?
    let makers: [Maker]?
    let principalMakers: [Maker]?
    
    let plaqueDescriptionDutch: String?
    let plaqueDescriptionEnglish: String?
    let documentation: [String]?
    let label: Label?
    
    enum CodingKeys: String, CodingKey {
        case links
        case id
        case priref
        case objectNumber
        case language
        case title
        case copyrightHolder
        case webImage
        case titles
        case description
        case labelText
        case makers
        case principalMakers
        case plaqueDescriptionDutch
        case plaqueDescriptionEnglish
        case documentation
        case label
    }
    
    static func == (lhs: ArtObjectDetails, rhs: ArtObjectDetails) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Maker: Codable {
    
    let name: String?
    let unFixedName: String?
    let placeOfBirth: String?
    let dateOfBirth: String?
    let dateOfBirthPrecision: String?
    let dateOfDeath: String?
    let dateOfDeathPrecision: String?
    let placeOfDeath: String?
    let occupation: [String]?
    let roles: [String]?
    let nationality: String?
    let biography: String?
    let productionPlaces: [String]?
    let qualification: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case unFixedName
        case placeOfBirth
        case dateOfBirth
        case dateOfBirthPrecision
        case dateOfDeath
        case dateOfDeathPrecision
        case placeOfDeath
        case occupation
        case roles
        case nationality
        case biography
        case productionPlaces
        case qualification
    }
}

struct Label: Codable {
    
    let title: String?
    let makerLine: String?
    let description: String?
    let notes: String?
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case makerLine
        case description
        case notes
        case date
    }
}
