//
//  GMViewController.swift
//  hanasaka_times
//
//  Created by ymgn on 2019/02/13.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit
import GoogleMaps

struct Place: Decodable {
    let place_name: String
    let latitude: Double
    let longitude: Double
    let plants: [String]
}

class GMViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var googlemap : GMSMapView!
    var locationManager : CLLocationManager?
    var currentLocation : CLLocation?
    var place : Place?

    var _places : [Place]?

    var initView : Bool = false
    
    let session = URLSession(configuration: .default)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        googlemap = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        googlemap.isMyLocationEnabled = true
        googlemap.settings.compassButton = true
        googlemap.settings.myLocationButton = true
        googlemap.delegate = self
        let lat = googlemap.myLocation?.coordinate.latitude
        let long = googlemap.myLocation?.coordinate.longitude
        print("latitude:", lat)
        print("longitude:", long)
        let places: [Place] = getPlaces(lat: lat!, long: long!)
        _places = places
        print("places:", places)
        for p in places {
            let marker : GMSMarker = GMSMarker()
            var str = ""
            for tag in p.plants {
                str = str + tag + " "
            }
            marker.snippet = str
            marker.position = CLLocationCoordinate2DMake(p.latitude, p.longitude)
            marker.title = p.place_name
            
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
        for i in _places! {
            if i.latitude == marker.position.latitude && i.longitude == marker.position.longitude {
                place = i
            }
        }
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    func getPlaces(lat: Double, long: Double) -> [Place]{
        let url = URL(string: "ichigo.work:81/places/\(lat)/\(long)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = HttpClientImpl()
        let (data, _, _) = session.execute(request: request)
        guard let jsonData = data else {
            return []
        }
        return try! JSONDecoder().decode([Place].self, from: jsonData as Data)
        
    }
}
