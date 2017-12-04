//
//  DownloadOperation.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 02/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import Foundation


class DownloadOperation: Operation {
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
}



class DownloadFile: DownloadOperation {
    
    private let urlString: String
    
    var responseData: Data?
    var localUrl: URL?
    
    init(withURLString urlString: String) {
        self.urlString = urlString
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        
        executing(true)
        
        ApiManager.downloadFile(url: urlString, completion: {(status,tempUrl,fileName) in
            if status {
                
                let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = dir.appendingPathComponent(fileName)
                
                do {
                    try? FileManager.default.removeItem(at: fileURL)
                    try FileManager.default.copyItem(at: tempUrl!, to: fileURL)
                    self.localUrl = fileURL
                    
                } catch {}
            } else {
                
            }
            
            self.executing(false)
            self.finish(true)
        })
    }
}
