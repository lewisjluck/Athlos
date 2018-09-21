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
    var themeColour: String?
    var id: Int {
        return User.users.count
    }
    
    static func convertToColour(colour: String) -> UIColor {
        var selectedThemeColour: UIColor = UIColor.black
        switch colour {
            case "Red": selectedThemeColour = UIColor(displayP3Red: 252/255, green: 33/255, blue: 37/255, alpha: 0.75)
            case "Blue": selectedThemeColour = UIColor(displayP3Red: 29/255, green: 155/255, blue: 246/255, alpha: 0.75)
            case "Green": selectedThemeColour = UIColor(displayP3Red: 86/255, green: 215/255, blue: 43/255, alpha: 0.75)
            case "Orange": selectedThemeColour = UIColor(displayP3Red: 253/255, green: 130/255, blue: 8/255, alpha: 0.75)
            case "Yellow": selectedThemeColour = UIColor(displayP3Red: 254/255, green: 195/255, blue: 9/255, alpha: 0.75)
            case "Brown": selectedThemeColour = UIColor(displayP3Red: 144/255, green: 113/255, blue: 76/255, alpha: 0.75)
            case "Grey": selectedThemeColour = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.75)
            case "Purple": selectedThemeColour = UIColor(displayP3Red: 191/255, green: 87/255, blue: 218/255, alpha: 0.75)
            default: break
        }
        return selectedThemeColour
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
    
    var games: [Game] = []
    
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
    
    static var leaderboardUsers: [User] {
        
        return users.sorted(by: <)
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
    }
    
    var description: String {
        return "\(firstName) \(lastName)"
    }
    
    init(firstName: String, lastName: String, nickname: String?, profilePicture: UIImage?, themeColour: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.nickname = nickname
        if profilePicture == nil || profilePicture == #imageLiteral(resourceName: "EmptyProfilePic") {
                let randomNumber = Int(arc4random_uniform(4))
                var randomProfilePicture: UIImage
                switch randomNumber {
                case 0: randomProfilePicture = #imageLiteral(resourceName: "man")
                case 1: randomProfilePicture = #imageLiteral(resourceName: "man-1")
                case 2: randomProfilePicture = #imageLiteral(resourceName: "man-2")
                case 3: randomProfilePicture = #imageLiteral(resourceName: "boy-1")
                default: randomProfilePicture = #imageLiteral(resourceName: "man-1")
                }
                let randomPictureData = UIImageJPEGRepresentation(randomProfilePicture, 0.7)
                self.profilePicture = randomPictureData
        } else {
            if let profilePicture = profilePicture {
                let profilePictureData = UIImageJPEGRepresentation(profilePicture, 0.7)
                self.profilePicture = profilePictureData
            }
        }
        if let themeColour = themeColour {
            self.themeColour = themeColour
        } else {
            let randomNumber = Int(arc4random_uniform(8))
            var randomThemeColour: String = "Blue"
            switch randomNumber {
            case 0: randomThemeColour = "Blue"
            case 1: randomThemeColour = "Red"
            case 2: randomThemeColour = "Green"
            case 3: randomThemeColour = "Orange"
            case 4: randomThemeColour = "Yellow"
            case 5: randomThemeColour = "Purple"
            case 6: randomThemeColour = "Grey"
            case 7: randomThemeColour = "Brown"
            default: break
            }
            self.themeColour = randomThemeColour
        }
    }
    
    static var users: [User] = [] {
        didSet {
            User.saveToFile()
        }
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("users").appendingPathExtension("plist")
    
    static func saveToFile() {
        let users = User.users
        let encoder = PropertyListEncoder()
        let encodedUsers = try? encoder.encode(users)
        try? encodedUsers?.write(to: User.ArchiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [User]? {
        let decoder = PropertyListDecoder()
        if let retrievedUserData = try? Data(contentsOf: User.ArchiveURL), let decodedUsers = try? decoder.decode(Array<User>.self, from: retrievedUserData) {
            return decodedUsers
        } else {
            return nil
        }
    }
}

struct Game: Codable {
    var won: Bool
    var score: Int
    var sport: String
    var setNumber: Int
    var date: Date
}

let sportArray = ["Table Tennis", "Football"]

let colourArray = ["Blue", "Red", "Green", "Orange", "Yellow", "Brown", "Purple", "Grey"]

struct GameSettings: Codable {
    var playerOne: User?
    var playerTwo: User?
    var scoreToWin: Int?
    var setsToWin: Int?
    var sport: String?
    var playerOneIndex: Int?
    var playerTwoIndex: Int?
    var casual: Bool?
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("game_settings").appendingPathExtension("plist")
    
    static func saveToFile(gameSettings: GameSettings) {
        let encoder = PropertyListEncoder()
        let encodedGameSettings = try? encoder.encode(gameSettings)
        try? encodedGameSettings?.write(to: GameSettings.ArchiveURL, options: .noFileProtection)
        print("Data has been saved")
    }
    
    static func loadFromFile() -> GameSettings? {
        let decoder = PropertyListDecoder()
        if let retrievedGameSettingsData = try? Data(contentsOf: GameSettings.ArchiveURL), let decodedGameSettings = try? decoder.decode(GameSettings.self, from: retrievedGameSettingsData) {
            return decodedGameSettings
        } else {
            return nil
        }
    }
}

var gameSettings = GameSettings(playerOne: nil, playerTwo: nil, scoreToWin: nil, setsToWin: nil, sport: nil, playerOneIndex: nil, playerTwoIndex: nil, casual: false) {
    didSet {
        GameSettings.saveToFile(gameSettings: gameSettings)
    }
}







