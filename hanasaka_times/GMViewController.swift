//
//  GMViewController.swift
//  hanasaka_times
//
//  Created by ymgn on 2019/02/13.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit
import GoogleMaps

struct Place {
    var name : String
    var tags : [String]
    var lat : Double
    var lng : Double
    var imageURL : String
}

class GMViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var googlemap : GMSMapView!
    var locationManager : CLLocationManager?
    var currentLocation : CLLocation?
    var place : Place?

    var initView : Bool = false
    
    let places : [Place] = [Place.init(name : "岐阜工業高等専門学校", tags : ["高専"], lat: 35.446733, lng: 136.672408, imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/%E6%AD%A3%E9%9D%A2%E7%8E%84%E9%96%A2%E4%BB%98%E8%BF%91%E3%81%8B%E3%82%89%E3%81%AE%E7%9C%BA%E3%82%81.JPG/440px-%E6%AD%A3%E9%9D%A2%E7%8E%84%E9%96%A2%E4%BB%98%E8%BF%91%E3%81%8B%E3%82%89%E3%81%AE%E7%9C%BA%E3%82%81.JPG"),
                             Place.init(name : "豊田工業高等専門学校", tags : ["高専", "動物園"], lat: 35.103611, lng: 137.148183, imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/Toyota_National_College_of_Technology.jpg/440px-Toyota_National_College_of_Technology.jpg"),
                             Place.init(name : "沼津工業高等専門学校", tags : ["高専"], lat: 35.135944, lng: 138.884278, imageURL: "http://www.denshi.numazu-ct.ac.jp/top_photo3.jpg"),
                             Place.init(name: "鳥羽商船高等専門学校", tags:  ["高専"], lat: 34.482228, lng: 136.82485, imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Toba_Shosen.jpg/440px-Toba_Shosen.jpg")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        googlemap = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        googlemap.isMyLocationEnabled = true
        googlemap.settings.compassButton = true
        googlemap.settings.myLocationButton = true
        googlemap.delegate = self
        for p in places {
            let marker : GMSMarker = GMSMarker()
            var str = ""
            for tag in p.tags {
                str = str + tag + " "
            }
            marker.snippet = str
            marker.position = CLLocationCoordinate2DMake(p.lat, p.lng)
            marker.title = p.name
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail = segue.destination as? detailViewController
        if place == nil {
            let controller = UIAlertController(title: "", message: "マーカーが見つかりません", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
        detail?.markerInfo = place
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        for i in places {
            if i.lat == marker.position.latitude && i.lng == marker.position.longitude {
                place = i
            }
        }
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
}
