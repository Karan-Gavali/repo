//
//  Utils.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 02/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import Foundation
import UIKit


enum WeatherError {
    enum Request:Error {
        case unsupportedUrl
    }
    
    enum Parser: Error {
        case invalidHtml
    }
}

struct Constants {
    struct Path {
        static let url = "https://www.metoffice.gov.uk/climate/uk/summaries/datasets"
    }
    
    struct Segue {
        static let detailIdentifier = "weatherSegue"
    }
    
    struct Message {
        struct ErrorMessage {
            static let somethingWentWrong = "OOPS!!! Something went wrong."
            static let unableToParseTextFile = "Unable to parse text file."
            static let invalidHtml = "Invalid Html format."
            static let failToWriteCSV = "Fail to write CSV file."
            static let noInternetConnection = "It seems to be there is no internet connection available."
        }
        
    }
}

struct Params {
    static func getMonth(index: Int) -> String {
        switch index {
        case 1:
            return "JAN"
        case 2:
            return "FEB"
        case 3:
            return "MAR"
        case 4:
            return "APR"
        case 5:
            return "MAY"
        case 6:
            return "JUN"
        case 7:
            return "JUL"
        case 8:
            return "AUG"
        case 9:
            return "SEP"
        case 10:
            return "OCT"
        case 11:
            return "NOV"
        case 12:
            return "DEC"
        default:
            return ""
        }
    }
    
    static func getRegionCode(index:Int) -> String {
        switch index {
        case 0:
            return "UK"
        case 1:
            return "England"
        case 2:
            return "Wales"
        case 3:
            return "Scotland"
        default:
            return ""
        }
    }
    
    static func getWeatherParam(index:Int) -> String {
        switch index {
        case 0:
            return "Max Temp"
        case 1:
            return "Min Temp"
        case 2:
            return "Mean Temp"
        case 3:
            return "Sunshine"
        case 4:
            return "Rainfall"
        default:
            return ""
        }
    }
}


protocol Aletable {}


extension Aletable where Self: UIViewController {
        
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: title, message: "Weather", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
           self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showSpinner() {
        let alertController = UIAlertController(title: nil, message: "Loading \n\n", preferredStyle: .alert)
        
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        
        if let presentedViewController = self.presentedViewController {
            if presentedViewController.isKind(of: UIAlertController.self) {
                self.present(alertController, animated: false, completion: nil)
            }
        } else {
            self.present(alertController, animated: false, completion: nil)
        }
    }
    
    func dissmissSpinner() {
        if let presentedViewController = self.presentedViewController {
            if presentedViewController.isKind(of: UIAlertController.self) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}


extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy:NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}


