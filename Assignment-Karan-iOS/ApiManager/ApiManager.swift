//
//  ApiManager.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 02/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import Foundation
import Reachability

class ApiManager {

    static let reachability = Reachability()!
    
    static func getYearOrderedStats(callback:@escaping (Data?,Bool,String) -> ()) throws {
        
        guard let url = URL(string: Constants.Path.url) else { throw WeatherError.Request.unsupportedUrl }
        let urlRequest = URLRequest(url: url)

         URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response ,error) in
            if Reachability()?.isReachable ?? false {
                if error == nil {
                    callback(data,true,"")
                } else {
                    callback(nil,false,Constants.Message.ErrorMessage.somethingWentWrong)
                }
            } else {
                callback(nil,false,Constants.Message.ErrorMessage.noInternetConnection)
            }
        }).resume()
    }
    
    static func downloadFile(url:String, completion:@escaping (Bool,URL?,String) -> ())  {

        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
  
        URLSession.shared.downloadTask(with: urlRequest) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, let url = (response as? HTTPURLResponse)?.url {
                    if statusCode == 200 {
                        completion(true,tempLocalUrl,"\(url.pathComponents[7])\(url.pathComponents[9])")
                    } else {
                        completion(false,nil,"")
                    }
                } else {
                    completion(false,nil,"")
                }
            } else {
                completion(false,nil,"")
            }
        }.resume()
        
    }
}
