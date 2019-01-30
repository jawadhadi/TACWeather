//
//  ViewController.swift
//  TACWeather
//
//  Created by Hadi on 30/01/2019.
//  Copyright © 2019 Hadi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var defaultLocation = CLLocation(latitude: CLLocationDegrees(37.3320045), longitude: CLLocationDegrees(-122.0329699)) //Apple HQ's location, in case user doesn't allow access to location
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        enableLocationServices()
        
        //to remove the default double tap gesture
        //one way was to disable the zoom but in that case it wouldn't be easy for user to navigate
        if (mapView.subviews[0].gestureRecognizers != nil){
            for gesture in mapView.subviews[0].gestureRecognizers!{
                if (gesture.isKind(of: UITapGestureRecognizer.self)){
                    mapView.subviews[0].removeGestureRecognizer(gesture)
                }
            }
        }
        
        //to add custom double tap gesture
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTapGestureRecognizer)

    }
    
    
    @objc func handleDoubleTap(gesture: UIGestureRecognizer){
        
        let point = gesture.location(in: mapView)
        let touchCoordinate: CLLocationCoordinate2D = self.mapView.convert(point, toCoordinateFrom: mapView)
        defaultLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        performSegue(withIdentifier: "toWeatherVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherVC"{
            
            if let weatherViewController = segue.destination as? WeatherViewController{
            
                weatherViewController.location = defaultLocation
                
            }
            
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate{
    
    func enableLocationServices() {
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            // Request when-in-use authorization
            locationManager.requestWhenInUseAuthorization()
            
            break
            
        case .restricted, .denied:
            print("No access to user's location")
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            
            break
        }
    }
    
    //MARK: Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        if let location = locations.last{ //because the most recent location update is at the end of the array.
    
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        
        case .restricted, .denied:
            
            break
            
        case .authorizedWhenInUse:
            
            locationManager.startUpdatingLocation()
            break
            
        case .notDetermined, .authorizedAlways:
            
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationManager.stopUpdatingLocation()
        print("Location manager failed with error: " + error.localizedDescription)
        
    }
    
}
