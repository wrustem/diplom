//
//  VCMader.swift
//  MacApp
//
//  Created by Rustem Sayfullin on 8.01.2023.
//  Copyright 2023 MacApp. All rights reserved.
//

import Foundation

class VCMader {
    
    var mainElement: Element!
    
    var result = ""
    
    func start() {
        
        result.append("""
        import UIKit
        
        class ViewController\(mainElement.id): UIViewController {
        
        """)
        
        result.append("""
        
                var width: CGFloat {
                    view.frame.width
                }
                var height: CGFloat {
                    view.frame.height
                }
                
                func createText(box: CGRect, text: String) {
                    let v = UILabel()
                    v.text = text
                    v.font = UIFont.systemFont(ofSize: 10)
                    
                    v.frame = CGRect(
                        x: width * box.minX,
                        y: view.frame.height - height * box.maxY,
                        width: width * box.width,
                        height: height * box.height
                    )
                    
                    view.addSubview(v)
                }
                
                func createUIView(box: CGRect, color: UIColor) {
                    let v = UIView()
                    v.backgroundColor = color
                    v.frame = CGRect(
                        x: width * box.minX,
                        y: view.frame.height - height * box.maxY,
                        width: width * box.width,
                        height: height * box.height
                    )
                    view.addSubview(v)
                }
                
                func createSwitch(box: CGRect) {
                    let v = UISwitch()
                    v.frame = CGRect(
                        x: width * box.minX,
                        y: view.frame.height - height * box.maxY,
                        width: width * box.width,
                        height: height * box.height
                    )
                    view.addSubview(v)
                }
                
                func createSlider(box: CGRect) {
                    let v = UISlider()
                    v.frame = CGRect(
                        x: width * box.minX,
                        y: view.frame.height - height * box.maxY,
                        width: width * box.width,
                        height: height * box.height
                    )
                    view.addSubview(v)
                }
                
                func createUImage(box: CGRect, name: String) {
                    let v = UIImageView()
                    v.image = UIImage(named: name)!
                    v.frame = CGRect(
                        x: width * box.minX,
                        y: view.frame.height - height * box.maxY,
                        width: width * box.width,
                        height: height * box.height
                    )
                    view.addSubview(v)
                }
                
                func createButton(box: CGRect, tag: Int, color: UIColor) {
                    let v = UIButton()
                    v.addTarget(self, action: #selector(openNewScreen(_:)), for: .touchUpInside)
                    v.tag = tag
                    v.backgroundColor = color
                    v.frame = CGRect(
                        x: width * box.minX,
                        y: view.frame.height - height * box.maxY,
                        width: width * box.width,
                        height: height * box.height
                    )
                    view.addSubview(v)
                }
        """)
        
        result.append("""
                     override func viewDidLoad() {
                      super.viewDidLoad()
        
                     
        """)
        
        addElChilds(mainElement)
        
        result.append("""
                  }
                  
              }
        """)
        
        FileMader().createTextFile(content: result, filePath: "/Users/user/projects/diplom/GeneratedProj/GeneratedProj/ViewController\(mainElement.id).swift")
    }
    
    
    func addElChilds(_ el: Element) {
        for child in el.children {
            addElement(child)
            addElChilds(child)
        }
    }
    
    func addElement(_ el: Element) {
        switch el.elementType {
        case .unknown:
            createUIView(el)
            
        case .text(let t):
            createText(el, text: t)
            
        case .button(let toEl):
            createButton(el, toEl: toEl)
            
        case .image:
            createUIImage(el)
            
        default:
            break
        }
    }
    
    func createText(_ el: Element, text: String) {
        result.append("createText(box:  CGRect(x: \(el.box.minX), y: \(el.box.minY), width: \(el.box.width), height: \(el.box.height)), text: \"\(text)\")\n")
    }
    
    var countImage = 0
    
    func createUIImage(_ el: Element) {
        result.append("createUImage(box: CGRect(x: \(el.box.minX), y: \(el.box.minY), width: \(el.box.width), height: \(el.box.height)), name \"\(countImage)\")\n")
        
        countImage += 1
    }
    
    func createUIView(_ el: Element) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        (el.color ?? .black).usingColorSpace(.sRGB)!.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        result.append("createUIView(box: CGRect(x: \(el.box.minX), y: \(el.box.minY), width: \(el.box.width), height: \(el.box.height)), color: UIColor(red: \(red), green: \(green), blue: \(blue), alpha: \(alpha)))\n")
    }
    
    var countButton = 0
    var tagsVC = [Int:String]()
    
    func createButton(_ el: Element, toEl: Element) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        (el.color ?? .black).usingColorSpace(.sRGB)!.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        result.append("createUIImage(box: CGRect(x: \(el.box.minX), y: \(el.box.minY), width: \(el.box.width), height: \(el.box.height)), tag: \(countButton), color: UIColor(red: \(red), green: \(green), blue: \(blue), alpha: \(alpha)))\n")
        
        tagsVC[countButton] = toEl.id
        
        let newVC = VCMader()
        newVC.mainElement = toEl
        newVC.start()
    }
    
    func createRouts() {
        result.append("""
                @objc func openNewScreen(_ button: UIButton) {
                    switch button.tag {
        
        """)
        
        for i in tagsVC.keys {
            result.append("""
                        case \(i):
                            present(ViewController\(tagsVC[i]!)(), animated: true)
            """)
        }
        
        
        result.append("""
                    default:
                        break
                    }
                }
        
        
        """)
    }
}
