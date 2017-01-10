//
//  Question.swift
//  Cohort_App
//
//  Created by Wish Carr on 1/2/17.
//  Copyright © 2017 David Shapiro. All rights reserved.
//

import Foundation


//Question Class
class Question: NSObject {
    
    var questionText: String
    var ownerUserID: String
    var ownerFirstName: String
    var questionLocation: NSDictionary
    var questionKey: String
    var answerArray: [NSDictionary]?
    
    init (questionText: String, ownerUserID: String, ownerFirstName: String, questionLocation: NSDictionary, questionKey: String) {
        self.questionText = questionText
        self.ownerUserID = ownerUserID
        self.ownerFirstName = ownerFirstName
        self.questionLocation = questionLocation
        self.questionKey = questionKey
        
        super.init()
    }
    
}
