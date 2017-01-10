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

class InitialSetupViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    //Variables
    var ref:FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var birthdayPicker: UIPickerView!
    @IBOutlet weak var submitButton: UIButton!
    var pickerDataSource: [Int] = [1]

    let locationManager = CLLocationManager()
    
    //validate function variables
    var birthdayYes:Bool = false
    var locationYes:Bool = false
    var genderYes:Bool = false
    
    
    //View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - TO DO: setup geofire reference
        //let geofireRef = FIRDatabase.database().reference()
        // let geoFire = GeoFire(firebaseRef: geofireRef)
        
        //disable submit button
        self.submitButton.isEnabled = false
        
        //picker delegate and datasource and content
        //self.birthdayPicker.delegate = self
        //self.birthdayPicker.dataSource = self
        
        let date = NSDate()
        let calendar = NSCalendar.autoupdatingCurrent
        let components = calendar.dateComponents([.year], from: date as Date)
        let year = components.year
        var yearArray: [Int] = []
        for i in 0...79 {
            let aYear = year! - i
            yearArray.append(aYear)
        }
        pickerDataSource = yearArray
        
        //setup reference to FIRDatabase
        ref = FIRDatabase.database().reference()
        
        /*
        //location setup
        self.locationManager.delegate = self
        let authorizationCode = CLLocationManager.authorizationStatus()
        
        //if authorization code not determined
        if authorizationCode == CLAuthorizationStatus.notDetermined && locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
        {
            if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseDescription") != nil
            {
                locationManager.requestWhenInUseAuthorization()
            }
            else
            {
                print("No description provided")
            }
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        //could set this to always collecting location data instead. But here we do not.
        self.locationManager.startUpdatingLocation()
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //read in zip and convert to long lat
    
    @IBAction func zipCodeValueChanged(_ sender: UITextField) {
        let zipCode = sender.text
        
        var geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(zipCode!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            var placemark = placemarks?[0]
            var location = placemark?.location
            var coordinate = location?.coordinate
            print("Latitude \(coordinate?.latitude)")
            print("Longitude \(coordinate?.longitude)")
            
            var latitude: String
            var longitude: String
            
            if var latitude = coordinate?.latitude {
                latitude = (coordinate?.latitude)!
            }
            if var longitude = coordinate?.longitude {
                longitude = (coordinate?.longitude)!
            }
            
            //pass coordinates to person object in app delegate
            let appDelegate = UIApplication.shared as! AppDelegate
            appDelegate.currentPerson?.location["latitude"] = latitude
            appDelegate.currentPerson?.location["longitude"] = longitude
            appDelegate.currentPerson?.zipCode = zipCode!
            
        } as! CLGeocodeCompletionHandler)
        
    }
    

    
    
    
    //segmented control value changed
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        //update person object in app delegate
        let appDelegate = UIApplication.shared as! AppDelegate
        appDelegate.currentPerson?.gender = sender.selectedSegmentIndex
        
        //note 0 is male, 1 is female
        
        self.genderYes = true
        self.validate()
    }
    
    //picker delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> Int? {
        return pickerDataSource[row]
    }
    
    //send birthday to firebase
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update birthday in person object in app delegate
        let appDelegate = UIApplication.shared as! AppDelegate
        appDelegate.currentPerson?.birthday = pickerDataSource[row]
        
        self.birthdayYes = true
        self.validate()
    }
    
    
    
    //validate that all fields have been completed
    func validate() {
        if (birthdayYes == true && locationYes == true && genderYes == true) {
            self.submitButton.isEnabled = false
            print("All fields have been completed")
        }
    }
    
    
    
    //finish the setup and update Firebase user information when submit button clicked
    @IBAction func finishSetup(_ sender: Any) {
        //update users information in firebase from person object in app delegate
        
        let appDelegate = UIApplication.shared as! AppDelegate

        //set reference to dictionary that is the value for "basicInfo" and edit the dict. locally then overwrite on firebase
        
        let userRef = FIRDatabase.database().reference(withPath: "Users").child(self.userID!).child("basicInfo")
        
        let personDictionary:NSDictionary = [firstName: appDelegate.currentPerson?.firstName,lastName: appDelegate.currentPerson?.lastName,email: appDelegate.currentPerson?.email, gender: appDelegate.currentPerson?.gender, birthday: appDelegate.currentPerson?.birthday, zipCode: appDelegate.currentPerson?.zipCode]
        
        //update user information in firebase
        userRef.child("basicInfo").setValue(personDictionary as NSDictionary?)
        
        //push location to firebase via geofire
        
        //setup Geofire reference
        let geofireRef = FIRDatabase.database().reference(withPath:"Users").child(self.userID!).child("location")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        //set location value in firebase via GeoFire
        geoFire.setLocation(CLLocation(latitude: appDelegate.currentPerson?.location["latitude"], longitude: appDelegate.currentPerson?.location["longitude"]), forKey: "location")

        
        //go to the main tab bar view controller
        self.performSegue(withIdentifier: "loginTransition", sender: self)
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
