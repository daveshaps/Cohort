//
//  Person.swift
//  Cohort_App
//
//  Created by Wish Carr on 12/27/16.
//  Copyright © 2016 David Shapiro. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import CoreLocation

//Person Class
class Person: NSObject {

    var userID: String
    var firstName: String
    var lastName: String
    var email: String
    var gender: Int?
    var birthday: Int?
    var location: NSDictionary?

    init (userID: String, firstName: String, lastName: String, email: String) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email

        super.init()
    }

}
