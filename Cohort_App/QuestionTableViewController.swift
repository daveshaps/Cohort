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
// import geofire & CLLocation?

class QuestionTableViewController: UITableViewController {

    //MARK: - variables
    
    var ref:FIRDatabaseReference?
    var databaseHandle:FIRDatabase?
    var questionsArray: [NSDictionary]?
    
    //MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        //listen for children being added
        databaseHandle = ref?.child("Questions").observe(.childAdded, with: { (snapshot) in
            //take data from snapshot and add it to the question array
            
            let questionKey = snapshot.value as? String
            
            let basicInfoDict = ref?.child("Questions").child(questionKey).observeSingleEvent(of: .value, with: { (snapshotOfQuestionInfo) in
                // Get user value
                let questionInfoArray = snapshotOfQuestionInfo.value as? NSArray
                
                let questionText = questionBasicInfoDict["questionText"]
                let ownerFirstName = questionBasicInfoDict["ownerFirstName"]
                let ownerUserID = questionBasicInfoDict["ownerUserID"]
                let questionLocation = questionBasicInfoDict["questionLocation"]
                let questionKey = questionBasicInfoDict["questionKey"]
                
                let newQuestion = Question(questionText: questionText, ownerUserID: ownerUserID, ownerFirstName: ownerFirstName, location: questionLocation, questionKey: questionKey)
            
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
