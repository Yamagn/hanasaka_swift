//
//  detailViewController.swift
//  hanasaka_times
//
//  Created by ymgn on 2019/02/20.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit
import GoogleMaps

class detailViewController: UIViewController {

    var markerInfo : Place? = nil
    
    @IBOutlet weak var flowerImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var tagStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let place = markerInfo else {
            return
        }
        
        flowerImage.setImage(fromUrl: place.imageURL)
        placeName.text = place.name

        // Do any additional setup after loading the view.
    }
    @IBAction func shareTwitter(_ sender: Any) {
        
    }
}

extension UIImageView {
    public func setImage(fromUrl url: String) {
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) {(data, response, error) in
            guard let data = data, let _ = response, error == nil else {
                return
            }
            DispatchQueue.main.async(execute: {
                self.image = UIImage(data: data)
            })
            }.resume()
    }
}
