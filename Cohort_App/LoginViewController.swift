//
//  LoginViewController.swift
//  Cohort_App
//
//  Created by Wish Carr on 1/11/17.
//  Copyright © 2017 David Shapiro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GeoFire

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    //MARK:- Variables
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    var firstName:String?
    var lastName:String?
    var email:String?
    var userID:String?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //check to see if user is already logged in
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        if userID != nil {
            print("Recognized user is already logged in, moving to Main Tab Bar View Controller")
            self.performSegue(withIdentifier: "loginToMainTabBarSegue", sender: self)
            return
        }
        */
        /*
        //check to see if already logged in with fb
        if  FBSDKAccessToken.current() != nil {
            print("Performing segue to main tab bar vc")
            self.performSegue(withIdentifier: "loginToMainTabBarSegue", sender: self)
        }
        */
            
        //TODO:- add else statement back in
        //set up login button if user is not logged in
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Facebook Login Function
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil) {
            // Process error
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
            
        else if result.isCancelled {
            // Handle cancellations
            return
        }
        else {
            
            //checking for existing fb token
            if  FBSDKAccessToken.current() != nil {
                
                print("Recognized FB token, moving to Main Tab Bar View Controller")
                self.performSegue(withIdentifier: "loginToMainTabBarSegue", sender: self)
            }
            
            //exchange fb credential for a firebase credential
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            print("Exchanged FB token for Firebase credential", credential)
            
            //video directions
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                //grab userID and set it as self.userID variable (I think this works...need to test)
                self.userID = user?.uid
                print ("Succesful login with Firebase")
                
                //get fb profile info and create person object in appdelegate
                self.fetchProfile()
                
                //conduct partial user setup in Firebase
                self.partialUserSetup()
            })
        }
    
        self.performSegue(withIdentifier: "loginToInitialSetupSegue", sender: self)
    }
    
    //MARK:- Fetch profile from FB and create in appDelegate
    
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
            appDelegate.currentPerson?.gender = 0
            print("Successfully grabbed info from FB and set person in appDelegate")
            print(appDelegate.currentPerson?.userID as Any,appDelegate.currentPerson?.firstName as Any,appDelegate.currentPerson?.lastName,appDelegate.currentPerson?.email as Any)
        }
    }
    
    //MARK:- Partial User Setup when FB Login happening for first time
    
    func partialUserSetup() {
        //setup firebase reference to basicInfo
        let userRef = FIRDatabase.database().reference(withPath: "Users").child(self.userID!).child("basicInfo")
        
        //create dictionary with user info fetched from appdelegate
        let personDictionary: [String : Any] = ["firstName": self.appDelegate.currentPerson?.firstName,"lastName": self.appDelegate.currentPerson?.lastName,"email": self.appDelegate.currentPerson?.email, "gender": 0, "birthday": -1, "zipCode": -1]
        if personDictionary["firstName"] != nil {
            print("Person dictionary succesfully created")
        }
        
        //update user information in firebase
        userRef.setValue(personDictionary)
        print("Set value in Firebase for personDictionary")
    }
    
    
    //MARK:- Facebook Logout Function
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("Succesful logout of Facebook")
        
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
