//
//  FileMader.swift
//  MacApp
//
//  Created by Rustem Sayfullin on 8.01.2023.
//  Copyright 2023 MacApp. All rights reserved.
//

import Foundation

struct FileMader {
    
    func createTextFile(content: String, filePath: String) -> Bool {
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Файл успешно создан!")
            return true
        } catch {
            print("Ошибка: \(error.localizedDescription)")
            return false
        }
    }
    
}
