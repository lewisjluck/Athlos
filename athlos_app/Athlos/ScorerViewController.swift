//
//  ScorerViewController.swift
//  SportScore
//
//  Created by Lewis Luck on 8/9/18.
//  Copyright © 2018 Fortune Inc. All rights reserved.
//

import UIKit
import Speech

class ScorerViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel1: UILabel!
    @IBOutlet weak var scoreLabel2: UILabel!
    
    @IBOutlet weak var playerOneNameLabel: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    
    @IBOutlet weak var playerOneProfilePicture: UIImageView!
    @IBOutlet weak var playerTwoProfilePicture: UIImageView!
    
    @IBOutlet weak var playerOneBackgroundColour: UIView!
    @IBOutlet weak var playerTwoBackgroundColour: UIView!
    
    @IBOutlet weak var microphoneBarItem: UIBarButtonItem!
    
    var score1 = 0
    var score2 = 0
    
    let playerOneUser = gameSettings.playerOne
    
    func updateUI() {
        if let player1 = gameSettings.playerOne {
            playerOneNameLabel.text = player1.nickname ?? player1.description
            playerOneProfilePicture.image = player1.convertToImage()
            playerOneBackgroundColour.backgroundColor = User.convertToColour(colour: player1.themeColour!)
            playerOneProfilePicture.layer.cornerRadius = playerOneProfilePicture.frame.height/2
            playerOneProfilePicture.layer.masksToBounds = false
            playerOneProfilePicture.clipsToBounds = true
            
        }
        if let player2 = gameSettings.playerTwo {
            playerTwoNameLabel.text = player2.nickname ?? player2.description
            playerTwoProfilePicture.image = player2.convertToImage()
            playerTwoBackgroundColour.backgroundColor = User.convertToColour(colour: player2.themeColour!)
            playerTwoProfilePicture.layer.cornerRadius = playerTwoProfilePicture.frame.height/2
            playerTwoProfilePicture.layer.masksToBounds = false
            playerTwoProfilePicture.clipsToBounds = true
        }
        if gameSettings.playerOne == nil {
            playerOneNameLabel.text = "Guest 1"
            playerOneProfilePicture.image = #imageLiteral(resourceName: "man-2")
            playerOneBackgroundColour.backgroundColor = User.convertToColour(colour: "Red")
            playerOneProfilePicture.layer.cornerRadius = playerOneProfilePicture.frame.height/2
            playerOneProfilePicture.layer.masksToBounds = false
            playerOneProfilePicture.clipsToBounds = true
        }
        if gameSettings.playerTwo == nil {
            playerTwoNameLabel.text = "Guest 2"
            playerTwoProfilePicture.image = #imageLiteral(resourceName: "man")
            playerTwoBackgroundColour.backgroundColor = User.convertToColour(colour: "Blue")
            playerTwoProfilePicture.layer.cornerRadius = playerTwoProfilePicture.frame.height/2
            playerTwoProfilePicture.layer.masksToBounds = false
            playerTwoProfilePicture.clipsToBounds = true
        }
    }
    
    @IBAction func unwindFromGameSettings(unwindSegue: UIStoryboardSegue) {
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
        if gameSettings.playerOne == nil || gameSettings.playerTwo == nil {
            gameSettings.casual = true 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            updateScore()
            updateUI()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addUser1(_ sender: UIButton) {
        score1 += 1
        updateScore()
    }
    
    @IBAction func minusUser1(_ sender: UIButton) {
        if score1 > 0 {
        score1 -= 1
        updateScore()
        }
    }
    
    @IBAction func addUser2(_ sender: UIButton) {
        score2 += 1
        updateScore()
    }
    
    @IBAction func minusUser2(_ sender: UIButton) {
        if score2 > 0 {
        score2 -= 1
        updateScore()
        }
    }
    
    @IBAction func recordingStarted(_ sender: Any) {
        if audioEngine.isRunning {
            stopAudio()
        } else {
            recordAndRecognizeSpeech()
        }
    }
    
    func presentWinScreen(playerOneWon: Bool) {
        var winner: String
        if playerOneWon {
            winner = gameSettings.playerOne?.nickname ?? gameSettings.playerOne?.firstName ?? "Guest 1"
            playerOneBackgroundColour.backgroundColor?.withAlphaComponent(1)
            playerTwoBackgroundColour.backgroundColor?.withAlphaComponent(0.5)
        } else {
            winner = gameSettings.playerTwo?.nickname ?? gameSettings.playerTwo?.firstName ?? "Guest 1"
            playerTwoBackgroundColour.backgroundColor?.withAlphaComponent(1)
            playerOneBackgroundColour.backgroundColor?.withAlphaComponent(0.5)
        }
        
        let alertController = UIAlertController(title: "\(winner) Won!", message: nil, preferredStyle: .alert)
        
        let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { (action) in
            self.score2 = 0
            self.score1 = 0
            self.updateScore()
        }
        
        alertController.addAction(playAgainAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func updateScore() {
        scoreLabel1.text = "\(score1)"
        scoreLabel2.text = "\(score2)"
        guard gameSettings.casual == false else {return}
        let scoreToWin = gameSettings.scoreToWin ?? 11
        if score2 >= scoreToWin && score1 <= score2 - 2 {
            if let playerTwoIndex = gameSettings.playerTwoIndex {
                User.users[playerTwoIndex].games.append(Game(player: gameSettings.playerTwo!, won: true, score: score2, sport: gameSettings.sport ?? "Table Tennis", date: Date(), opponent: gameSettings.playerOne!, opponentScore: score1, gameid: gameSettings.gameIDCount))
                if let playerOneIndex = gameSettings.playerOneIndex {
                    User.users[playerOneIndex].games.append(Game(player: gameSettings.playerOne!, won: false, score: score1, sport: gameSettings.sport ?? "TableTennis", date: Date(), opponent: gameSettings.playerTwo!, opponentScore: score2, gameid: gameSettings.gameIDCount))
                }
            }
            presentWinScreen(playerOneWon: false)
            gameSettings.gameIDCount += 1
        }
        if score1 >= scoreToWin && score2 <= score1 - 2 {
            if let playerOneIndex = gameSettings.playerOneIndex {
                User.users[playerOneIndex].games.append(Game(player: gameSettings.playerOne!, won: true, score: score1, sport: gameSettings.sport ?? "Table Tennis", date: Date(), opponent: gameSettings.playerTwo!, opponentScore: score2, gameid: gameSettings.gameIDCount))
                if let playerTwoIndex = gameSettings.playerTwoIndex {
                    User.users[playerTwoIndex].games.append(Game(player: gameSettings.playerTwo!, won: false, score: score2, sport: gameSettings.sport ?? "Table Tennis", date: Date(), opponent: gameSettings.playerOne!, opponentScore: score1, gameid: gameSettings.gameIDCount))
                }
                presentWinScreen(playerOneWon: true)
                gameSettings.gameIDCount += 1
            }
        
            
        }
    }
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    func recordAndRecognizeSpeech() {
        microphoneBarItem.image = #imageLiteral(resourceName: "Speech")
        
        request = SFSpeechAudioBufferRecognitionRequest()
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            buffer, _ in self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
           try audioEngine.start()
        } catch {
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {return}
        if !myRecognizer.isAvailable {return}
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {result, error in if let result = result {
            let bestString = result.bestTranscription.formattedString
            
            var lastString: String = ""
            let split = bestString.split(separator: " ")
            lastString = String(split.suffix(1).joined(separator: [" "]))
            
            
            print(lastString)
            
            let lowercasedLastString = lastString.lowercased()
            
            if lowercasedLastString == "one" || lowercasedLastString == "1" || lowercasedLastString == "two" || lowercasedLastString == "2" || lowercasedLastString == "to" || lowercasedLastString == "too" {
            self.stopAudio()
            self.addScore(string: lowercasedLastString)
            }
            if let player1 = gameSettings.playerOne {
                    print("Players recognised")
                if lowercasedLastString == player1.firstName.lowercased() {
                    self.stopAudio()
                    self.addScore(string: lowercasedLastString)
            }
                if let playerOneNickname = player1.nickname?.lowercased() {
                    print("Nickname recognised")
                    if lowercasedLastString == playerOneNickname {
                        self.stopAudio()
                        self.addScore(string: lowercasedLastString)
                    }
                }
            }
            if let player2 = gameSettings.playerTwo {
                    print("Players recognised")
                if lowercasedLastString == player2.firstName.lowercased() {
                    self.stopAudio()
                    self.addScore(string: lowercasedLastString)
                }
                if let playerTwoNickname = player2.nickname?.lowercased() {
                    print("Nickname recognised")
                    if lowercasedLastString == playerTwoNickname {
                        self.stopAudio()
                        self.addScore(string: lowercasedLastString)
                    }
                    
                }
                }
            
            
            
        } else if let error = error {
            print(error)
            }})
    }
    
    func stopAudio() {
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
        audioEngine.inputNode.removeTap(onBus:0)
        microphoneBarItem.image = #imageLiteral(resourceName: "Speech Off")
        print("Speech Stopped")
    }
    
    func addScore(string: String) {
        print("addScoreCalled with \(string)")
        switch string {
        case "one": score1 += 1
            print("received")
        case "1": score1 += 1
        case "two": score2 += 1
        case "to": score2 += 1
        case "too": score2 += 1
        case "2": score2 += 1
        case gameSettings.playerOne?.nickname?.lowercased(): score1 += 1
        case gameSettings.playerOne?.firstName.lowercased(): score1 += 1
        case gameSettings.playerTwo?.nickname?.lowercased(): score2 += 1
        case gameSettings.playerTwo?.firstName.lowercased(): score2 += 1
        default: break
        }
        updateScore()
        recordAndRecognizeSpeech()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
