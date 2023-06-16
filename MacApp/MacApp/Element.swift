//
//  Element.swift
//  MacApp
//
//  Created by Rustem Sayfullin on 8.01.2023.
//  Copyright 2023 MacApp. All rights reserved.
//

import Cocoa
import Foundation

import AVFoundation
import Vision
import Foundation

enum UIIDStr {
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

class Element: NSObject {
    let id = UIIDStr.randomString(length: 5)
    var contour: VNContour?
    var box: CGRect
    var children: [Element] = []
    var elementType: ElementType = .unknown
    var color: NSColor?
    var image: NSImage?
    
    init(box: CGRect) {
        self.box = box
    }
    

    
    init(contour: VNContour, box: CGRect) {
        self.contour = contour
        self.box = box
    }
    
    init(contour: VNContour, box: CGRect, children: [Element]) {
        self.contour = contour
        self.box = box
        self.children = children
    }
    
    init(children: [Element], box: CGRect) {
        self.children = children
        self.box = box
    }
    
    func checkMy(_ element: Element) -> Bool  {
        box.contains(element.box)
    }
    
    func addElementToIerarh(_ element: Element){
        guard box.contains(element.box) else { return }
        
        var added = false
        for child in children where child.checkMy(element) {
            if !added {
                added = true
                child.addElementToIerarh(element)
            }
        }
        
        if !added { children.append(element) }
    }
    
    func getAllChildren() -> [Element] {
        var allChildren = [self]
        for child in children {
            allChildren.append(contentsOf: child.getAllChildren())
        }
        return allChildren
    }
    
    func setTextChain(text: String, rect: CGRect) {
        if pointinElelment(rect: rect) {
            setTextType(text: text)
        } else {
            var elArray = [Element]()
            for (index, child) in children.enumerated() {
                if child.pointinElelment(rect: rect) {
                    elArray.append(children[index])
                } else {
                    child.setTextChain(text: text, rect: rect)
                }
            }
            
            if !elArray.isEmpty {
                children = children.filter { ch in
                    !elArray.contains(where: { $0 == ch })
                }
                let res = Element.mergeElements(elArray)
                res.elementType = .text(text)
                res.box = rect
                children.append(res)
            }
        }
    }
    
    func setButtonChain(el: Element, point: CGPoint) {
        var finded = false
        for child in children {
            if child.pointinElelment(point: point) {
                finded = true
                child.setButtonChain(el: el, point: point)
                return
            }
        }
        if !finded {
            elementType = .button(el)
        }
    }
    
    static func mergeElements(_ elements: [Element]) -> Element {
        guard !elements.isEmpty else { return Element(box: CGRect())}
        
        var unionRect = CGRect()
        
        elements.forEach { element in
            unionRect = unionRect.union(element.box)
        }
        
        let el = Element(box: unionRect)
        
        elements.forEach { element in
            element.children.forEach { element1 in
                el.addElementToIerarh(element1)
            }
        }
        
        return el
    }
    
    func pointinElelment(point: CGPoint) -> Bool {
        let b1 = CGRect(
            x: box.minX,
            y: box.maxY,
            width: box.width,
            height: box.height
        )
        return b1.contains(point)
    }
    
    func pointinElelment(rect: CGRect) -> Bool {
        let rect1 = CGRect(x: rect.minX - 0.01, y: rect.minY - 0.01, width: rect.width + 0.02, height: rect.height + 0.02)
        return rect1.contains(box)
    }
    
    func setTextType(text: String) {
        elementType = .text(text)
        
        for child in children {
            child.setTextType(text: text)
        }
    }
    
    func isHaveNavBar() -> Bool {
        for i in children {
            switch i.elementType {
            case .navigationBar:
                return true
                
            default:
                break
            }
        }
        return false
    }

    func isEqual(to: Element) -> Bool {
        self.children.count == to.children.count
//        var firstBoxes = Set<CGRect>()
//        for e in children {
//            firstBoxes.insert(e.box)
//        }
//
//        var firstBoxes1 = Set<CGRect>()
//        for e in to.children {
//            firstBoxes1.insert(e.box)
//        }
//
//        var equalCount = 0
//
//        for e in to.children {
//            let e1 = e.box
//            if firstBoxes.contains(e1) {
//                equalCount += 1
//            }
//        }
//
//        if Double(equalCount) / Double(to.children.count) > 0.5 {
//            return true
//        } else {
//            return false
//        }
    }
}

enum ElementType {
    case unknown
    case text(String)
    case navigationBar
    case button(Element)
    case buttonEmpty
    case image
    case segmentcontrol
    case slider
    case uiswitch
}

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(minX)
        hasher.combine(minY)
        hasher.combine(maxX)
        hasher.combine(maxY)
    }
}
