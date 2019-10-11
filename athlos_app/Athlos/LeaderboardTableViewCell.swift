//
//  LeaderboardTableViewCell.swift
//  Athlos
//
//  Created by Lewis Luck on 29/9/18.
//  Copyright © 2018 Fortune Inc. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    @IBOutlet weak var positionImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var sideDetailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(user: User, position: Int) {
        nameLabel.text = "\(user.description)"
        detailLabel.text = "\(user.wins) Wins"
        sideDetailLabel.text = "Score: \(user.totalPoints)"
        var image: UIImage
        switch position {
        case 1: image = #imageLiteral(resourceName: "First")
        case 2: image = #imageLiteral(resourceName: "Second")
        case 3: image = #imageLiteral(resourceName: "Third")
        default: image = #imageLiteral(resourceName: "Certificate")
        }
        positionImage.image =  image
        
    }
    }
    

