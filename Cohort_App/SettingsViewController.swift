////
////  SettingsViewController.swift
////  Cohort_App
////
////  Created by Wish Carr on 12/19/16.
////  Copyright © 2016 David Shapiro. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//
//
//class SettingsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
//
////Variables
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var locationTextField: UITextField!
//    
//    let locationManager = CLLocationManager()
//    
////View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    //location setup
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
////Location Delegate Methods
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
