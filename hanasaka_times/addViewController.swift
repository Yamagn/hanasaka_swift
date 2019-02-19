//
//  addViewController.swift
//  hanasaka_times
//
//  Created by ymgn on 2019/02/15.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit

class addViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var placeText: UITextField!
    @IBOutlet weak var tagText: UITextField!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        postButton.isHidden = true
        photoImage.isHidden = true
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickButton.isHidden = true
        photoImage.isHidden = false
        photoImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        postButton.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post(_ sender: Any) {
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
