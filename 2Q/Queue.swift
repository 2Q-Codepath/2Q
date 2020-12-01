//
//  Queue.swift
//  2Q
//
//  Created by Sterling Gamble on 11/17/20.
//

import Foundation
import Parse

class Queue {
    var queue: PFObject?
    var host: PFUser?
    var live: Bool?
    var queuers: [PFUser]? {
        return fetchQueuers(queue: queue!)
    }
    var imageURL: URL?
    var location: String?
    var description: String?
    var name: String?
//    var count: Int = 0
    var role: Role?
    var saved: Bool?
    
    init(queue:PFObject? = nil) {
        if queue != nil {
            self.queue = queue
            self.host = queue?["host"] as? PFUser
            self.live = queue?["live"] as? Bool
            self.name = queue?["name"] as? String
            self.location = queue?["location"] as? String
            self.description = queue?["description"] as? String
            // image
            let imageFile = queue?["image"] as! PFFileObject
            let urlString = imageFile.url!
            self.imageURL = URL(string: urlString)!
            
//            self.queuers = fetchQueuers(queue: queue!)
            self.role = getRole()
            self.saved = isSaved()
            
        }
        
    }
    
    func fetchQueuers(queue: PFObject) -> [PFUser] {
        let query = PFQuery(className: "Queuer")
        query.whereKey("queue", equalTo: queue)
//        query.selectKeys(["user"])
        query.includeKey("user")
        let results: [PFObject]?
        do {
            results = try query.findObjects()
        } catch {
            print(error)
            results = nil
        }
        
        var queuers = [PFUser]()
        for result in results! {
            let user = result["user"] as? PFUser
            queuers.append(user!)
        }
        
        return queuers
    }
    
    func getPosition(queue: PFObject, user: PFUser) -> Int {
        let queuers = fetchQueuers(queue: queue)
        
        guard let index = queuers.firstIndex(of: user) else { return 0 }
        return index + 1
    }
    
    func getPosition() -> Int {
        let queuers = fetchQueuers(queue: queue!)
        var i = 0
        while i < queuers.count {
            if queuers[i].objectId == PFUser.current()?.objectId {
                return i + 1
            }
            i += 1
        }
        return 0
    }
    
    func getRole() -> Role {
        let host = queue?["host"] as? PFUser
        let position = getPosition()
        if host?.objectId == PFUser.current()?.objectId {
            return .host
        } else if position > 0 {
            return .queuer
        }
        return .guest
    }
        
    // edit
    
    func checkIn(user: PFUser) {
        // fetch queuer
        let query = PFQuery(className: "Queuer")
        query.whereKey("queue", equalTo: queue)
        query.includeKey("user")
        // remove user from "Queuers"
        let results: [PFObject]?
        do {
            results = try query.findObjects()
        } catch {
            print(error)
            results = nil
        }
        
        for result in results! {
            let user2 = result["user"] as? PFUser
            if user.objectId == user2?.objectId {
                result.deleteInBackground { (succeeded, error) in
                    if succeeded {
                        print("checked in")
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    // join
    func join() {
        // add current user to "Queuers"
        let queuer = PFObject(className: "Queuer")
        queuer["queue"] = queue
        queuer["user"] = PFUser.current()
        queuer.saveInBackground { (succeeded, error) in
            if succeeded {
                print("Joined Queue")
                self.role = .queuer
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    // leave
    func leave() {
        // remove current user from "Queuers"
        // fetch queuer
        let query = PFQuery(className: "Queuer")
        query.whereKey("queue", equalTo: queue)
        query.includeKey("user")
        // remove user from "Queuers"
        let results: [PFObject]?
        do {
            results = try query.findObjects()
        } catch {
            print(error)
            results = nil
        }
        
        for result in results! {
            let user = result["user"] as? PFUser
            if user?.objectId == PFUser.current()?.objectId {
                result.deleteInBackground { (succeeded, error) in
                    if succeeded {
                        print("left")
                        self.role = .guest
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
        
        
    }
    
    // start queue
    func start() {
        // update
        let query = PFQuery(className: "Queue")
        query.getObjectInBackground(withId: (queue?.objectId)!) { (object, error) in
            if object != nil {
                object?["live"] = true
                object?.saveInBackground()
                self.live = true
            }
        }
    }
    
    // end queue
    func end() {
        let query = PFQuery(className: "Queue")
        query.getObjectInBackground(withId: (queue?.objectId)!) { (object, error) in
            if object != nil {
                object?["live"] = false
                object?.saveInBackground()
                self.live = false
            }
        }
    }
    
    // save
    func save() {
        let saved = PFObject(className: "Saved")
        saved["queue"] = queue
        saved["user"] = PFUser.current()
        saved.saveInBackground { (succeeded, error) in
            if succeeded {
                self.saved = true
                print("saved")
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func isSaved() -> Bool {
        let query = PFQuery(className: "Saved")
        query.whereKey("queue", equalTo: queue)
        query.whereKey("user", equalTo: PFUser.current()!)
        let results: [PFObject]?
        do {
            results = try query.findObjects()
        } catch {
            print(error)
            results = nil
        }
        
        if (results != nil) {
            return true
        }
        return false
        
    }
}

enum Role {
    case host
    case queuer
    case guest
}
