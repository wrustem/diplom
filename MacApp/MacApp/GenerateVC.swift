//
//  GenerateVC.swift
//  MacApp
//
//  Created by user on 20.06.2023.
//

import Cocoa

class GenerateVC: NSViewController {

    var mainElement: Element!
    var im: NSImage!
    
    var newEl = [Element]()
    var cur = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addElChilds(mainElement)
        
        view.wantsLayer = true
        view.layer?.backgroundColor = .white
    }

    func addElChilds(_ el: Element) {
        for child in el.children {
            addElement(child)
            addElChilds(child)
        }
    }
    
    @IBAction func buttonTappped(_ sender: Any) {
        cur += 1
        if cur > newEl.count - 1 {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateController(withIdentifier: "thVC") as! NSViewController
            self.presentAsSheet(vc)
        } else {
            view.subviews.forEach { i in
                if i is NSButton {
                    print()
                } else {
                    i.removeFromSuperview()
                }
            }
            addElChilds(newEl[cur])
        }
    }
    
    func addElement(_ el: Element) {
        switch el.elementType {
        case .unknown:
            createNSImage(el)
            
        case .text(let t):
            createText(el, text: t)
            
        case .button(let toEl):
            createButton(el, toEl: toEl)
            
        default:
            break
        }
    }
    
    var width: CGFloat {
        350
    }
    
    var height: CGFloat {
        735
    }
    
    func createButton(_ el: Element, toEl: Element) {
        
        newEl.append(toEl)
        
        let v = CustomButton()
//        v.font = NSFont.systemFont(ofSize: 10)
        
        v.frame = CGRect(
            x: width * el.box.minX,
            y: height * el.box.minY,
            width: width * el.box.width,
            height: height * el.box.height
        )
        
        v.customObject = toEl
        v.layer?.backgroundColor = el.color?.cgColor
        
        v.target = self
        v.action = #selector(buttonTapped(_:))
        
        view.addSubview(v)
    }
    
    @objc func buttonTapped(_ sender: Any) {
        
        guard let customObject = (sender as! CustomButton).customObject else {
            return
        }
        
        mainElement = customObject
        
        view.subviews.forEach { $0.removeFromSuperview() }
        addElChilds(mainElement)
    }
    
    func createText(_ el: Element, text: String) {
        
        let v = NSTextField()
        v.stringValue = text
        v.font = NSFont.systemFont(ofSize: 6)
        v.textColor = .black
        
        v.frame = CGRect(
            x: width * el.box.minX,
            y: height * el.box.minY,
            width: width * el.box.width,
            height: 15
        )
        
        view.addSubview(v)
    }
    
    func createNSImage(_ el: Element) {
        let v = NSImageView(frame: .zero)
//        v.backgroundColor = NSColor.random()
        
        
//        v.backgroundColor = NSImage(named: "img")!.getPixelColor(pos: CGPoint(x: im.size.width * el.box.minX * im.scale + 5, y: im.size.height * (1 - el.box.minY * im.scale) + 5))
//
        v.image = el.image
        v.wantsLayer = true
        v.layer?.backgroundColor = el.color?.cgColor
        
        v.frame = CGRect(
            x: width * el.box.minX,
            y: height * el.box.minY,
            width: width * el.box.width,
            height: height * el.box.height
        )
        
        guard el.box.width * el.box.height > 0.00005 else { return }

        view.addSubview(v)
        
//        NSLayoutConstraint.activate([
//            v.topAnchor.constraint(equalTo: v.topAnchor, constant: width * el.box.minX),
//            v.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: CGFloat),
//            v.rightAnchor.constraint(equalTo: v.rightAnchor, constant: ),
//            v.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: )
//        ])
    }
    
}

class CustomButton : NSButton {

    var customObject : Element?

    convenience init(object: Element) {
        self.init()
        self.customObject = object
    }
}
