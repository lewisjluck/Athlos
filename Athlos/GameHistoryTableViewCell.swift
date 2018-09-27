//
//  GameHistoryTableViewCell.swift
//  Athlos
//
//  Created by Lewis Luck on 26/9/18.
//  Copyright © 2018 Fortune Inc. All rights reserved.
//

import UIKit

class GameHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var playerOnePic: UIImageView!
    @IBOutlet weak var playerOneName: UILabel!
    
    @IBOutlet weak var playerTwoPic: UIImageView!
    @IBOutlet weak var playerTwoName: UILabel!
    
    @IBOutlet weak var gameSportLabel: UILabel!
    @IBOutlet weak var gameScoreLabel: UILabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(game: Game) {
        playerOneName.text = game.player.nickname ?? game.player.firstName
        playerOnePic.image = game.player.convertToImage()
        playerTwoName.text = game.opponent.nickname ?? game.opponent.firstName
        playerTwoPic.image = game.opponent.convertToImage()
        gameSportLabel.text = game.sport
        gameScoreLabel.text = "\(game.score):\(game.opponentScore)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        gameDateLabel.text = dateFormatter.string(from: game.date)
    }

}
