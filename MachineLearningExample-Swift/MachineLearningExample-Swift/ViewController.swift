//
//  ViewController.swift
//  MachineLearningExample-Swift
//
//  Created by ismail karaçayır on 13.09.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info [.originalImage] as? UIImage
        self.dismiss(animated: true)
        
        if let ciImage = CIImage(image: imageView.image!) {
            recognizeImage(image: ciImage)
        }
    }
    
  func  recognizeImage (image : CIImage){
      if let model = try? VNCoreMLModel(for: MobileNetV2().model){
          let request = VNCoreMLRequest(model: model) { vnRequest, error in
              if let result = vnRequest.results as? [VNClassificationObservation]{
                  if result.count > 0 {
                      let topResult = result[0]
                      DispatchQueue.main.async {
                          let confi = (topResult.confidence ) * 100
                          self.DescriptionLabel.text = "\(confi) it is \(String(describing: topResult.identifier))"
                      }
                      
                  }
                  
              }
          }
          let handler = VNImageRequestHandler(ciImage: image)
          DispatchQueue.global(qos: .userInteractive).async {
              do {
                  try handler.perform([request])
              }catch{
                  print("hata")
                  
              }
              }
      }
      
  
      
  }
    
}

