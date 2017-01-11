////
////  SettingsViewController.swift
////  Cohort_App
////
////  Created by Wish Carr on 12/19/16.
////  Copyright © 2016 David Shapiro. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//import Firebase
//import FirebaseDatabase
//
//
//class SettingsViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
//
////Variables
//    var ref:FIRDatabaseReference?
//    let userID = FIRAuth.auth()?.currentUser?.uid
//    
//    @IBOutlet weak var zipCodeTextField: UITextField!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
//    @IBOutlet weak var errorLabel: UILabel!
//    @IBOutlet weak var birthdayPicker: UIPickerView!
//    @IBOutlet weak var logoutButton: UIButton!
//    
//    
//    var pickerDataSource: [Int] = [1]
//    
//    let locationManager = CLLocationManager()
//
//       
////View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //picker delegate and datasource and content
//        //self.birthdayPicker.delegate = self
//        //self.birthdayPicker.dataSource = self
//        
//        let date = NSDate()
//        let calendar = NSCalendar.autoupdatingCurrent
//        let components = calendar.dateComponents([.year], from: date as Date)
//        let year = components.year
//        var yearArray: [Int] = []
//        for i in 0...79 {
//            let aYear = year! - i
//            yearArray.append(aYear)
//        }
//        pickerDataSource = yearArray
//        
//        //setup reference to FIRDatabase
//        ref = FIRDatabase.database().reference()
//        
//        //make appDelegate reference
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        //setup initial picker value
//        let bDay = Int((appDelegate.currentPerson?.birthday)!)
//        let bDayRow = year! - bDay!
//        birthdayPicker.selectRow(bDayRow, inComponent: 1, animated: true)
//        //setup initial location value
//        zipCodeTextField.text = appDelegate.currentPerson?.zipCode
//        //setup initial segmented control gender value
//        genderSegmentedControl.selectedSegmentIndex = (appDelegate.currentPerson?.gender)!
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    //location changed value
//    @IBAction func zipCodeValueChanged(_ sender: UITextField) {
//        let zipCode = sender.text
//        
//        
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(zipCode!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
//            
//            let placemark = placemarks?[0]
//            let location = placemark?.location
//            let coordinate = location?.coordinate
//            print("Latitude \(coordinate?.latitude)")
//            print("Longitude \(coordinate?.longitude)")
//            
//            let latitude: Double = (coordinate?.latitude)! as Double
//            let longitude: Double = (coordinate?.longitude)! as Double
//            
//            //pass coordinates to person object in app delegate
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.currentPerson?.location?["latitude"] = latitude
//            appDelegate.currentPerson?.location?["longitude"] = longitude
//            appDelegate.currentPerson?.zipCode = zipCode!
//            
//            } as! CLGeocodeCompletionHandler)
//
//    }
//    
//    //segmented control value changed
//    
//    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
//        //update person object in app delegate
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.currentPerson?.gender = sender.selectedSegmentIndex
//        
//        //note 0 is male, 1 is female
//        
//    }
//    
//    //picker delegate methods
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1;
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerDataSource.count;
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> Int? {
//        return pickerDataSource[row]
//    }
//    
//    //birthday changed value 
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        //update birthday in person object in app delegate
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.currentPerson?.birthday = pickerDataSource[row]
//        
//    }
//    
//    
//    //finish the setup and update Firebase user information when back button clicked
//    @IBAction func finishSettingsUpdate(_ sender: Any) {
//        //update users information in firebase from person object in app delegate
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        ref?.child("Users").child(userID!).child("birthday").setValue(appDelegate.currentPerson?.birthday)
//        
//        ref?.child("Users").child(userID!).child("gender").setValue(appDelegate.currentPerson?.gender)
//        
//        //TODO:- need to push location to firebase
//        
//    }
//    
//    //TODO:- fix this segue
//    @IBAction func logout(_ sender: Any) {
//        self.performSegue(withIdentifier: "logout", sender: self)
//    }
//    
//    //TODO:- Need an FB logout button
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
