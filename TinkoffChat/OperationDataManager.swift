//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 22/10/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation



class OperationDataManager: Operation {
    
    let queue = OperationQueue()
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
    }
    
    
    public func writeDataOper(data: String, fileForWrite: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileForWrite)
            
            //writing
            do {
                try data.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
    }
    
    


