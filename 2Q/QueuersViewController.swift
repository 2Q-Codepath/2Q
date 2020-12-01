//
//  QueuersViewController.swift
//  2Q
//
//  Created by Sterling Gamble on 11/29/20.
//

import UIKit
import Parse

class QueuersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var queuers = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queuers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        
        let queuer = queuers[indexPath.row]
        cell.usernameLabel.text = queuer.username
        let firstName = queuer["firstName"] as? String
        let lastName = queuer["lastName"] as? String
        let name = firstName! + " " + lastName!
        cell.nameLabel.text = name
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
