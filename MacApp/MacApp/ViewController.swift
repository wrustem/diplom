//
//  ViewController.swift
//  MacApp
//
//  Created by Rustem Sayfullin on 8.01.2023.
//  Copyright 2023 MacApp. All rights reserved.
//

import Cocoa

import AVFoundation
import Vision
import Foundation

class ViewController: NSViewController {
    
    var counter = 0
    let preferredTimescale = 60
    let stepTimescale = 10
    
    var videoURL: URL?
    var sourceImage: NSImage!
    var isRecognizeMode = true
    
    var detectedVC: Element!
    var lastDetectedVC: Element?
    
    var boxes = [CGRect]()
    
    let uiObjectClassifier = try! TapToolBig1(configuration: MLModelConfiguration())
    
    @objc
    private func continueButton2Tapped() {
        isRecognizeMode = false
        let a = AppDelegateMader()
        a.mainElement = detectedVC
        a.start()
        
        let v = VCMader()
        v.mainElement = detectedVC
        v.start()
        
        task1()
        task2()
        task3()
    }

    @IBAction func testButton(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = ["mp4", "mov"]
        if openPanel.runModal() == NSApplication.ModalResponse.OK {
            if let url = openPanel.url {
                print(url.path)
                videoURL = url
                displayLinkCallback()
                // Действия с выбранным файлом
            }
        }
    }
    
    func imageFromVideo(url: URL, at time: TimeInterval) -> NSImage? {
        let asset = AVURLAsset(url: url)
        
        let seconds = Double(CMTimeGetSeconds(asset.duration))
        let duration = seconds * Double(stepTimescale)
        
        if time > duration {
            return nil
        }
        
        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = .encodedPixels
        
        let cmTime = CMTime(seconds: time , preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }
        
        return NSImage(cgImage: thumbnailImageRef, size: CGSize(width: thumbnailImageRef.width, height: thumbnailImageRef.height))
    }
    
    @objc func displayLinkCallback() {
        DispatchQueue.global().async {
            guard let im = self.imageFromVideo(url: self.videoURL!, at: TimeInterval(self.counter * 10)) else {
                DispatchQueue.main.sync { [self] in
                    self.continueButton2Tapped()
                }
                return
            }
            self.sourceImage = im
            let newImage = self.detectingAndDraw(sourceImage: self.sourceImage)
            self.counter += 1
            
            if self.isRecognizeMode {
                self.displayLinkCallback()
            }
        }
    }
    
    func detectingAndDraw(sourceImage: NSImage) -> NSImage? {
        // Распознование и проверка, что экраны разные
        guard let element = detectVisionContours(sourceImage: sourceImage),
              !(lastDetectedVC?.isEqual(to: element) ?? false),
              element.children.count > 0
        else { return nil }
        
        let strings = recognizeText(sourceImage)
        
        strings.forEach { string in
            element.setTextChain(text: string.0, rect: string.1)
        }
        
        if detectedVC == nil {
            detectedVC = element
            lastDetectedVC = element
        }
        detectCircle(sourceImage: sourceImage)
        if let b = boxes.last {
            DispatchQueue.main.sync {
                
                let f = CGRect(
                    x: b.minX / sourceImage.size.width,
                    y: (sourceImage.size.height - b.minY -  b.height) / sourceImage.size.height,
                    width: b.width / sourceImage.size.width,
                    height: b.height / sourceImage.size.height
                )
                lastDetectedVC?.setButtonChain(
                    el: element,
                    point: CGPoint(x: f.minX, y: f.maxY)
                )
            }
            
            lastDetectedVC = element
        }
        
        return sourceImage
    }
    
    func recognizeText(_ image: NSImage) -> [(String, CGRect)] {
        guard let imageData = sourceImage.tiffRepresentation,
              let bitmapImageRep = NSBitmapImageRep(data: imageData),
              let cgImage = bitmapImageRep.cgImage
        else { return [] }

        let request = VNRecognizeTextRequest()
        var recognizedStrings = [(String, CGRect)]()

        do {
            try VNImageRequestHandler(cgImage: cgImage).perform([request])
            if let results = request.results {
                for observation in results {
                    if let candidate = observation.topCandidates(1).first {
                        recognizedStrings.append((candidate.string, observation.boundingBox))
                    }
                }
            }
        } catch {
            return []
        }

        return recognizedStrings
    }
    
    func detectVisionContours(sourceImage: NSImage) -> Element? {
        
        guard let imageData = sourceImage.tiffRepresentation,
              let bitmapImageRep = NSBitmapImageRep(data: imageData),
              let cgImage = bitmapImageRep.cgImage
        else { return nil }
        
        let inputImage = CIImage.init(cgImage: cgImage)
        let contourRequest = VNDetectContoursRequest()
        contourRequest.revision = VNDetectContourRequestRevision1
        contourRequest.contrastAdjustment = 30
        contourRequest.maximumImageDimension = 100000
        contourRequest.contrastPivot = 1
        
        
        let requestHandler = VNImageRequestHandler.init(ciImage: inputImage, options: [:])
        
        try! requestHandler.perform([contourRequest])
        
        guard let contoursObservation = contourRequest.results?.first else { return nil }
        
        let topElement = Element(box: CGRect(origin: .zero, size: CGSize(width: 1, height: 1)))
        for i in (0...contoursObservation.contourCount-1) {
            let contour = try! contoursObservation.contour(at: i)
            let box = contour.normalizedPath.boundingBox
            guard box.width * box.height > 0.003 else { continue }
            let el = Element(contour: contour, box: contour.normalizedPath.boundingBox)
            
            let revBox = CGRect(x: box.minX, y: 1 - box.maxY, width: box.width, height: box.height)
            DispatchQueue.main.sync {
                el.color = sourceImage.getPixelColor(
                    atLocation: NSPoint(
                        x: revBox.minX + revBox.width / 2,
                        y: revBox.minY + revBox.height / 2
                    ),
                    withFrameSize: CGSize(width: 1, height: 1)
                )
            }
            topElement.addElementToIerarh(el)
        }
        
        
        
        return topElement
    }
    
    private func detectCircle(sourceImage: NSImage) {
        let group = DispatchGroup()
        
        let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: uiObjectClassifier.model)) { [self] (request, error) in
            group.enter()
            
            for objectObservation in request.results! {
                // Select only the label with the highest confidence
                guard let objectObservation = objectObservation as? VNRecognizedObjectObservation else { return }
                let topLabelObservation = objectObservation.labels[0]
                DispatchQueue.main.sync {
                    let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(sourceImage.size.width), Int(sourceImage.size.height))
                    let transformedBounds = CGRect(x: objectBounds.minX, y: sourceImage.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
                    boxes.append(transformedBounds)
                }
            }
            
            group.leave()
        }
        
        guard let imageData = sourceImage.tiffRepresentation,
              let bitmapImageRep = NSBitmapImageRep(data: imageData),
              let cgImage = bitmapImageRep.cgImage
        else { return  }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
        
        group.wait()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBOutlet weak var test: NSSwitch!
    

    func task1() {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-project", "/Users/user/projects/diplom/GeneratedProj/GeneratedProj.xcodeproj", "-scheme", "GeneratedProj", "-configuration", "Debug", "-destination", "platform=iOS,name=iPhone w"]
        task.launchPath = "/usr/bin/xcodebuild"


        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        print(output ?? "No output")
    }
    
    func task2() {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["install", "ios-deploy"]
        task.launchPath = "/opt/homebrew/bin/brew"

        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
    }
    
    func task3() {
        deployBundleToDevice(bundleName: "GeneratedProj", deviceID: "00008101-000A4DD43CE8001E")
    }
    
    func deployBundleToDevice(bundleName: String, deviceID: String) {
        guard let appBundleUrl = findAppBundle(bundleName: bundleName) else {
            print("Unable to locate \(bundleName) in Derived Data")
            return
        }

        let arguments = ["--bundle", appBundleUrl.path, "-i", deviceID, "-d"]
        let task = Process()
        task.launchPath = "/opt/homebrew/bin/ios-deploy"
        task.arguments = arguments

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        task.launch()
        task.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            print(output)
        }
    }

    func findAppBundle(bundleName: String) -> URL? {
        
        let contentUrl = URL(string: "/Users/user/Library/Developer/Xcode/DerivedData")!
        let contents = try! FileManager.default.contentsOfDirectory(atPath: contentUrl.path)
        for content in contents {
            if content.hasPrefix(bundleName) {
                let c = contentUrl.appending(path: "\(content)/Build/Products/Debug-iphoneos/\(bundleName).app")
                return c
            }
        }
        
        return nil
    }

    
    func getPixelColor(at point: NSPoint, in image: NSImage) -> NSColor? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var rawData = [UInt8](repeating: 0, count: bytesPerRow * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        let pixelInfo = Int((CGFloat(width) * point.y) + point.x) * bytesPerPixel
        let red = CGFloat(rawData[pixelInfo + 1]) / 255.0
        let green = CGFloat(rawData[pixelInfo + 2]) / 255.0
        let blue = CGFloat(rawData[pixelInfo + 3]) / 255.0
        let alpha = CGFloat(rawData[pixelInfo]) / 255.0
        let color = NSColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}

