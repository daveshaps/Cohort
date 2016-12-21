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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  FBSDKAccessToken.current() != nil {
            self.performSegue(withIdentifier: "loginTransition", sender: self) //go to next viewcontroller
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
 
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        //exchange fb credential for a firebase credential
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        //sign into firebase using credential
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: "intialSetupTransition", sender: self)  //go to next view controller,
        }
 
    }
 
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
}


/*
//get person's information from fb
if (FBSDKAccessToken.current() != nil) {
    FBSDKGraphRequest(graphPath: "me", parameters: nil).start(withCompletionHandler: {(_ connection: FBSDKGraphRequestConnection, _ result: Any, _ error: Error) -> Void in
        if !error {
            print("fetched user:\(result)")
            //set variable for Person object to represent user
        }
    })
}
 */
