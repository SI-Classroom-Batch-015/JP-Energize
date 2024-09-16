//
//  User.swift
//  JP Energize
//
//  Created by Phillip Wilke on 05.09.24.
//

import Foundation

struct Profile: Codable {
    
    var firstName: String
    var lastName: String
    var birthDate: Date
    var email: String
    var password: String
    var phoneNumber: String
    var profileImage: String
}


