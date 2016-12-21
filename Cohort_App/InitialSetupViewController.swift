////
////  InitialSetupViewController.swift
////  Cohort_App
////
////  Created by Wish Carr on 12/20/16.
////  Copyright © 2016 David Shapiro. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//import FirebaseAuth
//import FirebaseDatabase
//
//class InitialSetupViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
//
//    //Variables
//    var ref:FIRDatabaseReference?
//    let userID = FIRAuth.auth()?.currentUser?.uid
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var locationTextField: UITextField!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
//    let locationManager = CLLocationManager()
//    
//    //View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //setup reference to FIRDatabase
//        ref = FIRDatabase.database().reference()
//        
//        //scrollView setup (not sure why this isn't working or at least can't place objects outside normal view)
//        scrollView.contentSize.height = 800
//       
//        
//        //location setup
//        self.locationManager.delegate = self
//        let authorizationCode = CLLocationManager.authorizationStatus()
//        
//        //if authorization code not determined
//        if authorizationCode == CLAuthorizationStatus.notDetermined && locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
//        {
//            if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseDescription") != nil
//            {
//                locationManager.requestWhenInUseAuthorization()
//            }
//            else
//            {
//                print("No description provided")
//            }
//        }
//        
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        self.locationManager.requestWhenInUseAuthorization()
//        //could set this to always collecting location data instead. But here we do not.
//        self.locationManager.startUpdatingLocation()
//        self.mapView.showsUserLocation = true
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    //Location Delegate Methods
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//        
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
//        
//        self.mapView.setRegion(region, animated: true)
//        
//        self.locationManager.stopUpdatingLocation()
//        
//        //Pin
//        
//        let locationPinCoord = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locationPinCoord
//        
//        mapView.addAnnotation(annotation)
//        mapView.showAnnotations([annotation], animated: true)
//        
//        //geo coder
//        
//        let geoCoder = CLGeocoder()
//        
//        geoCoder.reverseGeocodeLocation(location!, completionHandler:
//            { (placemarks, error) -> Void in
//                
//                var placeMark: CLPlacemark!
//                placeMark = placemarks?[0]
//                
//                if let subLocality = placeMark.addressDictionary!["subLocality"] as? NSString
//                {
//                    self.locationTextField.text = String(subLocality)
//                    
//                }
//        })
//        
//    }
//    
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
//    {
//        print("Errors: " + error.localizedDescription)
//    }
//
//    //finish the setup and update Firebase user information
//    @IBAction func finishSetup(_ sender: Any) {
//        if (self.locationTextField.text != nil) {
//            
//            //update users information in firebase
//            ref?.child("Users").child(userID).child("firstName").setValue(//grab from fb)
//            ref?.child("Users").child(userID).child("lastName").setValue(//grab from fb)
//            ref?.child("Users").child(userID).child("email").setValue(//grab from fb)
//            if //get gender value from switch and set to 0 or 1 
//                
//            ref?.child("Users").child(userID).child("gender").setValue(genderValue)
//                
//            //grad date picker value
//                birthdayDatePicker.addTarget(self, action: "birthdayDatePickerChanged:", forControlEvents: .ValueChanged)
//                
//            ref?.child("Users").child(userID).child("birthday").setValue(birthday)
//                //grab location and translate to string 
//            ref?.child("Users").child(userID).child("location").setValue(userLocation)
//            
//            self.performSegue(withIdentifier: "loginTransition", sender: self)
//        }
//        else {
//            return
//        }
//        
//    }
//    
//    func datePickerChanged (sender: UIDatePicker) {
//        let formatter = DateFormatter()
//        formatter.datestyle = .short
//        dateText.text = formatter.stringFromDate(sender.date)
//    }
//    
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
