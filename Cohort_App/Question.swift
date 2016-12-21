////
////  Questions.swift
////  Cohort_App
////
////  Created by Wish Carr on 12/19/16.
////  Copyright © 2016 David Shapiro. All rights reserved.
////
//
//import Foundation
//import UIKit
//import FirebaseAuth
//
////Person Class
//class Person: NSObject {
//    
//    var userID = String
//    var firstName: String
//    var lastName: String
//    var email: String
//    var birthday: Int
//    var location: location?
//    
//    init (firstName: String, lastName: String, email: String, birthday: Int, location: location?) {
//        self.userID = user.uid
//        self.firstName = firstName
//        self.lastName = lastName
//        self.email = email
//        self.birthday = birthday
//        self.location = location
//        
//        super.init()
//    }
//    
//}
//    
////Answer class
//    class Answer: NSObject {
//        
//        var owner = String?
//        var answer: String?
//        var answerTuple = (String, String)
//        
//        init (owner: String, answer: String) {
//            self.owner = owner
//            self.answer = answer
//            self.answerTuple = (owner, answer)
//            super.init()
//        }
//    }
//
////Question class
//class Question: NSObject {
//    
//    var questionOwner = String?
//    var question = String?
//    var answers = [Answer?]
//    
//    
//    init (questionOwner: String, question: String, answers: [Answer]) { //do I need to set array to nil?
//        self.questionOwner = questionOwner
//        self.question = question
//        self.answers = answers
//        super.init()
//    }
//    
//    //adds new answer object to answer array for a given question
//    func addAnswer(answer: String) {
//        let answer: Answer = (self.Person, answer)
//        self.answers.append(answer)
//    }
//    
//}
