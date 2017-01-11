//
//  ViewController.swift
//  Cohort_App
//
//  Created by Wish Carr on 12/13/16.
//  Copyright © 2016 David Shapiro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GeoFire

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //MARK:- variables
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    var firstName:String?
    var lastName:String?
    var email:String?
    var userID:String?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
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
                
                //grab userID and set it as self.userID variable
                self.userID = user?.uid
                //setup user by pulling basicInfo from firebase
                self.userFirebasePull()
                //setup user location by pulling location from firebase
                self.userLocationSetup()
                
            })
            
            //move to next view
            self.performSegue(withIdentifier: "loginTransition", sender: self) //go to next viewcontroller (maintabbar)
        }
 
        else {
            
            var loginButton = FBSDKLoginButton()
            loginButton.delegate = self
            loginButton.center = self.view.center
            self.view.addSubview(loginButton)
            //FBSDKLoginButton.classForCoder()
            
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //MARK:- Other Functions
    
    //create user by pulling from firebase and populating currentPerson in app delegate
func userFirebasePull() {
    
    //create listener for user information in firebase database
    let userRef = FIRDatabase.database().reference(withPath: "Users").child(self.userID!)
    
    //take data from snapshot and add it to person variables
    userRef.child("basicInfo").observe(.value, with: { (snapshotOfUserInfo) in
        
        let userInfoDict = snapshotOfUserInfo.value as? NSDictionary
        
        let firstName = userInfoDict?["firstName"] as? String
        let lastName = userInfoDict?["lastName"] as? String
        let email = userInfoDict?["email"] as? String
        let gender = userInfoDict?["gender"] as? Int
        let birthday = userInfoDict?["birthday"] as? String
        let zipCode = userInfoDict?["zipCode"] as? String
        
        //create person in appdelegate as well
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.currentPerson = Person(userID: self.userID!, firstName: firstName!, lastName: lastName!, email: email!)
        
        appDelegate.currentPerson?.gender = gender
        appDelegate.currentPerson?.birthday = birthday
        appDelegate.currentPerson?.zipCode = zipCode
    })
}
    
    //setup user location
func userLocationSetup() {
        
        //setup Geofire reference
        let geofireRef = FIRDatabase.database().reference(withPath:"Users").child(self.userID!).child("location")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        //instantiate location variables
        var longitude: Double?
        var latitude: Double?
        
        //grab location from geofire
        
        geoFire?.getLocationForKey("location", withCallback: { (location, error) in
            if (error != nil) {
                print("An error occurred getting the location for \"location\": \(error?.localizedDescription)")
            } else if (location != nil) {
                //set location variables
                longitude = location?.coordinate.longitude
                latitude = location?.coordinate.latitude
                
                print("Location for \"location\" is [\(location?.coordinate.latitude), \(location?.coordinate.longitude)]")
            } else {
                print("GeoFire does not contain a location for \"location\"")
            }
        })
        
        //set currentPerson's location
        appDelegate.currentPerson?.location["latitude"] = latitude
        appDelegate.currentPerson?.location["longitude"] = longitude
    }
    

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
            
            //grab userID and set it as self.userID variable (I think this works...need to test)
            self.userID = user?.uid
            
            //get fb profile info and create person object in appdelegate
            self.fetchProfile()
            
            //setup user in firebase (missing gender, birthday, zipcode, location)
            self.partialUserSetup()
            
            print("Successful login to Firebase with FB credentials", user!)
        })
        
        //go to next view controller to setup user profile
        self.performSegue(withIdentifier: "initialSetupTransition", sender: self)
    }
 
//first time user firebase partial setup
//TODO:- look into skipping this here and just doing it in the next viewcontroller
func partialUserSetup() {
        //setup firebase reference to basicInfo
        let userRef = FIRDatabase.database().reference(withPath: "Users").child(self.userID!).child("basicInfo")
        
        //create dictionary with user info fetched from appdelegate
        let personDictionary:Dictionary = ["firstName": self.appDelegate.currentPerson?.firstName,"lastName": self.appDelegate.currentPerson?.lastName,"email": self.appDelegate.currentPerson?.email, "gender": nil, "birthday": nil, "zipCode": nil]
        
        //update user information in firebase
        userRef.setValue(personDictionary as NSDictionary?)
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
            
            if let result = result as? [String: AnyObject] {
                
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
                
            }
            
            //populate person object in appdelegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.currentPerson = Person(userID: self.userID!, firstName: self.firstName!, lastName: self.lastName!, email: self.email!)
            
        }
    }
}
