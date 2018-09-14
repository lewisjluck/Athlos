//
//  User.swift
//  Athlos
//
//  Created by Lewis Luck on 13/9/18.
//  Copyright © 2018 Fortune Inc. All rights reserved.
//

import Foundation
import UIKit

struct User: Equatable, CustomStringConvertible, Codable, Comparable {
    var firstName: String
    var lastName: String
    var nickname: String?
    var profilePicture: Data?
    var themeColour: Colour?
    var id: Int {
        return User.users.count
    }
    
    mutating func setRandomProfilePicture() {
        let randomNumber = Int(arc4random_uniform(4))
        var randomProfilePicture: UIImage
        switch randomNumber {
        case 0: randomProfilePicture = #imageLiteral(resourceName: "man")
        case 1: randomProfilePicture = #imageLiteral(resourceName: "man-1")
        case 2: randomProfilePicture = #imageLiteral(resourceName: "man-2")
        case 3: randomProfilePicture = #imageLiteral(resourceName: "boy-1")
        default: randomProfilePicture = #imageLiteral(resourceName: "man-1")
        }
        let randomPictureData = UIImagePNGRepresentation(randomProfilePicture)
        self.profilePicture = randomPictureData
    }
    
    func convertToImage() -> UIImage? {
        if let profilePicture = self.profilePicture {
            if let finalImage = UIImage(data: profilePicture) {
                return finalImage
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func < (rhs: User, lhs: User) -> Bool {
        return lhs.wins < rhs.wins
    }
    
    var games: [Game] = [Game()]
    
    var totalPoints: Int {
        var count = 0
        for game in games {
            count += game.score
        }
        return count
    }
    var wins: Int {
        var winCount = 0
        for game in games {
        if game.won == true {
            winCount += 1
            }
        }
        return winCount
    }
        var losses: Int {
            var lossCount = 0
            for game in games {
                if game.won == false {
                    lossCount += 1
                }
            }
            return lossCount
        }
    
    var winLossRatio: Double {
        return Double(wins/losses)
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
    }
    
    var description: String {
        return "\(firstName) \(lastName)"
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        nickname = nil
        profilePicture = nil
        themeColour = nil
    }
    
    init(firstName: String, lastName: String, nickname: String, profilePicture: UIImage, themeColour: Colour) {
        self.firstName = firstName
        self.lastName = lastName
        self.nickname = nickname
        let profilePictureData = UIImagePNGRepresentation(profilePicture)!
        self.profilePicture = profilePictureData
        self.themeColour = themeColour
    }
    
    static var users: [User] = []
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("users").appendingPathExtension("plist")
    
    static func saveToFile() {
        let users = User.users
        let encoder = PropertyListEncoder()
        let encodedUsers = try? encoder.encode(users)
        try? encodedUsers?.write(to: User.ArchiveURL)
    }
    
    static func loadFromFile() -> [User]? {
        let decoder = PropertyListDecoder()
        if let retrievedUserData = try? Data(contentsOf: ArchiveURL), let decodedUsers = try? decoder.decode(Array<User>.self, from: retrievedUserData) {
            return decodedUsers
        } else {
            return nil
        }
    }
}

struct Game: Codable {
    var won: Bool?
    var score: Int = 0
    var sport: Sport = .tableTennis
    var sets: Bool = false
    var setNumber: Int?
    var date: Date = Date()
}

enum Sport: Int, Codable {
    case tableTennis, football
}

enum Colour: Int, Codable {
    case blue, red, green, orange, yellow, pink, purple, grey
}

struct GameSettings: Codable {
    var playerOne: User?
    var playerTwo: User?
    var scoreToWin: Int?
}





