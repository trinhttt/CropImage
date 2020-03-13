//
//  ViewController.swift
//  CropImage
//
//  Created by Trinh Thai on 3/8/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit
import AVKit

    struct PageItem {
        let x: CGFloat = 702
        let y: CGFloat = 698
        // scale is ratio to real image size with real display view
        // scale > 1 if real image size < real display view
        // scale < 1 if real image size > real display view
        let scale: CGFloat = 2.5//0.541666686534882
        let rotation: CGFloat = 0 // -270
        let frameTop : CGFloat = 117
        let frameLeft : CGFloat = 117
        let frameWidth : CGFloat = 1170
        let frameHeight : CGFloat = 1163
    }
class ViewController: UIViewController {

    @IBOutlet weak var ibDisplayView: UIView!
    @IBOutlet weak var ibDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ibDisplayViewWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCroppedImage()
    }
    
    private func showCroppedImage() {
        let item = PageItem()
        // Ratio between real and display
        let ratio = ibDisplayView.frame.size.width / item.frameWidth
        ibDisplayViewHeight.constant = item.frameHeight * ratio
        ibDisplayViewWidth.constant = item.frameWidth * ratio
        var image = UIImage(named: "image")!
        image = image.rotated(angle: item.rotation)!
        // image.size is real size of image
        let imageWidth = image.size.width * item.scale * ratio
        let imageHeight = image.size.height * item.scale * ratio

        let photoFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        let photoImageView = UIImageView(frame: photoFrame)
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        photoImageView.image = image
        let centerX = (item.x - item.frameLeft) * ratio
        let centerY = (item.y - item.frameTop) * ratio
        photoImageView.center = CGPoint(x: centerX, y: centerY)
        self.ibDisplayView.clipsToBounds = true
        self.ibDisplayView.addSubview(photoImageView)
    }
        
    // Cropped image is not correct, not in rect area
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
    
    func rotated(angle: CGFloat) -> UIImage? {
        if angle == -90 {
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .left)
        } else if angle == -270 {
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .right)
        } else if angle == -180 {
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .down)
        } else {
            return self
        }
    }
}
