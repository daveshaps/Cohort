//
//  SingleQuestionViewController.swift
//  Cohort_App
//
//  Created by Wish Carr on 12/19/16.
//  Copyright © 2016 David Shapiro. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SingleQuestionViewController: UIViewController {

    //MARK: - Variables
    
    let appDelegate = UIApplication.shared as! AppDelegate
    
    let userID = FIRAuth.auth()?.currentUser?.uid
    var questionAskerName: String?
    var question: Question?
    var questionKey: String?
    
    var responderFirstName: String = appDelegate.currentPerson.firstName
    
    var ref:FIRDatabaseReference?
    
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var askerNameTextField: UITextField = questionAskerName
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
            
        self.questionAskerName = self.question?.ownerFirstName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addAnswerButton(_ sender: Any) {
        
        let answerText = answerTextView.text
        
        let answerDict = [answer: answerText, responderFirstName: self.responderFirstName, userID: self.userID]
        
        ref?.child("Questions").child(questionKey!).child("answerArray").observeSingleEvent(of: .value, with: { (snapshotOfAnswerArray) in
            answerArray = snapshotOfAnswerArray.value as? Array
            answerArray.append(answerDict)
            
            ref?.child("Questions").child(questionKey!).child("answerArray").setValue(answerArray)
        })
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
