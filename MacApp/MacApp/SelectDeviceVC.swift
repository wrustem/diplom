//
//  SelectDeviceVC.swift
//  MacApp
//
//  Created by user on 20.06.2023.
//

import Cocoa
import Foundation

class SelectDeviceVC: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    // Data model: These strings will be the data for the table view cells
    var animals = [(String,String)]()
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["xctrace list devices"]
        task.launchPath = "/usr/bin/xcrun"


        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let text = String(data: data, encoding: .utf8)!

        let pattern = "(.*?)\\s+\\(([0-9A-F-]+)\\)"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let nsrange = NSRange(text.startIndex..<text.endIndex, in: text)
        let matches = regex.matches(in: text, options: [], range: nsrange)

        let results = matches.map({ match -> (String, String) in
            let name = String(text[Range(match.range(at:1), in: text)!]).trimmingCharacters(in: .whitespacesAndNewlines)
            let udid = String(text[Range(match.range(at:2), in: text)!])
            return (name, udid)
        })
        
        animals = results

    }
    
    // number of rows in table view
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.animals.count
    }
      

    
    // create a cell for each table view row
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
          
          let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"), owner: self) as? NSTableCellView
          
        cell?.textField?.stringValue = animals[row].0
          
          return cell
      }

    
    // method to run when table view cell is tapped
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        dismiss(nil)
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
    
    func task1(name: String) {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-project", "/Users/user/projects/diplom/GeneratedProj/GeneratedProj.xcodeproj", "-scheme", "GeneratedProj", "-configuration", "Debug", "-destination", "platform=iOS,name=\(name)"]
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
        
//        print(output ?? "No output")
    }
    
    func task3(id: String) {
        deployBundleToDevice(bundleName: "GeneratedProj", deviceID: id)
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        task1(name: animals[row].0)
        task2()
        task3(id: animals[row].1)
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "ggVC") as! NSViewController
        self.presentAsSheet(vc)
        return true
    }
}
