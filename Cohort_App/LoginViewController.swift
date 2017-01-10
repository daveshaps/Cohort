//
//  ViewController.swift
//  Cohort_App
//
//  Created by Wish Carr on 12/13/16.
//  Copyright © 2016 David Shapiro. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //MARK:- variables
    
    var firstName:String?
    var lastName:String?
    var email:String?
    var userID:String?
    let appDelegate = UIApplication.shared as! AppDelegate
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checking for fb token
        if  FBSDKAccessToken.current() != nil {
            
            
            //create person by pulling info from firebase
             
             //exchange fb credential for firebase credential
             let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
             
             //sign into firebase
             FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
             
             if error != nil {
             print(error!)
             return
             }
             
             //grab userID and set it as self.userID variable (I think this works...need to test)
             self.userID = user?.uid
            
             //create listener for user information in firebase database
             let userRef = FIRDatabase.database().reference(withPath: "Users").child(self.userID!)
                
            //take data from snapshot and add it to person variables
             userRef.child("basicInfo").observe(.value, with: { (snapshotOfUserInfo) in
                     
                        let userInfoDict = snapshotOfUserInfo.value as? NSDictionary
                        
                        let firstName = userInfoDict["firstName"]
                        let lastName = userInfoDict["lastName"]
                        let email = userInfoDict["email"]
                        let gender = userInfoDict["gender"]
                        let birthday = userInfoDict["birthday"]
                        let zipCode = userInfoDict["zipCode"]
                        
                        //create person in appdelegate as well
                        let appDelegate = UIApplication.shared as! AppDelegate
                        AppDelegate.currentPerson = Person(userID: self.userID, firstName: firstName, lastName: lastName, email: email)
                        currentPerson?.gender = gender
                        currentPerson?.birthday = birthday
                        currentPerson?.zipCode = zipCode
                
                
                        //setup Geofire reference
                        let geofireRef = FIRDatabase.database().reference(withPath:"Users").child(self.userID!).child("location")
                        let geoFire = GeoFire(firebaseRef: geofireRef)
                
                        //instantiate location variables
                        var longitude: String?
                        var latitude: String?
                
                        //grab location from geofire
                
                geoFire.getLocationForKey("location", withCallback: { (location, error) in
                    if (error != nil) {
                        println("An error occurred getting the location for \"location\": \(error.localizedDescription)")
                    } else if (location != nil) {
                        //set location variables
                        longitude = location.coordinate.longitude
                        latitude = location.coordinate.latitude
                        
                        println("Location for \"location\" is [\(location.coordinate.latitude), \(location.coordinate.longitude)]")
                    } else {
                        println("GeoFire does not contain a location for \"location\"")
                    }
                })
                
                        //set currentPerson's location
                        currentPerson?.location["latitude"] = latitude
                        currentPerson?.location["longitude"] = longitude
             
             })
                
             })
            
            //move to next view
            self.performSegue(withIdentifier: "loginTransition", sender: self) //go to next viewcontroller (maintabbar)
        }
            
        else {
            
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //MARK:- Other Functions
    
    //facebook login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        //exchange fb credential for a firebase credential
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        //video directions
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            print("Successful login to Firebase with FB credentials", user!)
            
            //grab userID and set it as self.userID variable (I think this works...need to test)
            self.userID = user?.uid
            
            //get fb profile info and create person object in appdelegate
            self.fetchProfile()
            
            let userRef = FIRDatabase.database().reference(withPath: "Users").child(self.userID!).child("basicInfo")
            
            //create dictionary with user info fetched from appdelegate
            let personDictionary:NSDictionary = [firstName: appDelegate.currentPerson?.firstName,lastName: appDelegate.currentPerson?.lastName,email: appDelegate.currentPerson?.email, gender: nil, birthday: nil, zipCode: nil]
            
            //update user information in firebase
            userRef.setValue(personDictionary as NSDictionary?)
            
        })
        
        //go to next view controller to setup user profile
        self.performSegue(withIdentifier: "initialSetupTransition", sender: self)
    }
 
    //facebook logout
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    //get facebook profile info and create person object in appdelegate
    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields": "first_name, last_name, email"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            if let email = result["email"] as? String {
                self.email = email
                print(email)
            }
            
            if let firstName = result["first_name"] as? String {
                self.firstName = firstName
                print(firstName)
            }
            
            if let lastName = result["last_name"] as? String {
                self.lastName = lastName
                print(lastName)
            }
            
            //populate person object in appdelegate
            let appDelegate = UIApplication.shared as! AppDelegate
            appDelegate.currentPerson = Person(userID: self.userID!, firstName: self.firstName!, lastName: self.lastName!, email: self.email!)

            
            
        }
    }
}


//pass person's information via navigation (incorrect)



