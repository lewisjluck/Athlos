//
//  StatisticsTableViewController.swift
//  Athlos
//
//  Created by Lewis Luck on 29/9/18.
//  Copyright © 2018 Fortune Inc. All rights reserved.
//

import UIKit

class StatisticsTableViewController: UITableViewController {
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!
    @IBOutlet weak var winLossLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var averagePointLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userIndex: Int?
    var user: User? {
        if let userIndex = userIndex {
        return User.users[userIndex]
        } else {
            return User.users.first
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }

    func updateUI() {
        guard let user = user else {return}
        winLabel.text = String(user.wins)
        lossLabel.text = String(user.losses)
        winLossLabel.text = String(format: "%.2f", user.winLossRatio)
        gamesPlayedLabel.text = String(user.totalGames)
        averagePointLabel.text = String(format: "%.2f", user.averagePointDifference)
        profilePicImageView.image = user.convertToImage()
        totalPointsLabel.text = String(user.totalPoints)
        nameLabel.text = user.nickname ?? user.description
        
    }
    
    @IBAction func unwindToStatistics(unwindSegue: UIStoryboardSegue) {
        let source = unwindSegue.source as! ChoosePlayersTableViewController
        if let statisticsUser = source.statsUser {
            self.userIndex = statisticsUser
        }
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseStatisticsUser" {
            let destinationNav = segue.destination as! UINavigationController
            let destination = destinationNav.topViewController as! ChoosePlayersTableViewController
            destination.statistics = true
            destination.navigationItem.title = "Choose Statistics Player"
            if let statsUserIndex = self.userIndex {
                destination.statsUser = statsUserIndex
            }
        }
    }

}
