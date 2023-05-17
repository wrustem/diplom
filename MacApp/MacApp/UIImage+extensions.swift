//
//  UIImage+extensions.swift
//  MacApp
//
//  Created by Rustem Sayfullin on 8.01.2023.
//  Copyright 2023 MacApp. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {
    func getPixelColor(atLocation location: NSPoint, withFrameSize size: NSSize) -> NSColor? {
        let point = NSPoint(x: self.size.width * location.x, y: self.size.height * location.y)
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * cgImage.width
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: cgImage.height * bytesPerRow)
        defer { pixelData.deallocate() }

        let context = CGContext(data: pixelData, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)!
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))

        let pixelInfo = Int(point.y) * bytesPerRow + Int(point.x) * bytesPerPixel
        let r = CGFloat(pixelData[pixelInfo]) / CGFloat(255)
        let g = CGFloat(pixelData[pixelInfo + 1]) / CGFloat(255)
        let b = CGFloat(pixelData[pixelInfo + 2]) / CGFloat(255)
        let a = CGFloat(pixelData[pixelInfo + 3]) / CGFloat(255)

        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
}
