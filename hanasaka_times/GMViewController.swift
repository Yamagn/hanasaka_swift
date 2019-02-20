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
    
    struct latlng {
        var name : String
        var tag : String?
        var lat : Double
        var lng : Double
    }
    
    let places : [latlng] = [latlng.init(name : "岐阜工業高等専門学校", tag : "高専", lat: 35.446733, lng: 136.672408),
                             latlng.init(name : "豊田工業高等専門学校", tag : "高専", lat: 35.103611, lng: 137.148183),
                             latlng.init(name : "沼津工業高等専門学校", tag : "高専", lat: 35.135944, lng: 138.884278),
                             latlng.init(name: "鳥羽商船高等専門学校", tag: "高専", lat: 34.482228, lng: 136.82485)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        googlemap = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        googlemap.isMyLocationEnabled = true
        googlemap.settings.compassButton = true
        googlemap.settings.myLocationButton = true
        googlemap.delegate = self
        for p in places {
            let marker : GMSMarker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(p.lat, p.lng)
            marker.title = p.name
            marker.snippet = p.tag
            marker.map = googlemap
        }
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
