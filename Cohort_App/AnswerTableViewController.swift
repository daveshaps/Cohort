////
////  AnswerTableViewController.swift
////  Cohort_App
////
////  Created by Wish Carr on 12/19/16.
////  Copyright © 2016 David Shapiro. All rights reserved.
////
//
//import UIKit
//import FirebaseDatabase
//
//class AnswerTableViewController: UITableViewController {
//
//    //MARK: - variables
//    
//    var questionsForReview: [String?]
//    
//    var ref:FIRDatabaseReference?
//    
//    var databaseHandle:FIRDatabase?
//    
//    //MARK: - view life cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        ref = FIRDatabase.database().reference()
//        //listen for children being added
//        databaseHandle = ref?.child("Questions").observe(.childAdded, with: { (snapshot) in
//            //take data from snapshot and add it to the question array
//            
//            let questionID = snapshot.value as? String
//            
//            let basicInfoDict = ref?.child("Questions").child(questionID).child("BasicInfo").observeSingleEvent(of: .value, with: { (snapshotOfBasicInfo) in
//                // Get user value
//                let questionBasicInfoDict = snapshotOfBasicInfo.value as? NSDictionary
//                let question = questionBasicInfoDict["question"]
//                let user = questionBasicInfoDict["user"]
//            
//            
//            if let actualQuestion = question {
//                self.questionsForReview.append(actualQuestion)
//                tableView.reloadData()
//            }
//            
//        })
//    })
//    
//    //reloading the table for when you go back to this view from submitAnswer view so changes appear
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableView.reloadData()
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.questionsForReview.count
//    }
//
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        let question = self.questionsForReview[indexPath.row]  //indexPath.row gives us the row we are at in the table
//        
//        //optionally could add name of asker and their picture here by calling user
//        
//        if (question?.question) != nil {
//            cell.textLabel?.text = question?.question
//        }
//        
//        else {
//            cell.textLabel?.text = "Not Available"
//        }
//        
//        return cell
//    }
//    
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    
//    // MARK: - Navigation
//
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
// 
// let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
// let questionID = self.questionsForReview[indexPath.row]
// let destination = segue.destination as! SingleQuestionViewController
// destination.questionID = questionID
// 
// }
//
//}
