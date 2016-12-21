////
////  SingleQuestionViewController.swift
////  Cohort_App
////
////  Created by Wish Carr on 12/19/16.
////  Copyright © 2016 David Shapiro. All rights reserved.
////
//
//import UIKit
//import FirebaseDatabase
//import FirebaseAuth
//
//class SingleQuestionViewController: UIViewController {
//
//    //MARK: - Variables
//    
//    let userID = FIRAuth.auth()?.currentUser?.uid
//    
//    var questionAskerName: String
//    
//    var questionID: String?
//    
//    var ref:FIRDatabaseReference?
//    
//    @IBOutlet weak var answerTextView: UITextView!
//    
//    @IBOutlet weak var questionTextView: UITextView!
//    
//    @IBOutlet weak var askerNameTextField: UITextField!
//    
//    //MARK: - View Life Cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        ref = FIRDatabase.database().reference()
//        
//        ref?.child("Users").child(userID!).child("firstName").observeSingleEvent(of: .value, with: { (snapshotOfUserName) in
//            questionAskerName = snapshotOfUserName.value as? String
//
//        })
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    @IBAction func addAnswerButton(_ sender: Any) {
//        
//        let answer = answerTextView.text
//        let user = userID
//        let answerDict = {"answer" : answer, "user" : user}
//        ref?.child("Questions").child(questionID!).child("Answers").childByAutoID().setValue(answerDict)
//        
//    }
//    
//    
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
