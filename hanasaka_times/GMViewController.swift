//
//  GMViewController.swift
//  hanasaka_times
//
//  Created by ymgn on 2019/02/13.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit
import GoogleMaps

class GMViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var googlemap : GMSMapView!
    var locationManager : CLLocationManager?
    var currentLocation : CLLocation?

    var initView : Bool = false
    
    let latitude: CLLocationDegrees = 36.5780574
    let longitude: CLLocationDegrees = 136.6486596

    override func viewDidLoad() {
        super.viewDidLoad()
        
        googlemap = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        googlemap.isMyLocationEnabled = true
        googlemap.settings.compassButton = true
        googlemap.settings.myLocationButton = true
        googlemap.delegate = self
//        let marker : GMSMarker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
//        marker.map = googlemap
        self.view.addSubview(googlemap)
        
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 50
        locationManager?.startUpdatingLocation()
        self.locationManager?.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !initView {
            let camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: 15)
            googlemap.camera = camera
            locationManager?.stopUpdatingLocation()
            initView = true
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
