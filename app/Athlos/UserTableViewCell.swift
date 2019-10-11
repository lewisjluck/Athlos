//
//  UserTableViewCell.swift
//  Athlos
//
//  Created by Lewis Luck on 15/9/18.
//  Copyright © 2018 Fortune Inc. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func update(with user: User) {
        nameLabel.text = user.description
        profilePicture.image = user.convertToImage()
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.layer.masksToBounds = false
        profilePicture.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
