//
//  GMViewController.swift
//  hanasaka_times
//
//  Created by ymgn on 2019/02/13.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit
import GoogleMaps

class GMViewController: UIViewController {
    
    var gm : GMSMapView!
    
    let latitude: CLLocationDegrees = 36.5780574
    let longitude: CLLocationDegrees = 136.6486596

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let zoom: Float = 15
        
        let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        
        gm = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        gm.camera = camera
        
        let marker : GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.map = gm
        
        self.view.addSubview(gm)
        
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
