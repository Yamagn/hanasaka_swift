//
//  addViewController.swift
//  hanasaka_times
//
//  Created by ymgn on 2019/02/15.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit
import CoreLocation

struct place_regist: Encodable {
    let place_name: String
    let latitude: Double
    let longitude: Double
    let description: String
}

struct plant_regist: Encodable {
    let plant: String
}

class addViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    var nowLatitude: Double = 0.0
    var nowLongitude: Double = 0.0
    @IBOutlet weak var placeText: UITextField!
    @IBOutlet weak var tagText: UITextField!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    var image : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        postButton.isHidden = true
        photoImage.isHidden = true
        
        let lm = CLLocationManager()
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 300
    }
    
    @IBAction func photoPick(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        } else {
            let controller = UIAlertController(title: "カメラにアクセスできません", message: "[設定] → [プライバシー]からカメラのアクセスを許可してください", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        nowLatitude = locations[0].coordinate.latitude
        nowLongitude = locations[0].coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickButton.isHidden = true
        photoImage.isHidden = false
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        photoImage.image = image
        postButton.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post(_ sender: Any) {
        if placeText.text == nil || photoImage.image == nil {
            let controller = UIAlertController(title: nil, message: "場所の名前か、写真が存在しません", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        
        let session = URLSession.shared
        
        let infoUrl = URL(string: "http://ichigo.work/register/")
        let imageUrl = URL(string: "http://ichigo.work/up_image/\(placeText.text!)/\(tagText.text)/")
        let plantUrl = URL(string: "http://ichigo.work/addplant/\(placeText.text!)")
        let infoBody: place_regist = place_regist(place_name: placeText.text!, latitude: nowLatitude, longitude: nowLongitude, description: "")
        let plantBody: plant_regist = plant_regist(plant: tagText.text!)
        
        
        do {
            var infoReq = URLRequest(url: infoUrl!)
            infoReq.httpMethod = "POST"
            infoReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            infoReq.httpBody = try encoder.encode(infoBody)
            session.dataTask(with: infoReq) { (_, res, error) in
                if error != nil {
                    let controller = UIAlertController(title: "エラーが発生しました", message: "通信に失敗しました", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    return
                }
            }
            
            var plantReq = URLRequest(url: plantUrl!)
            plantReq.httpMethod = "POST"
            plantReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
            plantReq.httpBody = try encoder.encode(plantBody)
            session.dataTask(with: plantReq) { (data, _, error) in
                if error != nil {
                    let controller = UIAlertController(title: "エラーが発生しました", message: "通信に失敗しました", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    return
                }
            }
            
            guard let postImage = image else {
                return
            }
            
            var imageReq = URLRequest(url: imageUrl!)
            infoReq.httpMethod = "POST"
            infoReq.addValue("image/jpg", forHTTPHeaderField: "Content-Type")
            infoReq.httpBody = postImage.jpegData(compressionQuality: 0.8)
            session.dataTask(with: imageReq) { (data, res, error) in
                if error != nil {
                    let controller = UIAlertController(title: "エラーが発生しました", message: "通信に失敗しました", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    return
                }
            }
        }
        catch {
            return
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
