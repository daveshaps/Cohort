//
//  ViewController.swift
//  Cohort_App
//
//  Created by Wish Carr on 12/13/16.
//  Copyright © 2016 David Shapiro. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: FBSDKLoginButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  FBSDKAccessToken.current() != nil {
            //go to next viewcontroller
        }
        else {
            
        let loginButton = FBSDKLoginButton()
        //loginButton.delegate = self
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    @IBAction func FBLogin(_ sender: Any) {
        loginButton(sender)
    }
 */
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        /*
        //from firebase authentication
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                // ...
                return
            }
    }
    */

}
