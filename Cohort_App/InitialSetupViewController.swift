//
//  InitialSetupViewController.swift
//  Cohort_App
//
//  Created by Wish Carr on 12/20/16.
//  Copyright © 2016 David Shapiro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import GeoFire

class InitialSetupViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Variables
    var ref:FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var birthdayPicker: UIPickerView!
    @IBOutlet weak var submitButton: UIButton!
    var pickerDataSource: [String] = [""]
    var zipCode:String?

    //let locationManager = CLLocationManager()
    
    //validate function variables
    var birthdayYes:Bool = false
    var locationYes:Bool = false
    //var genderYes:Bool = false
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide back button
        navigationItem.hidesBackButton = true
        
        //TODO:- setup geofire reference
        //let geofireRef = FIRDatabase.database().reference()
        //let geoFire = GeoFire(firebaseRef: geofireRef)
        
        //disable submit button
        self.submitButton.isEnabled = false
        
        //picker delegate and datasource
        self.birthdayPicker.delegate = self
        self.birthdayPicker.dataSource = self
        
        //textField delegate and datasource
        self.zipCodeTextField.delegate = self
        
        //setup reference to FIRDatabase
        ref = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //setup picker content
        let date = NSDate()
        let calendar = NSCalendar.autoupdatingCurrent
        let components = calendar.dateComponents([.year], from: date as Date)
        let year = components.year
        var yearArray: [String] = []
        for i in 0...79 {
            let aYear = ((year! - i) as NSNumber).stringValue
            yearArray.append(aYear)
        }
        pickerDataSource = yearArray
        print(yearArray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- read in zip code (need a function that does this when person presses return)

    /*6
    @IBAction func zipCodeChanged(_ sender: UITextField) {
        print("zip code value changed")
        print(sender.text)
        self.zipCode = sender.text
        self.zipToCoordinates()
        self.locationYes = true
        self.validate()
    }
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("text field has returned")
        print(textField.text)
        self.zipCode = textField.text
        self.zipToCoordinates()
        self.locationYes = true
        self.validate()
        
        if (self.zipCode)?.characters.count != 5 {
            return false
        }
        else {
            return true
        }
     }
    
    
    //MARK:-zip to coordinates function
    func zipToCoordinates() {
        let geoCoder = CLGeocoder()
        let zip = self.zipCode!
        geoCoder.geocodeAddressString(zip, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            
            let placemark = placemarks?[0]
            let location = placemark?.location
            let coordinate = location?.coordinate
            print("Latitude \(coordinate?.latitude)")
            print("Longitude \(coordinate?.longitude)")
            
            let latitude: Double = (coordinate?.latitude)! as Double
            let longitude: Double = (coordinate?.longitude)! as Double
            print("Succesfully calculated lat and long:", latitude, longitude)
            
            //TODO:- this value in current person dictionary for location is coming out nil
            //pass coordinates to person object in app delegate
            self.appDelegate.currentPerson?.location? = ["latitude": 0.0, "longitude": 0.0]
            self.appDelegate.currentPerson?.location?["latitude"] = latitude
            self.appDelegate.currentPerson?.location?["longitude"] = longitude
            self.appDelegate.currentPerson?.zipCode = self.zipCode!
            print("Succesfully set zip code and lat long in current Person in App Delegate:", self.appDelegate.currentPerson?.zipCode as Any,self.appDelegate.currentPerson?.location?["latitude"] as Any,self.appDelegate.currentPerson?.location?["longitude"] as Any)
            
            })
    }
    
    
    //MARK:- Segmented Control Function for value changed
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        //update person object in app delegate
        appDelegate.currentPerson?.gender = sender.selectedSegmentIndex
        
        //note 0 is male, 1 is female
        
        self.validate()
        print("Segmented control has been picked")
    }
    
    //MARK:- Picker Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    //TODO:- this method is not working!
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    //Function to send birthday to firebase
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update birthday in person object in app delegate
        appDelegate.currentPerson?.birthday = pickerDataSource[row]
        
        self.birthdayYes = true
        self.validate()
        print ("Birthday has been picked", birthdayYes)
    }
    
    //MARK: - Validate Function confirms that all fields have been completed
    func validate() {
        if (birthdayYes == true && locationYes == true) {
            self.submitButton.isEnabled = true
            print("All fields have been completed")
        }
    }
    
    
    //MARK:- Function to finish the setup and update Firebase user information when submit button clicked
    @IBAction func finishSetup(_ sender: Any) {
        //update users information in firebase from person object in app delegate
        
        //set reference to dictionary that is the value for "basicInfo" and edit the dict. locally then overwrite on firebase
        
        let userRef = FIRDatabase.database().reference(withPath: "Users").child(self.userID!).child("basicInfo")
        
        let personDictionary:NSDictionary = ["firstName": appDelegate.currentPerson?.firstName,"lastName": appDelegate.currentPerson?.lastName,"email": appDelegate.currentPerson?.email, "gender": appDelegate.currentPerson?.gender, "birthday": appDelegate.currentPerson?.birthday, "zipCode": appDelegate.currentPerson?.zipCode]
        
        //update user information in firebase
        userRef.child("basicInfo").setValue(personDictionary as NSDictionary?)
        
        //push location to firebase via geofire
        
        //setup Geofire reference
        let geofireRef = FIRDatabase.database().reference(withPath:"Users").child(self.userID!).child("location")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        let latActual = (appDelegate.currentPerson?.location?["latitude"])!
        let longActual = (appDelegate.currentPerson?.location?["longitude"])!
        
        //set location value in firebase via GeoFire
        geoFire?.setLocation(CLLocation(latitude: latActual, longitude: longActual), forKey: "location")

        //go to the main tab bar view controller
        self.performSegue(withIdentifier: "initialSetupToMainTabBarSegue", sender: self)
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
