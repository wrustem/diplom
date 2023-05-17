//
//  AppDelegateMader.swift
//  MacApp
//
//  Created by user on 17.06.2023.
//

import Foundation

class AppDelegateMader {
    
    var mainElement: Element!
    
    var result = ""
    
    func start() {
        
        result.append("""
        
                import UIKit

                @UIApplicationMain
                class AppDelegate: UIResponder, UIApplicationDelegate {
                    var window: UIWindow?

                    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                        // Override point for customization after application launch.
                        
                        window = UIWindow(frame: UIScreen.main.bounds)
                        window?.rootViewController = ViewController\(mainElement.id)()
                        window?.makeKeyAndVisible()
                        
                        return true
                    }
                }
        
        """)
        
        FileMader().createTextFile(content: result, filePath: "/Users/user/projects/diplom/GeneratedProj/GeneratedProj/AppDelegate.swift")
    }
}
