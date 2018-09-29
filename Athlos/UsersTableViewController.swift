//
//  UsersTableViewController.swift
//  Athlos
//
//  Created by Lewis Luck on 15/9/18.
//  Copyright © 2018 Fortune Inc. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    var userIndex = 0
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return User.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let selectedUser = User.users[indexPath.row]
        cell.update(with: selectedUser)
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func unwindFromAddUser(unwindSegue: UIStoryboardSegue) {
        guard let source = unwindSegue.source as? AddEditUserTableViewController, let addedUser = source.user else {return}
        if source.editingUser == true {
            if User.users[userIndex].description == gameSettings.playerOne?.description {
                gameSettings.playerOne = addedUser
            }
            if User.users[userIndex].description == gameSettings.playerTwo?.description {
                gameSettings.playerTwo = addedUser
            }
            User.users[userIndex].firstName = addedUser.firstName
            User.users[userIndex].lastName = addedUser.lastName
            User.users[userIndex].nickname = addedUser.nickname
            User.users[userIndex].themeColour = addedUser.themeColour
            User.users[userIndex].profilePicture = addedUser.profilePicture
            userIndex = 0
        } else {
            User.users.append(addedUser)
            tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alertController = UIAlertController(title: "Are you sure you want to delete this user?", message: "This action cannot be undone!", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                let user = User.users[indexPath.row]
                if user == gameSettings.playerOne {
                    gameSettings.playerOne = nil
                } else if user == gameSettings.playerTwo {
                    gameSettings.playerTwo = nil
                }
                User.users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUser" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let selectedUser = User.users[selectedIndexPath.row]
            self.userIndex = selectedIndexPath.row
            let segueDestination = segue.destination as! UINavigationController
            let destination = segueDestination.topViewController as! AddEditUserTableViewController
            destination.title = selectedUser.description
            destination.user = selectedUser
            destination.editingUser = true
            destination.userIndex = selectedIndexPath.row
            }
        }
    }
    

}
