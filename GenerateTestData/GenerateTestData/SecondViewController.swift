//
//  SecondViewController.swift
//  GenerateTestData
//
//  Created by wrustem on 09.03.2023.
//

import UIKit


class SecondViewController: UIViewController {
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        navigationController?.navigationBar.backgroundColor = UIColor.random()
        
        imageView.frame = CGRect(x: 200, y: 200, width: 200, height: 200)
        imageView.backgroundColor = .white
        view.addSubview(imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        startTimer()
    }
    
    private var timer: Timer?
    
    private func startTimer() {
        imageView.isHidden = false
        
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(screenshoot),
            userInfo: nil,
            repeats: true
        )
    }
    
    func randomString(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @objc func screenshoot()  {
        print("stated")
        title = randomString(Int.random(in: 0..<6))
        navigationController?.navigationBar.backgroundColor = UIColor.random()
        
        self.navigationController?.navigationBar.tintColor = UIColor.random()
        
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let y = layer.convert(navigationController!.navigationBar.frame.origin, to: nil).y/layer.frame.height
        
        let width = navigationController!.navigationBar.frame.width/layer.frame.width
        let height = navigationController!.navigationBar.frame.height/layer.frame.height
        //
        //        let cropped = screenshot?.cropped(to: CGRect(
        //            x: 0,
        //            y: screenshot!.size.height * y * screenshot!.scale,
        //            width: screenshot!.size.width * width * screenshot!.scale,
        //            height: screenshot!.size.height * height * screenshot!.scale
        //        ))
        
        print(CGRect(
            x: 0,
            y: screenshot!.size.height * y * screenshot!.scale,
            width: screenshot!.size.width * width * screenshot!.scale,
            height: screenshot!.size.height * height * screenshot!.scale
        ))
        
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
    }
    
}

extension UIImage {
    func cropped(to rect: CGRect) -> UIImage? {
        guard let cgImage = cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}


extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
