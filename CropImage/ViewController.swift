//
//  ViewController.swift
//  CropImage
//
//  Created by Trinh Thai on 3/8/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var ibImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        if let image = UIImage(named: "image0") {
            //                let result = self.cropImage2(image: image, rect: frame, scale: 1)
            let result = image.cropping(to: frame)
            ibImage.image = result
        }
        
    }
    
    func cropImage1(image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!)
    }
    
    func cropImage2(image: UIImage, rect: CGRect, scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
        //draw at point
        image.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
    
}
extension UIImage {
    func cropping(to rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
        // draw in rect
        self.draw(in: CGRect(x: -rect.origin.x, y: -rect.origin.y, width: self.size.width, height: self.size.height))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
}
