//
//  AnswerTableViewController.swift
//  Cohort_App
//
//  Created by Wish Carr on 12/19/16.
//  Copyright © 2016 David Shapiro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GeoFire

class QuestionTableViewController: UITableViewController {

    //MARK: - variables
    
    var ref:FIRDatabaseReference?
    var databaseHandle:FIRDatabase?
    var questionsArray: [NSArray]?
    
    //MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:- might need to make geofirequery here instead of all of this...
        
        let appDelegate = UIApplication.shared as! AppDelegate
        var personLatitude = appDelegate.currentPerson?.location["latitude"]
        var personLongitude = appDelegate.currentPerson?.location["longitude"]
        
        let center = CLLocation(latitude: personLatitude, longitude: personLongitude)
        
        // Query locations at person's lat & long with a radius of 7 kilometers
        var circleQuery = geoFire.queryAtLocation(center, withRadius: 7.0)
        
        //observe to see when keys matching criteria are found
        var queryHandle = query.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
            
            println("Key '\(key)' entered the search area and is at location '\(location)'")
            
            //append questions to array one at a time
            
            //TODO:- need to get key's parent key...not sure if code below works...pretty sure it doesn't
            
            let parentKey = key.parent().name()
            let questionLocation = ["latitude": location.coordinate.latitude, "longtitude": location.coordinate.longitude]
            
            let basicInfoDict = ref?.child("Questions").child(parentKey).child("questionInfo").observeSingleEvent(of: .value, with: { (snapshotOfQuestionInfo) in
                // Get question value
                let questionInfoArray = snapshotOfQuestionInfo.value as? NSArray
                
                let questionText = questionBasicInfoDict["questionText"]
                let ownerFirstName = questionBasicInfoDict["ownerFirstName"]
                let ownerUserID = questionBasicInfoDict["ownerUserID"]
                
                let questionKey = questionBasicInfoDict["questionKey"]
                
                //create new question object
                let newQuestion = Question(questionText: questionText, ownerUserID: ownerUserID, ownerFirstName: ownerFirstName, questionKey: questionKey)
                
                //append new question to array
                self.questionArray.append(newQuestion)

        })
        
        //signifies that all keys have been loaded
        query.observeReadyWithBlock({
            println("All initial data has been loaded and events have been fired!")
            
            //reload table
            tableView.reloadData()
        })
        
        
        ref = FIRDatabase.database().reference()
        //listen for children being added
        databaseHandle = ref?.child("Questions").observe(.childAdded, with: { (snapshot) in
            //take data from snapshot and add it to the question array
            
            let questionKey = snapshot.value as? String
            
            let basicInfoDict = ref?.child("Questions").child(questionKey).child("questionInfo").observeSingleEvent(of: .value, with: { (snapshotOfQuestionInfo) in
                // Get question value
                let questionInfoArray = snapshotOfQuestionInfo.value as? NSArray
                
                let questionText = questionBasicInfoDict["questionText"]
                let ownerFirstName = questionBasicInfoDict["ownerFirstName"]
                let ownerUserID = questionBasicInfoDict["ownerUserID"]
                
                let questionKey = questionBasicInfoDict["questionKey"]
                
                //get location using firebase geofire call
                
                let geofireRef = FIRDatabase.database().reference()
                let geoFire = GeoFire(firebaseRef: geofireRef)
                
                var questionLocation: NSDictionary?
                
                geoFire.getLocationForKey("firebase-hq", withCallback: { (location, error) in
                    if (error != nil) {
                        println("An error occurred getting the location for \"firebase-hq\": \(error.localizedDescription)")
                    } else if (location != nil) {
                        
                        //set location dictionary
                        questionLocation = ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]
                        
                        println("Location for \"firebase-hq\" is [\(location.coordinate.latitude), \(location.coordinate.longitude)]")
                        
                    } else {
                        println("GeoFire does not contain a location for \"firebase-hq\"")
                    }
                })
                
                //create new question object
                let newQuestion = Question(questionText: questionText, ownerUserID: ownerUserID, ownerFirstName: ownerFirstName, questionKey: questionKey)
            
                //append new question to array
                self.questionArray.append(newQuestion)
                tableView.reloadData()
            
        })
    })
    
    //reloading the table for when you go back to this view from submitAnswer view so changes appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        let question = self.questionsArray[indexPath.row]  //indexPath.row gives us the row we are at in the table
        
        //optionally could add name of asker and their picture here by calling user
        
        if (question?.questionText) != nil {
            cell.textLabel?.text = question?.questionText
        }
        
        else {
            cell.textLabel?.text = "Not Available"
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
 
 let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
 let question = self.questionsArray[indexPath.row]
 let destination = segue.destination as! SingleQuestionViewController
 
 destination.question = question
 destination.questionKey = question.questionKey
 }

        
}
}
