//
//  detailViewController.swift
//  hanasaka_times
//
//  Created by ymgn on 2019/02/20.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit
import GoogleMaps

struct Images: Decodable {
    let image_names: [String]
}

class detailViewController: UIViewController {

    var markerInfo : Place? = nil
    
    @IBOutlet weak var imagesView: UIScrollView!
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var tagStack: UIStackView!
    var imageData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let place = markerInfo else {
            return
        }
        
        let session = HttpClientImpl()
        
        placeName.text = place.place_name
        var tags : [UILabel] = []
        for i in place.plants {
            let l = UILabel()
            l.layer.backgroundColor = UIColor.gray.cgColor
            l.layer.cornerRadius = 5
            l.text = i
            tags.append(l)
            
            var req = URLRequest(url: URL(string: "http://ichigo.work/\(place.place_name)/\(i)")!)
            req.httpMethod = "GET"
            let (data, _, error) = session.execute(request: req)
            if error != nil {
                let controller = UIAlertController(title: "エラーが発生しました", message: "通信に失敗しました", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                return
            }
            guard data != nil else {
                let controller = UIAlertController(title: "エラーが発生しました", message: "通信に失敗しました", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                return
            }
            let decoder = JSONDecoder()
            var jsonData = try! decoder.decode(Images.self, from: data as! Data)
            imageData = jsonData.image_names
        }
        print(tags)
        for i in tags {
            tagStack.addArrangedSubview(i)
        }
        
        for image in imageData {
            var imageView = UIImageView()
            imageView.setImage(fromUrl: image)
            imagesView.addSubview(imageView)
        }

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
