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
    @IBOutlet weak var microphoneBarItem: UIBarButtonItem!
    
    var score1 = 0
    var score2 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
            updateUI()
        print("Hello")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addUser1(_ sender: UIButton) {
        score1 += 1
        updateUI()
    }
    
    @IBAction func minusUser1(_ sender: UIButton) {
        score1 -= 1
        updateUI()
    }
    
    @IBAction func addUser2(_ sender: UIButton) {
        score2 += 1
        updateUI()
    }
    
    @IBAction func minusUser2(_ sender: UIButton) {
        score2 -= 1
        updateUI()
    }
    
    @IBAction func recordingStarted(_ sender: Any) {
        if audioEngine.isRunning {
            stopAudio()
        } else {
            recordAndRecognizeSpeech()
        }
    }
    
    func updateUI() {
        scoreLabel1.text = "\(score1)"
        scoreLabel2.text = "\(score2)"
    }
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    func recordAndRecognizeSpeech() {
        microphoneBarItem.image = #imageLiteral(resourceName: "Microphone icon")
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
            
            if lowercasedLastString == "one" || lowercasedLastString == "1" || lowercasedLastString == "two" || lowercasedLastString == "2" || lowercasedLastString == "to" || lowercasedLastString == "too"  {
            print("ifStatementCalled")
            self.addScore(string: lastString)
            self.stopAudio()
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
        microphoneBarItem.image = #imageLiteral(resourceName: "Microphone off icon")
    }
    
    func addScore(string: String) {
        print("addScoreCalled with \(string)")
        switch string.lowercased() {
        case "one": score1 += 1
            print("received")
        case "1": score1 += 1
        case "two": score2 += 1
        case "to": score2 += 1
        case "too": score2 += 1
        case "2": score2 += 1
        default: break
        }
        updateUI()
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
