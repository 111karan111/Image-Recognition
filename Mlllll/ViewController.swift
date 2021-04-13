//
//  ViewController.swift
//  Mlllll
//
//  Created by Karan Gandhi on 4/13/21.
//

import UIKit
import CoreML
import Vision


//Set Current View controller as a delegate of UI VIew Conroller, Image Poicker and Navigation Controller

class ViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate{
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    var classificationResults : [VNClassificationObservation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion:  nil)
            
            guard let ciImage = CIImage(image: image) else {
               fatalError("Could not convert")
            }
            
            detect(image: ciImage)
            
        }
      
        
    }
    
    
    func detect(image : CIImage){
        
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Could not initialize the model")
            
            
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first
            
            else {
                fatalError("unexpected")
            }
            
            
            
            if topResult.identifier.contains("hotdog"){
                DispatchQueue.main.async {
                    self.navigationItem.title = "HotDog!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.green
                    self.navigationController?.navigationBar.isTranslucent = false
                }
            }
                else {
                    
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not Hotdog!"
                        self.navigationController?.navigationBar.barTintColor = UIColor.red
                        self.navigationController?.navigationBar.isTranslucent = false
                }
                
            }
            
                
        }
            
            
            
            let handler = VNImageRequestHandler(ciImage: image)
            do {
                
                
                try handler.perform([request])
            }
            
            catch {
                print(error)
                
            }
    }
        
        
        
    
    
  
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)

    }
    

        
}


