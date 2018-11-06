//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 22/10/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

protocol DataManager: class {
    var nameData : String {get set}
    var infoData : String {get set}
    var imageData : String {get set}
}

import Foundation


class GCDDataManager: DataManager {
    
   
    
    var nameData = "name.txt"
    var infoData = "info.txt"
    var imageData = "image.png"
    
    
    
    
    public func asyncReadFile(fileForRead: String) -> String {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileForRead)
            
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                print(text)
                return text
            }
            catch {/* error handling here */}
    }
        return ""
    }



    public func writeData(data: String, fileForWrite: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileForWrite)
            
            //writing
            do {
                try data.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
    }

}
    
    
    
  


